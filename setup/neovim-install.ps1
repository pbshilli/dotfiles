$NEOVIM_VERSION = '0.9.0'

# Use default prj path if not defined
if (!(Test-Path Variable:PrjPath)) {
    $PrjPath = "$env:USERPROFILE\prj"
}

if (!(Test-Path Variable:DotfilesLocalName)) {
    $DotfilesLocalName = 'pbshilli-dotfiles'
}

$AppPath = "$PrjPath\Neovim"
$AppBinPath = "$AppPath\bin"

$InitVimPath = "$env:LOCALAPPDATA\nvim\init.vim"

# Remove old Neovim install
Remove-Item -Path $AppPath -Recurse -Force -ErrorAction SilentlyContinue

# Set up Neovim
Invoke-WebRequest "https://github.com/neovim/neovim/releases/download/v$NEOVIM_VERSION/nvim-win64.zip" -OutFile "$PrjPath\nvim-win64.zip"
Expand-Archive -Path  "$PrjPath\nvim-win64.zip" -DestinationPath $PrjPath
Move-Item -Path  "$PrjPath\nvim-win64" -Destination $AppPath
Remove-Item "$PrjPath\nvim-win64.zip"

# Create a local init.vim if it doesn't exist
New-Item -Path "$env:LOCALAPPDATA\nvim" -ItemType Directory -Force
if (!(Test-Path $InitVimPath)) {
    New-Item $InitVimPath -Force
}

# Connect the Git dotfiles profile to the local profile
$GitProfileInLocal = Select-String -Path $InitVimPath -Pattern $DotfilesLocalName -SimpleMatch
if ($GitProfileInLocal -eq $null) {
    Add-Content -Path $InitVimPath -Value "source ~/git/$DotfilesLocalName/vim/init_nvim.vim" -Encoding ascii
}

# Download/install Neovim packages
# NOTE: pbshilli-dotfiles/start will autoload on Neovim start
#       pbshilli-dotfiles/opt will only load with :packadd
New-Item -Path "$env:LOCALAPPDATA\nvim-data\site\pack\pbshilli-dotfiles\start" -ItemType Directory -Force
Push-Location -Path "$env:LOCALAPPDATA\nvim-data\site\pack\pbshilli-dotfiles\start"

# Fuzzy file search
git clone https://github.com/kien/ctrlp.vim.git

# Color scheme
git clone https://github.com/romainl/Apprentice.git

# File explorer
git clone https://github.com/tpope/vim-vinegar.git
git clone https://github.com/tpope/vim-dispatch.git

# CTAGS utility
git clone https://github.com/ludovicchabant/vim-gutentags.git

# Syntax highlighting
git clone https://github.com/kergoth/vim-bitbake.git

# Secure modelines
git clone https://github.com/ciaranm/securemodelines.git

Pop-Location

# Add Neovim to the user-level env:PATH (if not already added)
$EnvUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (!($EnvUserPath.Contains($AppBinPath))) {
    [Environment]::SetEnvironmentVariable("Path", "$EnvUserPath;$AppBinPath", "User")
    $env:Path = "$env:Path;$AppBinPath"
}

# Set up Neovim context menu to point to this install
New-Item -Path "HKCU:\Software\Classes\*\shell" -Force
Push-Location -LiteralPath "HKCU:\Software\Classes\*\shell"
New-Item -Name "Edit with Neovim" -Force
New-Item -Path "Edit with Neovim" -Name command -Value "`"$AppBinPath\nvim-qt.exe`" `"%1`"" -Force
New-ItemProperty -Path "Edit with Neovim" -Name Icon -Value "$AppBinPath\nvim-qt.exe,0" -Force
Pop-Location
New-Item -Path "HKCU:\Software\Classes\Directory\shell" -Force
Push-Location -Path "HKCU:\Software\Classes\Directory\shell"
New-Item -Name "Open Neovim Here" -Force
New-Item -Path "Open Neovim Here" -Name command -Value "`"$AppBinPath\nvim-qt.exe`" `"%1`"" -Force
New-ItemProperty -Path "Open Neovim Here" -Name Icon -Value "$AppBinPath\nvim-qt.exe,0" -Force
Pop-Location
New-Item -Path "HKCU:\Software\Classes\Directory\Background\shell" -Force
Push-Location -Path "HKCU:\Software\Classes\Directory\Background\shell"
New-Item -Name "Open Neovim Here" -Force
New-Item -Path "Open Neovim Here" -Name command -Value "$AppBinPath\nvim-qt.exe" -Force
New-ItemProperty -Path "Open Neovim Here" -Name Icon -Value "$AppBinPath\nvim-qt.exe,0" -Force
Pop-Location

# Set up ctags path
New-Item -Path "$PrjPath\ctags" -ItemType Directory -Force

# Open up a web browser to get the latest ctags release
Start-Process "https://github.com/universal-ctags/ctags-win32/releases"

Write-Host "Neovim setup complete.  Manual tasks:"
Write-Host "  * Install the latest ctags release to $PrjPath\ctags"
Write-Host "  * Set up file type associations with Neovim"
