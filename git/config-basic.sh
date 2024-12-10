# Basic preferences
git config --global color.interactive.prompt 'bold white'
git config --global rebase.stat true

# Push to the branch of the same name by default
git config --global push.default current
git config --global diff.context 7
git config --global status.showuntrackedfiles all
git config --global commit.verbose true

# When perfoming garbage collection, nuke all pruned branches
git config --global gc.pruneExpire now

