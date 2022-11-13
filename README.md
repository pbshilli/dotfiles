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

## Vim Installation

1. [Install vim-plug](https://github.com/junegunn/vim-plug)
1. Create ~/.vimrc or ~/\_vimrc depending on the OS
1. Add the following to whatever vimrc or init.vim file:
    * `source /path/to/init.vim`
1. Open Vim, run `:PlugInstall` and restart

## VsVim Installation

Create ~/\_vsvimrc with the following contents:
`source /path/to/init_vs.vim`

## tmux Installation

In the home directory:
`echo source-file /path/to/dotfiles/tmux/tmux.conf > .tmux.conf`
