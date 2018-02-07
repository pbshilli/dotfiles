# Identitiy
git config --global user.name "Peter Shilliday"
git config --global user.email pbshilli@users.noreply.github.com

# Basic preferences
git config --global core.editor vim
git config --global color.interactive.prompt "bold white"
git config --global rebase.stat true
git config --global diff.context 7
git config --global status.showuntrackedfiles all

# Global gitignore
git config --global core.excludesfile ~/.gitignore
echo "*.swp" > ~./gitignore

# Common git aliases
git config --global alias.ci "commit"
git config --global alias.co "checkout"
git config --global alias.df "diff"
git config --global alias.ds "diff --stat"
git config --global alias.dt "difftool"
git config --global alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit"
git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"
git config --global alias.mt "mergetool"
git config --global alias.st "status"
git config --global alias.su "submodule update"
git config --global alias.nuke "!git reset --hard && git clean -dfx -e*.swp"

# For graphical diffs
git config --global diff.tool meld
git config --global merge.tool meld
git config --global merge.conflictstyle diff3
git config --global difftool.prompt false
git config --global mergetool.prompt false

# For command line only
#git config --global diff.tool vimdiff
#git config --global merge.tool vimdiff
