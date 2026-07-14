@echo off
cd apps\api
echo Compilando API...
npm run build
echo.
echo Iniciando API en puerto 3000...
npm start
pause
