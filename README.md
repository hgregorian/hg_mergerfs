# hg_mergerfs cookbook

Cookbook for deploying [mergerfs] and associated [mergerfs-tools].

## Supported Platforms

* CentOS 6/7

## Attributes

| Key | Type | Description | Default |
| --- | ---- | ----------- | ------- |
|`node['hg_mergerfs']['filesystems']`|Array|mergerfs filesystems to ensure are configured.|[] [see .kitchen.yml](.kitchen.yml)|
|`node['hg_mergerfs']['package_version']`|String|Version of mergerfs package to install|'2.16.1'|
|`node['hg_mergerfs']['tools_version']`|String|Commit hash for mergerfs-tools (use 'master' for latest)|'master'|
|`node['hg_mergerfs']['tools_paths']`|String|Path where tools should be deployed|'/opt/mergerfs-tools/bin'|

## Usage

### hg_mergerfs::default

Include `hg_mergerfs`:

```ruby
include_recipe 'hg_mergerfs::default'
```

## Provided Resources
This cookbook provides two custom resources; **mergerfs_package** and **mergerfs_tools**.  At the time of this writing, both resources are included in the default recipe, but this will likely change.

### mergerfs_package

```ruby
mergerfs_package 'name' do
  version                    String # defaults to 'name' if not specified
  tags_url                   String
  release_url                String
  notifies                   # see description
  subscribes                 # see description
  action                     Symbol # defaults to :install if not specified
end
```

#### Properties
**version**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Package version to install

**tags_url**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Github API url for repository tags

**release_url**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Github base URL for project releases

### mergerfs_tools
```ruby
mergerfs_tools 'name' do
  commit                     String # defaults to 'name' if not specified
  base_url                   String
  target                     String
  tools                      Array
  symlink                    TrueClass, FalseClass
  notifies                   # see description
  subscribes                 # see description
  action                     Symbol # defaults to :install if not specified
end
```

#### Properties
**commit**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Commit hash to use when sync'ing tools.

**base_url**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Github API url to tools directory for project.

**target**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Directory where tools will be sync'd to.

**tools**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Array of desired tools to sync.

**symlink**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Whether or not to provide symlinks into `/usr/local/sbin`


## License and Authors

Author:: Heig Gregorian (theheig@gmail.com)

[mergerfs]: https://github.com/trapexit/mergerfs
[mergerfs-tools]: https://github.com/trapexit/mergerfs-tools
