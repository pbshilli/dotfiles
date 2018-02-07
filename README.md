dotfiles
===

## Overview

This repository is a self-contained package of all my dotfiles.

## Git Installation

1. Verify all settings in `git/git_setup_global.sh` are correct/desired
1. Run `git/git_setup_global.sh`

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

In the home directory: `ln -s /path/to/tmux/.tmux.conf`
