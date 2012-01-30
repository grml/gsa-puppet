class serial {
  exec { "update-grub":
    command => "update-grub",
    path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
    refreshonly => true
  }
  exec { "init-change":
    command => "telinit q",
    path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
    refreshonly => true
  }
  augeas{"serial-grub":
    context => "/files/etc/default/grub",
    changes => [
		"set GRUB_CMDLINE_LINUX_DEFAULT '\"console=ttyS0,115200 console=tty0 quiet\"'"
		],
    notify  => Exec["update-grub"];
  }


  augeas{"serial-inittab":
    context => "/files/etc/inittab/",
    changes => [
		'set ser/runlevels "1223"',
		'set ser/action  "respawn"',
		'set ser/process  "/sbin/getty -L ttyS0 115200 vt100"'
		],
    onlyif => "match *[process =~ regexp('.*ttyS0.*')] size == 0",
		notify  => Exec["init-change"];
  }
}
