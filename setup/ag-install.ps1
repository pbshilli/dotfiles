# Use default prj path if not defined
if (!(Test-Path Variable:PrjPath)) {
    $PrjPath = "$env:USERPROFILE\prj"
}
$AppPath = "$PrjPath\ag"

# Set up ag path
New-Item -Path $PrjPath -ItemType Directory -Force
New-Item -Path "$AppPath" -ItemType Directory -Force

# Add ag to the user-level env:PATH (if not already added)
$EnvUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (!($EnvUserPath.Contains($AppPath))) {
    [Environment]::SetEnvironmentVariable("Path", "$EnvUserPath;$AppPath", "User")
    $env:Path = "$env:Path;$AppPath"
}

# Open up a web browser to get the latest ag release
Start-Process "https://github.com/k-takata/the_silver_searcher-win32/releases"

Write-Host "ag setup complete.  Manual tasks:"
Write-Host "  * Install the latest ag release to $PrjPath\ag"
