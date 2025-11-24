@echo off
REM fix-add.bat - diagnostics and fixes to help `git add .` succeed
REM Usage: run this from cmd.exe in the repository folder (or double-click)























:: 4) attempt per-file add loop to find problematic file (will stop at first failure)
echo Attempting to add files one-by-one to locate problem (this may take a while)...
for /f "delims=" %%F in ('dir /b /s /a:-d') do (
    echo Adding: "%%F"
    git add "%%F" 2>&1
    if errorlevel 1 (
        echo FAILED adding "%%F". This file is likely causing the problem.
        echo Please inspect or rename it, then re-run this script.
        popd & exit /b 1
    )
)

:: final try
necho All files added individually. Now running: git add -v .
ngit add -v . 2>&1
nif not errorlevel 1 (
    echo SUCCESS: git add completed successfully.
    popd & exit /b 0
) else (
    echo git add still failing after individual adds. Inspect repo and permissions.
    popd & exit /b 1
)

:: 3) try adding a small known file first (isolate)
if exist "restaurant management.html" (
    echo Trying to add single file: restaurant management.html
    git add "restaurant management.html" 2>&1
    if errorlevel 1 (
        echo Failed to add "restaurant management.html". There may be a filename/permission/encoding issue.
        echo Next: listing files with potentially problematic names (trailing spaces or reserved names)...
        powershell -NoProfile -Command "Get-ChildItem -Recurse -File | ForEach-Object { if ($_.Name -match '\s$' -or $_.Name -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$') { Write-Output $_.FullName } }"
        popd & exit /b 1
    ) else (
        echo Single-file add succeeded. Trying to add remainder...
        git add -v . 2>&1
        if not errorlevel 1 (
            echo SUCCESS: git add completed successfully.
            popd & exit /b 0
        )
    )
) else (
    echo Note: "restaurant management.html" not found. Skipping single-file test.
)
:: 2) enable long paths in Git (global)
echo Enabling Git long paths (global config)...
ngit config --global core.longpaths true 2>nul || echo Warning: could not set core.longpaths (insufficient permissions)
:: 1) check and remove stale index lock
necho Checking for .git\index.lock ...
if exist ".git\index.lock" (
    echo Found .git\index.lock - removing it...
    del ".git\index.lock" 2>nul
    if errorlevel 1 (
        echo Failed to remove .git\index.lock. Close editors locking files and re-run this script (run as Administrator if needed).
        popd & exit /b 1
    ) else (
        echo Removed .git\index.lock
    )
) else (
    echo No .git\index.lock found.
)
necho git add failed. Attempting safe fixes...)  popd & exit /b 0  echo SUCCESS: git add completed successfully.if not errorlevel 1 (
:: try adding verbosely first
necho -- Attempt: git add -v . --
ngit add -v . 2>&1git status --porcelain=2 -v
:: show repo status
necho -- git status (summary) --git --versionecho Git version: )  popd & exit /b 1  echo ERROR: Git not found in PATH. Install Git for Windows and try again.if errorlevel 1 (
:: check Git availability
nwhere git >nul 2>&1echo Working directory: %cd%pushd "%~dp0":: change to script directory