Clear-Host
Write-Host " ***************************"
Write-Host " *    Update OSDCloudUSB   *"
Write-Host " ***************************"
Write-Host

### Check if OSDCloudUSB drive is found
if ($disk -eq $null) {
    Write-host " OSDCloudUSB drive not found" -ForegroundColor Red
    Write-host " Check that the partition name matches: OSDCloudUSB" -ForegroundColor Red
    Write-Host
    cmd /c 'pause'
} else {
    ### Version check
    if ($versionondisk -eq $version){
        Write-host " OSDCloudUSB already updated to version $version" -ForegroundColor Green
        Write-Host
        cmd /c 'pause'
    } else {
        Write-host " Updating OSDCloudUSB to version $version" -ForegroundColor Green
        New-Item -ItemType Directory -Path $location\Automate -force -ErrorAction SilentlyContinue | Out-Null
        ### Write new version + error handeling
        try {
            Invoke-WebRequest -Uri $RepositoryURL/Update/Automate/Start-OSDCloudGUI.json -OutFile $location\Automate\Start-OSDCloudGUI.json
        } catch {
            Write-host " An error occurred: $($_.Exception.Message)" -ForegroundColor Red
            $error1 = 1
        }
        if ($error1 -eq "1"){
            Write-Host
            cmd /c 'pause'
        } else {
            Invoke-WebRequest -Uri $RepositoryURL/Update/Start-Menu.ps1 -OutFile $disk\Start-Menu.ps1
            New-Item -Path $location -Name "$file" -ItemType "file" -Value $version -Force -ErrorAction SilentlyContinue | Out-Null
            Write-host " Updating compleet to version $version" -ForegroundColor Green
            Write-Host
            cmd /c 'pause'
        }
    }
}
