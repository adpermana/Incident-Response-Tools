-------------------------------------------------------
# Incident Response Tools (Open Source Licenses) v1.1
-------------------------------------------------------

<!-- Banner -->
<p align="center">
  <img src="https://img.shields.io/badge/Incident%20Response%20Tools-Analisa%20Branch-red?style=for-the-badge&logo=github" alt="Incident Response Tools Banner">
</p>

<p align="center">
  <b>🛡️ Automating Artefact Collector, Malware Scanner, Auditing</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Active-success?style=flat-square">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square">
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-lightgrey?style=flat-square">
</p>

# Automate Data Collection 
 - Run this shell script on your server :
   * Ubuntu Server
     ```bash
     sudo bash ./UbuntuIR.sh /path/to/scan
     
   * Example Scan to Folder /var/www/html
     ```bash
     curl -sO https://raw.githubusercontent.com/adpermana/Incident-Response-Tools/analisa/UbuntuIR.sh && sudo bash ./UbuntuIR.sh /var/www/html
   
 - After run, output saved to "Collection.tar.gz" and files "*.html"
 - To extract : tar -xf Collection.tar.gz

 # Automate Delete
 - Siapkan list malicious file yang akan dihapus
 - Simpan list tersebut pada sebuah file (misal list_backdoor.txt)
 - Run :
   * Ubuntu Server
     ```bash
     curl -sO https://raw.githubusercontent.com/adpermana/Incident-Response-Tools/analisa/delete.sh && sudo bash ./delete.sh
 - Setelah dijalankan pilih nomor 1 atau 2
 - Lalu masukan nama file yang berisi kumpulan list malicious files tersebut
