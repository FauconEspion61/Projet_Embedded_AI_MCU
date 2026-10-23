# Ajoute Vivado et Vitis 2025.2 au PATH de la session PowerShell courante.
# Usage (le point initial est necessaire) :   . .\ZYNQ_ZedBoard\scripts\env.ps1
#
# N'ajoute volontairement PAS le compilateur ARM de Vitis au PATH : il y a deja
# un arm-none-eabi-gcc de STM32CubeIDE, et Vitis utilise le sien en interne.

$AMD = "C:\AMDDesignTools\2025.2"

foreach ($p in @("$AMD\Vivado\bin", "$AMD\Vitis\bin")) {
    if (-not (Test-Path $p)) {
        Write-Warning "Introuvable : $p (adapter `$AMD en haut de ce script)"
    }
    elseif ($env:PATH -notlike "*$p*") {
        $env:PATH = "$p;$env:PATH"
    }
}

Write-Host "Vivado et Vitis 2025.2 disponibles dans cette session."
