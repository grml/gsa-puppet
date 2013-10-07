# Install our standard packages
class grml::packages(
        $packagelist   = hiera_array('grml::packages::packagelist', [])
        ) {
        package { $packagelist: ensure => "installed" }
}

