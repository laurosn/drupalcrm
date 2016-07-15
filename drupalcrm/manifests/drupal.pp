class drupalcrm::drupal {

       exec { "install-drupal":
	command => "drush dl drupal --destination=/var/www/",
	cwd	=> "/var/www/",
	path    => ['/usr/bin', '/usr/sbin', '/bin'],
	onlyif  => ["test ! -f /var/www/drupal-7.50"],
	require => Package["drush"],
      }
      ->
      file { '/var/www/drupal':
	    ensure => 'link',
	    target => '/var/www/drupal-7.50',
       }
       ->
       exec { "install-drupal-std":
        command => "/bin/sh -c 'cd /var/www/drupal && drush site-install standard --db-url=mysql://drupaluser:drupal@localhost/drupaldb --account-name=admin --account-pass=admin --yes'",
        cwd     => "/var/www/drupal",
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        require => Package["drush"],
      }

}
