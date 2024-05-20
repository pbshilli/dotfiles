# Assumes git setup is completed
# Assumes Python 3 is installed with pip
param(
    [String]$PrjPath="$env:USERPROFILE\prj",
    [String]$GitPath="$env:USERPROFILE\git",
    [String]$DotfilesLocalName='pbshilli-dotfiles',
    # SSH version: Allows R/W access, but requires setting up SSH key in GitHub
    # $DotfilesURL = 'git@github.com:pbshilli/dotfiles.git'
    # HTTPS version: Read-only, but works out of the box
    [String]$DotfilesURL='https://github.com/pbshilli/dotfiles.git',
    [String]$NeovimVersion='0.9.0'
)

# Allow Unicode characters to be entered by ALT+<hex value> via the numpad
New-ItemProperty -Path 'HKCU:\Control Panel\Input Method\' -Name EnableHexNumpad -Value 1 -PropertyType String -Force

# Disable Bing when performing a Windows search
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Value 0 -PropertyType DWord -Force

# Add/update dotfiles
New-Item -Path $GitPath -ItemType Directory -Force
Push-Location -Path $GitPath
if (Test-Path $DotfilesLocalName) {
    Push-Location -Path $DotfilesLocalName
    git pull
    Pop-Location
} else {
    git clone $DotfilesURL $DotfilesLocalName
}
Pop-Location

# Create a local profile if it doesn't exist
if (!(Test-Path $PROFILE)) {
    New-Item $PROFILE -Force
}

# Connect the Git dotfiles profile to the local profile
$GitProfileInLocal = Select-String -Path $PROFILE -Pattern $DotfilesLocalName -SimpleMatch
if ($GitProfileInLocal -eq $null) {
    Add-Content -Path $PROFILE -Value ". $GitPath\$DotfilesLocalName\powershell\profile.ps1"
}

& $GitPath\$DotfilesLocalName\setup\neovim-install.ps1 `
    -PrjPath $PrjPath `
    -DotfilesLocalName $DotfilesLocalName `
    -NeovimVersion $NeovimVersion
& $GitPath\$DotfilesLocalName\setup\ag-install.ps1 `
    -PrjPath $PrjPath

# Set up the Python language server
py -3-64 -m pip install --user python-lsp-server
