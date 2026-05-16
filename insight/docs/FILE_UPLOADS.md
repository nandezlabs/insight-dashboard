# File Upload Setup Guide

This guide explains how to set up and use file uploads in the Insight Dashboard.

## Overview

The Insight Dashboard supports file uploads in forms using:
- **FormIO.js** for the file upload UI component
- **Supabase Storage** for file storage (optional, uses base64 by default)
- **Database tracking** for file metadata

## Quick Start (Base64 Storage)

File uploads work out of the box using base64 encoding. Files are stored directly in the submission data in the database.

### Usage

1. **Create a form** with a file upload field:
   - Go to Forms → Create New Form
   - Add a field and set type to "File Upload"
   - Optionally specify accepted file types (e.g., `.pdf,.doc,.jpg`)
   - Set file as required if needed

2. **Submit the form** with file attachments
   - Files are automatically converted to base64
   - Stored in the submission data

3. **View uploaded files**:
   - Go to Submissions → View submission
   - Files appear with download buttons

### Limitations of Base64 Storage

- ✅ **Pros**: Simple, no configuration needed, works immediately
- ❌ **Cons**: 
  - Database size increases rapidly (files stored in JSON)
  - 10MB file size limit recommended
  - Not ideal for images/media galleries
  - Performance degrades with large files

## Advanced: Supabase Storage (Recommended for Production)

For production use with larger files, set up Supabase Storage.

### Step 1: Create Storage Bucket

1. Go to your **Supabase Dashboard**
2. Navigate to **Storage**
3. Click **Create Bucket**
   - Name: `uploads`
   - Public bucket: `true` (for downloadable files)
   - File size limit: `50MB` (or your preference)
4. Click **Create Bucket**

### Step 2: Set Up Storage Policies

In the Supabase Dashboard, go to **Storage → Policies** and create:

**1. Allow Public Read Access**:
```sql
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'uploads');
```

**2. Allow Authenticated Upload**:
```sql
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'uploads');
```

**3. Allow Authenticated Delete**:
```sql
CREATE POLICY "Authenticated users can delete their files"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'uploads');
```

### Step 3: Update Form Configuration

When creating forms with file fields, FormIO will automatically use the configured storage.

The file upload configuration in the form builder already includes:
- Storage: `base64` (can be changed to `url` for Supabase)
- File pattern: Configurable accepted file types
- Max file size: 10MB default

### Step 4: File Metadata Tracking

Uploaded file metadata is automatically tracked in the `files` table:

- `id`: Unique file identifier
- `filename`: Original filename
- `bucket_path`: Path in Supabase storage
- `size`: File size in bytes
- `mime_type`: File MIME type
- `submission_id`: Link to submission
- `uploaded_at`: Upload timestamp

## File Type Configuration

When adding a file field in the form builder:

1. **Accepted File Types**: Specify allowed extensions
   - Example: `.pdf,.doc,.docx`
   - Example: `.jpg,.jpeg,.png,.gif`
   - Leave empty to allow all types

2. **Common Configurations**:
   - **Documents**: `.pdf,.doc,.docx,.txt`
   - **Images**: `.jpg,.jpeg,.png,.gif,.webp`
   - **Spreadsheets**: `.xlsx,.xls,.csv`
   - **Archives**: `.zip,.tar,.gz`

## Security Best Practices

1. **File Size Limits**: Keep default 10MB limit for base64, increase for Supabase Storage
2. **File Type Validation**: Always specify accepted file types
3. **Virus Scanning**: Consider adding virus scanning for production (external service)
4. **Access Control**: Use Supabase RLS policies to control who can access files
5. **File Naming**: Files are automatically renamed with timestamps to avoid conflicts

## Troubleshooting

### Files Not Uploading

1. Check browser console for errors
2. Verify file size is under limit
3. Check file type is in accepted list
4. Ensure Supabase Storage bucket exists (if using Supabase Storage)

### Files Not Displaying

1. Verify submission data contains file information
2. Check Supabase Storage policies (if using Supabase Storage)
3. Ensure file URLs are properly generated
4. Check browser network tab for download failures

### Large Files Causing Issues

1. Switch from base64 to Supabase Storage
2. Increase file size limits in both FormIO and Supabase
3. Consider implementing chunked uploads for very large files
4. Use compression for images before upload

## Migration from Base64 to Supabase Storage

If you start with base64 and want to migrate to Supabase Storage:

1. Create a migration script to extract base64 files
2. Upload extracted files to Supabase Storage
3. Update submission data with new file URLs
4. Update form schemas to use `url` storage instead of `base64`

Example migration script:

```python
# TODO: Implement migration script
# This would extract base64 data, upload to Supabase Storage,
# and update submission records
```

## API Reference

### File Upload Helper

Located in `frontend/lib/supabase.ts`:

```typescript
uploadFile(file: File, path?: string): Promise<{ path: string; url: string } | null>
```

### Get File URL

```typescript
getFileUrl(filePath: string): Promise<string | null>
```

## Future Enhancements

- [ ] Drag-and-drop file upload UI
- [ ] Multiple file upload support
- [ ] Image preview thumbnails
- [ ] Progress bars for large uploads
- [ ] Virus scanning integration
- [ ] Automatic image optimization
- [ ] File compression before upload

## Support

For issues or questions about file uploads:
1. Check the [QUICKSTART.md](../QUICKSTART.md) guide
2. Review [docs/SETUP.md](SETUP.md) for environment configuration
3. Check Supabase Storage logs in the dashboard
