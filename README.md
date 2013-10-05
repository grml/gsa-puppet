gsa-puppet
==========

The Puppet configuration driving the Grml.org infrastructure,
maintained by the Grml.org System Administration team.

The post-receive hook will check the syntax of the manifest and calls r10k
deploy\_all and puppet runonce afterwards
