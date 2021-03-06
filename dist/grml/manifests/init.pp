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
  define ssh::key::mru(){
    ssh_authorized_key{"mru for ${name}":
      user => $name,
      key => 'AAAAB3NzaC1kc3MAAACBAMoegEuX/qjlMjejBqMJN8CrKUoxsHAK9OzoIlbWzdwgcv47ZxrOxXk5eKtvTV+EzmQ+4ClU7AvWHe/lfiAGAvzjO4jMVi+JrJpG7NnoZGo/TZ8N8zbmqVUyg7eROEv2PoYwv4C/dBDYqiAJjo27JBKlAM8Xjoxn+XgfNkmN9EmNAAAAFQCe5TxLAXV3aONTAp3PlXRxnJwoZwAAAIEApntL9JS9iQdxjhnszy++u4YY0D+Vw2GUR8+Loc+UDktkYpieFIfwIflu+Jh1FrIZ7C0Uxb/jEKEukbnEe+w5Qenfh/p4pfvYDwGhh5XAyOaKYWa1xzXsO1gxIvpQUb8XV4cjCJwblX4smjmZN9p9DSGJKSp4hP4LlIaotVnkNo8AAACAGcenZKCPvE+hLTd4wd6AiSxTnF3pe9lc7eDaagLmTlll+7AQG6EdJHYDoYu6pp+IZs8Q2sJ7Pra0Q1v2AG8OCJD7cZ9ghOgnDfcixItvn5kupE0T5sTHiBTFGFEw2WmAg4c0iOx+w0ZXJ9XiNxfKMj0HZ33J6CtQzpRCc9w2JRk=',
      type   => "dsa",
      ensure => absent,
    }
  }
  define ssh::key::ch() {
    ssh_authorized_key{"ch for ${name}":
      user => $name,
      key => 'AAAAB3NzaC1yc2EAAAABIwAAAgEAofxbWxWtZU35kJUPYZrMi1+Zw49VmVn7sD0iqvN3xB1T6YnnBsXBYA+N/SdsA2Jsq+1cKGX87uWRn8EzDZ0IERD9lDOslb2rQ09h44bDDD0bplPuE+yOXDFWRgFOYN13I7c0O0NZ4ue1TE8I2TyWpUksbas4JgDGT/1/EsSRZJsoEXpXtvYCRwngGWVenjBxFFSo1DwwYv8yc97+cXZoOUd8F78Rb9H70GI4tshrlntXQI8vyoiIAc7lPVJYBTuENJpa/bvYysFxjpjQrpK1w7PtgM/f1F2QG9KDPsGqqfGXsMcmIrHVkl4dF/ffpYpKn4+fu0hY0O4O2y9gSU7Xi57IIGx1oX0C7eyHIctWo0z8+13n7yigU3VnigDZlK3sKZdNAekFBjuXFxbXoqf/zdESlsGVo7aL36+Hw7XSH7oexD1E+2xpNKhiF/ZY5WzzWvenNHHKHkppTKDlk00fh5ssM/F3TpclwHy6NkrkY9SV6JvT9fNp2noSGS1LH4Ee9sc88IFYp8lReSeto+LxnJxdVUhFnbfgkeqT4FSwVKp/tvv90hIX1G+4nYlcN+SijbBo4wxnBIsoGBfcwKDwdlY9J+UogNWoZmcIKaO9rFF74J2TYNnnxMPkQ7hl1hUQUanY3NPokRGA0Z0Q2Kn28lYkE6KHLUdFC9ur0t/BpWs=',
      type   => "rsa",
      ensure => absent,
    }
  }
  define ssh::key::formorer() {
    ssh_authorized_key{"formorer for ${name}":
      user => $name,
      key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEApLjZA49ao1n58z2EGkhOsYzOBl1yNRcG7YyYSni2pp+OWJ7UbkO+kiMJb2pz8JcU2zBHA2RxgRqrP6QS0w1Bf2qaO7W6brwOmKIirrAufDTPtdg+Q3G+xvtsx0+W62ozLCRh1HNEgjty1sA+GyA13jgHlDqDnnh9B8e7Y9HdkJUNGkQpyw+iwjxi2MY5Mvuvi6T2L+o5i2Wi6Su0QzdUUmpRhr1TLicXPftEggHVQamkzbr6zoimRGLcRp3ZJ8KzuMBie3ZKGNzIVMNcZaQYYHlS2+KRUucIL8nK1kQ2xbv2tDaMIGK62TIunJSYjUkH8nMllCgbm90jFM9OV5S3lQ==',
      type   => "rsa",
      ensure => present,
    }

  }
  define ssh::key::mika(){
    ssh_authorized_key { "mika for user ${name}":
      type   => "rsa",
      key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCo/bTHFOglnCy/ni9YGR9amZ4wpM76L8VV8kvsCeHRP+Ca/YOGNAXv8ZUibMKwrzaI5yR2GeZcdNJlCGP+l2q2i8O1LU2jeH3J8RFE+tBSM5gmKPXLwqlkY/uiIxF9wljgOjBq1ROzqrZXz+Pxlk4Pa2e/5GIjqvJou3+qseTzjAvi3C6Ac+5wui7Wf8mLL4Nqx8yUkXlFTUEXMOqPxS8uRC/sfarwesTa0t1ZdGCgvlauMG9ngma2FFtzxeE3yO0RR1A5DocMMwKv3ws6DkNE96dmzRR79QwJMEebDG9wSluuH52ouaj/YxZvT8yM4ToIIua1TxVdxLJ1ChHIeDGh',
      user   => "$name",
      ensure => present,
    }
  }
  define ssh::key::jimmy(){
    ssh_authorized_key { "jimmy for user ${name}":
      type   => "rsa",
      key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDYHTT6JOhkjSueoBj90eTAHzendWBlZ8Jl+40ckWf7OVQnZ7+enxKlDAVSeHDu13S4Ni9zUxztgdkG068H2ETIaJAFrr5ddef9JKLGkDJsJOyuKH6eW0/aEGCisb1OL/PvGO4YBp9VVCW0IO69F3wKK2vcogimU3CynE5HMfjDRAv0c15FFjzRtGN4Je16acNTZ3Ta8M/k4RaKKXn6c4YjPdPgTnJ7d3M3gMPY4DX7RoOFtMrAH3MZnAmeSqmpRgeJ0jaPk0ayjxKUmzSsFu5Q4Z6kquI//e5Pw7XcNHYZb4RB/uUy3Q4txV6hVjv0UZ++CK50LjYxozRz+NaVz+mv",
      user   => "$name",
      ensure => absent,
    }
  }
  define ssh::key::evgeni(){
    ssh_authorized_key { "zhenech for user ${name}":
      type   => "rsa",
      key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDJOXoC+NAPExAT6ZgC5W8vH3A1UMoxOW6bhmDRr7Dv3fLIeHSi8DEqwTMW1dUtcfqO5/9AYZsSsWKSilj6jvea9jFCkGh670Qv/lasOEszJWpWq8jpQsBYEMiS2DyAJZQlZ5zep5dxW9DaMbLKdcu7mLWbf3TDp3pdeQxqSVbN224vijUPqFfE9T4C842kgezAqE2yki6zVv/QK3Mgu2o5tvIwlnUQ1tWUGyy94+7rdxQ35MGSigRvvDfr4QVJLqAZ8bSm02axWTuiinYF3OXPb3ellwDrRys97T4n2R6vJGknM9WOtkS1k2cNbM6G4HfFwcTHwjEX2yA7wZ4qVl7P",
      user   => "$name",
      ensure => present,
    }
  }
  define ssh::key::bionix(){
    ssh_authorized_key { "bionix for user ${name}":
      type   => "rsa",
      key    => "AAAAB3NzaC1yc2EAAAADAQABAAACAQDnnnJ6fIB7+ARtrJcPoTIxTNO5BNPLo2n9nCepMLy1PxbomyGMe+iWGk3ShxyDS8RXuWPWWCIuT+c7rWqJZ88J+wToRsUH2chuLAq2UnDkaZ6KgbHdPHitEHKzqwuzJZGtM/4KfurwmoXi424U19kmhciAu+v/gG1d/E7G62qb7HiEoevy5no8NM7ofEyBeoBD4xOZz5V9xE0SgElkXgSZxY3HC37g9eNKUDvw5dlVOg2kzoJBAa8Yb2V8ZI06l7I5FNuV6my/ots7fHwYjttnwHXLdTMHGvh0Jna6jmfvrsyb6bez+73qCNAIcKc6kH5ds9MpVoWUWDGmBzn0uXwisBqTpk+eQf2MluSDH5Eo5T4WAANx4fYraSNM6zWFWNcSavjLl4uAWxD+9upXMX3PkjlnLi3bIh18ZveWr2Fcny15hOB43/7Ma6Wv18CN2glTSfZ+HZA9Axnck3d2NhW5W3csLIMs+VOMzGK2hFeEIWuQWFbGaXB+gTReEorKokS/mzgIQ9n2/cyC8AyNSdV9WQJIbUF3hGEbinmHcBc8kXPEFjDVQvtjXTzQhQaC7jykJhJLcGB5NPINxQqh+UyT4b1WfZ/LyEzTC6b1eqicBrkz0k5laS5QTrymyJDXVlt+iwHLXqCuXpaAItKYHx/G/jwAuWnjqXhdfliJ+dlqhQ==",
      user   => "$name",
      ensure => absent,
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



