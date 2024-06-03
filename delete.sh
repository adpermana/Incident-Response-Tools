#! /bin/bash

echo "************************************************************"
echo "Automate Quarantine Malicious Files"
echo "************************************************************"

# Read Current Directory
curr=${PWD}

echo "Pilihlah Salah Satu Untuk Mitigasi :"
echo "[1] Karantina File Backdoor"
echo "[2] Karantina File Slot"
echo -n "Pilihan Anda : " 
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
