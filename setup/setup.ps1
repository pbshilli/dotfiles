# Assumes git setup is completed
# Assumes Python 3 is installed with pip

$prjpath = 'C:\Users\Peter\prj'
$gitpath = 'C:\Users\Peter\git'

# Allow Unicode characters to be entered by ALT+<hex value> via the numpad
New-ItemProperty -Path 'HKCU:\Control Panel\Input Method\' -Name EnableHexNumpad -Value 1 -PropertyType String

New-Item -Path $gitpath -ItemType Directory -Force
Push-Location -Path $gitpath
git clone https://github.com/pbshilli/dotfiles.git pbshilli-dotfiles
Pop-Location

New-Item -Path 'C:\Users\Peter\Documents\WindowsPowerShell' -ItemType Directory -Force
Write-Output ". $gitpath\pbshilli-dotfiles\powershell\profile.ps1" > 'C:\Users\Peter\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'

# Set up Neovim
New-Item -Path $prjpath -ItemType Directory -Force
Invoke-WebRequest https://github.com/neovim/neovim/releases/download/v0.5.0/nvim-win64.zip -OutFile "$prjpath\nvim-win64.zip"
Expand-Archive -Path  "$prjpath\nvim-win64.zip" -DestinationPath $prjpath
Remove-Item "$prjpath\nvim-win64.zip"
New-Item -Path 'C:\Users\Peter\AppData\Local\nvim' -ItemType Directory -Force
New-Item -Path 'C:\Users\Peter\AppData\Local\nvim\autoload' -ItemType Directory -Force
Write-Output 'source ~/git/pbshilli-dotfiles/vim/init_nvim.vim' | Out-File -encoding ascii 'C:\Users\Peter\AppData\Local\nvim\init.vim'
Invoke-WebRequest 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' -OutFile 'C:\Users\Peter\AppData\Local\nvim\autoload\plug.vim'
Invoke-Expression "$prjpath\Neovim\bin\nvim.exe -c PlugInstall -c qa"

# Set up ag and ctags paths
New-Item -Path "$prjpath\ag" -ItemType Directory -Force
New-Item -Path "$prjpath\ctags" -ItemType Directory -Force

# Add Neovim and ag to the user-level path
Push-Location -Path HKCU:\Environment
Set-ItemProperty -Path . -Name Path -Value $($(Get-ItemProperty -Path . -Name Path).path + "$prjpath\Neovim\bin;$prjpath\ag;")
Pop-Location

# Set up Neovim context menu
New-Item -Path "HKCU:\Software\Classes\*\shell" -Force
Push-Location -LiteralPath "HKCU:\Software\Classes\*\shell"
New-Item -Name "Edit with Neovim"
New-Item -Path "Edit with Neovim" -Name command -Value "`"$prjpath\Neovim\bin\nvim-qt.exe`" `"%1`""
New-ItemProperty -Path "Edit with Neovim" -Name Icon -Value "$prjpath\Neovim\bin\nvim-qt.exe,0"
Pop-Location
New-Item -Path "HKCU:\Software\Classes\Directory\shell" -Force
Push-Location -Path "HKCU:\Software\Classes\Directory\shell"
New-Item -Name "Open Neovim Here"
New-Item -Path "Open Neovim Here" -Name command -Value "`"$prjpath\Neovim\bin\nvim-qt.exe`" `"%1`""
New-ItemProperty -Path "Open Neovim Here" -Name Icon -Value "$prjpath\Neovim\bin\nvim-qt.exe,0"
Pop-Location
New-Item -Path "HKCU:\Software\Classes\Directory\Background\shell" -Force
Push-Location -Path "HKCU:\Software\Classes\Directory\Background\shell"
New-Item -Name "Open Neovim Here"
New-Item -Path "Open Neovim Here" -Name command -Value "$prjpath\Neovim\bin\nvim-qt.exe"
New-ItemProperty -Path "Open Neovim Here" -Name Icon -Value "$prjpath\Neovim\bin\nvim-qt.exe,0"
Pop-Location

# Set up the Python language server
py -3 -m pip install --user python-language-server

# Open up a web browser to get the latest ctags and ag releases
Start-Process "https://github.com/universal-ctags/ctags-win32/releases"
Start-Process "https://github.com/k-takata/the_silver_searcher-win32/releases"

Write-Host "Setup complete.  Some manual tasks:"
Write-Host "  * Install the latest ag release to $prjpath\ag"
Write-Host "  * Install the latest ctags release to $prjpath\ctags"
Write-Host "  * Set up file type associations with Neovim"

