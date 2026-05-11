@echo off
title Atualizar Dados - Buriti Alegre Ambiental
cd /d "C:\BI_BuritiAlegre"
echo.
echo ============================================================
echo   BURITI ALEGRE AMBIENTAL - Atualizacao Manual de Dados
echo ============================================================
echo.
powershell -ExecutionPolicy Bypass -File "scripts\run_etl_diario.ps1"
echo.
if %errorlevel% equ 0 (
    echo [OK] Dados atualizados com sucesso!
    echo      O dashboard online sera atualizado em ~2 minutos.
) else (
    echo [AVISO] Verifique o log acima para detalhes.
)
echo.
pause
