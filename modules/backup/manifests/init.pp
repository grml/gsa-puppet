class backup {

   user { "backuppc":
    groups => 'nogroup',
    comment => 'Backuppc User',
    ensure => 'present',
    managehome => 'true',
    home => '/var/lib/backuppc',
    shell => '/bin/bash',
   }
 
}

