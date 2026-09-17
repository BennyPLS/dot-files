#!/usr/bin/env python3
"""Keep only the newest successful GDM rebuild backup; remove the earlier ones."""
from pathlib import Path
import re
import shutil


def prune(state: Path):
    backups = []
    newest = None
    for directory in state.iterdir():
        if not re.fullmatch(r"backup-\d{8}-\d{6}-[A-Za-z0-9]{6}", directory.name):
            continue
        if directory.is_symlink() or not directory.is_dir():
            continue
        backups.append(directory)
        marker = directory / "success"
        if (marker.is_symlink() or not marker.is_file()
                or (directory / "failed").exists()):
            continue
        key = (marker.stat().st_mtime_ns, directory.name)
        if newest is None or key > newest[0]:
            newest = (key, directory)
    if newest is None:
        return
    for directory in backups:
        if directory == newest[1]:
            continue
        shutil.rmtree(directory)
        print(f"Removed old GDM backup: {directory.name}")


if __name__ == "__main__":
    prune(Path("/var/lib/graphite-gdm"))
