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
    resolv_conf { "grml":
        domainname  => "grml.org",
        searchpath  => ['grml.org'],
        nameservers =>
            ['10.0.3.1',
             '81.3.3.81',
             '81.3.2.130'],
       }
}
