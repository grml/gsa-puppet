class ssh {
	define add_ssh_key( $key, $type ) {
		$username       = $title

	  ssh_authorized_key{ "${username}_${key}":
	    ensure  => present,
	    key     => $key,
	    type    => $type,
	    user    => $username,
	    require => File["/home/$username/.ssh/authorized_keys"]
	  }
	}

    package { 'openssh-server':
        ensure => latest
    }

    file { '/etc/ssh/sshd_config':
        owner => root,
              group => root,
              mode => '0644',
              notify => Service['ssh'],
              require => Package['openssh-server'],
    }

    service { 'ssh':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => [
            File['/etc/ssh/sshd_config'],
            Package['openssh-server']
        ],
    }

    augeas { "sshd_config":
        context => "/files/etc/ssh/sshd_config",
        notify  => Service['ssh'],
                changes => [
                    "set UseLPK yes",
                    "set LpkServers ldap://10.0.3.1/",
                    "set LpkUserDN ou=People,dc=grml,dc=org",
                    "set LpkGroupDN ou=Group,dc=grml,dc=org",
                    "set LpkSearchTimelimit 3",
                    "set LpkBindTimelimit 3",
                    "set LpkForceTLS no",
                    "set PermitRootLogin without-password"
                ],
    }
}
