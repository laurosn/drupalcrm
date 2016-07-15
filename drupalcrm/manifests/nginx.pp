class drupalcrm::nginx {

       file { "/etc/nginx/nginx.conf":
		ensure	=> file,
		mode	=> '0644',
		owner	=> 'root',
		group	=> 'root',
		source  => "puppet:///modules/${module_name}/nginx/nginx.conf",
		require => Package["nginx"],
		notify => Service['nginx-service']
 	}

       file { "/etc/nginx/sites-available/default":
		ensure	=> file,
		mode	=> '0644',
		owner	=> 'root',
		group	=> 'root',
		source  => "puppet:///modules/${module_name}/nginx/default.nginx",
		require => Package["nginx"],
		notify => Service['nginx-service']
 	}
	->
        file { '/etc/nginx/sites-enabled/default':
	    ensure => 'link',
	    target => '/etc/nginx/sites-available/default',
	  }


	 file { "/var/www/html":
	    ensure  => directory,
	    replace => false,
	    recurse => false,
	    owner   => "www-data",
	    group   => "www-data",
	  }
	 ->
          file { "/var/www/html/info.php":
	    ensure  => file,
	    owner   => "www-data",
	    group   => "www-data",
	    source  => "puppet:///modules/${module_name}/phpfpm/info.php",
	  }

         file { "/etc/nginx/ssl":
	    ensure  => directory,
	    replace => false,
	    recurse => false,
	    owner   => "root",
	    group   => "root",
	    require => Package["nginx"],
	  }

	 file { "/etc/nginx/ssl/drupal.crt":
	    ensure  => file,
	    owner   => "root",
	    group   => "root",
	    source  => "puppet:///modules/${module_name}/nginx/drupal.crt",
	    require => File["/etc/nginx/ssl"],
	  }

         file { "/etc/nginx/ssl/drupal.key":
	    ensure  => file,
	    owner   => "root",
	    group   => "root",
	    mode    => '0600',
	    source  => "puppet:///modules/${module_name}/nginx/drupal.key",
	    require => File["/etc/nginx/ssl"],
	  }



         file { "/etc/nginx/sites-available/drupal.conf":
		ensure	=> file,
		mode	=> '0644',
		owner	=> 'root',
		group	=> 'root',
		source  => "puppet:///modules/${module_name}/nginx/drupal.conf",
		require => [Package["nginx"], File["/etc/nginx/ssl/drupal.key"], File["/etc/nginx/ssl/drupal.crt"]],
		notify => Service['nginx-service']
 	}
	->
        file { '/etc/nginx/sites-enabled/drupal.conf':
	    ensure => 'link',
	    target => '/etc/nginx/sites-available/drupal.conf',
	  }



	  service { 'nginx-service':
	    name   => "nginx",
	    ensure => running,
	    enable => true,
	    hasstatus => true,
	    hasrestart => true,
	  }
}
