@echo ******************************
@echo Automate Data Collection for Windows OS Script v1.0

Create Directory :
mkdir C:\Collection

Sesuaikan Directory
set dir=C:\Collection

Identifikasi Date and Time :
date /t > %dir%\0.DateTime.txt
time /t > %dir%\0.DateTime.txt

Identifikasi Routing Jaringan :
netstat -r > %dir%\1.Routing.txt

Identifikasi Versi Sistem Operasi :
ver > %dir%\2.Version.txt
set > %dir%\3.Detail_Version.txt

Identifikasi Aplikasi/Service
net start > %dir%\4.Net_Start.txt
sc query > %dir%\5.Query01.txt
sc query state= all > %dir%\6.Query_All.txt

Identifikasi Running Process :
tasklist > %dir%\7.Daftar_Proses.txt

Identifikasi Aplikasi Terjadwal :
schtasks > %dir%\8.Aplikasi_Terjadwal.txt
wmic startup list full > %dir%\9.Startup.txt
wmic startup get Caption, Command > %dir%\10.StartupFull.txt

Identifikasi Jaringan Komunikasi :
netstat -nao > %dir%\11.Jaringan.txt

Identifikasi Koneksi :
net session > %dir%\12.Session.txt
net share > %dir%\13.Share.txt
net use > %dir%\14.Net_Use.txt

Identifikasi DNS :
ipconfig /displaydns > %dir%\15.DNS.txt

Identifikasi Daftar User :
net user > %dir%\16.User.txt
net localgroup > %dir%\17.Localgroup.txt
net localgroup administrators > %dir%\18.Grup_Admin.txt

@echo ******************************
@echo Script Complete!
