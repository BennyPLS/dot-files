
## Base Distro [Arch](https://wiki.archlinux.org/) + [Manjaro](https://manjaro.org/download/) + [GNOME](https://www.gnome.org/)
---
## Drivers

### Neccesary Drivers

#### Lenovo Leguion 5 Realtek Wifi Card Driver
This is a neccesary driver for my **Lenovo Legion 5 15ACH6H**.
*  [Realtek 8852AE](https://github.com/lwfinger/rtw89)
---
### Optional Drivers

#### Logitech Options Unofficial
This is a neccesary dirver for using my Logitech Vertical Mouse.
* [Logi Ops](https://github.com/PixlOne/logiops)

#### Logitech G-Hub Unofficial
This is another neccesary driver to configure my Logitech 502 Wired and G413 carbon keyboard.
* [Piper](https://github.com/libratbag/piper)

---
## List of All Programs

### Console - Alacritty
For the terminal i use Alacritty that is a modern terminal emulator with higth configurability.
* [Alacritty](https://alacritty.org/) [Config File]()
---
#### Console Applications

##### Text-Editor - NeoVim w\\ NvChad
I use Neovim or Nvim to unfrecuenly edit configurations in the terminal in addition to Nvim i use the ***NvChad*** as base configuration of my NeoVim Instalation Setup. A note to this is becose i actualy use this line of Lua and VimScript, in the  `Path: ~/.config/nvim/init.lua`
```lua
vim.cmd [[ au VimLeave,VimSuspend * set guicursor=a:ver25 ]]
```
* [NeoVim](https://neovim.io/)
* [NvChad](https://nvchad.com/)

##### CCat Alternative Cat
CCat is a cat with syntax highlighting cat is that simple.
* [CCat](https://github.com/owenthereal/ccat)

##### Exa Alternative to Ls
Exa is a modern replacement for the command-line program ls.
* [Exa](https://the.exa.website/introduction)

##### Terminal File Manager - LF
This is a terminal file manager written in go.
 * [LF](https://github.com/gokcehan/lf)ç

##### Choss-Shell Promt - Starship
This is my Shell Promt application of preference and i have a configuration
* [Starship](https://starship.rs/) [Config File](starship.toml)
##### NeoFetch && Pfetch
I use neofetch in all starting consoles.
* [pFetch](https://github.com/dylanaraps/pfetch)
* [NeoFetch](https://github.com/dylanaraps/neofetch) [Config File](neofetch/config.conf)

---
### Desktop Applications

#### ScreenShot - Flameshot
Flameshot is a multiplatform screenshot open source free software.
* [FlameShot](https://flameshot.org/)

### Code Editors
Actualy i use the #JetBrains Suit.
* [JetBrains Home page](https://www.jetbrains.com/)
Alternatively i use nvim to script in bash or powershell.
And finally i use Visual Studio Code in certain ocasions

---
### Desktop Enviroment
For Desktop Enviroment I use Gnome with the following Extensions added.
* [Dash to Panel](https://github.com/home-sweet-gnome/dash-to-panel) [Config File](dashPanel.config)
* [Gnome Shell X11 Gestures](https://github.com/JoseExposito/gnome-shell-extension-x11gestures)
* [Unite Shell](https://github.com/hardpixel/unite-shell)
* [Gnome UI Tune](https://github.com/axxapy/gnome-ui-tune)
* [App Indicator](https://github.com/ubuntu/gnome-shell-extension-appindicator)
* [ClipBoard Indicator](https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator)
* [gSnap](https://github.com/GnomeSnapExtensions/gSnap)
