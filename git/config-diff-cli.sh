# For command line only
git config --global diff.tool nvimdiff
git config --global merge.tool nvimdiff
git config --global merge.conflictstyle diff3

# Set up nvimdiff such that the right side is NOT read-only
git config --global difftool.nvimdiff.cmd 'nvim -R -f -d -c "wincmd l" -c "set noreadonly" -c '\''cd "$GIT_PREFIX"'\'' "$LOCAL" "$REMOTE"'
