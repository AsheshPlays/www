Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Install-Chocolatey {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Start-Process powershell -ArgumentList 'Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))' -Verb RunAs -Wait
    }
}

function Get-InstalledApps {
    Install-Chocolatey
    $installed = choco list --local-only
    foreach ($item in $panel.Controls) {
        if ($item -is [System.Windows.Forms.CheckBox]) {
            $item.Checked = $installed -like "*$($item.Tag)*"
        }
    }
}

function Install-SelectedApps {
    Install-Chocolatey
    $selectedApps = $panel.Controls | Where-Object { $_ -is [System.Windows.Forms.CheckBox] -and $_.Checked } | ForEach-Object { $_.Tag }
    $selectedApps | ForEach-Object { Start-Process powershell -ArgumentList "choco install $_ -y" -Verb RunAs -Wait }
}

function Uninstall-SelectedApps {
    Install-Chocolatey
    $selectedApps = $panel.Controls | Where-Object { $_ -is [System.Windows.Forms.CheckBox] -and $_.Checked } | ForEach-Object { $_.Tag }
    $selectedApps | ForEach-Object { Start-Process powershell -ArgumentList "choco uninstall $_ -y" -Verb RunAs -Wait }
}

function Clean-And-Exit {
    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory([Environment]::GetFolderPath('LocalApplicationData') + '\Temp', [Microsoft.VisualBasic.FileIO.DeleteDirectoryOption]::DeleteAllContents)
    Clear-RecycleBin -Force
    $form.Close()
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Ashesh Development: Tool Menu'
$form.Size = New-Object System.Drawing.Size(500, 400)
$form.StartPosition = 'CenterScreen'
$form.Font = New-Object System.Drawing.Font('Consolas', 10)
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object System.Drawing.Point(10, 10)
$panel.Size = New-Object System.Drawing.Size(480, 260)
$panel.AutoScroll = $true

$applications = 'firefox, vlc, 7zip, git, vscode, nodejs, discord, slack, skype, chrome, edge'
$y = 10
foreach ($app in $applications.Split(', ')) {
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $app.Trim()
    $checkBox.Location = New-Object System.Drawing.Point(10, $y)
    $checkBox.Size = New-Object System.Drawing.Size(450, 20)
    $checkBox.Tag = $app.Trim()
    $panel.Controls.Add($checkBox)
    $y += 30
}

$buttonGetInstalled = New-Object System.Windows.Forms.Button
$buttonGetInstalled.Text = 'Get Installed Apps'
$buttonGetInstalled.Location = New-Object System.Drawing.Point(10, 280)
$buttonGetInstalled.Size = New-Object System.Drawing.Size(150, 30)
$buttonGetInstalled.Add_Click({ Get-InstalledApps })

$buttonInstallSelected = New-Object System.Windows.Forms.Button
$buttonInstallSelected.Text = 'Install Selected Apps'
$buttonInstallSelected.Location = New-Object System.Drawing.Point(170, 280)
$buttonInstallSelected.Size = New-Object System.Drawing.Size(150, 30)
$buttonInstallSelected.Add_Click({ Install-SelectedApps })

$buttonUninstallSelected = New-Object System.Windows.Forms.Button
$buttonUninstallSelected.Text = 'Uninstall Selected Apps'
$buttonUninstallSelected.Location = New-Object System.Drawing.Point(330, 280)
$buttonUninstallSelected.Size = New-Object System.Drawing.Size(150, 30)
$buttonUninstallSelected.Add_Click({ Uninstall-SelectedApps })

$buttonCleanExit = New-Object System.Windows.Forms.Button
$buttonCleanExit.Text = 'Clean and Exit'
$buttonCleanExit.Location = New-Object System.Drawing.Point(10, 320)
$buttonCleanExit.Size = New-Object System.Drawing.Size(470, 30)
$buttonCleanExit.Add_Click({ Clean-And-Exit })

$form.Controls.Add($panel)
$form.Controls.Add($buttonGetInstalled)
$form.Controls.Add($buttonInstallSelected)
$form.Controls.Add($buttonUninstallSelected)
$form.Controls.Add($buttonCleanExit)

$form.ShowDialog()
