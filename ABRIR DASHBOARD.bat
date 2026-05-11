@echo off
title Dashboard - Buriti Alegre Ambiental
cd /d "C:\BI_BuritiAlegre"
start "" "http://localhost:8502"
python -m streamlit run app.py --server.port 8502
