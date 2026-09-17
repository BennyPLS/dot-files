# GNOME extensions

Enabled on the source workstation (GNOME Shell 50.4). Install versions compatible with the new machine's GNOME release. Project links are below; enabled UUIDs are also listed in `gnome/enabled-extensions.txt`.

| Extension | UUID | Captured version |
| --- | --- | --- |
| [Unite](https://github.com/hardpixel/unite-shell) | `unite@hardpixel.eu` | 85 |
| [Removable Drive Menu](https://gitlab.gnome.org/GNOME/gnome-shell-extensions) | `drive-menu@gnome-shell-extensions.gcampax.github.com` | 82 |
| [AppIndicator and KStatusNotifierItem Support](https://github.com/ubuntu/gnome-shell-extension-appindicator) | `appindicatorsupport@rgcjonas.gmail.com` | 64 |
| [Caffeine](https://github.com/eonpatapon/gnome-shell-extension-caffeine) | `caffeine@patapon.info` | 60 |
| [Clipboard Indicator](https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator) | `clipboard-indicator@tudmotu.com` | 71 |
| [Color Picker](https://github.com/tuberry/color-picker) | `color-picker@tuberry` | 49 |
| [Gnome 4x, 5x UI Improvements](https://github.com/axxapy/gnome-ui-tune) | `gnome-ui-tune@itstime.tech` | 26 |
| [gSnap](https://github.com/GnomeSnapExtensions/gSnap) | `gSnap@micahosborne` | 27 |
| [Dash to Panel](https://github.com/home-sweet-gnome/dash-to-panel) | `dash-to-panel@jderose9.github.com` | 74 |
| [User Themes](https://gitlab.gnome.org/GNOME/gnome-shell-extensions) | `user-theme@gnome-shell-extensions.gcampax.github.com` | 79 |
| [ArcMenu](https://gitlab.com/arcmenu/ArcMenu) | `arcmenu@arcmenu.com` | 73 |

## Captured preferences

- Dash to Panel: grouped apps, intelligent hiding, custom indicator colors, window previews, and the recorded panel behavior. On new hardware, select the primary display and set the preferred top panel with size 40 and a centered taskbar manually.
- Unite: hide app-menu icon, no app-menu button, no desktop name. Generated GTK decoration imports are recreated on the target machine.
- gSnap: modifier required, four-pixel margins, snapping allowed. Layouts are stored separately in `gnome/extensions/gsnap-layouts.json`.
- Caffeine: user-enabled; keeps the session awake when active.
- User Themes: `Graphite-red-Dark-nord`.
- Clipboard Indicator: history limit 50, cache size 10, clear on boot, no paste on selection, Ctrl+Alt+V menu shortcut. Clipboard contents are not exported.
- ArcMenu: Alt+Space runner, centered, on the primary monitor; pinned entries include Files, GNOME Terminal, and ArcMenu Settings. The GNOME Terminal pin reflects the captured state; replace it with Ghostty in ArcMenu on the new machine.
- AppIndicator, Removable Drive Menu, GNOME UI Improvements, and Color Picker have no portable saved overrides in this snapshot. Their version defaults apply. Color Picker's recent color history was omitted.

CodexBar is installed on the source but disabled, so it is not included in the enabled list or settings export.

## Install extensions

Find the listed names on [GNOME Extensions](https://extensions.gnome.org/) or follow each project's installation instructions above. Install a release compatible with the new GNOME version; the captured versions identify the old setup, not required versions to pin. Enable installed extensions through the Extensions application. User Themes must be enabled to select the Graphite Shell theme.

## Import customized extension settings

Only extensions with saved preferences have `.dconf` files under `gnome/extensions/`. Import individual files after installing their corresponding extensions. These commands are Bash examples, run as the desktop user from the repository root:

```bash
mkdir -p "$HOME/extension-settings-backup"
for name in dash-to-panel unite gsnap caffeine user-theme arcmenu clipboard-indicator; do
    dconf dump "/org/gnome/shell/extensions/$name/" > "$HOME/extension-settings-backup/$name.dconf"
    dconf load "/org/gnome/shell/extensions/$name/" < "gnome/extensions/$name.dconf"
done
```

You can import just one extension by running its `dconf load` command. Imports update the saved keys; version defaults still apply to other settings. Keep your backup before repeating an import. To restore a saved backup, use the same extension path with the corresponding backup file as input.

For gSnap, back up existing `~/.config/gSnap/layouts.json`, then copy `gnome/extensions/gsnap-layouts.json` there. It contains None, H-Split, and V-Split definitions plus old monitor/workspace assignments; reassign those in gSnap on the new machine.

No configuration file is needed here for AppIndicator, Removable Drive Menu, GNOME UI Improvements, or Color Picker. Enable them and use their defaults. No general desktop dump, GTK CSS copy, or monitor snapshot is included.

See [GNOME appearance setup](GNOME%20and%20GTK.md) for theme, cursor, icon, and font downloads and installation.
