# Nuke-VSCodeAI-Final.ps1
# Restores menu bar, fixes the broken file search, and permanently kills Copilot.

# 1. Self-Elevate to Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Restarting as Administrator..." -ForegroundColor Cyan
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

 $ErrorActionPreference = "Continue"

Write-Host "Force killing ALL VS Code processes..." -ForegroundColor Cyan
Get-Process -Name "Code*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# 2. Disable Built-in Extensions via CLI (The official way to kill built-ins)
Write-Host "Disabling built-in AI extensions via CLI..." -ForegroundColor Cyan
code --uninstall-extension github.copilot 2>&1 | Out-Null
code --uninstall-extension github.copilot-chat 2>&1 | Out-Null
code --uninstall-extension ms-vscode.chat 2>&1 | Out-Null
code --uninstall-extension ms-vscode.inline-chat 2>&1 | Out-Null

# 3. Physically Delete Copilot from User Profile (Where market extensions live)
Write-Host "Scrubbing Copilot from user extensions..." -ForegroundColor Cyan
 $extPath = "$env:USERPROFILE\.vscode\extensions"
if (Test-Path $extPath) {
    # Only look at top-level folders to avoid breaking other extensions
    Get-ChildItem -Path $extPath -Directory | Where-Object { 
        $_.Name -like "github.copilot*" -or $_.Name -like "ms-vscode.chat*" -or $_.Name -like "ms-vscode.inline-chat*"
    } | ForEach-Object {
        $path = $_.FullName
        cmd /c rmdir /s /q "$path" 2>&1 | Out-Null
        if (Test-Path $path) {
            Rename-Item -Path $path -NewName "$($_.Name).disabled" -Force -ErrorAction SilentlyContinue
        }
        Write-Host "  Deleted/Disabled user extension: $($_.Name)" -ForegroundColor Green
    }
}

# 4. Overwrite settings.json with pristine, simplified ISE layout
Write-Host "Hardcoding pristine ISE settings..." -ForegroundColor Cyan
 $settingsPath = "$env:APPDATA\Code\User\settings.json"
 $settingsDir = Split-Path $settingsPath
if (-not (Test-Path $settingsDir)) { New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null }

# Note: "window.menuBarVisibility" has been REMOVED so your menu bar comes back.
 $settingsJson = @"
{
    "workbench.startupEditor": "none",
    "workbench.welcomePage.walkthroughs.openOnInstall": false,
    "workbench.welcomePage.extraAnnouncements": false,
    "workbench.colorTheme": "PowerShell ISE",
    "workbench.panel.defaultLocation": "bottom",
    "powershell.integratedConsole.focusConsoleOnExecute": false,
    "editor.tabCompletion": "on",
    "files.defaultLanguage": "powershell",
    
    "window.titleBarStyle": "native",
    "window.commandCenter": false,
    
    "editor.quickSuggestions": {
        "other": true,
        "comments": true,
        "strings": true
    },
    "editor.suggestOnTriggerCharacters": true,
    "editor.wordBasedSuggestions": true,
    "editor.acceptSuggestionOnEnter": "on",
    "editor.suggest.showWords": true,
    "editor.suggest.preview": true,
    
    "github.copilot.enable": { "*": false },
    "chat.commandCenter.enabled": false,
    "editor.inlineSuggest.enabled": false,
    "editor.codeLens": false,
    "inlineChat.enabled": false,
    "chat.experimental.quickChat.enabled": false,
    "workbench.editor.chat.openOnStartup": false,
    "workbench.editor.chat.enabled": false,
    
    "update.mode": "none",
    "extensions.autoUpdate": false,
    "extensions.autoCheckUpdates": false,
    "extensions.ignoreRecommendations": true,
    "workbench.enableExperiments": false,
    "workbench.settings.enableNaturalLanguageSearch": false,
    "telemetry.telemetryLevel": "off",
    "workbench.tips.enabled": false,
    "git.enabled": false,
    "github.gitAuthentication": false,
    
    "workbench.activityBar.visible": false,
    "workbench.statusBar.visible": false,
    "editor.minimap.enabled": false,
    "breadcrumbs.enabled": false,
    "workbench.editor.enablePreview": false,
    "workbench.sideBar.visible": false,
    
    "editor.folding": false,
    "editor.glyphMargin": false,
    "editor.guides.indentation": false,
    "editor.guides.bracketPairs": false,
    "editor.overviewRulerLanes": 0,
    "editor.stickyScroll.enabled": false,
    "workbench.editor.editorActionsLocation": "hidden"
}
"@

[System.IO.File]::WriteAllText($settingsPath, $settingsJson, [System.Text.UTF8Encoding]::new($false))

Write-Host "`nConfiguration Complete!" -ForegroundColor Green
Write-Host "Your menu bar is back, and Copilot has been disabled via CLI and deleted from your profile." -ForegroundColor Green

Write-Host "`n--- HOW TO HIDE THE CHAT PANEL ---" -ForegroundColor Yellow
Write-Host "If the Chat panel is still visible on the right side of your screen:" -ForegroundColor Yellow
Write-Host "1. Click inside the VS Code window." -ForegroundColor Yellow
Write-Host "2. Press Ctrl+Alt+B on your keyboard." -ForegroundColor Yellow
Write-Host "3. This will toggle the panel closed permanently." -ForegroundColor Yellow

Read-Host "`nPress Enter to exit"
