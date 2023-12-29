#Inicio Script
# Verificar si se tienen permisos de administrador
$admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if (-not $admin) {
    # Si no se tienen permisos de administrador, solicitar elevación
    try {
        $process = Start-Process -FilePath PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Host "El script se ejecutó como administrador."
        } else {
            Write-Host "No se pudo ejecutar el script como administrador."
        }
    }
    catch {
        Write-Host "No se pudo iniciar el proceso de solicitud de permisos de administrador."
    }

    # Salir del script si no se pudo obtener los permisos de administrador
    exit
}

#Main Menu
function MainMenu{
    #Main Menu Options
    Clear-Host
    Write-Host " "
    Write-Host " ======= Fixing Windows Image, Components & Microsoft Store (DIMS) ======= "
    Write-Host " "
    Write-Host " Este autoscript tiene opciones practicas para reparar Windows "
    Write-Host " usando el servicio de DISM (Deployment Image Servicing and Management) "
    Write-Host " y de esta manera mantener al imagen principal del sistema en buen estado "
    Write-Host " "
    Write-Host " Sistema Windows: "
    Write-Host " "
    Write-Host " 1. Analizar si hay corrupcion dentro de la imagen local de Windows "
    Write-Host " 2. Realiza un escaneo más avanzado para determinar si la imagen tiene algún problema"
    Write-Host " 3. Reparar imagen (Si hay problemas con la imagen del sistema: Opciones 1 o 2)"
    Write-Host " "
    Write-Host " Microsoft Store: "
    Write-Host " "
    Write-Host " 4. Analizar Componentes de Microsoft Store (Si no se puede abrir o no funciona correctamente)"
    Write-Host " 5. Reparar Microsoft Store (Si la opcion 4 tiene errores)"
    Write-Host " Q. Salir"
    Write-Host " "
    $selection = Read-Host "Elija una opcion an option"
    switch ($selection)
    {
      '1' {AnalizarOS}
      '2' {RevisarOS}
      '3' {RepararOS}
      '4' {AnalizarStore}
      '5' {RepararStore}
      'Q' {exit}
    }
  }
    #functions
    function AnalizarOS{
        Clear-Host
        DISM.exe /Online /Cleanup-image /CheckHealth
        Write-Host " "
        pause
        MainMenu     
    }
    function RevisarOS{
        Clear-Host
        DISM.exe /Online /Cleanup-image /ScanHealth
        Write-Host " "
        pause
        MainMenu     
    }
    function RepararOS{
        Clear-Host
        DISM.exe /Online /Cleanup-image /RestoreHealth
        Write-Host " "
        pause
        MainMenu     
    }
    function AnalizarStore{
        Clear-Host
        DISM.exe /online /cleanup-image /AnalyzeComponentStore
        Write-Host " "
        pause
        MainMenu  
    }   
    function RepararStore{
        Clear-Host
        DISM.exe /online /cleanup-image /startcomponentcleanup
        Write-Host " "
        pause
        MainMenu
    }

#Main Program
MainMenu