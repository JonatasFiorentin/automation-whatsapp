@echo off
setlocal

:: Configurações - personalize aqui
set BACKEND_PORT=5007
set FRONTEND_PORT=3007
set FRONTEND_TITLE=Coronel
set NEXT_PUBLIC_API_URL=http://localhost:%BACKEND_PORT%

echo Verificando dependências...

:: Backend
if exist backend-automation-whatsapp\node_modules (
    echo Dependências do backend já instaladas.
) else (
    echo Instalando dependências do backend...
    cd /d backend-automation-whatsapp
    call npm install
    cd ..
)

:: Frontend
if exist frontend-automation-whatsapp\node_modules (
    echo Dependências do frontend já instaladas.
) else (
    echo Instalando dependências do frontend...
    cd /d frontend-automation-whatsapp
    call npm install
    cd ..
)

:: Criar/atualizar .env.local se necessário
echo Verificando .env.local no frontend...
set ENV_FILE=frontend-automation-whatsapp\.env.local

if exist %ENV_FILE% (
    findstr /C:"NEXT_PUBLIC_SITE_TITLE=%FRONTEND_TITLE%" %ENV_FILE% >nul
    if errorlevel 1 (
        echo Atualizando .env.local...
        goto :updateEnv
    ) else (
        echo .env.local já está atualizado.
    )
) else (
    echo Criando .env.local...
    goto :updateEnv
)
goto :skipUpdate

:updateEnv
(
    echo NEXT_PUBLIC_SITE_TITLE=%FRONTEND_TITLE%
    echo NEXT_PUBLIC_API_URL=%NEXT_PUBLIC_API_URL%
    echo PORT=%FRONTEND_PORT%
) > %ENV_FILE%
echo .env.local atualizado!

:skipUpdate

:: Verifica se já tem build
if exist frontend-automation-whatsapp\.next (
    echo Build do frontend já existente. Pulando build.
) else (
    echo Iniciando build do frontend...
    cd /d frontend-automation-whatsapp
    call npm run build
    cd ..
)

echo.
echo ✅ Verificação concluída!
echo Iniciando aplicações...

:: Iniciar backend minimizado com porta dinâmica
start "" /min cmd /c "cd /d backend-automation-whatsapp && set PORT=%BACKEND_PORT% && npm run start:dev"

:: Iniciar frontend minimizado
start "" /min cmd /c "cd /d frontend-automation-whatsapp && set PORT=%FRONTEND_PORT% && npm run start"

:: Aguardar frontend subir
timeout /t 15 >nul

:: Abrir navegador
start chrome http://localhost:%FRONTEND_PORT%

exit
