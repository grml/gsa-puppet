require 'yaml'

Facter.add('location') do
    setcode do
        location = 'unknown'
        location_file = File.expand_path(File.dirname(__FILE__)) + '/locations.yaml'
        if FileTest.exist?(location_file)
            data = YAML.load_file(location_file);
            location = data[Puppet[:certname]]
        end
        location
    end
end
