Exec {
	path => "/usr/bin:/usr/sbin:/bin:/sbin"
}

node base {
    include apt-keys
    include sudo
    include grml
    include backup

}

node "father.grml.org", "amd64.grml.org" inherits base {
    #noop
}

node "monitoring.grml.org" inherits base {
    #noop
}

node "buildhost.grml.org" inherits base {
    #noop
}

node "wien.grml.org" inherits base {
    #noop
}


node "web.grml.org","mail.grml.org","misc.grml.org","repos.grml.org","deb.grml.org", "jenkins.grml.org" inherits base {
    include serial
    include collectd::client
    include resolver
    include ldap
    
    case $hostname {
    	deb,www: { tag (webserver)
               tag (rsync)
               tag (smtp)
               }
    }

    if $hostname == 'www' {
        @ferm::rule { "bttrack":
            prio            => "00",
            description     => "bttrack",
            rule            => "&SERVICE(tcp, 6969)"
        }

        @ferm::rule { "bittorrent":
            prio            => "00",
            description     => "bittorrent",
            rule            => "&SERVICE( (tcp, udp), 51413)"
        }
    }
	

    if tagged(webserver) {
        include ferm 

	    @ferm::rule { "http":
            prio            => "00",
            description     => "Allow web access",
            rule            => "&SERVICE(tcp, (http https))"
	    } 
    }

    if tagged(rsync) {
        include ferm 

	    @ferm::rule { "rsync":
            prio            => "00",
            description     => "Allow rsync access",
            rule            => "&SERVICE((tcp udp), (rsync))"
	    } 
    }

    if tagged(smtp) {
        include ferm 

	    @ferm::rule { "smtp":
            prio            => "00",
            description     => "Allow smtp access",
            rule            => "&SERVICE(tcp, smtp)"
	    } 
    }


    resolv_conf { "grml":
        domainname  => "grml.org",
        searchpath  => ['grml.org'],
        nameservers =>
            ['10.0.3.1',
             '81.3.3.81',
             '81.3.2.130'],
       }
}

# vim:set et: 
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
