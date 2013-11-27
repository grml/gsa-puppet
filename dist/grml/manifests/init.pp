define set_alternatives($linkto) {
  exec { "/usr/sbin/update-alternatives --set $name $linkto":
    unless => "/bin/sh -c '! [ -e $linkto ] || ! [ -e /etc/alternatives/$name ] || ([ -L /etc/alternatives/$name ] && [ /etc/alternatives/$name -ef $linkto ])'"
  }
}

class grml {
  tag("initial")

  apt::source { 'puppetlabs':
      location   => 'http://apt.puppetlabs.com',
      repos      => 'main dependencies',
      key        => '4BD6EC30',
      key_server => 'pgp.mit.edu',
  }


  file    {
    "/etc/cron.d/puppet":
      owner => root,
      group => root,
      source => "puppet:///modules/grml/etc/cron.d/puppet";

    "/etc/apt/apt.conf.d/local-recommends":
      owner => root,
      group => root,
      source => "puppet:///modules/grml/etc/apt/apt.conf.d/local-recommends";

    "/etc/apt/apt.conf.d/periodic-updates":
      owner => root,
      group => root,
      source => "puppet:///modules/grml/etc/apt/apt.conf.d/periodic-updates";

    "/usr/local/bin/check_apt-updates":
      owner => root,
      group => root,
      source => "puppet:///modules/grml/usr/local/bin/check_apt-updates";

    "/usr/lib/check_mk_agent/local/apt":
      owner => root,
      group => root,
      source => "puppet:///modules/grml/usr/lib/check_mk_agent/local/apt";

    "/usr/lib/check_mk_agent/local/debian_version":
      owner => root,
      group => root,
      source =>
      "puppet:///modules/grml/usr/lib/check_mk_agent/local/debian_version";

    "/usr/lib/check_mk_agent/local/puppet":
      owner => root,
      group => root,
      require => Package["check-mk-agent"],
      source => "puppet:///modules/grml/usr/lib/check_mk_agent/local/puppet";

    "/etc/apt/sources.list.d/backports.org.list":
      owner => root,
      group => root,
      require => Package["lsb-release"],
      content => template("grml/etc/apt/sources.list.d/backports.org.list.erb"),
      notify  => Exec["apt-get update"];

    "/etc/xinetd.d/check_mk":
      group => root,
      owner => root,
      require => Package["xinetd"],
      source => "puppet:///modules/grml/etc/xinetd.d/check_mk";

    "/etc/apt/sources.list.d/grml.list":
      owner => root,
      group => root,
      content => template("grml/etc/apt/sources.list.d/grml.list.erb"),
      notify  => Exec["apt-get update"];

    "/etc/apt-dater-host.conf":
      owner => root,
      group => root,
      source => "puppet:///modules/grml/etc/apt-dater-host.conf";

    "/etc/apt/sources.list.d/grml-infrastructure.list":
      owner => root,
      group => root,
      content =>
      template("grml/etc/apt/sources.list.d/grml-infrastructure.list.erb"),
      notify  => Exec["apt-get update"];

    "/etc/ssl/certs/grml-ca.pem":
      owner => root,
      group => root,
      source => "puppet:///modules/grml/etc/ssl/certs/grml-ca.pem";

    "/etc/apt/apt.conf.d/99checkmk":
      owner => root,
      group => root,
      source => "puppet:///modules/grml/etc/apt/apt.conf.d/99checkmk";

  }

  set_alternatives { "editor":
    linkto => "/usr/bin/vim.basic",
  }

  exec { "apt-get update":
    command => 'apt-get update',
    path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
    refreshonly => true
  }

  define ssh::key::formorer() {
    ssh_authorized_key{"formorer for ${name}":
      user => $name,
      key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEApLjZA49ao1n58z2EGkhOsYzOBl1yNRcG7YyYSni2pp+OWJ7UbkO+kiMJb2pz8JcU2zBHA2RxgRqrP6QS0w1Bf2qaO7W6brwOmKIirrAufDTPtdg+Q3G+xvtsx0+W62ozLCRh1HNEgjty1sA+GyA13jgHlDqDnnh9B8e7Y9HdkJUNGkQpyw+iwjxi2MY5Mvuvi6T2L+o5i2Wi6Su0QzdUUmpRhr1TLicXPftEggHVQamkzbr6zoimRGLcRp3ZJ8KzuMBie3ZKGNzIVMNcZaQYYHlS2+KRUucIL8nK1kQ2xbv2tDaMIGK62TIunJSYjUkH8nMllCgbm90jFM9OV5S3lQ==',
      ensure => present,
      type   => "rsa",
    }
  }

  define ssh::key::mika(){
    ssh_authorized_key { "mika for user ${name}":
      ensure => present,
      type   => "rsa",
      key    => "AAAAB3NzaC1yc2EAAAABIwAAAIEA6vOzf8GdTer0WhvWyysyPBhCPKxOo9xKqNpVEZQHizuKbBTdK+DsmFUL0939okik1h8FOx1isIgxzl/JH3x/21Z/yVFB9c8MVlJX/BelVLJ6S4j4AYz2PMKO2uJm4F7U8m8OiwlKbvz3CUSTB5SHEfTAtK5wME3fDtc1MpAWN58=",
      user   => "$name",
    }
  }

  define ssh::key::evgeni(){
    ssh_authorized_key { "zhenech for user ${name}":
      ensure => present,
      type   => "rsa",
      key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDJOXoC+NAPExAT6ZgC5W8vH3A1UMoxOW6bhmDRr7Dv3fLIeHSi8DEqwTMW1dUtcfqO5/9AYZsSsWKSilj6jvea9jFCkGh670Qv/lasOEszJWpWq8jpQsBYEMiS2DyAJZQlZ5zep5dxW9DaMbLKdcu7mLWbf3TDp3pdeQxqSVbN224vijUPqFfE9T4C842kgezAqE2yki6zVv/QK3Mgu2o5tvIwlnUQ1tWUGyy94+7rdxQ35MGSigRvvDfr4QVJLqAZ8bSm02axWTuiinYF3OXPb3ellwDrRys97T4n2R6vJGknM9WOtkS1k2cNbM6G4HfFwcTHwjEX2yA7wZ4qVl7P",
      user   => "$name",
    }
  }

  ssh::key::formorer{['root']:}
  ssh::key::mika{['root']:}
  ssh::key::evgeni{['root']:}

  # minimal locales
  file { "/etc/locale.gen":
    ensure => present,
    source => "puppet:///modules/grml/etc/locale.gen",
    mode => "0644",
    owner => "root",
    group => "root",
    notify => Exec["locale-gen"],
  }

  file { "/etc/default/locale":
    ensure => present,
    content => "LANG=en_US.UTF-8\n",
    mode => "0644",
    owner => "root",
    group => "root",
    require => Package["locales"],
    notify => Exec["locale-gen"],
  }

  exec { "locale-gen":
    refreshonly => true,
  }

  @@sshkey { $hostname: type => ssh-rsa, host_aliases => $fqdn, key => $sshrsakey }
  Sshkey <<| |>>

  file { "/etc/ssh/ssh_known_hosts":
    mode    => 644,
  }
}



