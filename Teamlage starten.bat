@echo off
setlocal
set PORT=8420
set "DIR=%~dp0"

rem Lokalen Server im Hintergrund starten (falls er nicht schon laeuft).
start "" /min powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%DIR%server.ps1" -Port %PORT% -Root "%DIR%"

rem Dem Server einen Moment Zeit zum Starten geben.
timeout /t 1 /nobreak >nul

rem App im "App-Modus" oeffnen: kein Adressfeld, keine Tabs, sieht wie ein eigenes Programm aus.
where msedge >nul 2>nul
if %errorlevel%==0 (
  start "" msedge --app=http://localhost:%PORT%/index.html --window-size=1440,900
  goto :eof
)

where chrome >nul 2>nul
if %errorlevel%==0 (
  start "" chrome --app=http://localhost:%PORT%/index.html --window-size=1440,900
  goto :eof
)

rem Fallback: normaler Browser-Tab, falls weder Edge noch Chrome gefunden wurden.
start "" http://localhost:%PORT%/index.html
