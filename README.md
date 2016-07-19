# Compucorp DevOps / Sysadmin Tasks

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
  * ```/var/www/drupal``` - Drupal site files
  * ```/root/backup/scripts/``` - Backup/restore shell scripts
**4. Puppet module**

* The source is available on [Github](https://github.com/laurosn/drupalcrm/tree/master/drupalcrm)
* Inside the *manifests* folder are located the classes (.pp files) that manages the configuration:
  * ```backup.pp``` - Installs all the scripts to manage the backup tasks and configures the crontab for the jobs
  * ```civicrm.pp``` - Installs CiviCRM module (extract tarball and execute the installation through Drush )
  * ```database.pp``` - Manage and configure the databases (CiviCRM database and Drupal Database)
  * ```drupal.pp``` - Installs Drupal (extract tarball and execute the installation through Drush )
  * ```/etc/puppetlabs/code/environments/production/manifests/init.pp``` - Node configuration
  * ```nginx.pp``` - Manage and configure the nginx configuration/service
  * ```packages.pp``` - Manage all the necessary operating system packages
  * ```phpfpm.pp``` - Manage and configure the PHP/Fpm configuration/service
  * ```puppetmodules.pp``` - Installs all the external puppet modules (mysql, xtrabackup, s3cmd)
* Running the puppet agent
  * ```sudo su``` 
  * ```source /etc/profile.d/puppet_locale.sh``` - setting locale 
  * ```source /etc/profile.d/puppet_path.sh``` 
  * ```puppet apply --test --debug /etc/puppetlabs/code/environments/production/manifests/init.pp```
  * To test if puppet is managing the configuration you could do some tests: stop nginx/mysql services, drop databases, remove drupal folder, change nginx configuration. Then, run the agent again


**5. Backup**

* I've tried to use the *Backup and Migrate Drupal module*, but it was difficult to find good resources (docs , articles, etc). All examples that i've found were using the "wizard" screen, but we want to automate  the backup process without "manually" intervention. So, the option was to do this through "drush bam". I've tried, but as i said before, i haven't found good resources. So, i've decided to take a more generic approach, using two opensource solutions:  [Xtrabackup](https://www.percona.com/software/mysql-database/percona-xtrabackup)  to backup Mysql and   [Duplicity](http://duplicity.nongnu.org/) to backup the websites.

* **5.1 Backup/Restore Mysql**
  * The puppet class *drupalcrm::backup* (file backup.pp) installs the xtrabackup package and restore shell script
  * The puppet class *drupalcrm::backup* schedule a xtrabackup job(cron) to backup the database everyday 00:30
  * When the backup job finishes, backup files are sent to S3 (work-for-us-bucket)
  * To restore a backup, use the script ```/root/backup/scripts/recover_mysql.sh YYYY-MM-DD```
 
* **5.2 Backup/Restore Drupal**
  * The puppet class *drupalcrm::backup* (file backup.pp) installs two shell scripts (backup_www.sh and restore_www.sh)
  * The puppet class *drupalcrm::backup* schedules the backup_www.sh script (cron) to backup the /var/www everyday 00:39
  * When the backup job finishes, backup files are sent to S3 (work-for-us-bucket/drupal)
  * To restore a backup, use the script ```restore_www.sh -d [DATE] -f [FILES_TO_RECOVER] -t [RESTORE_TO]```
  * Example ```/root/backup/scripts/restore_www.sh -d 2016-07-19 -f var/www -t /var/www```

**6. PCI compliance scan**

![PCI compliance scan](https://github.com/laurosn/drupalcrm/blob/master/Selection_060.png)


**7. TODO**

  * Unfortunately i didn't have enough time to do the Pentaho task
  * All passwords/data are stored in clear text inside puppet/shell script files. In a production environment, we should use hiera + eyaml.
  * Use r10k to manage puppet modules
