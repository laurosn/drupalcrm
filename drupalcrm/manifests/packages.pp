class drupalcrm::packages {
        ### Installing essential packages ###
        package {[              'nginx',
				'git',
                                'php5-fpm',
                                'php5-cli',
                                'php5-gd',
                                'php5-mysql',
				'drush',
				'curl',
				'php5-curl',
				'duplicity',
				'python-pip',
				'python-boto'
                                ]:
                                ensure  => installed
        }


}
