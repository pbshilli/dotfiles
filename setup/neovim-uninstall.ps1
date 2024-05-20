param(
    [String]$PrjPath="$env:USERPROFILE\prj"
)

$AppPath = "$PrjPath\Neovim"
$AppBinPath = "$AppPath\bin"

# Clean up ctags path
Remove-Item -Path "$PrjPath\ctags" -Recurse -Force -ErrorAction Continue

# Clean up Neovim context menu
Remove-Item -LiteralPath "HKCU:\Software\Classes\*\shell\Edit with Neovim" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "HKCU:\Software\Classes\Directory\shell\Open Neovim Here" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "HKCU:\Software\Classes\Directory\Background\shell\Open Neovim Here" -Recurse -Force -ErrorAction Continue

# Remove Neovim packages
Remove-Item -Path "$env:LOCALAPPDATA\nvim-data\site\pack\pbshilli-dotfiles" -Recurse -Force -ErrorAction Continue

# Remove Neovim from the user-level env:PATH (if not already removed)
$EnvUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($EnvUserPath.Contains(";$AppBinPath")) {
    $EnvUserPath = $EnvUserPath.replace(";$AppBinPath","")
    [Environment]::SetEnvironmentVariable("Path", $EnvUserPath, "User")
    $env:Path = $env:Path.replace(";$AppBinPath","")
}

# Clean up Neovim path
Remove-Item -Path "$AppPath" -Recurse -Force -ErrorAction Continue
