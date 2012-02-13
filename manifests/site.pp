Exec {
	path => "/usr/bin:/usr/sbin:/bin:/sbin"
}

node base {
    include apt-keys
    include sudo
    include grml
    include backup

}

node "father.grml.org", "amd64.grml.org", "klaus.grml.org" inherits base {
    #noop
}

node "monitoring.grml.org" inherits base {
    include ferm
    include ferm::www
}

node "buildhost.grml.org" inherits base {
    include ferm
    include ferm::www
    @ferm::rule { "jenkins":
        description     => "Allow jenkins access",
        rule            => "&SERVICE(tcp, 8080)"
    }
}

node "web.grml.org","mail.grml.org","misc.grml.org","repos.grml.org","deb.grml.org", "jenkins.grml.org", "backup.grml.org", "blog.grml.org", "foreman.grml.org" inherits base {
    include serial
    include collectd::client
    include resolver
    include ldap

    case $hostname {
        deb,web: {
            include ferm
            include ferm::rsync
            include ferm::smtp
            include ferm::www
            if $hostname == 'web' {
                include ferm::bittorrent
            }
        }
        jenkins,blog: {
            include ferm
            include ferm::www
        }
        forman: {
          include ferm
          include ferm::www
          @ferm::rule { "jenkins":
            description     => "Allow foreman access",
            rule            => "&SERVICE(tcp, 3000)"
          }
        }
        misc: {
            include ferm
            include ferm::jabber
            include ferm::smtp
            include ferm::dns
        }
        repos: {
            include ferm
            include ferm::git
            include ferm::www
        }
        mail: {
            include ferm
            include ferm::smtp
            include ferm::imaps
            include ferm::www
        }
    }


      case $hostname {
        blog,foreman,backup,jenkins: {
          resolv_conf { "grml":
            domainname  => "grml.org",
            searchpath  => ['grml.org'],
            nameservers => ['10.0.3.1', '89.207.128.252', '89.207.130.252'],
          }
        }
        default: {
          resolv_conf { "grml":
            domainname  => "grml.org",
            searchpath  => ['grml.org'],
            nameservers => ['10.0.3.1', '81.3.3.81', '81.3.2.130'],
          }
        }
      }

}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
# eval: (
