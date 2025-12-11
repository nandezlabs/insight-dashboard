"""
7 Habits tracking and management classes
"""

import json
import uuid
from datetime import datetime
from pathlib import Path
from typing import List, Optional, Dict

from .utils import logger


# The 7 Habits
SEVEN_HABITS = [
    "Habit 1: Be Proactive",
    "Habit 2: Begin with the End in Mind",
    "Habit 3: Put First Things First",
    "Habit 4: Think Win-Win",
    "Habit 5: Seek First to Understand, Then to Be Understood",
    "Habit 6: Synergize",
    "Habit 7: Sharpen the Saw",
]


class HabitEntry:
    """Represents a single habit tracking entry"""

    def __init__(
        self,
        habit_number: int,
        action: str,
        reflection: str = "",
        entry_id: Optional[str] = None,
        timestamp: Optional[datetime] = None,
    ):
        self.id = entry_id or str(uuid.uuid4())[:8]
        self.habit_number = habit_number
        self.habit_name = SEVEN_HABITS[habit_number - 1]
        self.action = action
        self.reflection = reflection
        self.timestamp = timestamp or datetime.now()

    def to_dict(self) -> dict:
        """Convert entry to dictionary"""
        return {
            "id": self.id,
            "habit_number": self.habit_number,
            "habit_name": self.habit_name,
            "action": self.action,
            "reflection": self.reflection,
            "timestamp": self.timestamp.isoformat(),
        }

    @classmethod
    def from_dict(cls, data: dict) -> "HabitEntry":
        """Create entry from dictionary"""
        return cls(
            habit_number=data["habit_number"],
            action=data["action"],
            reflection=data.get("reflection", ""),
            entry_id=data.get("id"),
            timestamp=datetime.fromisoformat(data["timestamp"]) if "timestamp" in data else None,
        )


class Reflection:
    """Represents a daily reflection or journal entry"""

    def __init__(
        self,
        content: str,
        tags: Optional[List[str]] = None,
        reflection_id: Optional[str] = None,
        timestamp: Optional[datetime] = None,
    ):
        self.id = reflection_id or str(uuid.uuid4())[:8]
        self.content = content
        self.tags = tags or []
        self.timestamp = timestamp or datetime.now()

    def to_dict(self) -> dict:
        """Convert reflection to dictionary"""
        return {
            "id": self.id,
            "content": self.content,
            "tags": self.tags,
            "timestamp": self.timestamp.isoformat(),
        }

    @classmethod
    def from_dict(cls, data: dict) -> "Reflection":
        """Create reflection from dictionary"""
        return cls(
            content=data["content"],
            tags=data.get("tags", []),
            reflection_id=data.get("id"),
            timestamp=datetime.fromisoformat(data["timestamp"]) if "timestamp" in data else None,
        )


