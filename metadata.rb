name 'hg_mergerfs'
maintainer 'Heig Gregorian'
maintainer_email 'theheig@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures hg_mergerfs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.5.0'
depends 'yum-epel'
depends 'managed_directory', '~> 0.3.1'

gem 'mixlib-versioning'

supports 'centos'
supports 'redhat'
source_url 'https://github.com/hgregorian/hg_mergerfs' if defined?(:source_url)
issues_url 'https://github.com/hgregorian/hg_mergerfs/issues' if defined?(:issues_url)
