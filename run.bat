@echo off
setlocal
pushd "%~dp0backend"

set "PYTHON=python"
where py.exe >nul 2>nul
if not errorlevel 1 (
    py -3 --version >nul 2>nul
    if not errorlevel 1 set "PYTHON=py -3"
)

if not exist ".venv\Scripts\python.exe" (
    echo Creating the project Python environment...
    %PYTHON% -m venv .venv
    if errorlevel 1 goto python_error
)

echo Installing or checking Flask and PostgreSQL dependencies...
".venv\Scripts\python.exe" -m pip install --disable-pip-version-check -r requirements.txt
if errorlevel 1 goto install_error

echo Starting Orbit Expense Manager.
echo Keep this window open while using the app. Press Ctrl+C to stop the server.
set "OPEN_BROWSER=1"
".venv\Scripts\python.exe" app.py
set "APP_EXIT_CODE=%ERRORLEVEL%"
popd
endlocal & exit /b %APP_EXIT_CODE%

:python_error
echo Could not create the Python environment. Install Python 3 and try again.
popd
endlocal & exit /b 1

:install_error
echo Could not install dependencies. Check your internet connection and try again.
popd
endlocal & exit /b 1
