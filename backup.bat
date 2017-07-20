start /w "" "C:\Program Files (x86)\WinSCP\WinSCP.exe" /console /script=E:\\backup.txt /log=E:\log.txt
 
set date=%date:~10,4%%date:~7,2%%date:~4,2%

"C:\Program Files\7-Zip\7z.exe" a -tzip %date%.zip sync.*
