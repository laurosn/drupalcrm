# drupalcrm

**1. Accessing the aws instance through SSH**

* Download the [.pem file](https://github.com/laurosn/drupalcrm/blob/master/drupalcrm/files/keys/workforus%20(1).pem)
* ```ssh -i workforus\ \(1\).pem ubuntu@ec2-52-67-92-118.sa-east-1.compute.amazonaws.com ```


**2. Accessing the website**

* On web browser, access this [link](https://ec2-52-67-92-118.sa-east-1.compute.amazonaws.com)
* User: *admin* Password: *admin*


**3. Accessing the configuration**

* Access the amazon instance through ssh ```ssh -i workforus\ \(1\).pem ubuntu@ec2-52-67-92-118.sa-east-1.compute.amazonaws.com ```
* Configuration directories
  * ```/etc/nginx``` - Nginx configuration (generated from puppet module) 
  * ```/etc/puppetlabs/code/environments/production/modules/drupalcrm``` - Puppet module created that manages all the required configuration

**4. Puppet module**

* The source is avaiable on his [Github](https://github.com/laurosn/drupalcrm/tree/master/drupalcrm)
* Inside the *manifests* folder are located the classes (.pp files) that manages the configuration:
  * ```backup.pp``` - Installs all the scripts to manage the backup tasks and configures the crontab for the jobs
  * ```civicrm.pp``` - Install CiviCRM module (extract tarball and execute the installation through Drush )
  * ```database.pp``` - Manage and configure the databases (CiviCRM database and Drupal Database)
  * ```drupal.pp``` - Install Drupal (extract tarball and execute the installation through Drush )
  * ```init.pp``` - Node configuration
  * ```nginx.pp``` - Manage and configure the nginx configuration/service
  * ```packages.pp``` - Manage all the necessary operating system packages
  * ```phpfpm.pp``` - Manage and configure the PHP/Fpm configuration/service
  * ```puppetmodules.pp``` - Installs all the external puppet modules (mysql, xtrabackup, s3cmd)
