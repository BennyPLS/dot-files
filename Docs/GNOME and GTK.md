# GNOME appearance setup

Use this guide on the new Arch workstation to recreate the desktop appearance. Theme assets are downloaded from their authors; this repository keeps only configuration for customized GNOME extensions.

For automated setup, use [the GNOME setup script](Setup%20scripts.md). The steps below are the manual alternative.

## Theme: Graphite Nord, red, dark, rimless

Source and installation reference: [vinceliuice/Graphite-gtk-theme](https://github.com/vinceliuice/Graphite-gtk-theme).

Run these commands on the new machine:

```sh
sudo pacman -S --needed git sassc gnome-themes-extra gnome-tweaks
mkdir -p "$HOME/.local/src"
git clone https://github.com/vinceliuice/Graphite-gtk-theme.git "$HOME/.local/src/Graphite-gtk-theme"
cd "$HOME/.local/src/Graphite-gtk-theme"
./install.sh -t red -c dark --tweaks nord rimless -l
```

The options select red accents, dark appearance, the Nord palette, and rimless windows/menus. `-l` applies the theme's GTK 4/libadwaita integration. On an existing machine, back up `~/.config/gtk-4.0` first because that integration changes its files. Run the installer as your regular user; its theme destination defaults to `~/.themes`.

Select the installed theme:

```sh
gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-red-Dark-nord'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

Install and enable **User Themes** from the [extension list](Gnome%20Extensions.md), then choose `Graphite-red-Dark-nord` as the Shell theme in GNOME Tweaks. Its saved extension configuration also selects this theme. Rimless is an installer tweak, not a separate GNOME setting.

## Cursor: Oreo Spark Red

Source: [varlesh/oreo-cursors](https://github.com/varlesh/oreo-cursors). The upstream README links to [prebuilt cursor downloads on Pling](https://www.pling.com/p/1360254/).

Download and extract the prebuilt theme containing **`oreo_spark_red_cursors`**. Place that theme directory in `~/.icons/`, creating the parent directory if needed. Check that `~/.icons/oreo_spark_red_cursors/index.theme` and its `cursors/` directory exist; avoid an extra archive wrapper directory.

Select the current workstation's variant and size:

```sh
gsettings set org.gnome.desktop.interface cursor-theme 'oreo_spark_red_cursors'
gsettings set org.gnome.desktop.interface cursor-size 32
```

Alternatively, build from the GitHub source following its manual installation instructions; it requires Git, Make, Inkscape, xcursorgen, and Ruby. The prebuilt download avoids building all cursor variants.

## Icons: Candy

Source: [EliverLara/candy-icons](https://github.com/EliverLara/candy-icons). Download its ZIP or clone directly into the user icon directory:

```sh
mkdir -p "$HOME/.icons"
git clone https://github.com/EliverLara/candy-icons.git "$HOME/.icons/candy-icons"
gsettings set org.gnome.desktop.interface icon-theme 'candy-icons'
```

If already installed as a Git checkout, update that checkout instead of cloning over it. Candy is the icon pack selected on the current workstation; Graphite's suggested icon pack is not part of this setup.

## Fonts

The current workstation uses JetBrains Mono Nerd Fonts:

```sh
sudo pacman -S --needed ttf-jetbrains-mono-nerd
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font Propo 11'
gsettings set org.gnome.desktop.interface document-font-name 'JetBrainsMono Nerd Font Propo 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 11'
```

Ghostty may choose its font separately. Keep its current defaults unless you want to customize them.

## Wallpaper and extensions

The current wallpaper is `wave-Dark-nord.jpg`. Get it from the theme author's [Graphite wallpaper directory](https://github.com/vinceliuice/Graphite-gtk-theme/tree/main/wallpaper), then select it in GNOME Settings → Appearance/Background.

Follow [GNOME extensions](Gnome%20Extensions.md) for the installed extension list, custom preferences, and optional configuration imports. Log out and back in after setup, then inspect GTK applications, the Shell theme, cursor, icons, and panel. Theme support can vary with the installed GNOME/GTK release; use the upstream instructions when updating.

## Why Nautilus uses the theme

On the inspected machine, `~/.profile` configures JetBrains Toolbox, Rust, and Vite+ paths. It does not set `GTK_THEME` or another GTK theme variable. The inspected GNOME Shell process also has no `GTK_THEME` override.

`~/.config/gtk-4.0/gtk.css` contains Graphite CSS plus Unite's window decoration import. Its `assets` and `gtk-dark.css` entries point into the installed Graphite theme. Graphite's `-l` option recreates this GTK 4 integration. The setup script uses it without editing `.profile`.

GTK documents [`GTK_THEME`](https://gnome.pages.gitlab.gnome.org/gtk/gtk4/running.html) as a debugging override. Setting it globally is not needed to reproduce this configuration.

## Login screen

See [Keep Graphite on the login screen](GDM.md) for the GDM installer and pacman hook that reapplies the theme after GNOME Shell updates.
