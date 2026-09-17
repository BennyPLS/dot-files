#!/usr/bin/env python3
"""Install compatible GNOME extensions and apply their saved preferences."""
import ast
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.parse
import urllib.request
import zipfile


def output(*args):
    return subprocess.check_output(args, text=True).strip()


def download(url):
    request = urllib.request.Request(url, headers={"User-Agent": "personal-dotfiles-setup"})
    with urllib.request.urlopen(request, timeout=60) as response:
        if urllib.parse.urlparse(response.url).scheme != "https":
            raise ValueError("Download redirected away from HTTPS")
        return response.read()


def main():
    repo, backup = map(Path, sys.argv[1:])
    version = re.search(r"\b(\d+)\.", output("gnome-shell", "--version"))
    if not version:
        raise RuntimeError("Could not detect GNOME Shell version")
    major = version.group(1)
    uuids = (repo / "gnome/enabled-extensions.txt").read_text().splitlines()
    installed = Path(os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))) / "gnome-shell/extensions"
    with tempfile.TemporaryDirectory(prefix="dotfiles-extensions-") as temp:
        bundles = []
        # Resolve and validate every download before changing extension files.
        for uuid in uuids:
            if not re.fullmatch(r"[A-Za-z0-9_.@+-]+", uuid):
                raise ValueError(f"Invalid extension UUID: {uuid!r}")
            query = urllib.parse.urlencode({"uuid": uuid, "shell_version": major})
            data = json.loads(download("https://extensions.gnome.org/extension-query/?" + query))
            match = next((item for item in data.get("extensions", []) if item["uuid"] == uuid), None)
            release = match.get("shell_version_map", {}).get(major) if match else None
            if not release:
                raise RuntimeError(f"No compatible release of {uuid} for GNOME {major}. Install a supported release or use --skip-extensions.")
            url = "https://extensions.gnome.org/download-extension/" + urllib.parse.quote(uuid, safe="")
            url += ".shell-extension.zip?" + urllib.parse.urlencode({"version_tag": release["pk"]})
            archive = Path(temp) / (uuid + ".zip")
            archive.write_bytes(download(url))
            with zipfile.ZipFile(archive) as bundle:
                for entry in bundle.infolist():
                    path = Path(entry.filename)
                    if path.is_absolute() or ".." in path.parts or (entry.external_attr >> 16) & 0o170000 == 0o120000:
                        raise ValueError(f"Unsafe archive path in {uuid}: {entry.filename}")
                metadata = json.loads(bundle.read("metadata.json"))
                if metadata["uuid"] != uuid or major not in metadata["shell-version"]:
                    raise ValueError(f"Extension metadata mismatch for {uuid}")
            bundles.append((uuid, archive))
        for uuid, archive in bundles:
            old = installed / uuid
            if old.exists():
                shutil.copytree(old, backup / "extension-files" / uuid, symlinks=True)
            subprocess.run(["gnome-extensions", "install", "--force", str(archive)], check=True)
            schemas = installed / uuid / "schemas"
            if schemas.exists():
                subprocess.run(["glib-compile-schemas", str(schemas)], check=True)
            print(f"Installed {uuid}", flush=True)
    for config in sorted((repo / "gnome/extensions").glob("*.dconf")):
        with config.open() as settings:
            subprocess.run(["dconf", "load", f"/org/gnome/shell/extensions/{config.stem}/"], stdin=settings, check=True)
    # Newly installed extensions may not yet be visible to the running Shell.
    # Preserve other enabled extensions and request activation on next login.
    current = output("gsettings", "get", "org.gnome.shell", "enabled-extensions")
    enabled = ast.literal_eval(current.removeprefix("@as "))
    for uuid in uuids:
        if uuid not in enabled:
            enabled.append(uuid)
    subprocess.run(["gsettings", "set", "org.gnome.shell", "enabled-extensions", repr(enabled)], check=True)
    print("Extensions configured. Log out and back in to activate newly installed extensions.")


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"Extension setup failed: {error}", file=sys.stderr)
        sys.exit(1)
