class backup {

   user { "backuppc":
    groups => 'nogroup',
    comment => 'Backuppc User',
    ensure => 'present',
    managed_home => 'true',
    home => '/var/lib/backuppc',
    shell => '/bin/bash',
    system => 'true',
   }
 
}

