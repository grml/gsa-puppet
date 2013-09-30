class sudo {
  package{"sudo": ensure => installed }
  package{"augeas-lenses": ensure => installed }
  package{"libaugeas-ruby": ensure => installed }
  augeas{"sudoers-wheel":
    context => "/files/etc/sudoers",
    changes => [
	        "set spec[user = '%wheel']/user %wheel",
	        "set spec[user = '%wheel']/host_group/host ALL",
	        "set spec[user = '%wheel']/host_group/command[1] 'ALL'",
	        "set spec[user = '%wheel']/host_group/command[1]/tag 'PASSWD'",
	        "set spec[user = '%wheel']/host_group/command[2] '/usr/bin/apt-get'",
	        "set spec[user = '%wheel']/host_group/command[2]/tag NOPASSWD",
	        "set spec[user = '%wheel']/host_group/command[3] '/usr/bin/aptitude'",
                "set spec[user = 'backuppc']/user backuppc",
                "set spec[user = 'backuppc']/host_group/host ALL",
                "set spec[user = 'backuppc']/host_group/command[1] 'ALL'",
                "set spec[user = 'backuppc']/host_group/command[1]/tag NOPASSWD",
                "set spec[user = 'backuppc']/host_group/command[1] '/usr/bin/rsync'",
	        "set /Defaults/env_keep/var[01] MAINTAINER"
	        ],
    require => [ Package["sudo"], Package["augeas-lenses"], Package["libaugeas-ruby" ]]
  }
}
