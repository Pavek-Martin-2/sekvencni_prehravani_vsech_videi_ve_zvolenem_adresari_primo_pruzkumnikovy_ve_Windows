@echo off
title play_vor.mp4

set file="vor.mp4"

set f="yes"
REM tady si jeste muzete vybrat, budto jedno nebo druhy
REM set f="no"

set m="no"
REM set m="yes"

set sp="1"
REM set sp="0.5"


set a01="00:37:37.560"
set b01="00:38:05.040"
mpv --fullscreen=%f% --mute=%m% --speed=%sp% --start=%a01% --end=%b01% %file%

set a02="00:38:16.760"
set b02="00:38:31.080"
mpv --fullscreen=%f% --mute=%m% --speed=%sp% --start=%a02% --end=%b02% %file%

set a03="00:38:39.440"
set b03="00:38:49.240"
mpv --fullscreen=%f% --mute=%m% --speed=%sp% --start=%a03% --end=%b03% %file%

set a04="00:39:06.440"
set b04="00:39:39.200"
mpv --fullscreen=%f% --mute=%m% --speed=%sp% --start=%a04% --end=%b04% %file%

set a05="00:39:39.240"
set b05="00:39:45.720"
mpv --fullscreen=%f% --mute=%m% --speed=%sp% --start=%a05% --end=%b05% %file%

pause
