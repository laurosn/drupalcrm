class drupalcrm::backup {

	file { "/root/backup/":
		    ensure  => directory,
		    replace => false,
		    recurse => false,
		    owner   => "root",
		    group   => "root",
	}
	->
	class { ::xtrabackup:
	  backup_retention       => '30',
	  cron_hour              => '*',
	  cron_minute            => '40',
	  backup_dir             => '/root/backup/', 
	  mysql_user             => 'root',
	  mysql_pass             => 'root'
	}
->
class { 's3cmd':
    aws_access_key => 'AKIAJUB7W33OW52CKNEQ',
    aws_secret_key => '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',
    gpg_passphrase => 'gpg password for encryption',
    owner => 'root',
}
->
cron { 'putmysqlbkpons3':
      ensure   => present,
      user     => root,
      command  => "/bin/tar cvfz /root/backup/$(date +\%F).tar.gz /root/backup/$(date +\%F) && /usr/bin/s3cmd put /root/backup/$(date +\%F).tar.gz s3://work-for-us-bucket/ && rm -rf /root/backup/$(date +\%F)",
      hour     => '*',
      minute   => '29',
      weekday  => '*',
      month    => '*',
      monthday => '*',
    }


}
