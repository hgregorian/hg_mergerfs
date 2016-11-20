name 'hg_mergerfs'
maintainer 'Heig Gregorian'
maintainer_email 'theheig@gmail.com'
license 'all_rights'
description 'Installs/Configures hg_mergerfs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
depends 'yum-epel'
depends 'managed_directory', '~> 0.2.1'

supports 'centos'
supports 'redhat'
