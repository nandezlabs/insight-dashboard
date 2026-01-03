from typing import List
from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from sqlalchemy.orm import Session
import os
import uuid
from pathlib import Path

from app.api.deps import get_database
from app.models.team import Team

router = APIRouter()

# Configure upload directory
UPLOAD_DIR = Path("uploads")
UPLOAD_DIR.mkdir(exist_ok=True)

# Allowed file extensions
ALLOWED_EXTENSIONS = {
    "image": ["jpg", "jpeg", "png", "gif", "webp"],
    "document": ["pdf", "doc", "docx", "xls", "xlsx", "txt"],
}


def get_file_extension(filename: str) -> str:
    """Extract file extension from filename."""
    return filename.rsplit(".", 1)[-1].lower() if "." in filename else ""


def is_allowed_file(filename: str) -> bool:
    """Check if file extension is allowed."""
    ext = get_file_extension(filename)
    return any(ext in exts for exts in ALLOWED_EXTENSIONS.values())


def get_file_type(filename: str) -> str:
    """Determine file type category."""
    ext = get_file_extension(filename)
    for file_type, extensions in ALLOWED_EXTENSIONS.items():
        if ext in extensions:
            return file_type
    return "unknown"


@router.post("/upload", response_model=dict)
async def upload_files(
    files: List[UploadFile] = File(...),
    db: Session = Depends(get_database),
):
    """
    Upload one or more files.

    Returns list of uploaded file metadata including URLs.
    """
    if not files:
        raise HTTPException(status_code=400, detail="No files provided")

    uploaded_files = []

    for file in files:
        # Validate file
        if not file.filename:
            continue

        if not is_allowed_file(file.filename):
            raise HTTPException(
                status_code=400, detail=f"File type not allowed: {file.filename}"
            )

        # Generate unique filename
        file_ext = get_file_extension(file.filename)
        unique_filename = f"{uuid.uuid4()}.{file_ext}"
        file_path = UPLOAD_DIR / unique_filename

        # Save file
        try:
            content = await file.read()
            with open(file_path, "wb") as f:
                f.write(content)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error saving file: {str(e)}")

        # Store file metadata
        uploaded_files.append(
            {
                "filename": file.filename,
                "stored_filename": unique_filename,
                "url": f"/api/v1/files/{unique_filename}",
                "size": len(content),
                "type": get_file_type(file.filename),
                "extension": file_ext,
            }
        )

    return {
        "success": True,
        "files": uploaded_files,
        "count": len(uploaded_files),
    }


@router.get("/{filename}")
async def get_file(
    filename: str,
):
    """
    Retrieve an uploaded file.
    """
    file_path = UPLOAD_DIR / filename

    if not file_path.exists():
        raise HTTPException(status_code=404, detail="File not found")

    from fastapi.responses import FileResponse

    return FileResponse(
        path=file_path,
        filename=filename,
    )


@router.delete("/{filename}")
async def delete_file(
    filename: str,
    db: Session = Depends(get_database),
):
    """
    Delete an uploaded file.
    """
    file_path = UPLOAD_DIR / filename

    if not file_path.exists():
        raise HTTPException(status_code=404, detail="File not found")

    try:
        os.remove(file_path)
        return {"success": True, "message": "File deleted"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error deleting file: {str(e)}")
