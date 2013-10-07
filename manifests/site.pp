Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin'
}

hiera_include('classes')

node default {
}

node base inherits default {
        mcollective::plugin { 'puppet':
                package => true,
        }
}

node 'amd64.grml.org', 'klaus.grml.org' inherits base {
    #noop
}

node 'father.grml.org' inherits base {
    git::repo{'repo_name':
        path   => '/etc/puppet/hieradata',
        source => 'https://github.com/grml/grml-hiera.git',
    }


}

node 'buildhost.grml.org' inherits base {
    include ferm
    include ferm::www
    @ferm::rule { 'jenkins':
        description     => 'Allow jenkins access',
        rule            => '&SERVICE(tcp, 8080)'
    }
}

node 'web.grml.org','mail.grml.org','misc.grml.org','repos.grml.org','deb.grml.org', 'jenkins.grml.org', 'backup.grml.org', 'blog.grml.org', 'foreman.grml.org', 'redmine.grml.org' inherits base {
    include serial
    include collectd::client
    include resolver
    include ldap
    include ssh

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
        foreman: {
          include ferm
          include ferm::www
          @ferm::rule { 'foreman':
            description     => 'Allow foreman access',
            rule            => '&SERVICE(tcp, 3000)'
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
        redmine: {
            include ferm
            include ferm::www
        }
        default: {

        }
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
# eval: (
