-------------------------------------------------------
# Incident Response Tools (Open Source Licenses)
-------------------------------------------------------

# Ticketing System
 - OTRS System >> https://community.otrs.com/
 - OSTicket >> https://github.com/osTicket/osTicket
 
# Detection System
 - Monitoring System 
   * Security Onion >> https://github.com/Security-Onion-Solutions/security-onion/blob/master/Verify_ISO.md
   * Cacti >> https://www.cacti.net/download_cacti.php
 - Firewall 
   * PFSense >> https://www.pfsense.org/
   * PFSense Download Virtual >> https://www.pfsense.org/download/
   * IPFire >> https://www.ipfire.org/download/ipfire-2.23-core136
 - Network Intrusion Detection System (NIDS)
   * SNORT >> https://www.snort.org/
   * SNORTER >> https://github.com/joanbono/Snorter
   * SURRICATA >> https://suricata-ids.org/news/
   * SNORT to Telegram Notification >> https://github.com/rizkylab/Web-Snort-Firewall
   * SNORBY >> https://github.com/Snorby/snorby
 - Host Intrusion Detection System (HIDS)
   * OSSEC >> https://www.ossec.net/downloads/
   * WAZUH >> https://wazuh.com/
   * OSSIM >> https://www.alienvault.com/products/ossim
 - Web Application Firewall (WAF)
   * ModSecurity >> https://www.modsecurity.org/
   * Tutorial ModSecurity on Centos 7 >> https://govcsirt.bssn.go.id/tutorial-instalasi-modsecurity-pada-centos-7/
   * Shadow Daemon >> https://shadowd.zecure.org/overview/introduction/
 - Log Management
   * Elasticksearch Logstash Kibana (ELK) >> https://www.elastic.co/what-is/elk-stack
   * Installation ELK >> https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04
   * Graylog >> https://www.graylog.org/downloads
   
# Investigation on Linux Server
 - Network Analysis
   * Netstat Command in Linux >> https://www.rekha.com/netstat-cheat-sheet-for-newbies.html
   * Netstat Command in Linux >> https://www.tecmint.com/20-netstat-commands-for-linux-network-management/
   * TCPDump Cheat Sheet >> https://www.andreafortuna.org/2018/07/18/tcpdump-a-simple-cheatsheet/
   * Netstat Command >> https://linuxaria.com/howto/how-to-verify-ddos-attack-with-netstat-command-on-linux-terminal
 - Directory Analysis
   * Linux Cheat Sheet >> http://cheatsheetworld.com/programming/unix-linux-cheat-sheet/
 - Backdoor Search Script
   * Grep >> grep -RPn "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile) *\(" nama_direktori
   * Grep >> grep -Rinw nama_direktori -e "nama_string"
 - Privilege Escalation
   * PE >> https://blog.g0tmi1k.com/2011/08/basic-linux-privilege-escalation/
   * PE >> https://www.rebootuser.com/?p=1623
 - Process Analysis
 - Log Analysis
 
# Backup System
 - Backup
 - Imaging
 
# Post Incident Activity
 - Vulnerability Assessment
   * Pentesting tools >> https://highon.coffee/blog/penetration-testing-tools-cheat-sheet/#osint
   * Pentesting Cheat Sheet >> https://highon.coffee/blog/cheat-sheet/
   * Pentesting Cheat Sheet >> https://ired.team/offensive-security-experiments/offensive-security-cheetsheets
 - Hardening
   * Centos 7 OS >> https://highon.coffee/blog/security-harden-centos-7/
 
# IP Analysis
 - Whois IP Lookup : https://www.ultratools.com/tools/ipWhoisLookupResult
 - IP Analysis :
    - https://www.ipalyzer.com/
    - https://www.ipvoid.com/
    - https://mxtoolbox.com/blacklists.aspx
    - https://www.abuseipdb.com/
 - IP Reputation : https://www.talosintelligence.com/reputation_center
 - Trace History IP :
    - https://www.riskiq.com/
    - https://archive.org/web/

Referensi : 
- https://github.com/meirwah/awesome-incident-response
- https://github.com/Cugu/awesome-forensics
- https://www.alienvault.com/resource-center/ebook/insider-guide-to-incident-response/incident-response-tools
- Honeypot : https://github.com/zdresearch/OWASP-Honeypot
- Honeypot : https://github.com/paralax/awesome-honeypots
