Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Install-Chocolatey {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Start-Process powershell -ArgumentList 'Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))' -Verb RunAs -Wait
    }
}

function Install-SelectedApps {
    Install-Chocolatey
    $global:selectedApps | ForEach-Object {
        Start-Process powershell -ArgumentList "choco install $_ -y" -Verb RunAs -Wait
    }
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Ashesh Development Windows Tool Menu'
$form.Size = New-Object System.Drawing.Size(800,600)
$form.StartPosition = 'CenterScreen'
$form.Font = New-Object System.Drawing.Font('Consolas', 10)
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)

$scrollBar = New-Object System.Windows.Forms.VScrollBar
$scrollBar.Dock = [System.Windows.Forms.DockStyle]::Right

$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = [System.Windows.Forms.DockStyle]::Fill
$panel.AutoScroll = $true

$categories = @{
    'General Applications' = 'firefox, vlc, 7zip';
    'Development Tools' = 'git, vscode, nodejs';
    'Communication Apps' = 'discord, slack, skype';
    'Browsers' = 'chrome, edge, firefox';
}

$y = 10
foreach ($category in $categories.Keys) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $category
    $label.Location = New-Object System.Drawing.Point(10, $y)
    $label.Size = New-Object System.Drawing.Size(200, 20)
    $panel.Controls.Add($label)
    $y += 30
    $apps = $categories[$category].Split(', ')
    foreach ($app in $apps) {
        $checkBox = New-Object System.Windows.Forms.CheckBox
        $checkBox.Text = $app
        $checkBox.Location = New-Object System.Drawing.Point(30, $y)
        $checkBox.Size = New-Object System.Drawing.Size(200, 20)
        $checkBox.Tag = $app
        $panel.Controls.Add($checkBox)
        $y += 30
    }
}

$installButton = New-Object System.Windows.Forms.Button
$installButton.Text = 'Install Selected Applications'
$installButton.Location = New-Object System.Drawing.Point(600, 520)
$installButton.Size = New-Object System.Drawing.Size(180, 30)
$installButton.Add_Click({
    $global:selectedApps = @()
    $panel.Controls | Where-Object {$_ -is [System.Windows.Forms.CheckBox] -and $_.Checked} | ForEach-Object {
        $global:selectedApps += $_.Tag
    }
    Install-SelectedApps
})

$form.Controls.Add($scrollBar)
$form.Controls.Add($panel)
$form.Controls.Add($installButton)

$form.ShowDialog()
