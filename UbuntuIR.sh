#! /bin/bash

echo "************************************************************"
echo "Automate Data Collection for Ubuntu Server Script v1.0"
echo "************************************************************"

# Read Current Directory
curr=${PWD}

# Create Directory :
mkdir $curr/UbuntuIR-$1

# Sesuaikan Directory
dir=$curr/UbuntuIR-$1

# Identifikasi Date :
date > $dir/0.DateTime-$1.txt

# Identifikasi Versi Environment System :
uname -a > $dir/1.Versi_Kernel-$1.txt
cat /etc/lsb-release > $dir/2.Versi_OS-$1.txt

# Identifikasi Aplikasi/Service
ps -aux > $dir/3.Daftar_Proses-$1.txt
top -b -n 1 > $dir/4.Daftar_Running_App-$1.txt
cat /root/.bash_history > $dir/5.History-$1.txt
ls -al /etc/cron* > $dir/6.Cron-$1.txt
crontab -l > $dir/7.Crontab-$1.txt
ls -al /var/spool/cron/crontabs/ > $dir/7-1.Crontab-$1.txt
bash -c 'for user in $(cut -f1 -d: /etc/passwd); do echo "Cron jobs for user: $user"; crontab -l -u $user; echo ""; done' > $dir/7-2.Crontab-$1.txt

# Identifikasi Jaring Komunikasi
netstat -tulnp > $dir/8.Inbound-$1.txt
netstat -antup > $dir/9.Outbound-$1.txt
netstat -antup | grep "ESTABLISHED" > $dir/10.Established_Conn-$1.txt
w > $dir/11.Connected_to_PC-$1.txt
cat /etc/resolv.conf > $dir/12.DNS-$1.txt
cat /etc/hostname > $dir/13.Hostname-$1.txt
cat /etc/hosts > $dir/14.Hosts-$1.txt

# Identifikasi User
cat /etc/passwd > $dir/15.Daftar_User-$1.txt
cat /etc/passwd | grep "bash"> $dir/16.Daftar_User_Bash-$1.txt
lastlog > $dir/17.Lastlog-$1.txt
last > $dir/18.Last-$1.txt

# List Directory
ls -alrt -R /home > $dir/19.Homedir-$1.txt
ls -alrt -R /var/www > $dir/20.VarWWWdir-$1.txt

# Searching Backdoor File
echo "Start Searching ..."
grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" /home/ > $dir/21.Backdoor-Homedir-$1.txt
grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" /var/www/ > $dir/22.Backdoor-VarWWWdir-$1.txt

# Searching others malicious activity
grep -Rinw /home -e "slot" -e "gacor" -e "maxwin" -e "thailand" -e "sigmaslot" -e "zeus" -e "cuan" > $dir/23.ListSlot-$1.txt
echo "Finish Searching.\n"

# Create Compressed File
tar -czf Collection-$1.tar.gz UbuntuIR-$1
rm -rf UbuntuIR-$1

echo "************************************************************"
echo "Script Completed Succesfully, saved to ./Collection.tar.gz"
echo "************************************************************"
