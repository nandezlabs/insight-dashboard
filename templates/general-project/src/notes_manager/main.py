"""
Main module for Notes Manager
"""

import argparse
import sys
from pathlib import Path
from datetime import datetime

from . import __version__
from .utils import logger
from .note import Note, NoteManager


def parse_args():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="Notes Manager - A simple yet powerful CLI note management system",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {__version__}",
    )

    parser.add_argument(
        "--notes-dir",
        type=Path,
        help="Directory to store notes",
        default=Path.home() / "Documents" / "Notes",
    )

    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Create note
    create_parser = subparsers.add_parser("create", help="Create a new note")
    create_parser.add_argument("title", help="Note title")
    create_parser.add_argument("--content", help="Note content", default="")
    create_parser.add_argument("--tags", nargs="+", help="Tags for the note", default=[])
    create_parser.add_argument("--category", help="Note category", default="General")

    # List notes
    list_parser = subparsers.add_parser("list", help="List all notes")
    list_parser.add_argument("--category", help="Filter by category")
    list_parser.add_argument("--tag", help="Filter by tag")

    # Search notes
    search_parser = subparsers.add_parser("search", help="Search notes")
    search_parser.add_argument("query", help="Search query")

    # Show note
    show_parser = subparsers.add_parser("show", help="Show a note")
    show_parser.add_argument("note_id", help="Note ID or title")

    # Edit note
    edit_parser = subparsers.add_parser("edit", help="Edit a note")
    edit_parser.add_argument("note_id", help="Note ID or title")

    # Delete note
    delete_parser = subparsers.add_parser("delete", help="Delete a note")
    delete_parser.add_argument("note_id", help="Note ID or title")

    # Export notes
    export_parser = subparsers.add_parser("export", help="Export notes")
    export_parser.add_argument("--format", choices=["markdown", "json", "html"], default="markdown")
    export_parser.add_argument("--output", type=Path, help="Output file")

    return parser.parse_args()


def main():
    """Main entry point for the application"""
    args = parse_args()

    logger.info(f"Notes Manager v{__version__}")

    # Initialize note manager
    manager = NoteManager(args.notes_dir)

    if not args.command:
        logger.error("No command specified. Use --help for usage information.")
        return 1

    try:
        if args.command == "create":
            note = manager.create_note(
                title=args.title,
                content=args.content,
                tags=args.tags,
                category=args.category,
            )
            logger.info(f"✓ Created note: {note.title} (ID: {note.id})")
            return 0

        elif args.command == "list":
            notes = manager.list_notes(category=args.category, tag=args.tag)
            if not notes:
                logger.info("No notes found.")
                return 0

            print(f"\n{'ID':<8} {'Title':<40} {'Category':<15} {'Tags':<20} {'Date':<12}")
            print("-" * 100)
            for note in notes:
                tags_str = ", ".join(note.tags[:3])
                if len(note.tags) > 3:
                    tags_str += "..."
                date_str = note.created.strftime("%Y-%m-%d")
                print(f"{note.id:<8} {note.title[:38]:<40} {note.category:<15} {tags_str:<20} {date_str:<12}")
            print(f"\nTotal: {len(notes)} notes\n")
            return 0

        elif args.command == "search":
            notes = manager.search_notes(args.query)
            if not notes:
                logger.info(f"No notes found matching '{args.query}'")
                return 0

            print(f"\nFound {len(notes)} note(s) matching '{args.query}':\n")
            for note in notes:
                print(f"  [{note.id}] {note.title}")
                if args.query.lower() in note.content.lower():
                    # Show context
                    idx = note.content.lower().find(args.query.lower())
                    start = max(0, idx - 40)
                    end = min(len(note.content), idx + len(args.query) + 40)
                    context = note.content[start:end].replace("\n", " ")
                    print(f"      ...{context}...")
                print()
            return 0

        elif args.command == "show":
            note = manager.get_note(args.note_id)
            if not note:
                logger.error(f"Note not found: {args.note_id}")
                return 1

            print(f"\n{'=' * 80}")
            print(f"Title: {note.title}")
            print(f"ID: {note.id}")
            print(f"Category: {note.category}")
            print(f"Tags: {', '.join(note.tags) if note.tags else 'None'}")
            print(f"Created: {note.created.strftime('%Y-%m-%d %H:%M:%S')}")
            print(f"Modified: {note.modified.strftime('%Y-%m-%d %H:%M:%S')}")
            print(f"{'=' * 80}\n")
            print(note.content)
            print()
            return 0

        elif args.command == "edit":
            note = manager.get_note(args.note_id)
            if not note:
                logger.error(f"Note not found: {args.note_id}")
                return 1

            # For now, just show the note path for manual editing
            logger.info("Opening editor... (Not implemented in template)")
            logger.info(f"To edit: {note.file_path}")
            return 0

        elif args.command == "delete":
            success = manager.delete_note(args.note_id)
            if success:
                logger.info(f"✓ Deleted note: {args.note_id}")
                return 0
            else:
                logger.error(f"Failed to delete note: {args.note_id}")
                return 1

        elif args.command == "export":
            output_file = args.output or Path.cwd() / f"notes_export_{datetime.now():%Y%m%d_%H%M%S}.{args.format}"
            success = manager.export_notes(output_file, format=args.format)
            if success:
                logger.info(f"✓ Exported notes to: {output_file}")
                return 0
            else:
                logger.error("Export failed")
                return 1

    except Exception as e:
        logger.error(f"Error: {e}")
        logger.exception("Detailed error:")
        return 1


if __name__ == "__main__":
    sys.exit(main())
