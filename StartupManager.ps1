Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Log actions to a text file
function Log-Action($message) {
    $logPath = "$env:TEMP\StartupManagerLog.txt"
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $message"
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Ashesh Development: Start Up Manager'
$form.Size = New-Object System.Drawing.Size(500,400)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# Monokai Dark and Light Themes
$monokaiDark = @{
    Background = [System.Drawing.Color]::FromArgb(39, 40, 34)
    Foreground = [System.Drawing.Color]::FromArgb(248, 248, 242)
    ControlBackground = [System.Drawing.Color]::FromArgb(60, 60, 60)
    ButtonBackground = [System.Drawing.Color]::FromArgb(70, 70, 65)
    ButtonForeground = [System.Drawing.Color]::FromArgb(248, 248, 242)
}

$monokaiLight = @{
    Background = [System.Drawing.Color]::FromArgb(249, 248, 245)
    Foreground = [System.Drawing.Color]::FromArgb(39, 40, 34)
    ControlBackground = [System.Drawing.Color]::FromArgb(255, 255, 255)
    ButtonBackground = [System.Drawing.Color]::FromArgb(230, 230, 230)
    ButtonForeground = [System.Drawing.Color]::FromArgb(39, 40, 34)
}

$currentTheme = $monokaiDark

function Set-Theme($theme) {
    $form.BackColor = $theme.Background
    $form.ForeColor = $theme.Foreground
    $textBox.BackColor = $theme.ControlBackground
    $textBox.ForeColor = $theme.Foreground
    $browseButton.BackColor = $theme.ButtonBackground
    $browseButton.ForeColor = $theme.ButtonForeground
    $addButton.BackColor = $theme.ButtonBackground
    $addButton.ForeColor = $theme.ButtonForeground
    $listButton.BackColor = $theme.ButtonBackground
    $listButton.ForeColor = $theme.ButtonForeground
    $removeButton.BackColor = $theme.ButtonBackground
    $removeButton.ForeColor = $theme.ButtonForeground
    $themeCheckBox.BackColor = $theme.Background
    $themeCheckBox.ForeColor = $theme.Foreground
    $checkedListBox.BackColor = $theme.ControlBackground
    $checkedListBox.ForeColor = $theme.Foreground
}

$themeCheckBox = New-Object System.Windows.Forms.CheckBox
$themeCheckBox.Location = New-Object System.Drawing.Point(350,10)
$themeCheckBox.Size = New-Object System.Drawing.Size(130,24)
$themeCheckBox.Text = 'Dark Mode'
$themeCheckBox.Checked = $true
$themeCheckBox.Add_CheckedChanged({
    if ($themeCheckBox.Checked) {
        $currentTheme = $monokaiDark
        $themeCheckBox.Text = 'Dark Mode'
    } else {
        $currentTheme = $monokaiLight
        $themeCheckBox.Text = 'Light Mode'
    }
    Set-Theme $currentTheme
})
$form.Controls.Add($themeCheckBox)

# Text box for file path
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,50)
$textBox.Size = New-Object System.Drawing.Size(360,20)
$form.Controls.Add($textBox)

# Browse button
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Location = New-Object System.Drawing.Point(380,50)
$browseButton.Size = New-Object System.Drawing.Size(100,20)
$browseButton.Text = 'Browse'
$browseButton.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.InitialDirectory = [System.Environment]::GetFolderPath('Desktop')
    if ($openFileDialog.ShowDialog() -eq 'OK') {
        $textBox.Text = $openFileDialog.FileName
    }
})
$form.Controls.Add($browseButton)

# Add to startup button
$addButton = New-Object System.Windows.Forms.Button
$addButton.Location = New-Object System.Drawing.Point(10,80)
$addButton.Size = New-Object System.Drawing.Size(470,30)
$addButton.Text = 'Add to Startup'
$addButton.Add_Click({
    $path = $textBox.Text
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $name = [System.IO.Path]::GetFileNameWithoutExtension($path)
    Set-ItemProperty -Path $key -Name $name -Value $path
    Log-Action "Added to startup: $path"
    [System.Windows.Forms.MessageBox]::Show("Added to startup: $path")
})
$form.Controls.Add($addButton)

# Listbox to display startup items
$checkedListBox = New-Object System.Windows.Forms.CheckedListBox
$checkedListBox.Location = New-Object System.Drawing.Point(10,120)
$checkedListBox.Size = New-Object System.Drawing.Size(470,200)
$form.Controls.Add($checkedListBox)

# Button to list startup items
$listButton = New-Object System.Windows.Forms.Button
$listButton.Location = New-Object System.Drawing.Point(10,330)
$listButton.Size = New-Object System.Drawing.Size(230,30)
$listButton.Text = 'List Startup Items'
$listButton.Add_Click({
    $checkedListBox.Items.Clear()
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $items = Get-ItemProperty -Path $key
    $items.PSObject.Properties | ForEach-Object {
        $checkedListBox.Items.Add("$($_.Name) - $($_.Value)", $false)
    }
})
$form.Controls.Add($listButton)

# Remove from startup button
$removeButton = New-Object System.Windows.Forms.Button
$removeButton.Location = New-Object System.Drawing.Point(250,330)
$removeButton.Size = New-Object System.Drawing.Size(230,30)
$removeButton.Text = 'Remove Selected from Startup'
$removeButton.Add_Click({
    $key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    foreach ($item in $checkedListBox.CheckedItems) {
        $name = $item.Split('-')[0].Trim()
        Remove-ItemProperty -Path $key -Name $name
        Log-Action "Removed from startup: $name"
    }
    [System.Windows.Forms.MessageBox]::Show("Selected items removed from startup.")
    $listButton.PerformClick() # Refresh the list
})
$form.Controls.Add($removeButton)

Set-Theme $currentTheme
$form.ShowDialog()
