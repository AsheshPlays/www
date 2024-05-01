Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Check and install Chocolatey if not installed
function Install-Chocolatey {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..."
        Start-Process powershell -ArgumentList 'Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))' -Verb RunAs -Wait
    }
    Write-Host "Chocolatey is installed."
}

# Install selected applications
function Install-SelectedApps {
    Install-Chocolatey
    $selectedApps | ForEach-Object {
        Start-Process powershell -ArgumentList "choco install $_ -y" -Verb RunAs -Wait
    }
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Ashesh Development Windows Tool Menu'
$form.Size = New-Object System.Drawing.Size(800,600)
$form.StartPosition = 'CenterScreen'
$form.Font = New-Object System.Drawing.Font('Consolas', 10)

$categories = @{
    'General Applications' = 'firefox, vlc, 7zip';
    'Development Tools' = 'git, vscode, nodejs';
    'Communication Apps' = 'discord, slack, skype';
    'Browsers' = 'chrome, edge, firefox';
}

# Create checkboxes dynamically based on categories
$y = 20
foreach ($category in $categories.Keys) {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $category
    $label.Location = New-Object System.Drawing.Point(30, $y)
    $label.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($label)
    $y += 30
    $apps = $categories[$category].Split(', ')
    foreach ($app in $apps) {
        $checkBox = New-Object System.Windows.Forms.CheckBox
        $checkBox.Text = $app
        $checkBox.Location = New-Object System.Drawing.Point(50, $y)
        $checkBox.Size = New-Object System.Drawing.Size(200, 20)
        $checkBox.Tag = $app
        $form.Controls.Add($checkBox)
        $y += 30
    }
}

$installButton = New-Object System.Windows.Forms.Button
$installButton.Text = 'Install Selected Applications'
$installButton.Location = New-Object System.Drawing.Point(30, $y + 20)
$installButton.Size = New-Object System.Drawing.Size(200, 30)
$installButton.Add_Click({
    $selectedApps = @()
    $form.Controls | Where-Object {$_ -is [System.Windows.Forms.CheckBox] -and $_.Checked} | ForEach-Object {
        $selectedApps += $_.Tag
    }
    Install-SelectedApps
})
$form.Controls.Add($installButton)

$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)

$form.ShowDialog()
