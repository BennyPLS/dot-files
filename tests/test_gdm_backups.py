import importlib.util
import os
from pathlib import Path
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "gnome/gdm/graphite-gdm-prune.py"
spec = importlib.util.spec_from_file_location("gdm_prune", SCRIPT)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class BackupRetention(unittest.TestCase):
    def test_keeps_only_the_newest_successful_backup(self):
        with tempfile.TemporaryDirectory() as tmp:
            state = Path(tmp)
            backups = []
            for i in range(3):
                path = state / f"backup-20260917-12000{i}-abcdef"
                path.mkdir()
                marker = path / "success"
                marker.touch()
                # Completion order is the reverse of directory-name order.
                os.utime(marker, ns=(3-i, 3-i))
                backups.append(path)
            for name in ["backup-20260917-130000-abcdef", "install-backup-abcdef"]:
                (state / name).mkdir()
            failed = state / "backup-20260917-130000-abcdef"
            (failed / "failed").touch()
            (failed / "success").touch()
            module.prune(state)
            self.assertEqual([p.exists() for p in backups], [True, False, False])
            self.assertFalse(failed.exists())
            self.assertTrue((state / "install-backup-abcdef").exists())
            module.prune(state)
            self.assertEqual(len(list(state.iterdir())), 2)

    def test_keeps_every_backup_when_none_succeeded(self):
        with tempfile.TemporaryDirectory() as tmp:
            state = Path(tmp)
            failed = state / "backup-20260917-120000-abcdef"
            failed.mkdir()
            (failed / "failed").touch()
            unmarked = state / "backup-20260917-130000-abcdef"
            unmarked.mkdir()
            module.prune(state)
            self.assertTrue(failed.exists())
            self.assertTrue(unmarked.exists())

    def test_does_not_follow_symlinked_backups_or_markers(self):
        with tempfile.TemporaryDirectory() as tmp:
            state = Path(tmp) / "state"
            state.mkdir()
            outside = Path(tmp) / "outside"
            outside.mkdir()
            (outside / "success").touch()
            (state / "backup-20260917-120000-abcdef").symlink_to(outside, target_is_directory=True)
            local = state / "backup-20260917-130000-abcdef"
            local.mkdir()
            (local / "success").symlink_to(outside / "success")
            module.prune(state)
            self.assertTrue((outside / "success").exists())
            self.assertTrue(local.exists())


if __name__ == "__main__":
    unittest.main()
