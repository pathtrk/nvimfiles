# vimfiles
Setting files for vim on Windows, Linux or macOS

<img src="https://github.com/user-attachments/assets/4d4b13a0-1f3e-4013-9413-9c7ef9b37884" width="760">


## Prerequisites

- Neovim 0.11+

## Cloning this repo

For macOS/Linux:

```bash
git clone git@github.com:pathtrk/nvimfiles.git
cd nvimfiles
bash setup/mac/install-nvim.sh
```

This will create ~/.config/nvim directory and copy and place init.vim there.

For Windows, copy or link nvim directory to the configuration directory.


## Installing plugins

```
nvim -qa PlugInstall
```

## Appendix

### Applying the saved settings for Windows Terminal

Place `windows_setup/terminal/settings.json` into your settings directory of Wndows Teminal app.

Otherwise you can copy the file contents and paste into your `settings.json` that can be opened from Windows Terminal's settings menu, then save yours.
