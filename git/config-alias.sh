# Common git aliases
git config --global alias.ci "commit"
git config --global alias.co "checkout"
git config --global alias.df "diff"
git config --global alias.ds "diff --stat"
git config --global alias.dt "difftool"
git config --global alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit"
git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"
git config --global alias.mt "mergetool"
git config --global alias.rou "config remote.origin.url"
git config --global alias.st "status"
git config --global alias.su "submodule update"
git config --global alias.nuke "!git reset --hard && git submodule update --init --recursive && git clean -dfx -e*.swp"

