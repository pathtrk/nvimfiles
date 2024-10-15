# vimfiles
Setting files for vim on Windows

## Prerequisites

- vim 9.1 or later
- Windows 11 (might work with Windows 10, but not tested)
- Powershell 7.4.5 or later

## Install

```powershell
git clone git@github.com:pathtrk/vimfiles.git $HOME\vimfiles  
```

`install-vim-plug.ps1` script installs [vim-plug](https://github.com/junegunn/vim-plug) for plugin management.

```powershell
cd $HOME\vimfiles
.\install-vim-plug.ps1
```

Running `:PlugInstall` inside vim editor downloads plugins specified in `vimrc` and makes them ready.
