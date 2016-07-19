#!/bin/bash

BACKUP_PATH=/root/backup/
AWS_S3_BUCKET=s3://work-for-us-bucket/
backup_date=$1
count=`s3cmd ls $AWS_S3_BUCKET$backup_date.tar.gz | wc -l`
DAILYLOGFILE="/root/backup/backup.daily.log"

# Trace function for logging
trace () {
    stamp=`date +%Y-%m-%d_%H:%M:%S`
    echo "$stamp: $*" >> ${DAILYLOGFILE}
}

if [[ $count -gt 0 ]]; then
	trace "File $backup_date.tar.gz exists on aws s3 bucket  "
	trace "Starting restore database from day $backup_date"
	trace "Recovering file $backup_date.tar.gz from aws s3"
	s3cmd get $AWS_S3_BUCKET$backup_date.tar.gz $BACKUP_PATH
	if [ -f "$BACKUP_PATH$backup_date.tar.gz" ]
	then
		trace "File $backup_date.tar.gz downloaded from aws s3"
		trace "Extracting file $backup_date.tar.gz on folder $BACKUP_PATH"
		rm -rf $BACKUP_PATH$backup_date
		cd /
		tar xvfz $BACKUP_PATH$backup_date.tar.gz
		if [ "$?" -ne '0' ]; then
			trace 'Fail to extract file $BACKUP_PATH$backup_date.tar.gz'
			exit 1
		else
			trace "Stoping mysql service"
			service mysql stop
			trace "Waiting 10 seconds to stop mysql"
			sleep 10
			pidmysql=`pgrep mysql`
			if [[ -n "$pidmysql" && $pidmysql -gt 0 ]];then
				trace 'Failed to stop mysql'
				exit 1
			else
				trace 'Removing old data files from mysql folder'
				rm -rf /var/lib/mysql/*
				trace 'Syncing backup folder with mysql folder'
				rsync -avrP /root/backup/$backup_date/ /var/lib/mysql/
				trace 'Setting mysql data folder owner'
				chown -R mysql:mysql /var/lib/mysql
				trace "Starting mysql service"
				service mysql start
				trace "Waiting 5 seconds to start mysql"
				sleep 5
				pidmysql=`pgrep mysql`
				if [[ -n "$pidmysql" && $pidmysql -gt 0 ]];then
					trace 'Failed to start mysql. Recover failed.'
					exit 1
				else
					trace 'Mysql service started. Recover finished'
					exit 1
				fi
			fi			
		fi
	else
		trace "failed to download $backup_date.tar.gz  from aws s3"
	fi
else
	trace "File $backup_date.tar.gz does not exists on aws s3 bucket. Try another date"
	trace "Listing available backups"
	s3cmd ls $AWS_S3_BUCKET | grep tar.gz |  tr -s " " | cut -d " " -f4
fi
