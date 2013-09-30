class apt-keys {
  file {
    "/etc/apt/trusted-keys.d/":
      ensure  => directory,
      purge   => true,
      notify  => Exec["apt-keys-update"],
      ;
    "/etc/apt/trusted-keys.d/deb.grml.org.asc":
      source  => "puppet:///modules/apt-keys/deb.grml.org.asc",
      mode    => 664,
      owner   => "root",
      group   => "root",
      notify  => Exec["apt-keys-update"],
      ;
    }

    exec { "apt-keys-update":
      command => '/bin/true && for keyfile in /etc/apt/trusted-keys.d/*; do apt-key add $keyfile; done ; apt-get update',
      refreshonly => true
    }
}

