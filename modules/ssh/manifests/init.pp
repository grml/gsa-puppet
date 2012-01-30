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
}
