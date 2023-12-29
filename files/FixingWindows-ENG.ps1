# Start Script
# Check for administrator privileges
$admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if (-not $admin) {
    # If not running as administrator, request elevation
    try {
        $process = Start-Process -FilePath PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Host "The script ran as an administrator."
        } else {
            Write-Host "The script could not be executed as an administrator."
        }
    }
    catch {
        Write-Host "Could not initiate the administrator permission request process."
    }

    # Exit the script if administrator privileges could not be obtained
    exit
}

# Main Menu
function MainMenu{
    # Main Menu Options
    Clear-Host
    Write-Host " "
    Write-Host " ======= Fixing Windows Image, Components & Microsoft Store (DIMS) ======= "
    Write-Host " "
    Write-Host " This auto-script has practical options to repair Windows "
    Write-Host " using the DISM (Deployment Image Servicing and Management) service "
    Write-Host " to keep the system's main image in good condition. "
    Write-Host " "
    Write-Host " Windows System: "
    Write-Host " "
    Write-Host " 1. Check for corruption in the local Windows image "
    Write-Host " 2. Perform an advanced scan to determine if the image has any issues "
    Write-Host " 3. Repair image (If there are issues with the system image: Options 1 or 2) "
    Write-Host " "
    Write-Host " Microsoft Store: "
    Write-Host " "
    Write-Host " 4. Analyze Microsoft Store components (If it cannot open or does not function correctly) "
    Write-Host " 5. Repair Microsoft Store (If the option 4 have errors) "
    Write-Host " Q. Exit "
    Write-Host " "
    $selection = Read-Host "Choose an option"
    switch ($selection)
    {
      '1' {CheckOS}
      '2' {ScanOS}
      '3' {RepairOS}
      '4' {CheckStore}
      '5' {RepairStore}
      'Q' {exit}
    }
}

# Functions
function CheckOS{
    Clear-Host
    DISM.exe /Online /Cleanup-image /CheckHealth
    Write-Host " "
    pause
    MainMenu     
}

function ScanOS{
    Clear-Host
    DISM.exe /Online /Cleanup-image /ScanHealth
    Write-Host " "
    pause
    MainMenu     
}

function RepairOS{
    Clear-Host
    DISM.exe /Online /Cleanup-image /RestoreHealth
    Write-Host " "
    pause
    MainMenu     
}

function CheckStore{
    Clear-Host
    DISM.exe /online /cleanup-image /AnalyzeComponentStore
    Write-Host " "
    pause
    MainMenu  
}   

function RepairStore{
    Clear-Host
    DISM.exe /online /cleanup-image /startcomponentcleanup
    Write-Host " "
    pause
    MainMenu
}

# Main Program
MainMenu
