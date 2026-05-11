@echo off
REM ═══════════════════════════════════════════════════════════════════════════
REM ETL - Buriti Alegre Ambiental | BigQuery → Parquet (Task Scheduler)
REM Agendar: Task Scheduler diário às 07:30
REM ═══════════════════════════════════════════════════════════════════════════

setlocal enabledelayedexpansion

REM Diretório do projeto
cd /d "C:\BI_BuritiAlegre"

REM Executar script completo (BigQuery + Frota + Git push)
powershell -ExecutionPolicy Bypass -File "scripts\run_etl_diario.ps1"

REM Capturar exit code
set EXIT_CODE=%errorlevel%

REM Log da execução
echo.
echo ============================================================
if %EXIT_CODE% equ 0 (
    echo [OK] ETL executado com sucesso em %date% %time%
) else (
    echo [ERRO] ETL falhou com código: %EXIT_CODE%
)
echo ============================================================

exit /b %EXIT_CODE%
