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
