class users {
  define add_user ( $name, $uid, $shell ) {
    $username = $title
    user { $username:
      comment => "$name",
      home    => "/home/$username",
      shell   => $shell,
      uid     => $uid
    }

    group { $username:
      gid     => $uid,
      require => User[$username]
    }

    file { "/home/$username/":
      ensure  => directory,
      owner   => $username,
      group   => $username,
      mode    => 751,
      require => [ User[$username], Group[$username] ]
    }

    file { "/home/$username/.ssh":
      ensure  => directory,
      owner   => $username,
      group   => $username,
      mode    => 700,
      require => File["/home/$username/"]
    }

    file { "/home/$username/.ssh/authorized_keys":
      ensure  => present,
      owner   => $username,
      group   => $username,
      mode    => 600,
      require => File["/home/$username/"]
    }

    file { "/home/$username/.zshrc":
      ensure  => present,
      owner   => $username,
      group   => $username,
      require => File["/home/$username/"]
    }
  }
}
