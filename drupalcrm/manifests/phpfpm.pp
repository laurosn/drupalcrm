class drupalcrm::phpfpm {

       file { "/etc/php5/fpm/php.ini":
		ensure	=> file,
		mode	=> '0644',
		owner	=> 'root',
		group	=> 'root',
		source  => "puppet:///modules/${module_name}/phpfpm/php.ini",
		require => Package["php5-fpm"],
		notify => Service['php5-fpm-service']
 	}


	  service { 'php5-fpm-service':
	    name   => "php5-fpm",
	    ensure => running,
	    enable => true,
	    hasstatus => true,
	    hasrestart => true,
	  }
}
