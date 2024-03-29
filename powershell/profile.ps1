# Set up tab completion like bash
Set-PSReadLineKeyHandler -key Tab -function Complete

# MD5 Hash
Function Get-MD5-Hash( $filename ) { $( Get-FileHash -Algorithm MD5 $filename ).hash }
Set-Alias -Name md5 -Value Get-MD5-Hash

# Exiting
Function Exit { exit }
Set-Alias -Name :q -Value Exit

# Vim aliases
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim

# Make typos like "gi tst" to resolve to "git st"
Function Git-Typo-Fixer {
    Param([String[]]$Action)
    if ($Action.StartsWith("t")) {
        git $Action.SubString(1)
    }
    else {
        Throw "`"gi $Action`" too far gone to automatically fix"
    }
}
Del alias:gi -Force
Set-Alias -Name gi -value Git-Typo-Fixer

Function Get-UnidentifiedNetworkCategory {
    Get-NetConnectionProfile | Where-Object -Property Name -eq "Unidentified Network" | Select-Object InterfaceAlias, NetworkCategory
}
Set-Alias -Name gunc -Value Get-UnidentifiedNetworkCategory

Function Set-UnidentifiedNetworkCategory {
    Param([String[]]$NetworkCategory="Private")
    $InterfaceAlias = $(Get-UnidentifiedNetworkCategory | Select-Object -Last 1).InterfaceAlias
    Set-NetConnectionProfile -InterfaceAlias $InterfaceAlias -NetworkCategory $NetworkCategory
    Get-UnidentifiedNetworkCategory
}
Set-Alias -Name sunc -Value Set-UnidentifiedNetworkCategory
