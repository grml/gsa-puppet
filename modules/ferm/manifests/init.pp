class ferm {
    define rule($table="filter", $chain="INPUT", $rule, $description="", $prio="00", $notarule=false) {
        file {
            "/etc/ferm/rules.d/${prio}_${name}":
                ensure  => present,
                owner   => root,
                group   => root,
                mode    => 0400,
                content => template("ferm/ferm-rule.erb"),
                notify  => Exec["ferm restart"],
        }
    }

    # realize (i.e. enable) all @ferm::rule virtual resources
    Ferm::Rule <| |>

    package {
            ferm: ensure => installed;
    }

    file {
        "/etc/ferm/rules.d":
            ensure => directory,
            purge   => true,
            owner   => root,
            group   => root,
            force   => true,
            recurse => true,
            notify  => Exec["ferm restart"],
            require => Package["ferm"];
        "/etc/ferm":
            ensure  => directory,
            owner   => root,
            group   => root,
            mode    => 0755;
        "/etc/ferm/conf.d":
            ensure  => directory,
            owner   => root,
            group   => root,
            require => Package["ferm"];
        "/etc/default/ferm":
            source  => "puppet:///modules/ferm/ferm.default",
            owner   => root,
            group   => root,
            require => Package["ferm"],
            notify  => Exec["ferm restart"];
        "/etc/ferm/ferm.conf":
            source  => "puppet:///modules/ferm/ferm.conf",
            owner   => root,
            group   => root,
            require => Package["ferm"],
            mode    => 0400,
            notify  => Exec["ferm restart"];
        "/etc/ferm/conf.d/defs.conf":
            content => template("ferm/defs.conf.erb"),
            owner   => root,
            group   => root,
            require => Package["ferm"],
            mode    => 0400,
            notify  => Exec["ferm restart"];
    }

    exec {
        "ferm restart":
            command     => "/etc/init.d/ferm restart",
            refreshonly => true,
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
