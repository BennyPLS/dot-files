This is my Shell Prompt application of preference and i have a configuration explained below i use this prompt for all my O.S

## Installation

To "install" this prompt I will refer to the official documentation.

[Official Installation Tutorial](https://starship.rs/guide/#%F0%9F%9A%80-installation)

#### Manjaro Arch Linux Tutorial.

##### Installation : 
```shell 
pacman -S starship
```

##### Applying the theme.
Add the following line to your fish config file.
```Fish
starship init fish | source
```

#### Windows 10 & 11

##### Installation : 
```powershell
winget install --id Starship.Starship
```

##### Applying the theme :

###### PowerShell
Add the following line to your PowerShell config file.
```powershell
Invoke-Expression (&starship init powershell)
```

###### CMD
While using Clink create this file with the following contents.
Path : 
```Windows-Path
%LocalAppData%\clink\starship.lua
```
Content : 
```Clink
load(io.popen('starship init cmd'):read("*a"))()
```

## Explanation

For starters, my configuration is a 3-line prompt.

![[Starship Promt Configuration.png]]

First line : `Benny-LenovoLeguion with benny in dot-files on  main [✘!?]`
(host-name) with (user name) in (directory) on (Git, Rust, JavaScript, etc.) and if the (sudo password is cached) and the (time) that took the last command to execute.

Second line : ` 10% with `
The second line is the level of the battery and the shell, (depending on the shell you are using will be a symbol or text).

Las line : `x 127 ❯`
Finally in the last line will be the error code if the last command returned a failed code error and a symbol.

This configuration of starship configuration uses Nerd Font Icons all the used icons are explicitly in the configuration file.

## Other...

> [!FAQ]- Configuration File?
> [[starship.toml]]

> [!INFO]- Website
> [Starship Website](https://starship.rs/)

