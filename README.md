dotfiles
===

## Overview

This repository is a self-contained package of all my dotfiles.

## Git Installation

1. Run `git/config-basic.sh`
1. Run `git/config-alias.sh`
1. Run `git/config-user-noreply.sh` if no other user name configured
1. Run `git/config-diff-cli.sh` if using CLI
1. Run `git/config-diff-meld.sh` if using graphical Linux
1. Run `git/config-editor-nvim-qt.sh` if using graphical Linux/Windows
1. Run `git/config-editor-nvim.sh` if using CLI Linux

## Neovim Installation

Windows: Run `setup/neovim-install.ps1`

Linux:

1. Run `setup/neovim-install.sh`
1. Add the following to whatever vimrc or init.vim file:
    * `source /absolute/path/to/pbshilli-dotfiles/vim/init_nvim.vim`

## tmux Installation

In the home directory:
`echo source-file /path/to/dotfiles/tmux/tmux.conf > .tmux.conf`
