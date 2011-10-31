class backup {

   user { "backuppc":
    groups => 'nogroup',
    comment => 'Backuppc User',
    ensure => 'present',
    managehome => 'true',
    home => '/var/lib/backuppc',
    shell => '/bin/bash',
   }
 
   sshkey { "buildhost.grml.org":
       key =>
           'AAAAB3NzaC1yc2EAAAADAQABAAABAQDTIyLNwuGI1Ojn/WQLmBueD5XC/DkmYRylqpthKyippJqqcxEfeZtKw+o/qnR7l17k+L4sEHL3nzQco9cG6G5tNpfFsMfOcAEyJQ/H3K6FqAiO3I9aJeRH/ow9I+Ze/q/hhbbrIm5QsY6gqQIFiMS8QNtHzilHizA3e2luDY+9ANyF9fnBmNbzZrABOSfMsVQ3hlJPSUXk5JidDDFD26sjBFTBUNG4eaTaMAbfMlAqOVn+wiCWPpj3Bvb9HB65H/rXBC2qQquRqp6GUJKuC6Md7gGFYkB2J6D6uuwNwWT2OAzrvYfyR8OKD+8Ws50NWPGaPkpjvMaKEhk/UgLPHIT5',
           name => 'buildhost.grml.org',
           type => 'ssh-rsa'
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

