#! /bin/bash

echo "************************************************************"
echo "Automate Data Collection for Centos Server Script v1.0"
echo "************************************************************"

# Read Current Directory
curr=${PWD}

# Create Directory :
mkdir $curr/CentosIR

# Sesuaikan Directory
dir=$curr/CentosIR

# Identifikasi Date :
date > $dir/0.DateTime.txt

# Identifikasi Versi Environment System :
uname -a > $dir/1.Versi_Kernel.txt
cat /etc/redhat-release > $dir/2.Versi_OS.txt

# Identifikasi Aplikasi/Service
ps -aux > $dir/3.Daftar_Proses.txt
top -b -n 1 > $dir/4.Daftar_Running_App.txt
cat /root/.bash_history > $dir/5.History.txt
ls /etc/cron* > $dir/6.Cron.txt
crontab -l > $dir/7.Crontab.txt

# Identifikasi Jaring Komunikasi
netstat -tulnp > $dir/8.Inbound.txt
netstat -antup > $dir/9.Outbound.txt
netstat -antup | grep "ESTA" > $dir/10.Established_Conn.txt
w > $dir/11.Connected_to_PC.txt
cat /etc/resolv.conf > $dir/12.DNS.txt
cat /etc/hostname > $dir/13.Hostname.txt
cat /etc/hosts > $dir/14.Hosts.txt

# Identifikasi User
cat /etc/passwd > $dir/15.Daftar_User.txt
cat /etc/passwd | grep "bash"> $dir/16.Daftar_User_Bash.txt
lastlog > $dir/17.Lastlog.txt
last > $dir/18.Last.txt

# List Directory
ls -alrt -R /home > $dir/19.Homedir.txt
ls -alrt -R /var/www > $dir/20.VarWWWdir.txt

# Searching Backdoor File
echo "Start Searching ..."
grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" /home/ > $dir/21.Backdoor-Homedir.txt
grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" /var/www/ > $dir/22.Backdoor-VarWWWdir.txt
echo "Finish Searching.\n"

# Create Compressed File
tar -czf Collection.tar.gz CentosIR
rm -rf CentosIR

echo "************************************************************"
echo "Script Completed Succesfully, saved to ./Collection.tar.gz"
echo "************************************************************"
