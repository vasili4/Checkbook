rm -f /vol2/CSV/FaadsMainLd.csv
iconv -f ISO8859-1 -t UTF-8 /vol2/CSV/FaadsMainLd_MySQL.csv >/vol2/CSV/FaadsMainLd.csv
rm -f /vol2/CSV/FaadsMainLd_MySQL.csv
chmod 777 /vol2/CSV/FaadsMainLd.csv
