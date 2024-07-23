### Search OSDCloud and WinPE partitions
$disk       = Get-WMIObject Win32_Volume | Where-Object { $_.Label -eq 'OSDCloudUSB' }
$disk       = $disk.Name

### Getting version from GitHub .\Update\Version.txt and .\Update\VersionWinPE.txt
$version        = Invoke-WebRequest -Uri "$RepositoryURL/Update/Version.txt" -UseBasicParsing
$version        = $version.Content.Split([Environment]::NewLine) | Select-Object -First 1

### Setting file names and locations
$file           = "Version.txt"
$folder         = 'OSDCloud\'
$location       = "$disk$folder"

### Getting versions from USB drive
$versionondisk  = Get-Content "$location$file" -ErrorAction SilentlyContinue
Clear-Host
if ($disk -eq $null) {
    Write-host " OSDCloudUSB drive not found" -ForegroundColor Red
    Write-host " Check that the partition name matches: OSDCloudUSB" -ForegroundColor Red
    Write-Host
} else {
    ### Version check
    if ($versionondisk -eq $version){
        Write-host " OSDCloudUSB already updated to version $version" -ForegroundColor Green
        Write-Host
    } else {
        Write-host " Updating OSDCloudUSB to version $version" -ForegroundColor Green
        New-Item -ItemType Directory -Path $location\Automate -force -ErrorAction SilentlyContinue | Out-Null
        ### Write new version + error handeling
        try {
            Invoke-WebRequest -Uri $RepositoryURL/Update/Automate/Start-OSDCloudGUI.json -OutFile $location\Automate\Start-OSDCloudGUI.json -UseBasicParsing
        } catch {
            Write-host " An error occurred: $($_.Exception.Message)" -ForegroundColor Red
            $error1 = 1
        }
        if ($error1 -eq "1"){
            Write-Host
        } else {
            New-Item -Path $location -Name "$file" -ItemType "file" -Value $version -Force -ErrorAction SilentlyContinue | Out-Null
            Write-host " Updating compleet to version $version" -ForegroundColor Green
            Write-Host
        }
    }
}

### Start OSDCloud GUI
Start-OSDCloudGUI
