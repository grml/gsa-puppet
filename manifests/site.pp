Exec {
	path => "/usr/bin:/usr/sbin:/bin:/sbin"
}

node default {

    include grml
    include ldap
    include apt-keys
    include collectd::client
    include sudo
		include serial

}

node base {
    include apt-keys
    include sudo
    include grml
}

node web.grml.org,misc.grml.org,repos.grml.org,web.grml.org,deb.grml.org inherits base {
    include serial
    include collectd::client
    class resolver { "grml":
        domainname  => "grml.org",
        searchpath  => ['grml.org'],
        nameservers =>
            ['10.0.3.1',
             '81.3.3.81',
             '81.3.2.130'],
       }
}
