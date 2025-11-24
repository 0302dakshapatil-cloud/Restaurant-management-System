@echo off
REM run-and-commit.bat - runs fix-add, then git add and commit if successful
REM Usage: run from cmd.exe in the repository folder (or double-click)
pushd "%~dp0"
echo Working directory: %cd%








exit /b 0
echo   git push -u origin main

popdecho Next: add your remote and push to GitHub, for example:
echo   git remote add origin https://github.com/username/repo.git
:: perform git add
necho --- Running: git add -v . ---
ngit add -v .
if errorlevel 1 (
  echo git add failed. Please review error messages above.
  popd & exit /b 1
)

:: show staged files
necho --- Staged files (if any) ---
git diff --cached --name-only

:: ensure branch name is main
necho Setting branch to 'main' (safe if already named)
ngit branch -M main 2>nul || echo Note: could not rename branch (check refs).

:: commit
necho --- Committing staged changes ---
git commit -m "Initial commit"
if errorlevel 1 (
  echo Commit failed or there was nothing to commit. If nothing to commit, ensure files are staged, then run:
  echo   git add . && git commit -m "Initial commit"
  popd & exit /b 1
)

necho Commit successful.call fix-add.bat
nif errorlevel 1 (
  echo fix-add.bat reported an error. Resolve reported issues and re-run this script.
  popd & exit /b 1
)
:: run the fix script
necho --- Running fix-add.bat (diagnostics & safe fixes) ---if errorlevel 1 (
  echo ERROR: Git not found in PATH. Install Git for Windows and try again.
  popd & exit /b 1
):: ensure Git exists
nwhere git >nul 2>&1