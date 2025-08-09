#! /bin/bash

echo "*****************************************************************"
echo "Automate Data Collection for Compromise Assessment Script v1.1"
echo "Added Function : ThorLite - linpeas - lynis"
echo "*****************************************************************"

# Fungsi untuk memeriksa hak akses root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "ERROR: Skrip ini harus dijalankan sebagai root. Gunakan sudo."
        exit 1
    fi
}

DIR=""

function usage() {
    echo "Usage: $0 <path_direktori>"
    echo "  path ke directory yang akan dilakukan scan. Contoh: $0 /var/log"
    exit 1
}

if [ -z "$1" ]; then
    usage 
fi

DIR="$1" 

if [ -d "$DIR" ]; then
    LOG=$DIR
else
    echo "Direktori '$DIR' Tidak ditemukan."
    exit 0;
fi

# Periksa hak akses root
check_root 

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
HTML_REPORT_FILE="$curr/CATest/UbuntuIR_$(date +%Y%m%d-%H%M%S).html" # Nama file HTML report

## Evidence Collector for Compromise Assessment
echo "---------------------"
echo "| Collecting Data.. |"
echo "---------------------"

# Identifikasi Date :
date > $dir/0.DateTime.txt

# Identifikasi Versi Environment System :
uname -a > $dir/1.Versi_Kernel.txt
cat /etc/lsb-release > $dir/2.Versi_OS.txt

# Identifikasi Aplikasi/Service
ps -aux > $dir/3.Daftar_Proses.txt
top -b -n 1 > $dir/4.Daftar_Running_App.txt
#cat /root/.bash_history > $dir/5.History.txt
ls /etc/cron* > $dir/6.Cron.txt
crontab -l > $dir/7.Crontab.txt
ls -al /var/spool/cron/crontabs/ > $dir/7-1.Crontab.txt
bash -c 'for user in $(cut -f1 -d: /etc/passwd); do echo "Cron jobs for user: $user"; crontab -l -u $user; echo ""; done' > $dir/7-2.Crontab.txt

# Identifikasi history semua user
history_users="5.History.txt"
function get_history() {
    local user_dir="$1"
    local user_name
    user_name=$(basename "$user_dir")

    HIST_FILE="$user_dir/.bash_history"
    if [ -f "$HIST_FILE" ]; then
        echo -e "\n========================================================" >> "$history_users"
        echo "🧑‍💻 USER: $user_name ($HIST_FILE)" >> "$history_users"
        echo "========================================================" >> "$history_users"
        cat "$HIST_FILE" >> "$history_users"
    fi
}

