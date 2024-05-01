Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Log actions to a text file
function Log-Action($message) {
    $logPath = "$env:TEMP\AsheshToolMenuLog.txt"
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $message"
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Ashesh Development: Tool Menu'
$form.Size = New-Object System.Drawing.Size(500,400)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(39, 40, 34)
$form.ForeColor = [System.Drawing.Color]::FromArgb(248, 248, 242)

$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object System.Drawing.Point(10, 10)
$panel.Size = New-Object System.Drawing.Size(460, 280)
$panel.AutoScroll = $true

$buttonGetInstalled = New-Object System.Windows.Forms.Button
$buttonGetInstalled.Text = 'Get Installed Apps'
$buttonGetInstalled.Location = New-Object System.Drawing.Point(10, 300)
$buttonGetInstalled.Size = New-Object System.Drawing.Size(140, 30)
$buttonGetInstalled.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 65)
$buttonGetInstalled.ForeColor = [System.Drawing.Color]::FromArgb(248, 248, 242)
$buttonGetInstalled.Add_Click({
    # Implementation of Get-InstalledApps functionality
})

$buttonInstallSelected = New-Object System.Windows.Forms.Button
$buttonInstallSelected.Text = 'Install Selected Apps'
$buttonInstallSelected.Location = New-Object System.Drawing.Point(160, 300)
$buttonInstallSelected.Size = New-Object System.Drawing.Size(140, 30)
$buttonInstallSelected.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 65)
$buttonInstallSelected.ForeColor = [System.Drawing.Color]::FromArgb(248, 248, 242)
$buttonInstallSelected.Add_Click({
    # Implementation of Install-SelectedApps functionality
})

$buttonUninstallSelected = New-Object System.Windows.Forms.Button
$buttonUninstallSelected.Text = 'Uninstall Selected Apps'
$buttonUninstallSelected.Location = New-Object System.Drawing.Point(310, 300)
$buttonUninstallSelected.Size = New-Object System.Drawing.Size(140, 30)
$buttonUninstallSelected.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 65)
$buttonUninstallSelected.ForeColor = [System.Drawing.Color]::FromArgb(248, 248, 242)
$buttonUninstallSelected.Add_Click({
    # Implementation of Uninstall-SelectedApps functionality
})

$buttonCleanExit = New-Object System.Windows.Forms.Button
$buttonCleanExit.Text = 'Clean and Exit'
$buttonCleanExit.Location = New-Object System.Drawing.Point(10, 340)
$buttonCleanExit.Size = New-Object System.Drawing.Size(440, 30)
$buttonCleanExit.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 65)
$buttonCleanExit.ForeColor = [System.Drawing.Color]::FromArgb(248, 248, 242)
$buttonCleanExit.Add_Click({
    # Implementation of Clean-And-Exit functionality
})

$form.Controls.AddRange(@($panel, $buttonGetInstalled, $buttonInstallSelected, $buttonUninstallSelected, $buttonCleanExit))

# Populate the panel with checkboxes
$y = 10
$apps = 'firefox, vlc, 7zip, git, vscode, nodejs, discord, slack, skype, chrome, edge'.Split(', ')
foreach ($app in $apps) {
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $app.Trim()
    $checkBox.Location = New-Object System.Drawing.Point(10, $y)
    $checkBox.Size = New-Object System.Drawing.Size(400, 20)
    $checkBox.Tag = $app.Trim()
    $panel.Controls.Add($checkBox)
    $y += 30
}

$form.ShowDialog()
