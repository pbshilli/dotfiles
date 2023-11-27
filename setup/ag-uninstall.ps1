# Use default prj path if not defined
if (!(Test-Path Variable:PrjPath)) {
    $PrjPath = "$env:USERPROFILE\prj"
}
$AppPath = "$PrjPath\ag"

# If anything goes wrong, don't continue
$ErrorActionPreference = "Stop"

# Clean up ag path
Remove-Item -Path "$AppPath" -Recurse -Force -ErrorAction Continue

# Remove ag from the user-level env:PATH (if not already removed)
$EnvUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($EnvUserPath.Contains(";$AppPath")) {
    $EnvUserPath = $EnvUserPath.replace(";$AppPath","")
    [Environment]::SetEnvironmentVariable("Path", $EnvUserPath, "User")
    $env:Path = $env:Path.replace(";$AppPath","")
}
