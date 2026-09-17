"""Run with python -m unittest discover -s tests -v. No live settings are changed."""
import importlib.util
import io
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch
import zipfile

REPO = Path(__file__).resolve().parents[1]


class TerminalSetup(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.config = self.home / "config with spaces"
        self.config.mkdir()
        self.env = {**os.environ, "HOME": str(self.home), "XDG_CONFIG_HOME": str(self.config),
                    "XDG_DATA_HOME": str(self.home / "data")}
        old = self.config / "fish/functions"
        old.mkdir(parents=True)
        (old / "nvm.fish").write_text("old wrapper")
        (self.config / "starship.toml").write_text("old prompt")

    def run_setup(self, *args):
        return subprocess.run([str(REPO / "scripts/setup-terminal.sh"), *args],
                              env=self.env, capture_output=True, text=True)

    def test_dry_run_and_invalid_option_do_not_write(self):
        before = sorted(str(p) for p in self.home.rglob("*"))
        self.assertEqual(self.run_setup("--dry-run").returncode, 0)
        self.assertNotEqual(self.run_setup("--unknown").returncode, 0)
        self.assertEqual(before, sorted(str(p) for p in self.home.rglob("*")))

    def test_replace_backup_and_repeat_keeps_only_the_latest_backup(self):
        self.assertEqual(self.run_setup("--server", "--skip-packages").returncode, 0)
        first = next((self.home / "dotfiles-backups").iterdir())
        self.assertTrue((first / "fish/functions/nvm.fish").exists())
        self.assertEqual((first / "starship.toml").read_text(), "old prompt")
        result = self.run_setup("--server", "--skip-packages")
        self.assertEqual(result.returncode, 0, result.stderr)
        backups = list((self.home / "dotfiles-backups").iterdir())
        self.assertEqual(len(backups), 1)
        self.assertFalse(first.exists())
        # The surviving backup holds what the second run replaced.
        self.assertEqual((backups[0] / "starship.toml").read_bytes(), (REPO / "starship.toml").read_bytes())
        self.assertFalse((self.config / "fish/functions/nvm.fish").exists())
        self.assertEqual((self.config / "fish/config.fish").read_bytes(), (REPO / "fish/config.fish").read_bytes())

    def test_symlink_target_is_not_overwritten(self):
        external = self.home / "external.toml"
        external.write_text("keep me")
        target = self.config / "starship.toml"
        target.unlink()
        target.symlink_to(external)
        result = self.run_setup("--server", "--skip-packages")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(external.read_text(), "keep me")
        self.assertFalse(target.is_symlink())


class GnomeSetup(unittest.TestCase):
    def test_backups_and_theme_setup_without_live_changes(self):
        with tempfile.TemporaryDirectory(prefix="gnome-setup-test-") as tmp:
            home = Path(tmp)
            fakebin = home / "bin"
            fakebin.mkdir()
            mock = fakebin / "mock"
            mock.write_text("#!/usr/bin/python\n" + r'''import os, sys
from pathlib import Path
home = Path(os.environ["HOME"])
cmd = Path(sys.argv[0]).name
args = sys.argv[1:]
with (home / "calls").open("a") as log:
    log.write(cmd + " " + " ".join(args) + "\n")
if cmd == "git":
    if "clone" in args:
        dest = Path(args[-1]); dest.mkdir(parents=True); (dest / ".git").mkdir()
        if dest.name == "Graphite-gtk-theme":
            (dest / "install.sh").write_text("#!/bin/bash\nmkdir -p \"$HOME/.config/gtk-4.0\" \"$HOME/.themes/Graphite-red-Dark-nord\"\nprintf new > \"$HOME/.config/gtk-4.0/gtk.css\"\n")
        else:
            (dest / "index.theme").write_text("Candy")
    else:
        print("test-commit")
elif cmd == "dconf":
    print("[/]\nsetting=true")
elif cmd == "gsettings" and args[0] == "get":
    print("[]")
''')
            mock.chmod(0o755)
            for name in ["git", "sassc", "gnome-shell", "gsettings", "dconf"]:
                (fakebin / name).symlink_to(mock)
            gtk = home / ".config/gtk-4.0"
            gtk.mkdir(parents=True)
            (gtk / "gtk.css").write_text("old css")
            cursor = home / "downloaded cursor"
            (cursor / "cursors").mkdir(parents=True)
            (cursor / "index.theme").write_text("Oreo")
            temp = home / "tmp"
            temp.mkdir()
            env = {**os.environ, "HOME": str(home), "XDG_CONFIG_HOME": str(home / ".config"),
                   "XDG_DATA_HOME": str(home / ".local/share"), "TMPDIR": str(temp),
                   "PATH": str(fakebin) + ":" + os.environ["PATH"], "DBUS_SESSION_BUS_ADDRESS": "test"}
            result = subprocess.run([str(REPO / "scripts/setup-gnome.sh"), "--skip-packages",
                                     "--skip-extensions", "--cursor-dir", str(cursor)],
                                    env=env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            backup = next((home / "dotfiles-backups").iterdir())
            self.assertEqual((backup / "gtk-4.0/gtk.css").read_text(), "old css")
            self.assertEqual((gtk / "gtk.css").read_text(), "new")
            self.assertTrue((home / ".local/share/icons/oreo_spark_red_cursors/index.theme").exists())
            self.assertEqual((backup / "source-commits.txt").read_text().split(),
                             ["Graphite-gtk-theme", "test-commit", "candy-icons", "test-commit"])
            # Upstream downloads are removed when the script exits.
            self.assertEqual(list(temp.iterdir()), [])
            self.assertFalse((home / ".local/src").exists())
            self.assertFalse((home / ".profile").exists())


class Extensions(unittest.TestCase):
    def setUp(self):
        spec = importlib.util.spec_from_file_location("extensions", REPO / "scripts/install-extensions.py")
        self.module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.module)
        self.temp = tempfile.TemporaryDirectory(prefix="extensions-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        (self.root / "gnome/extensions").mkdir(parents=True)
        (self.root / "gnome/enabled-extensions.txt").write_text("test@example.com\n")
        (self.root / "gnome/extensions/unite.dconf").write_text("[/]\nshow-desktop-name=false\n")
        self.backup = self.root / "backup"
        self.backup.mkdir()
        self.calls = []

    def output(self, *args):
        return "GNOME Shell 50.4" if args[0] == "gnome-shell" else "['existing@example.com']"

    def payload(self, url, compatible=True, unsafe=False):
        if "extension-query" in url:
            return json.dumps({"extensions": [{"uuid": "test@example.com", "shell_version_map":
                {"50": {"pk": 123}} if compatible else {}}]}).encode()
        data = io.BytesIO()
        with zipfile.ZipFile(data, "w") as archive:
            archive.writestr("metadata.json", json.dumps({"uuid": "test@example.com", "shell-version": ["50"]}))
            if unsafe:
                archive.writestr("../escape", "bad")
        return data.getvalue()

    def execute(self, payload):
        with patch.object(self.module, "output", side_effect=self.output), \
             patch.object(self.module, "download", side_effect=payload), \
             patch.object(self.module.subprocess, "run", side_effect=lambda args, **kwargs: self.calls.append(args)), \
             patch.dict(os.environ, {"XDG_DATA_HOME": str(self.root / "data")}), \
             patch.object(self.module.sys, "argv", ["installer", str(self.root), str(self.backup)]):
            self.module.main()

    def test_preserves_other_enabled_extensions(self):
        self.execute(self.payload)
        setting = next(c for c in self.calls if c[:2] == ["gsettings", "set"])
        self.assertIn("existing@example.com", setting[-1])
        self.assertIn("test@example.com", setting[-1])
        self.assertIn(["dconf", "load", "/org/gnome/shell/extensions/unite/"], self.calls)

    def test_incompatible_release_does_not_install(self):
        with self.assertRaises(RuntimeError):
            self.execute(lambda url: self.payload(url, compatible=False))
        self.assertEqual(self.calls, [])

    def test_unsafe_archive_does_not_install(self):
        with self.assertRaises(ValueError):
            self.execute(lambda url: self.payload(url, unsafe=True))
        self.assertEqual(self.calls, [])


if __name__ == "__main__":
    unittest.main()
