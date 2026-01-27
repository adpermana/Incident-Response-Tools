#!/bin/bash

TARGET_DIR=${1:-$(pwd)}
OUT="scan_classified_$(date +%Y%m%d_%H%M%S).log"

RED="[HIGH]"
ORANGE="[MEDIUM]"
GREEN="[LOW]"

echo "========================================" | tee $OUT
echo " SEO Cloaking & Judi Malware Scanner" | tee -a $OUT
echo " Classified Output Version" | tee -a $OUT
echo " Target: $TARGET_DIR" | tee -a $OUT
echo "========================================" | tee -a $OUT
echo "" | tee -a $OUT

# ---------------- HIGH RISK ----------------
echo "$RED Critical Findings" | tee -a $OUT
echo "----------------------------------------" | tee -a $OUT

# htaccess cloaking
grep -RniE "googlebot|bingbot|yandex|HTTP_USER_AGENT|HTTP_REFERER|RewriteRule|RewriteCond.*google" $TARGET_DIR/.htaccess 2>/dev/null \
| sed "s/^/$RED /" | tee -a $OUT

# PHP backdoor patterns
grep -RniE "base64_decode|eval\(|gzinflate|str_rot13|preg_replace\(.*/e|shell_exec|system\(|exec\(" $TARGET_DIR 2>/dev/null \
| sed "s/^/$RED /" | tee -a $OUT

# PHP inside uploads/cache/tmp
find $TARGET_DIR -type d \( -iname "upload" -o -iname "cache" -o -iname "tmp" \) \
-exec find {} -type f -iname "*.php" \; 2>/dev/null \
| sed "s/^/$RED Suspicious PHP: /" | tee -a $OUT

echo "" | tee -a $OUT

# ---------------- MEDIUM RISK ----------------
echo "$ORANGE Suspicious / SEO Spam Indicators" | tee -a $OUT
echo "----------------------------------------" | tee -a $OUT

# sitemap spam
find $TARGET_DIR -iname "sitemap" -type f 2>/dev/null \
| sed "s/^/$ORANGE Sitemap file: /" | tee -a $OUT

# judi keywords
grep -RniE "judi|slot|casino|togel|betting|poker|pragmatic|gacor" $TARGET_DIR 2>/dev/null \
| sed "s/^/$ORANGE Keyword found: /" | tee -a $OUT

# redirect headers
grep -RniE "Location:|header\(.*Location" $TARGET_DIR 2>/dev/null \
| sed "s/^/$ORANGE Redirect logic: /" | tee -a $OUT

echo "" | tee -a $OUT

# ---------------- LOW RISK ----------------
echo "$GREEN Informational / Audit Trail" | tee -a $OUT
echo "----------------------------------------" | tee -a $OUT

# recently modified files
find $TARGET_DIR -type f -mtime -3 2>/dev/null \
| sed "s/^/$GREEN Recently modified: /" | tee -a $OUT

# cron jobs
(crontab -l 2>/dev/null && ls -la /etc/cron* 2>/dev/null) \
| sed "s/^/$GREEN Cron info: /" | tee -a $OUT

echo "" | tee -a $OUT
echo "========================================" | tee -a $OUT
echo " Scan finished. Log saved to: $OUT" | tee -a $OUT
echo "========================================" | tee -a $OUT
