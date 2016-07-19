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
	  cron_hour              => '0',
	  cron_minute            => '20',
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
      hour     => '0',
      minute   => '29',
      weekday  => '*',
      month    => '*',
      monthday => '*',
    }


file { "/root/backup/scripts":
                    ensure  => directory,
                    replace => false,
                    recurse => false,
                    owner   => "root",
                    group   => "root",
		    require => File["/root/backup/"]
}           

file { "/root/backup/scripts/recover_mysql.sh":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
    source  => "puppet:///modules/${module_name}/backup/recover_mysql.sh",
    require => File["/root/backup/scripts"]
}


file { "/root/backup/scripts/restore_www.sh":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
    source  => "puppet:///modules/${module_name}/backup/restore_www.sh",
    require => File["/root/backup/scripts"]
}
      
file { "/root/backup/scripts/backup_www.sh":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
    source  => "puppet:///modules/${module_name}/backup/backup_www.sh",
    require => File["/root/backup/scripts"]
}
->
cron { 'wwwbackupjob':
      ensure   => present,
      user     => root,
      command  => "/root/backup/scripts/backup_www.sh",
      hour     => '0',
      minute   => '39',
      weekday  => '*',
      month    => '*',
      monthday => '*',
    }



}


