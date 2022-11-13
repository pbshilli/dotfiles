$NEOVIM_VERSION = '0.8.0'

# Use default prj path if not defined
if (!(Test-Path Variable:PrjPath)) {
    $PrjPath = "$env:USERPROFILE\prj"
}
$AppPath = "$PrjPath\Neovim"
$AppBinPath = "$AppPath\bin"

# Remove old Neovim install
Remove-Item -Path $AppPath -Recurse -Force -ErrorAction SilentlyContinue

# Set up Neovim
Invoke-WebRequest "https://github.com/neovim/neovim/releases/download/v$NEOVIM_VERSION/nvim-win64.zip" -OutFile "$PrjPath\nvim-win64.zip"
Expand-Archive -Path  "$PrjPath\nvim-win64.zip" -DestinationPath $PrjPath
Move-Item -Path  "$PrjPath\nvim-win64" -Destination $AppPath
Remove-Item "$PrjPath\nvim-win64.zip"
New-Item -Path "$env:LOCALAPPDATA\nvim" -ItemType Directory -Force
New-Item -Path "$env:LOCALAPPDATA\nvim-data\site\autoload" -ItemType Directory -Force
Write-Output 'source ~/git/pbshilli-dotfiles/vim/init_nvim.vim' | Out-File -encoding ascii "$env:LOCALAPPDATA\nvim\init.vim"
Invoke-WebRequest 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' -OutFile "$env:LOCALAPPDATA\nvim-data\site\autoload\plug.vim"
Invoke-Expression "$AppBinPath\nvim.exe -c PlugInstall -c qa"

# Add Neovim to the user-level env:PATH (if not already added)
$EnvUserPath = $(Get-ItemProperty -Path HKCU:\Environment -Name Path).path
if (!($EnvUserPath.Contains($AppBinPath))) {
    Set-ItemProperty -Path HKCU:\Environment -Name Path -Value "$EnvUserPath;$AppBinPath"
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
