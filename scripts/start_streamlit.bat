@echo off
REM Inicia o BI Buriti Alegre - usa caminho curto para evitar problema com acentos no usuario
set STREAMLIT_SERVER_HEADLESS=true

C:\Users\SRGIOR~1\AppData\Local\Programs\Python\PYTHON~1\python.exe ^
    -m streamlit run "C:\BI_BuritiAlegre\app.py" ^
    --server.headless true ^
    --server.port 8502 ^
    >> "C:\BI_BuritiAlegre\scripts\logs\streamlit_startup.log" 2>&1
