Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin'
}

hiera_include('classes')

node default {
        mcollective::plugin { 'puppet':
                package => true,
        }
        mcollective::plugin { 'package':
                package => true,
        }
}

node 'father.grml.org' inherits default {
    git::repo{'repo_name':
        path   => '/etc/puppet/hieradata',
        source => 'https://github.com/grml/grml-hiera.git',
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
# eval: (
