# Use default prj path if not defined
if (!(Test-Path Variable:PrjPath)) {
    $PrjPath = "$env:USERPROFILE\prj"
}
# Use default git path if not defined
if (!(Test-Path Variable:GitPath)) {
    $GitPath = "$env:USERPROFILE\git"
}

if (!(Test-Path Variable:DotfilesLocalName)) {
    $DotfilesLocalName = 'pbshilli-dotfiles'
}

# If anything goes wrong, don't continue
$ErrorActionPreference = "Stop"

# Before removing personal dotfiles, make sure there's
# no outstanding changes about to be # discarded
if (Test-Path "$GitPath\$DotfilesLocalName") {
    Push-Location -Path "$GitPath\$DotfilesLocalName"
    if ($(git diff --shortstat)) {
        throw "There are modified files in $GitPath\$DotfilesLocalName"
    }
    if ($(git ls-files --other --directory --exclude-standard)) {
        throw "There are untracked files in $GitPath\$DotfilesLocalName"
    }
    Pop-Location
}

# Clean up the Python language server
py -3 -m pip uninstall python-language-server -y

& $PSScriptRoot\ag-uninstall.ps1
& $PSScriptRoot\neovim-uninstall.ps1

# Disconnect the Git dotfiles profile from the local profile
Get-Content $PROFILE | Where-Object {$_ -notlike ". $GitPath\$DotfilesLocalName\powershell\profile.ps1"} | Out-File $PROFILE

# Remove personal dotfiles
Remove-Item -Path "$GitPath\$DotfilesLocalName" -Recurse -Force
