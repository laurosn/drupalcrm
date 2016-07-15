node default{

include drupalcrm::packages
include drupalcrm::phpfpm
include drupalcrm::nginx
include drupalcrm::database
include drupalcrm::drupal
include drupalcrm::civicrm

Class['drupalcrm::database'] -> Class['drupalcrm::drupal']
Class['drupalcrm::drupal'] -> Class['drupalcrm::civicrm']


}
