param(
    [string]$GodotExe = 'C:\Program Files\Godot\Godot.exe',
    [string]$ProjectPath = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
    [switch]$AutoMatch
)

if (-not (Test-Path -LiteralPath $GodotExe -PathType Leaf)) {
    throw "Godot executable not found: $GodotExe"
}

if (-not (Test-Path -LiteralPath (Join-Path $ProjectPath 'project.godot') -PathType Leaf)) {
    throw "Godot project not found: $ProjectPath"
}

$server = $null
$clientA = $null
$clientB = $null

try {
    # Dedicated server
    $server = Start-Process `
        -FilePath $GodotExe `
        -ArgumentList @(
            '--headless',
            '--path',
            $ProjectPath,
            '--',
            '--server'
        ) `
        -PassThru `
        -WindowStyle Hidden

    Start-Sleep -Seconds 2

    if ($server.HasExited) {
        throw "Dedicated server exited with code $($server.ExitCode)"
    }

    # Client common arguments
    $clientArgs = @(
        '--path',
        $ProjectPath,
        '--',
        '--client',
        '--server-address=127.0.0.1'
    )

    if ($AutoMatch) {
        $clientArgs += '--auto-match'
    }

    # Client A
    $clientA = Start-Process `
        -FilePath $GodotExe `
        -ArgumentList ($clientArgs + '--player-id=test_player_01') `
        -PassThru

    # Client B
    $clientB = Start-Process `
        -FilePath $GodotExe `
        -ArgumentList ($clientArgs + '--player-id=test_player_02') `
        -PassThru

    Write-Host ""
    Write-Host "Local multiplayer started."
    Write-Host "Server PID : $($server.Id)"
    Write-Host "Client A PID: $($clientA.Id)"
    Write-Host "Client B PID: $($clientB.Id)"
    Write-Host ""
    Write-Host "Press Ctrl+C to stop server and clients."

    # Keep script alive until Ctrl+C
    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    Write-Host ""
    Write-Host "Stopping local multiplayer..."

    foreach ($process in @($clientA, $clientB, $server)) {
        if ($null -ne $process) {
            try {
                if (-not $process.HasExited) {
                    Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
                }
            }
            catch {
                # Process may already be closed.
            }
        }
    }

    Write-Host "Server and clients stopped."
}