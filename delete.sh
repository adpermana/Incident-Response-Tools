#! /bin/bash

echo "************************************************************"
echo "Automate Data Collection for Ubuntu Server Script v1.0"
echo "************************************************************"

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

# Read Current Directory
curr=${PWD}

echo "$Purple Pilihlah Salah Satu Untuk Mitigasi :$Color_Off"
echo "$Purple [1] Karantina File Backdoor $Color_Off"
echo "$Purple [2] Karantina File Slot $Color_Off"
echo -n "$Purple Pilihan Anda : " 
read choice

backdoor_quarantine(){
echo "Proses karantina file Backdoor.."
read -p "Masukan nama file : " bfile
mkdir $curr/BackdoorFiles

cat $bfile | while read i; do mv $i BackdoorFiles/; done

tar -czf Backdoorfiles.tar.gz BackdoorFiles
rm -rf BackdoorFiles

echo "************************************************************"
echo "Script Completed Succesfully, saved to ./BackdoorFiles.tar.gz"
echo "************************************************************"

echo "\nSelesai.."
}

gacor_quarantine(){
echo "Proses karantina file Slot Judi Online.."
read -p "Masukan nama file : " cfile
mkdir $curr/GacorFiles

cat $cfile | while read i; do mv $i GacorFiles/; done

tar -czf GacorFiles.tar.gz GacorFiles
rm -rf GacorFiles

echo "************************************************************"
echo "Script Completed Succesfully, saved to ./GacorFiles.tar.gz"
echo "************************************************************"

echo "\nSelesai.."
}

if [ $choice -eq 1 ] 
then
    backdoor_quarantine
elif [ $choice -eq 2 ]
then
    gacor_quarantine
else
    exit 0;
fi
