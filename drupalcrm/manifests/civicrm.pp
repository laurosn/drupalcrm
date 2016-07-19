class drupalcrm::civicrm {

#      exec{ "wget-civicrm":
#            command   => "/usr/bin/wget http://downloads.sourceforge.net/project/civicrm/civicrm-stable/4.7.9/civicrm-4.7.9-drupal.tar.gz -O /var/www/drupal/sites/all/modules/civicrm-4.7.9-drupal.tar.gz",
#            creates   => "/var/www/drupal/sites/all/modules/civicrm-4.7.9-drupal.tar.gz",
#      }
      file { "/var/www/drupal/sites/all/modules/civicrm-4.7.9-drupal.tar.gz":
	    ensure  => file,
	    owner   => "root",
	    group   => "root",
	    mode    => '0744',
	    source  => "puppet:///modules/${module_name}/civicrm-4.7.9-drupal.tar.gz",
      }
      ->
      exec{"extract-civicrm":
            command => "/bin/sh -c 'cd /var/www/drupal/sites/all/modules/ && tar xvfz /var/www/drupal/sites/all/modules/civicrm-4.7.9-drupal.tar.gz'",
            creates => "/var/www/drupal/sites/all/modules/civicrm"   
      }
      -> 
      exec{"chown-civicrm":
            command => "/bin/sh -c 'chown -R www-data: /var/www/drupal/'",
      }
      ->
      exec { "install-civicrm":
        command => "/bin/sh -c 'drush cache-clear drush && cd /var/www/drupal && drush civicrm-install --dbuser=civiuser --dbpass=civicrm --dbhost=localhost --dbname=civicrm > /var/www/drupal/sites/all/modules/civicrm/drush-civicrm-installed'",
#        command => "drush civicrm-install --dbuser=civiuser --dbpass=civicrm --dbhost=localhost --dbname=civicrm",
#        cwd     => "/var/www/drupal",
	creates => "/var/www/drupal/sites/all/modules/civicrm/drush-civicrm-installed",
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
      }
      ->
      exec{"chown-civicrm-2":
            command => "/bin/sh -c 'chown -R www-data: /var/www/drupal*'",
      }
}
