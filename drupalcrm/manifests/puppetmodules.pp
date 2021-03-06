class drupalcrm::puppetmodules {
      exec{"install-xtrabackup-module":
            command => "/opt/puppetlabs/bin/puppet module install --modulepath /etc/puppetlabs/code/environments/production/modules johnlawerance-xtrabackup",
	    creates => "/etc/puppetlabs/code/environments/production/modules/xtrabackup",	
      }
      exec{"install-mysql-module":
            command => "/opt/puppetlabs/bin/puppet module install --modulepath /etc/puppetlabs/code/environments/production/modules puppetlabs-mysql",
	    creates => "/etc/puppetlabs/code/environments/production/modules/mysql",	
      }
      exec{"install-s3cmd-module":
            command => "/opt/puppetlabs/bin/puppet module install --modulepath /etc/puppetlabs/code/environments/production/modules ilanco-s3cmd",
            creates => "/etc/puppetlabs/code/environments/production/modules/s3cmd",
      }


}
