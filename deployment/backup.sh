source /setup-sentry.sh
eval "$(setup_error_handling)"

mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD -h 172.20.0.3 $MYSQL_DATABASE > /tmp/mysqldump.sql
tarsnap --fsck
tarsnap -v -f $(date '+%Y-%m-%d_%H-%M-%S') -c /tmp/mysqldump.sql 1> /tmp/tarsnap-stdout.log 2> /tmp/tarsnap-stderr.log
