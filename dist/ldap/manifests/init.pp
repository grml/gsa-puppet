class ldap {
  package {
    libpam-ldap: ensure => purged;
    unscd: ensure => installed;
    libnss-ldap: ensure => purged;
    libnss-ldapd: ensure => installed;
    libpam-ldapd: ensure => installed;
  }
  file {
    "/etc/nslcd.conf":
      owner   => "root",
      group   => "root",
      source => "puppet:///modules/ldap/etc/nslcd.conf";
    "/etc/nsswitch.conf":
      owner   => "root",
      group   => "root",
      source => "puppet:///modules/ldap/etc/nsswitch.conf";
  }


  service { nslcd:
    ensure => running,
    subscribe => File["/etc/nslcd.conf"],
  }
  cfengine::append_if_no_such_line{pam_mkhomedir:
    file => "/etc/pam.d/common-session",
    line => "session    required    pam_mkhomedir.so skel=/etc/skel/ umask=0022"
  }
}
