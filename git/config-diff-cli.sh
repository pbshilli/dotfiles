# For command line only
git config --global diff.tool nvimdiff
git config --global merge.tool nvimdiff
git config --global merge.conflictstyle diff3

# For git instances that don't recognize nvimdiff:
# git config --global difftool.nvimdiff.cmd 'nvim -d $LOCAL $REMOTE'
