<#
.SYNOPSIS
    Choose_This_Day - PowerShell Edition
.NOTES
    Author: Cerafin C F (Converted into Native .NET Core Hooks)
#>

$appData = [System.Environment]::GetFolderPath('ApplicationData')
$memoryPath = Join-Path $appData "ctd_memory.txt"

# Dynamic sizing logic
$UI = $Host.UI.RawUI
$size = $UI.WindowSize
$size.Width = 170
$size.Height = 30
$UI.WindowSize = $size

# Structural state setup
$script:day_count = 0
$script:good_total = 0
$script:bad_total = 0
$script:name = ""
$script:current_phase = "intro"

Function Play-Sound {
    Param([string]$SoundName, [int]$Loops = 1)
    $systemSound = Join-Path $env:SystemRoot "Media\$SoundName"
    if (Test-Path $systemSound) {
        $player = New-Object System.Media.SoundPlayer($systemSound)
        Task {
            for ($i = 0; $i -lt $Loops; $i++) {
                $player.PlaySync()
            }
        }
    } else {
        [System.Media.SystemSounds]::Beep.Play()
    }
}

Function Say-Text {
    Param([string]$Msg)
    $chars = $Msg.ToCharArray()
    foreach ($c in $chars) {
        Write-Host $c -NoNewline
        Start-Sleep -Milliseconds (Get-Random -Minimum 40 -Maximum 90)
    }
    Write-Host ""
}

Function Send-ToastNotification {
    Param([string]$Message)
    Add-Type -AssemblyName System.Windows.Forms
    $global:notification = New-Object System.Windows.Forms.NotifyIcon
    $notification.Icon = [System.Drawing.SystemIcons]::Information
    $notification.Visible = $true
    $notification.BalloonTipTitle = "Choose_This_Day"
    $notification.BalloonTipText = $Message
    $notification.ShowBalloonTip(5000)
}

Function Save-State {
    $content = @($script:name, $script:day_count, $script:good_total, $script:bad_total, $script:current_phase)
    Out-File -FilePath $memoryPath -InputObject $content -Encoding utf8 -Force
}

# Game Loop Core Engine Implementation
Clear-Host
Play-Sound -SoundName "Windows Proximity Connection.wav" -Loops 1
Say-Text "PowerShell script core initialising..."
Start-Sleep -Seconds 1

# [Implementation repeats down cascading original logic with regular conditional flows...]
