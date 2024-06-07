Clear-Host
Write-Host " ***************************"
Write-Host " *  OSDCloud Installation  *"
Write-Host " ***************************"
Write-Host

### Test if any USB drive is fount
$testdisk = GET-WMIOBJECT win32_diskdrive | Where-Object { $_.mediatype -eq 'Removable Media' -or $_.mediatype -eq 'Removable Media' -or $_.InterfaceType -eq 'USB' }
#Option 2: $testdisk2 = Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"}
if ( $testdisk -eq $null) {
    Write-Host "No USB Drive found, going back to menu"
    Write-Host
    cmd /c 'pause'
    Invoke-WebPSScript "$RepositoryURL/OSDCloudUpdateMenu.ps1"
} else {
    Write-Host " Downloading WinPE"
    Write-Host
    
    ### Starting WinPE install from Azure Blob and writing the necessary files
    New-OSDCloudUSB -fromIsoUrl "$ISOURL"
    
    ### Re-enter Variables that where set in OSDCloudUpdateMenu.ps1
    ### Search OSDCloud disk after installation
    $disk = Get-WMIObject Win32_Volume | Where-Object { $_.Label -eq 'OSDCloudUSB' }
    $disk = $disk.Name
    
    ### Creating files on de OSDCloud drive
    New-Item -ItemType Directory -Path $location\Automate -force -ErrorAction SilentlyContinue | Out-Null
    Invoke-WebRequest -Uri $RepositoryURL/Update/Automate/Start-OSDCloudGUI.json -OutFile $location\Automate\Start-OSDCloudGUI.json
    New-Item -Path "$location" -Name "$file" -ItemType "file" -Value $version -force -ErrorAction SilentlyContinue | Out-Null
    New-Item -Path "$location" -Name "$fileWinPE" -ItemType "file" -Value $versionWinPE -force -ErrorAction SilentlyContinue | Out-Null
    
    $MainMenu = {
        Write-Host " ***************************"
        Write-Host " *  OSDCloud Installation  *"
        Write-Host " ***************************"
        Write-Host
        Write-Host " WinPE Installation complete"
        Write-Host " Install one more WinPE to a USB drive?"
        Write-Host
        Write-Host " 1.) Yes (insert new USB drive before continuing)"
        Write-Host " 2.) No (delete downloaded ISO)"
        Write-Host " Q.) Back (keeps ISO in Download folder)"
        Write-Host
        Write-Host " Select an option and press Enter: "  -nonewline
    }
    Clear-Host
    Do {
        Clear-Host
        Invoke-Command $MainMenu
        $Select = Read-Host
        Switch ($Select)
            {
            1 {
                Invoke-WebPSScript $RepositoryURL/OSDCloudInstallWinPE.ps1
            }
            2 {
                ### Getting the active download folder, Dismounting the image (if mounted) and removing the ISO file
                Dismount-DiskImage -ImagePath "$DownloadsPath\OSDCloud_NoPrompt.iso" -ErrorAction SilentlyContinue | Out-Null
                Remove-Item $DownloadsPath\OSDCloud_NoPrompt.iso -ErrorAction SilentlyContinue | Out-Null
                Invoke-WebPSScript $RepositoryURL/OSDCloudUpdateMenu.ps1
            }
            Q {
                Invoke-WebPSScript $RepositoryURL/OSDCloudUpdateMenu.ps1
            }
        }       
    }
    While ($Select -ne "Z")
}
