### Getting Windows versions and language opties from "Start-OSDCloudGUI.json"
$json     = Invoke-WebRequest $RepositoryURL/Update/Automate/Start-OSDCloudGUI.json | ConvertFrom-Json
$WinVer   = $json | ForEach-Object { $_.OSNameValues }
$winVer   = $WinVer.Replace(" x64", "")
$WinLang  = $json | ForEach-Object { $_.OSLanguageValues }

Clear-Host
Write-Host " ***************************"
Write-Host " * OSDCloud Offline Windows*"
Write-Host " ***************************"
Write-Host
Write-Host " Select a Windows version:"

### Listing Windows versions
$MenuVer = @{}
$WinVer | ForEach-Object -Begin {$i = 1} { 
     Write-Host " $i.) $_" 
     $MenuVer.add("$i",$_)
     $i++
}
Write-Host " Q.) Back"
Write-Host
$WinVerSelection = Read-Host " Select an option and press Enter: "

if ($WinVerSelection -eq 'Q') { 
     Invoke-WebPSScript $RepositoryURL/OSDCloudUpdateMenu.ps1
} Else { 
Clear-Host
Write-Host " ***************************"
Write-Host " * OSDCloud Offline Windows*"
Write-Host " ***************************"
Write-Host
Write-Host " Select a Windows language: "

### Listing language opties
$MenuLang = @{}
$WinLang | ForEach-Object -Begin {$i = 1} { 
     Write-Host " $i.) $_" 
     $MenuLang.add("$i",$_)
     $i++
}
Write-Host " Q.) Back"
Write-Host
$WinLangSelection = Read-Host " Select an option and press Enter: "

if ($WinLangSelection -eq 'Q') { 
     Invoke-WebPSScript $RepositoryURL/OSDCloudUpdateMenu.ps1
} Else { 
     Clear-Host
     Update-OSDCloudUSB -OSName $MenuVer.$WinVerSelection -OSLanguage $menuLang.$WinLangSelection -OSLicense Retail
}
}
