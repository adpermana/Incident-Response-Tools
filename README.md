-------------------------------------------------------
# Incident Response Tools (Open Source Licenses)
-------------------------------------------------------

# Automate Data Collection 
 - Run this shell script on your server :
   * Ubuntu Server : curl -sO https://raw.githubusercontent.com/adpermana/Incident-Response-Tools/analisa/UbuntuIR.sh && sudo bash ./UbuntuIR.sh nama_instansi
   
 - After run, output saved to ./Collection.tar.gz

 # Automate Delete
 - Siapkan list malicious file yang akan dihapus
 - Simpan list tersebut pada sebuah file (misal list_backdoor.txt)
 - Run :
   * Ubuntu Server : curl -sO https://raw.githubusercontent.com/adpermana/Incident-Response-Tools/analisa/delete.sh && sudo bash ./delete.sh
 - Setelah dijalankan pilih nomor 1 atau 2
 - Lalu masukan nama file yang berisi kumpulan list malicious files tersebut
