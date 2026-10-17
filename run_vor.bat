@echo off
title ffmpeg_vyrezi_videa_spojeni_vyrezu_5.ps1
cls

REM echo napr. kdyz_v_Litomericich_horelo.txt -n
REM set /p volba="nazev souboru : "
set volba=vor.txt -n
echo %volba%

powershell -file ffmpeg_vyrezi_videa_spojeni_vyrezu_5.ps1 %volba%
REM ffmpeg_vyrezi_videa_spojeni_vyrezu_3.exe %volba%
pause

