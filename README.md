# vimfiles
Setting files for vim on Windows

## Prerequisites

- vim 9.1 or later
- Windows 11 (might work with Windows 10, but not tested)
- Powershell 7.4.5 or later

## Cloning this repo

On Windows 11:

```powershell
git clone --recurse-submodules git@github.com:pathtrk/vimfiles.git $HOME\vimfiles  
```

On Wsl or Linux:

```bash
git clone --recurse-submodules git@github.com:pathtrk/vimfiles.git $HOME/.vim
```

## Installing plugins via Vundle

Launch vim and run the following from the editor: 

```
PluginInstall
```

This downloads plugins specified in `vimrc` and makes them ready.
