@echo off
ffmpeg -i vor.mp4 -ss 00:37:37.560 -t 00:00:27.480 01_vor.mp4 -n
ffmpeg -i vor.mp4 -ss 00:38:16.760 -t 00:00:14.320 02_vor.mp4 -n
ffmpeg -i vor.mp4 -ss 00:38:39.440 -t 00:00:09.800 03_vor.mp4 -n
ffmpeg -i vor.mp4 -ss 00:39:06.440 -t 00:00:32.760 04_vor.mp4 -n
ffmpeg -i vor.mp4 -ss 00:39:39.240 -t 00:00:06.480 05_vor.mp4 -n

ffmpeg -f concat -i "list_vor.txt" -vol 1024 "spojene_vor.mp4" -n
pause
