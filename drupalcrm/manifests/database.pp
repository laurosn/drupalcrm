class drupalcrm::database {

      class { '::mysql::server':
	  root_password           => 'root',
	  remove_default_accounts => true,
      }

	mysql::db { 'drupaldb':
	  user     => 'drupaluser',
	  password => 'drupal',
	  host     => 'localhost',
	  grant    => ['ALL'],
	}
        mysql::db { 'civicrm':
          user     => 'civiuser',
          password => 'civicrm',
          host     => 'localhost',
          grant    => ['ALL'],
        }


}
