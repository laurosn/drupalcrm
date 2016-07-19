node default{

include drupalcrm::packages
include drupalcrm::phpfpm
include drupalcrm::nginx
include drupalcrm::database
include drupalcrm::drupal
include drupalcrm::civicrm
include drupalcrm::puppetmodules
include drupalcrm::backup

Class['drupalcrm::packages'] -> Class['drupalcrm::nginx']
Class['drupalcrm::nginx'] -> Class['drupalcrm::phpfpm']
Class['drupalcrm::phpfpm'] -> Class['drupalcrm::puppetmodules']
Class['drupalcrm::puppetmodules'] -> Class['drupalcrm::database']
Class['drupalcrm::database'] -> Class['drupalcrm::drupal']
Class['drupalcrm::drupal'] -> Class['drupalcrm::civicrm']
Class['drupalcrm::civicrm'] -> Class['drupalcrm::backup']


}
