class collectd {
  define plugin ($options="") {
    file {
      "/etc/collectd/collectd.d/${name}.conf":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0644,
        content => template("collectd/plugin.conf.erb"),
        notify  => Exec["collectd restart"],
    }
  }
  package {
    collectd: ensure => installed;
  }

  file {
    "/etc/collectd/collectd.conf":
      content => template("collectd/etc/collectd/collectd.conf.erb"),
      notify  => Exec["collectd restart"];

    "/etc/collectd/collectd.d/":
      ensure  => directory,
      purge   => true,
      notify  => Exec["collectd restart"];

  }

  exec { "collectd restart":
    path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
    refreshonly => true
  }


  #load standardplugins
  plugin { 'contextswitch': }
  plugin { 'cpu': }
  plugin { 'df': }
  plugin { 'disk': }
  plugin { 'entropy': }
  plugin { 'interface': }
  plugin { 'irq': }
  plugin { 'load': }
  plugin { 'memory': }
  plugin { 'processes': }
  plugin { 'swap': }
  plugin { 'users': }
  plugin { 'network':
    options => 'Server "10.0.3.1"'
  }


}
