#!/opt/anaconda3/bin/python
"""
Cleanup Report Viewer - Modern GUI for viewing Developer folder cleanup reports
"""

import tkinter as tk
from tkinter import ttk, scrolledtext, messagebox
from pathlib import Path
from datetime import datetime
import re
import subprocess


class CleanupReportViewer:
    def __init__(self, root):
        self.root = root
        self.root.title("Cleanup Report Viewer")
        self.root.geometry("1200x800")

        # Paths
        self.reports_dir = Path.home() / "Developer" / "reports" / "cleanup"
        self.logs_dir = Path.home() / "Developer" / "logs" / "cleanup"

        # Create directories if they don't exist
        self.reports_dir.mkdir(parents=True, exist_ok=True)
        self.logs_dir.mkdir(parents=True, exist_ok=True)

        # Modern Color Palette - Dark Mode with Accents
        self.bg_dark = "#1a1d29"
        self.bg_medium = "#232736"
        self.bg_light = "#2d3142"
        self.bg_card = "#2d3142"
        self.accent_primary = "#667eea"  # Purple
        self.accent_secondary = "#764ba2"  # Deep Purple
        self.accent_success = "#48bb78"  # Green
        self.accent_warning = "#f6ad55"  # Orange
        self.accent_info = "#4299e1"  # Blue
        self.text_primary = "#f7fafc"
        self.text_secondary = "#a0aec0"
        self.text_muted = "#718096"

        # Gradient colors
        self.gradient_start = "#667eea"
        self.gradient_end = "#764ba2"

        # Setup UI
        self.setup_ui()
        self.load_reports()

    def setup_ui(self):
        """Setup the modern user interface"""

        # Main container
        self.root.configure(bg=self.bg_dark)

        # Custom style
        style = ttk.Style()
        style.theme_use("clam")

        # Top menu bar
        menubar = tk.Menu(self.root)
        self.root.config(menu=menubar)

        file_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="File", menu=file_menu)
        file_menu.add_command(label="Refresh Reports", command=self.load_reports)
        file_menu.add_command(label="Run Test Cleanup", command=self.run_test_cleanup)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=self.root.quit)

        tools_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="Tools", menu=tools_menu)
        tools_menu.add_command(
            label="Schedule Status", command=self.show_schedule_status
        )
        tools_menu.add_command(label="View Latest Log", command=self.view_latest_log)
        tools_menu.add_command(
            label="Open Reports Folder", command=self.open_reports_folder
        )

        help_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="Help", menu=help_menu)
        help_menu.add_command(label="About", command=self.show_about)

        # Modern Header with gradient effect
        header = tk.Frame(self.root, bg=self.accent_primary, height=80)
        header.pack(fill=tk.X, side=tk.TOP)

        header_content = tk.Frame(header, bg=self.accent_primary)
        header_content.pack(expand=True)

        title_label = tk.Label(
            header_content,
            text="🧹 Cleanup Report Viewer",
            bg=self.accent_primary,
            fg=self.text_primary,
            font=("SF Pro Display", 28, "bold"),
        )
        title_label.pack(pady=15)

        subtitle_label = tk.Label(
            header_content,
            text="Developer Folder Maintenance Dashboard",
            bg=self.accent_primary,
            fg=self.text_primary,
            font=("SF Pro Text", 11),
        )
        subtitle_label.pack()

        # Main content area with padding
        content = tk.Frame(self.root, bg=self.bg_dark)
        content.pack(fill=tk.BOTH, expand=True, padx=15, pady=15)

        # Left sidebar - Reports list with modern card design
        sidebar_frame = tk.Frame(content, bg=self.bg_medium, width=280)
        sidebar_frame.pack(fill=tk.Y, side=tk.LEFT, padx=(0, 15))
        sidebar_frame.pack_propagate(False)

        # Sidebar header
        sidebar_header = tk.Frame(sidebar_frame, bg=self.bg_light, height=60)
        sidebar_header.pack(fill=tk.X)
        sidebar_header.pack_propagate(False)

        sidebar_label = tk.Label(
            sidebar_header,
            text="📊 Reports",
            bg=self.bg_light,
            fg=self.text_primary,
            font=("SF Pro Display", 16, "bold"),
        )
        sidebar_label.pack(pady=18)

        # Reports listbox with modern styling
        list_frame = tk.Frame(sidebar_frame, bg=self.bg_medium)
        list_frame.pack(fill=tk.BOTH, expand=True, padx=12, pady=(5, 10))

        scrollbar = tk.Scrollbar(list_frame, bg=self.bg_medium)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        self.reports_listbox = tk.Listbox(
            list_frame,
            bg=self.bg_medium,
            fg=self.text_secondary,
            font=("SF Pro Text", 11),
            selectbackground=self.accent_primary,
            selectforeground=self.text_primary,
            yscrollcommand=scrollbar.set,
            activestyle="none",
            borderwidth=0,
            highlightthickness=0,
            relief=tk.FLAT,
        )
        self.reports_listbox.pack(fill=tk.BOTH, expand=True, side=tk.LEFT)
        scrollbar.config(command=self.reports_listbox.yview)

        self.reports_listbox.bind("<<ListboxSelect>>", self.on_report_select)

        # Modern action buttons
        button_frame = tk.Frame(sidebar_frame, bg=self.bg_medium)
        button_frame.pack(fill=tk.X, padx=12, pady=(0, 15))

        refresh_btn = tk.Button(
            button_frame,
            text="🔄  Refresh Reports",
            command=self.load_reports,
            bg=self.accent_primary,
            fg=self.text_primary,
            font=("SF Pro Text", 11, "bold"),
            relief=tk.FLAT,
            cursor="hand2",
            padx=20,
            pady=10,
            borderwidth=0,
        )
        refresh_btn.pack(fill=tk.X, pady=(0, 8))
        refresh_btn.bind(
            "<Enter>", lambda e: refresh_btn.config(bg=self.accent_secondary)
        )
        refresh_btn.bind(
            "<Leave>", lambda e: refresh_btn.config(bg=self.accent_primary)
        )

        test_btn = tk.Button(
            button_frame,
            text="🧪  Run Test",
            command=self.run_test_cleanup,
            bg=self.bg_light,
            fg=self.text_secondary,
            font=("SF Pro Text", 11),
            relief=tk.FLAT,
            cursor="hand2",
            padx=20,
            pady=8,
            borderwidth=0,
        )
        test_btn.pack(fill=tk.X)
        test_btn.bind("<Enter>", lambda e: test_btn.config(bg=self.bg_card))
        test_btn.bind("<Leave>", lambda e: test_btn.config(bg=self.bg_light))

        # Right side - Report content
        right_frame = tk.Frame(content, bg=self.bg_dark)
        right_frame.pack(fill=tk.BOTH, expand=True, side=tk.LEFT)

        # Modern Dashboard/Stats area with cards
        stats_frame = tk.Frame(right_frame, bg=self.bg_dark)
        stats_frame.pack(fill=tk.X, pady=(0, 15))

        self.stats_labels = {}

        # Create modern stat cards
        stats_grid = tk.Frame(stats_frame, bg=self.bg_dark)
        stats_grid.pack(fill=tk.X)

        stat_items = [
            ("files_removed", "Files Removed", "🗑️", self.accent_info),
            ("dirs_removed", "Directories", "📁", self.accent_warning),
            ("space_freed", "Space Freed", "💾", self.accent_success),
            ("duration", "Duration", "⏱️", self.accent_primary),
        ]

        for idx, (key, label, icon, color) in enumerate(stat_items):
            # Modern card with subtle shadow effect
            card = tk.Frame(stats_grid, bg=self.bg_card, relief=tk.FLAT)
            card.grid(row=0, column=idx, padx=8, pady=0, sticky="nsew")
            stats_grid.columnconfigure(idx, weight=1)

            # Inner padding frame
            inner = tk.Frame(card, bg=self.bg_card)
            inner.pack(fill=tk.BOTH, expand=True, padx=20, pady=18)

            # Icon with colored background
            icon_frame = tk.Frame(inner, bg=color, width=50, height=50)
            icon_frame.pack()
            icon_frame.pack_propagate(False)

            icon_label = tk.Label(
                icon_frame, text=icon, bg=color, font=("Helvetica", 22)
            )
            icon_label.pack(expand=True)

            # Value with large font
            value_label = tk.Label(
                inner,
                text="--",
                bg=self.bg_card,
                fg=self.text_primary,
                font=("SF Pro Display", 28, "bold"),
            )
            value_label.pack(pady=(12, 4))
            self.stats_labels[f"{key}_value"] = value_label

            # Label with muted text
            title_label = tk.Label(
                inner,
                text=label,
                bg=self.bg_card,
                fg=self.text_muted,
                font=("SF Pro Text", 11),
            )
            title_label.pack()

        # Report content area with modern header
        content_header = tk.Frame(right_frame, bg=self.bg_dark)
        content_header.pack(fill=tk.X, pady=(0, 12))

        content_label = tk.Label(
            content_header,
            text="📄 Report Details",
            bg=self.bg_dark,
            fg=self.text_primary,
            font=("SF Pro Display", 16, "bold"),
        )
        content_label.pack(side=tk.LEFT)

        # Modern text area container
        text_container = tk.Frame(right_frame, bg=self.bg_card, relief=tk.FLAT)
        text_container.pack(fill=tk.BOTH, expand=True)

        # Text area for report content with modern styling
        self.report_text = scrolledtext.ScrolledText(
            text_container,
            wrap=tk.WORD,
            font=("SF Mono", 11),
            bg=self.bg_card,
            fg=self.text_secondary,
            insertbackground=self.text_primary,
            relief=tk.FLAT,
            padx=20,
            pady=20,
            borderwidth=0,
            highlightthickness=0,
            selectbackground=self.accent_primary,
            selectforeground=self.text_primary,
        )
        self.report_text.pack(fill=tk.BOTH, expand=True)

        # Modern status bar
        status_frame = tk.Frame(self.root, bg=self.bg_medium, height=32)
        status_frame.pack(fill=tk.X, side=tk.BOTTOM)
        status_frame.pack_propagate(False)

        self.status_bar = tk.Label(
            status_frame,
            text="● Ready",
            bg=self.bg_medium,
            fg=self.text_muted,
            font=("SF Pro Text", 10),
            anchor=tk.W,
            padx=15,
        )
        self.status_bar.pack(fill=tk.BOTH, expand=True)

    def load_reports(self):
        """Load all available reports"""
        self.reports_listbox.delete(0, tk.END)
        self.reports = []

        if not self.reports_dir.exists():
            self.status_bar.config(text="No reports directory found")
            return

        # Get all report files
        report_files = sorted(
            self.reports_dir.glob("cleanup-report-*.txt"), reverse=True
        )

        if not report_files:
            self.status_bar.config(
                text="No reports found - run cleanup to generate first report"
            )
            self.reports_listbox.insert(tk.END, "No reports yet")
            self.reports_listbox.itemconfig(0, {"fg": self.text_muted})
            return

        for report_file in report_files:
            # Extract date from filename
            pattern = r"cleanup-report-(\d{8})-(\d{6})\.txt"
            match = re.search(pattern, report_file.name)
            if match:
                date_str = match.group(1)
                time_str = match.group(2)

                # Format date nicely
                date = datetime.strptime(date_str, "%Y%m%d")
                time = datetime.strptime(time_str, "%H%M%S")

                date_part = date.strftime("%b %d, %Y")
                time_part = time.strftime("%I:%M %p")
                display_name = f"{date_part} - {time_part}"

                self.reports_listbox.insert(tk.END, display_name)
                self.reports.append(report_file)

        self.status_bar.config(text=f"Found {len(report_files)} reports")

        # Auto-select first (latest) report
        if report_files:
            self.reports_listbox.select_set(0)
            self.on_report_select(None)

    def on_report_select(self, event):
        """Handle report selection"""
        selection = self.reports_listbox.curselection()
        if not selection:
            return

        index = selection[0]
        if index >= len(self.reports):
            return

        report_file = self.reports[index]
        self.display_report(report_file)

    def display_report(self, report_file):
        """Display the selected report"""
        try:
            with open(report_file, "r") as f:
                content = f.read()

            # Clear and display content
            self.report_text.delete("1.0", tk.END)
            self.report_text.insert("1.0", content)

            # Extract and display statistics
            self.extract_statistics(content)

            self.status_bar.config(text=f"Loaded: {report_file.name}")

        except Exception as e:
            messagebox.showerror("Error", f"Failed to load report: {e}")

    def extract_statistics(self, content):
        """Extract statistics from report content"""
        # Reset stats
        for key in self.stats_labels:
            self.stats_labels[key].config(text="--")

        # Extract files removed
        files_match = re.search(r"Files Removed:\s*(\d+)", content)
        if files_match:
            label = self.stats_labels["files_removed_value"]
            label.config(text=files_match.group(1))

        # Extract directories removed
        dirs_match = re.search(r"Directories Removed:\s*(\d+)", content)
        if dirs_match:
            label = self.stats_labels["dirs_removed_value"]
            label.config(text=dirs_match.group(1))

        # Extract space freed
        space_match = re.search(r"Space Freed:\s*([^\n]+)", content)
        if space_match:
            self.stats_labels["space_freed_value"].config(
                text=space_match.group(1).strip()
            )

        # Extract duration
        duration_match = re.search(r"Duration:\s*([^\n]+)", content)
        if duration_match:
            self.stats_labels["duration_value"].config(
                text=duration_match.group(1).strip()
            )

    def run_test_cleanup(self):
        """Run a test cleanup"""
        response = messagebox.askyesno(
            "Test Cleanup",
            "Run a test cleanup in dry-run mode?\n\n"
            "This will show what would be cleaned without "
            "actually deleting anything.",
        )

        if not response:
            return

        try:
            script = (
                Path.home()
                / "Developer"
                / "tools"
                / "maintenance"
                / "cleanup-workflow.sh"
            )

            if script.exists():
                cmd = [
                    "open",
                    "-a",
                    "Terminal",
                    str(script),
                    "safe",
                    "--dry-run",
                ]
                subprocess.Popen(cmd)
                self.status_bar.config(text="Launched test cleanup...")
            else:
                messagebox.showerror(
                    "Error", "Cleanup script not found at expected location"
                )

        except Exception as e:
            messagebox.showerror("Error", f"Failed to run test: {e}")

    def show_schedule_status(self):
        """Show cleanup schedule status"""
        try:
            result = subprocess.run(
                [
                    Path.home()
                    / "Developer"
                    / "tools"
                    / "maintenance"
                    / "schedule-cleanup.sh",
                    "status",
                ],
                capture_output=True,
                text=True,
            )

            # Create a popup window
            popup = tk.Toplevel(self.root)
            popup.title("Schedule Status")
            popup.geometry("600x400")
            popup.configure(bg=self.bg_dark)

            text = scrolledtext.ScrolledText(
                popup,
                wrap=tk.WORD,
                font=("SF Mono", 10),
                bg=self.bg_card,
                fg=self.text_secondary,
            )
            text.pack(fill=tk.BOTH, expand=True, padx=15, pady=15)
            text.insert("1.0", result.stdout)
            text.config(state=tk.DISABLED)

        except Exception as e:
            messagebox.showerror("Error", f"Failed to get status: {e}")

    def view_latest_log(self):
        """View the latest cleanup log"""
        try:
            logs = sorted(self.logs_dir.glob("cleanup-*.log"), reverse=True)
            if not logs:
                messagebox.showinfo("No Logs", "No cleanup logs found yet")
                return

            latest_log = logs[0]
            with open(latest_log, "r") as f:
                content = f.read()

            # Create a popup window
            popup = tk.Toplevel(self.root)
            popup.title(f"Log: {latest_log.name}")
            popup.geometry("800x600")
            popup.configure(bg=self.bg_dark)

            text = scrolledtext.ScrolledText(
                popup,
                wrap=tk.WORD,
                font=("SF Mono", 9),
                bg=self.bg_card,
                fg=self.text_secondary,
            )
            text.pack(fill=tk.BOTH, expand=True, padx=15, pady=15)
            text.insert("1.0", content)
            text.config(state=tk.DISABLED)

        except Exception as e:
            messagebox.showerror("Error", f"Failed to load log: {e}")

    def open_reports_folder(self):
        """Open the reports folder in Finder"""
        try:
            subprocess.run(["open", str(self.reports_dir)])
        except Exception as e:
            messagebox.showerror("Error", f"Failed to open folder: {e}")

    def show_about(self):
        """Show about dialog"""
        messagebox.showinfo(
            "About",
            "Cleanup Report Viewer v2.0\n\n"
            "Modern GUI for viewing Developer folder cleanup reports\n\n"
            "Part of the Developer Folder Automation System",
        )


def main():
    root = tk.Tk()
    _ = CleanupReportViewer(root)
    root.mainloop()


if __name__ == "__main__":
    main()
