require 'YAML'

Facter.add('location') do
    location = 'unknown'
    if FileTest.exist?("/etc/puppet/locations.yaml")
        data = YAML.load('/etc/puppet/locations.yaml');
        location = data[Puppet[:certname]]
    end
    location
end
