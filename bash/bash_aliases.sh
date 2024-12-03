# Copy relevant lines to ~/.bash_aliases
export EDITOR=nvim

alias :q='exit'

alias vi=nvim
alias vim=nvim
alias vims='vim -S'

# GNOME Keyring command line utilities
. ~/git/pbshilli-dotfiles/bash/gnome-keyring.sh
alias ks='keyring-status'
