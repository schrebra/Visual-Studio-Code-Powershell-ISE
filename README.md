# VS Code → Pristine PowerShell ISE Converter

This script transforms Visual Studio Code into a 1-to-1 replica of the classic PowerShell ISE. It is designed for users who want the modern IntelliSense of VS Code but absolutely none of the modern "IDE" bloat, AI features, or internet-connected distractions. 
It operates on a "pretend this is an offline system" philosophy, ripping out cloud-connected tools and enforcing a clean, distraction-free environment.

<img width="60%" alt="image" src="https://github.com/user-attachments/assets/42f258a1-e310-4e0e-b279-ca4e1a1e361e" />


## 🚀 What This Script Does

### 1. Eradicates AI & Copilot
If you are tired of AI "slop" suggestions, sign-in prompts, and chat panels, this script completely scrubs them from your system:
* Uses the official VS Code CLI to permanently disable built-in AI extensions.
* Physically deletes or disables `github.copilot`, `copilot-chat`, and `ms-vscode.chat` extension folders from your hard drive.
* Disables inline AI chat (Ctrl+I), AI "ghost text" suggestions, and the AI Chat command center.

### 2. Forces a 1-to-1 ISE Layout
Makes VS Code look and feel exactly like the legacy PowerShell ISE:
* Moves the integrated console to the bottom (Script top, Console bottom).
* Applies the classic "PowerShell ISE" color theme.
* Restores the native Windows title bar and standard File/Edit/View menu bar.
* Enables aggressive, local-only IntelliSense (the suggestion dropdown automatically appears as you type, anywhere).

### 3. Deeply Declutters the UI
Removes all the modern "IDE" distractions to keep you focused on the code:
* Hides the Activity Bar (far left icons), Status Bar (bottom bar), and Command Center (top search bar).
* Removes the code minimap, breadcrumbs, and editor action buttons (the `...` in the top right).
* Strips editor clutter like code folding arrows, glyph margins, indent guides, and sticky scroll.

### 4. Enforces "Offline Mode"
Stops VS Code from reaching out to the internet or showing popups:
* Disables auto-updates for both VS Code and extensions.
* Kills all telemetry and background experiments.
* Disables natural language settings search (which normally pings Bing).
* Stops the OOBE/Welcome screen, walkthroughs, and tip popups from ever appearing.
* Disables Git to prevent unwanted credential sign-in prompts.

---

## 📋 Requirements

* **OS:** Windows (PowerShell 5.1)
* **App:** Visual Studio Code (User or System installer)
* **Permissions:** Administrator rights (The script will automatically prompt for UAC to delete locked AI extension files).

---

## 🛠️ How to Use

1. Save the code as `VScode-PS_ISE-Config.ps1`.
2. Right-click the file and select **Run with PowerShell** (or run it from your PowerShell terminal).
3. Click **Yes** on the User Account Control (UAC) prompt to grant Administrator access.
4. Let the script run. It will automatically close VS Code, scrub the files, and apply the new settings.

> 💡 **Post-Install Note**
> 
> Because VS Code remembers open windows in a hidden database, if the Chat Panel is still visible on the right side of your screen after running the script:
> 1. Click inside the VS Code window.
> 2. Press **Ctrl+Alt+B** on your keyboard.
> 
> This will toggle the Secondary Side Bar closed permanently.
