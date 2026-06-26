@echo off

mysqldump ^
    -h 127.0.0.1 -P 3307 ^
    -u root -p ^
    --single-transaction --hex-blob --skip-ssl --skip-triggers ^
    central > pv/dump.sql
