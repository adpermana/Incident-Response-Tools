#! /bin/bash

echo "*****************************************************************"
echo "Automate Data Collection for Compromise Assessment Script v1.0"
echo "*****************************************************************"

# Read Current Directory
curr=${PWD}

# Create Directory :
mkdir $curr/CATest
mkdir $curr/CATest/UbuntuIR
mkdir $curr/CATest/ThorLite
mkdir $curr/CATest/Audit

# Sesuaikan Directory
dir=$curr/CATest/UbuntuIR
dirThor=$curr/CATest/ThorLite
dirAudit=$curr/CATest/Audit

## Evidence Collector for Compromise Assessment
echo "Compromise Assesment Processing!!"

# Identifikasi Date :
date > $dir/0.DateTime.txt

# Identifikasi Versi Environment System :
uname -a > $dir/1.Versi_Kernel.txt
cat /etc/lsb-release > $dir/2.Versi_OS.txt

# Identifikasi Aplikasi/Service
ps -aux > $dir/3.Daftar_Proses.txt
top -b -n 1 > $dir/4.Daftar_Running_App.txt
cat /root/.bash_history > $dir/5.History.txt
ls /etc/cron* > $dir/6.Cron.txt
crontab -l > $dir/7.Crontab.txt
ls -al /var/spool/cron/crontabs/ > $dir/7-1.Crontab-$1.txt
bash -c 'for user in $(cut -f1 -d: /etc/passwd); do echo "Cron jobs for user: $user"; crontab -l -u $user; echo ""; done' > $dir/7-2.Crontab-$1.txt

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
echo "Searching for Malicious Files..."
grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" /home/ > $dir/21.Backdoor-Homedir.txt
grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" /var/www/ > $dir/22.Backdoor-VarWWWdir.txt

# Searching others malicious activity
grep -Rinw /home -e "slot" -e "gacor" -e "maxwin" -e "thailand" -e "sigmaslot" -e "zeus" -e "cuan" > $dir/23.ListSlot.txt
echo "Finish Searching Malicious Files.\n"

## Malware Scanner with Thor-Lite
echo "Thor-Lite Processing!!"
git clone https://github.com/adpermana/Thor-2.git $dirThor
chmod +x $dirThor/thor-lite-linux
cd $dirThor && ./thor-lite-linux -a Filescan --intense --norescontrol --cross-platform --alldrives -p /home/
cd ../..

## Audit System with Lynis and LinPEAS
echo "Audit System Processing!!"
git clone https://github.com/CISOfy/lynis $dirAudit
cd $dirAudit && ./lynis audit system > $dirAudit/out-lynis.txt
cd ../..
mv lynis-report.dat $dirAudit
mv lynis.log $dirAudit

curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh | sh > $dirAudit/out-linpeas.txt

# Create Compressed File
tar -czf CATest.tar.gz CATest
rm -rf CATest

echo "************************************************************"
echo "Script Completed Succesfully, saved to ./CATest.tar.gz"
echo "************************************************************"
