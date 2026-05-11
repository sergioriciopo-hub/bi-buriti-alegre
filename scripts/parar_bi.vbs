'' Para o BI Buriti Alegre (encerra o processo python/streamlit na porta 8502)

Dim oShell
Set oShell = CreateObject("WScript.Shell")

'' Mata pela porta 8502
oShell.Run "cmd /c FOR /F ""tokens=5"" %a IN ('netstat -aon ^| find "":8502""') DO taskkill /f /PID %a 2>nul", 0, True

MsgBox "BI Buriti Alegre encerrado.", 64, "BI Buriti Alegre"