class HabitWorkshop:
    """Manages the 7 Habits workshop and tracking"""

    def __init__(self, data_dir: Path):
        self.data_dir = Path(data_dir)
        self.data_dir.mkdir(parents=True, exist_ok=True)
        self.entries_file = self.data_dir / "habit_entries.json"
        self.reflections_file = self.data_dir / "reflections.json"
        logger.debug(f"Initialized HabitWorkshop with directory: {self.data_dir}")

    def _load_entries(self) -> List[HabitEntry]:
        """Load all habit entries"""
        if not self.entries_file.exists():
            return []

        with open(self.entries_file, "r") as f:
            data = json.load(f)

        return [HabitEntry.from_dict(entry) for entry in data]

    def _save_entries(self, entries: List[HabitEntry]) -> None:
        """Save habit entries"""
        data = [entry.to_dict() for entry in entries]
        with open(self.entries_file, "w") as f:
            json.dump(data, f, indent=2)

    def _load_reflections(self) -> List[Reflection]:
        """Load all reflections"""
        if not self.reflections_file.exists():
            return []

        with open(self.reflections_file, "r") as f:
            data = json.load(f)

        return [Reflection.from_dict(refl) for refl in data]

    def _save_reflections(self, reflections: List[Reflection]) -> None:
        """Save reflections"""
        data = [refl.to_dict() for refl in reflections]
        with open(self.reflections_file, "w") as f:
            json.dump(data, f, indent=2)

    def track_habit(self, habit_number: int, action: str, reflection: str = "") -> HabitEntry:
        """Track an action for a specific habit"""
        if not 1 <= habit_number <= 7:
            raise ValueError("Habit number must be between 1 and 7")

        entry = HabitEntry(habit_number=habit_number, action=action, reflection=reflection)

        entries = self._load_entries()
        entries.append(entry)
        self._save_entries(entries)

        logger.debug(f"Tracked habit {habit_number}: {action}")
        return entry

    def add_reflection(self, content: str, tags: Optional[List[str]] = None) -> Reflection:
        """Add a daily reflection"""
        reflection = Reflection(content=content, tags=tags)

        reflections = self._load_reflections()
        reflections.append(reflection)
        self._save_reflections(reflections)

        logger.debug(f"Added reflection: {reflection.id}")
        return reflection

    def get_progress(self, days: Optional[int] = None) -> Dict:
        """Get progress summary for all habits"""
        entries = self._load_entries()

        if days:
            cutoff = datetime.now().timestamp() - (days * 86400)
            entries = [e for e in entries if e.timestamp.timestamp() >= cutoff]

        # Count entries per habit
        habit_counts = {i: 0 for i in range(1, 8)}
        for entry in entries:
            habit_counts[entry.habit_number] += 1

        total_entries = len(entries)
        return {
            "total_entries": total_entries,
            "habit_counts": habit_counts,
            "period_days": days,
            "habits": SEVEN_HABITS,
        }

    def list_entries(self, habit_number: Optional[int] = None, limit: int = 20) -> List[HabitEntry]:
        """List recent habit entries"""
        entries = self._load_entries()

        if habit_number:
            entries = [e for e in entries if e.habit_number == habit_number]

        # Sort by timestamp (newest first)
        entries.sort(key=lambda e: e.timestamp, reverse=True)

        return entries[:limit]

    def list_reflections(self, limit: int = 10) -> List[Reflection]:
        """List recent reflections"""
        reflections = self._load_reflections()
        reflections.sort(key=lambda r: r.timestamp, reverse=True)
        return reflections[:limit]

    def export_progress(self, output_file: Path, format: str = "markdown") -> bool:
        """Export progress report"""
        try:
            progress = self.get_progress()
            entries = self._load_entries()
            reflections = self._load_reflections()

            if format == "markdown":
                with open(output_file, "w") as f:
                    f.write("# 7 Habits Workshop - Progress Report\n\n")
                    f.write(f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n")
                    f.write(f"**Total Entries:** {progress['total_entries']}\n\n")

                    f.write("## Progress by Habit\n\n")
                    for i in range(1, 8):
                        count = progress["habit_counts"][i]
                        habit = SEVEN_HABITS[i - 1]
                        f.write(f"- **{habit}:** {count} entries\n")

                    f.write("\n## Recent Entries\n\n")
                    for entry in entries[-20:]:
                        f.write(f"### {entry.habit_name}\n")
                        f.write(f"**Date:** {entry.timestamp.strftime('%Y-%m-%d %H:%M')}\n\n")
                        f.write(f"**Action:** {entry.action}\n\n")
                        if entry.reflection:
                            f.write(f"**Reflection:** {entry.reflection}\n\n")
                        f.write("---\n\n")

                    f.write("## Reflections\n\n")
                    for refl in reflections[-10:]:
                        f.write(f"### {refl.timestamp.strftime('%Y-%m-%d')}\n\n")
                        f.write(f"{refl.content}\n\n")
                        if refl.tags:
                            f.write(f"*Tags: {', '.join(refl.tags)}*\n\n")
                        f.write("---\n\n")

            elif format == "json":
                data = {
                    "progress": progress,
                    "entries": [e.to_dict() for e in entries],
                    "reflections": [r.to_dict() for r in reflections],
                    "exported_at": datetime.now().isoformat(),
                }
                with open(output_file, "w") as f:
                    json.dump(data, f, indent=2)

            logger.info(f"Exported progress report to {output_file}")
            return True

        except Exception as e:
            logger.error(f"Export failed: {e}")
            return False

    def show_workshop_info(self) -> str:
        """Get workshop information about the 7 habits"""
        info = []
        info.append("=" * 80)
        info.append("THE 7 HABITS OF HIGHLY EFFECTIVE PEOPLE")
        info.append("by Stephen R. Covey")
        info.append("=" * 80)
        info.append("")

        for i, habit in enumerate(SEVEN_HABITS, 1):
            info.append(f"{habit}")
            info.append("")

        info.append("=" * 80)
        info.append("")
        info.append("Private Victory (Independence):")
        info.append("  • Habits 1-3: Focus on self-mastery and personal growth")
        info.append("")
        info.append("Public Victory (Interdependence):")
        info.append("  • Habits 4-6: Focus on relationships and teamwork")
        info.append("")
        info.append("Continuous Improvement:")
        info.append("  • Habit 7: Focus on renewal and balance")
        info.append("")

        return "\n".join(info)
