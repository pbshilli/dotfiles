# Use default prj path if not defined
if (!(Test-Path Variable:PrjPath)) {
    $PrjPath = "$env:USERPROFILE\prj"
}
$AppPath = "$PrjPath\Neovim"
$AppBinPath = "$AppPath\bin"

# Clean up ctags path
Remove-Item -Path "$PrjPath\ctags" -Recurse -Force -ErrorAction Continue

# Clean up Neovim context menu
Remove-Item -LiteralPath "HKCU:\Software\Classes\*\shell\Edit with Neovim" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "HKCU:\Software\Classes\Directory\shell\Open Neovim Here" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "HKCU:\Software\Classes\Directory\Background\shell\Open Neovim Here" -Recurse -Force -ErrorAction Continue

# Remove Neovim from the user-level env:PATH (if not already added)
$EnvUserPath = $(Get-ItemProperty -Path HKCU:\Environment -Name Path).path
$EnvUserPath = $EnvUserPath.replace(";$AppBinPath","")
Set-ItemProperty -Path HKCU:\Environment -Name Path -Value $EnvUserPath

# Clean up Neovim path
Remove-Item -Path "$AppPath" -Recurse -Force -ErrorAction Continue