# Loop semua user home dir
for dir in /home/*; do
    [ -d "$dir" ] && get_history "$dir"
done
get_history "/root"

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
ls -alrt -R $LOG > $dir/20.VarWWWdir.txt

# Searching Backdoor File
echo "Searching for Malicious Files..."
grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" /home/ > $dir/21.BackdoorScan-DirHome.txt
grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" $LOG > $dir/22.BackdoorScan.txt

# Searching others malicious activity
grep -Rinw $LOG -e "gacor" -e "maxwin" -e "thailand" -e "sigmaslot" -e "zeus" -e "cuan" > $dir/23.ListSlot.txt

# Identifikasi files yang 1 bulan terakhir terjadi perubahan
find $LOG -type f -mtime -30 -ls > $dir/24.LastModifiedFiles.txt
find $LOG -type f -ctime -30 -ls > $dir/25.NewFiles.txt

echo "Finish Searching Files.\n"

## Malware Scanner with Thor-Lite
echo "--------------------------"
echo "| Thor-Lite Processing.. |"
echo "--------------------------"

git clone https://github.com/adpermana/Thor-2.git $dirThor
chmod +x $dirThor/thor-lite-linux
cd $dirThor && ./thor-lite-linux -a Filescan --intense --norescontrol --cross-platform --alldrives --nocsv -p $LOG -e $curr/CATest/ --htmlfile thor-output.html
cd ../..

## Audit System with Lynis and LinPEAS
echo "-----------------------------"
echo "| Audit System Processing.. |"
echo "-----------------------------"

git clone https://github.com/CISOfy/lynis $dirAudit
cd $dirAudit && ./lynis audit system > $curr/CATest/out-lynis.txt
cd ../..

curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh | sh > $curr/CATest/out-linpeas.txt

echo "-----------------------------"
echo "| Create Report *.html file |"
echo "-----------------------------"

cat << EOF > "$HTML_REPORT_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hasil Pengumpulan Artefak Digital</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; background-color: #f4f7f6; color: #333; line-height: 1.6; }
        .container { max-width: 1000px; margin: auto; background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h1, h2, h3 { color: #2c3e50; padding-bottom: 8px; margin-top: 30px; }
        h1 { text-align: center; color: #1e88e5; }
        h2 { color: #3498db; border-bottom: 2px solid #3498db; }
        /* Style for details/summary */
        details {
            background-color: #e0f2f7; /* Light blue background for collapsed state */
            border: 1px solid #cceeff;
            border-radius: 5px;
            margin-bottom: 10px;
            padding: 0; /* Remove default padding */
        }
        summary {
            font-weight: bold;
            padding: 12px 15px;
            cursor: pointer;
            outline: none;
            background-color: #e0f2f7; /* Match details background */
            border-radius: 5px;
            transition: background-color 0.2s;
            color: #2c3e50; /* Darker text for summary */
        }
        summary:hover {
            background-color: #d1eff7; /* Slightly darker on hover */
        }
        details[open] {
            background-color: #f9f9f9; /* Lighter background when open */
            border-color: #a7d9f7;
        }
        details[open] summary {
            border-bottom: 1px solid #cceeff; /* Separator when open */
            background-color: #cceeff; /* Slightly different background when open */
            color: #1e88e5;
        }
        .code-content { /* New div to hold code-block inside details */
            padding: 10px 15px 15px 15px; /* Padding for content inside details */
        }
        .code-block {
            background-color: #f0f0f0;
            padding: 10px;
            border-radius: 5px;
            overflow-x: auto;
            font-family: 'Consolas', 'Monaco', monospace;
            white-space: pre-wrap;
            word-wrap: break-word;
            margin-top: 5px; /* Small margin from summary */
        }
        .info-box { background-color: #e3f2fd; border-left: 5px solid #2196f3; padding: 15px; margin-bottom: 20px; border-radius: 4px; color: #1e88e5; }
        .info-box span { font-weight: bold; color: #0d47a1; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Laporan Insiden Respons Linux Server</h1>
        <div class="info-box">
            <span>Tanggal Laporan:</span> $(date '+%Y-%m-%d %H:%M:%S')<br>
        </div>

        <h2>Ringkasan Sistem</h2>
        <details>
            <summary>Tanggal dan Waktu Pengambilan Artefak</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/0.DateTime.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Informasi OS (/etc/os-release)</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/2.Versi_OS.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Versi Kernel</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/1.Versi_Kernel.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Proses</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/3.Daftar_Proses.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Aplikasi Berjalan</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/4.Daftar_Running_App.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar History Root</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/5.History.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Cron</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/6.Cron.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Crontab</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/7.Crontab.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Crontab (/var/spool/)</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/7-1.Crontab.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Crontab All User</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/7-2.Crontab.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Listening Ports</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/8.Inbound.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Outbond Connection</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/9.Outbound.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Established Connection</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/10.Established_Conn.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar User Connected</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/11.Connected_to_PC.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>DNS Configuration</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/12.DNS.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Informasi Hostname</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/13.Hostname.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Informasi Host</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/14.Hosts.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Informasi Daftar User</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/15.Daftar_User.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Informasi Daftar User memiliki Bash System (cmd)</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/16.Daftar_User_Bash.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar User yang terakhir Login</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/17.Lastlog.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar User yang terakhir Login (last)</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/18.Last.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Direktori pada /home/</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/19.Homedir.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Direktori pada "$LOG"</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/20.VarWWWdir.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Files yang 1 bulan terakhir ditambahkan pada "$LOG"</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/25.NewFiles.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Files yang 1 bulan terakhir dimodifikasi pada "$LOG"</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/24.LastModifiedFiles.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Files yang terindikasi Malicious (/home)</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/21.BackdoorScan-DirHome.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar Files yang terindikasi Malicious "$LOG"</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/22.BackdoorScan.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        <details>
            <summary>Daftar File pada /home yang terindikasi Judi Online</summary>
            <div class="code-content"><div class="code-block"><pre><code>$(cat "$dir/23.ListSlot.txt" 2>/dev/null || echo "Data tidak tersedia.")</code></pre></div></div>
        </details>
        
        <div class="info-box" style="margin-top: 40px;">
            <span>Catatan:</span> Laporan HTML ini adalah ringkasan. Untuk analisis mendalam, periksa semua file data mentah di direktori <code>$(basename "CATest.tar.gz")</code> yang terkompresi.
        </div>
    </div>
</body>
</html>
EOF

cat $curr/CATest/thor-output.html >> $HTML_REPORT_FILE

# Create Compressed File
tar -czf CATest.tar.gz CATest
rm -rf CATest

echo "************************************************************"
echo " Script Completed Succesfully, saved to file CATest.tar.gz  "
echo "************************************************************"
