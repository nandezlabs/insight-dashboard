"""
Main module for 7 Habits Workshop
"""

import argparse
import sys
from pathlib import Path
from datetime import datetime

from . import __version__
from .utils import logger
from .habit import HabitWorkshop, SEVEN_HABITS


def parse_args():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="7 Habits Workshop - Track and practice The 7 Habits of Highly Effective People",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {__version__}",
    )

    parser.add_argument(
        "--data-dir",
        type=Path,
        help="Directory to store data",
        default=Path.home() / "Documents" / "7HabitsWorkshop",
    )

    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Workshop info
    subparsers.add_parser("workshop", help="Show workshop information about the 7 habits")

    # Track habit
    track_parser = subparsers.add_parser("track", help="Track an action for a habit")
    track_parser.add_argument("habit", help="Habit number (1-7) or habit name")
    track_parser.add_argument("--action", required=True, help="Action you took")
    track_parser.add_argument("--reflection", default="", help="Optional reflection")

    # Add reflection
    reflect_parser = subparsers.add_parser("reflect", help="Add a daily reflection")
    reflect_parser.add_argument("content", help="Reflection content")
    reflect_parser.add_argument("--tags", nargs="+", help="Tags for reflection")

    # View progress
    progress_parser = subparsers.add_parser("progress", help="View progress summary")
    progress_parser.add_argument("--days", type=int, help="Limit to last N days")

    # List entries
    list_parser = subparsers.add_parser("list", help="List recent entries")
    list_parser.add_argument("--habit", type=int, help="Filter by habit number (1-7)")
    list_parser.add_argument("--limit", type=int, default=20, help="Number of entries")

    # List reflections
    subparsers.add_parser("reflections", help="List recent reflections")

    # Export
    export_parser = subparsers.add_parser("export", help="Export progress report")
    export_parser.add_argument("--format", choices=["markdown", "json"], default="markdown")
    export_parser.add_argument("--output", type=Path, help="Output file")

    return parser.parse_args()


def get_habit_number(habit_input: str) -> int:
    """Convert habit input to number"""
    # Try direct number
    try:
        num = int(habit_input)
        if 1 <= num <= 7:
            return num
    except ValueError:
        pass

    # Try matching habit name
    habit_lower = habit_input.lower()
    for i, habit in enumerate(SEVEN_HABITS, 1):
        if habit_lower in habit.lower():
            return i

    raise ValueError(f"Invalid habit: {habit_input}. Use 1-7 or habit name.")


def main():
    """Main entry point"""
    args = parse_args()

    # Initialize workshop
    workshop = HabitWorkshop(args.data_dir)

    if not args.command:
        logger.error("No command specified. Use --help for usage information.")
        return 1

    try:
        if args.command == "workshop":
            print(workshop.show_workshop_info())
            return 0

        elif args.command == "track":
            habit_num = get_habit_number(args.habit)
            entry = workshop.track_habit(
                habit_number=habit_num,
                action=args.action,
                reflection=args.reflection,
            )
            logger.info(f"✓ Tracked: {entry.habit_name}")
            logger.info(f"  Action: {entry.action}")
            if entry.reflection:
                logger.info(f"  Reflection: {entry.reflection}")
            return 0

        elif args.command == "reflect":
            reflection = workshop.add_reflection(content=args.content, tags=args.tags)
            logger.info(f"✓ Added reflection (ID: {reflection.id})")
            return 0

        elif args.command == "progress":
            progress = workshop.get_progress(days=args.days)

            print(f"\n{'=' * 80}")
            print("7 HABITS WORKSHOP - PROGRESS SUMMARY")
            print(f"{'=' * 80}\n")

            if args.days:
                print(f"Period: Last {args.days} days")
            print(f"Total Entries: {progress['total_entries']}\n")

            print("Progress by Habit:")
            print("-" * 80)
            for i in range(1, 8):
                habit = SEVEN_HABITS[i - 1]
                count = progress["habit_counts"][i]
                bar = "█" * count
                print(f"{habit:<50} {count:>3} {bar}")

            print(f"\n{'=' * 80}\n")
            return 0

        elif args.command == "list":
            entries = workshop.list_entries(habit_number=args.habit, limit=args.limit)

            if not entries:
                logger.info("No entries found.")
                return 0

            print(f"\n{'=' * 80}")
            print("RECENT HABIT ENTRIES")
            print(f"{'=' * 80}\n")

            for entry in entries:
                print(f"[{entry.id}] {entry.habit_name}")
                print(f"  Date: {entry.timestamp.strftime('%Y-%m-%d %H:%M')}")
                print(f"  Action: {entry.action}")
                if entry.reflection:
                    print(f"  Reflection: {entry.reflection}")
                print()

            return 0

        elif args.command == "reflections":
            reflections = workshop.list_reflections()

            if not reflections:
                logger.info("No reflections found.")
                return 0

            print(f"\n{'=' * 80}")
            print("RECENT REFLECTIONS")
            print(f"{'=' * 80}\n")

            for refl in reflections:
                print(f"[{refl.id}] {refl.timestamp.strftime('%Y-%m-%d %H:%M')}")
                print(f"{refl.content}")
                if refl.tags:
                    print(f"Tags: {', '.join(refl.tags)}")
                print("-" * 80)

            return 0

        elif args.command == "export":
            output_file = args.output or Path.cwd() / f"7habits_report_{datetime.now():%Y%m%d_%H%M%S}.{args.format}"
            success = workshop.export_progress(output_file, format=args.format)

            if success:
                logger.info(f"✓ Exported report to: {output_file}")
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
