class backup {

   user { "backuppc":
    groups => 'nogroup',
    comment => 'Backuppc User',
    ensure => 'present',
    managehome => 'true',
    home => '/var/lib/backuppc',
    shell => '/bin/bash',
   }

   define ssh::key::backuppc(){
     ssh_authorized_key { "backuppc@buildhost":
       ensure => present,
       type   => "rsa",
       key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCpMRclAJB/FDNfHfEfEOFCNYWdVOhC/mnphOSnI+G64H+M6KFC9c80+Ob5JZ2CyXKAT2RpVag1/QTfQ9bAcy86YMbqPztqY4ViqYGBSae897nOgmNLJFCpEkqlRCKuuhAjVvIlGZLuXo88zE/wtHNeTumM9Fy70D3t4dh4O2+C/r07BXdxMeUtg5ExJBbqtCY2+Uo9uNSg1FMwqxIjEQQbym3dUQiDfCFs+IqwKL7s7BGZjJ/rU3bb6heI1tzop4Q9LNNKkdbvNxcxBOjbgQBri/zjTkUnlNqbGKnvBKNvS18E+TcQlNfb76JRpDV5wKblGiEwu+V3H3/b68jB+QP9",
       user   => "$name",
     }
   }
   ssh::key::backuppc{['backuppc']:}
}

