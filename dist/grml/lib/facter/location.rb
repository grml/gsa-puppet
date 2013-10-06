require 'yaml'

Facter.add('location') do
    setcode do
        location = 'unknown'
        if FileTest.exist?("/etc/puppet/locations.yaml")
            data = YAML.load_file('/etc/puppet/locations.yaml');
            location = data[Puppet[:certname]]
        end
        location
    end
end
