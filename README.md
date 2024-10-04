# vimfiles
Setting files for vim on Windows

## Prerequisites

- vim 9.1 or later
- Windows 11 (might work with Windows 10, but not tested)
- Powershell 7.4.5 or later

## Install

```powershell
git clone git@github.com:pathtrk/vimfiles.git $HOME/vimfiles  
vimfiles\install-vim-plug.ps1
```

The `install-vim-plug.ps1` script installs [vim-plug](https://github.com/junegunn/vim-plug) for plugin management.

Running `:PlugInstall` inside vim editor downloads specified plugins inside `vimrc` and make them ready.
