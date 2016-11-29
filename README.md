# hg_mergerfs cookbook

Cookbook for deploying [mergerfs], associated [mergerfs-tools], and instantiating mergerfs pools.

## Supported Platforms

* CentOS/RHEL 6
* CentOS/RHEL 7

## Usage

This cookbook provides three resources; **mergerfs_package**, **mergerfs_tools**, and **mergerfs_pool**.

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
`version`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Package version to install.

`tags_url`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Github API url for repository tags. (default: 'https://api.github.com/repos/trapexit/mergerfs/git/refs/tags')

`release_url`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Github base URL for project releases. (default: 'https://github.com/trapexit/mergerfs/releases/download/')


### mergerfs_tools
```ruby
mergerfs_tools 'name' do
  target                     String # defaults to 'name' if not specified
  commit                     String
  base_url                   String
  tools                      Array
  symlink                    TrueClass, FalseClass
  symlink_path               String
  notifies                   # see description
  subscribes                 # see description
  action                     Symbol # defaults to :install if not specified
end
```

#### Properties
`target`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Directory where tools will be sync'd to.

`commit`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Commit hash to use when sync'ing tools. (default: `'master'`)

`base_url`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Github API url to tools directory for project. (default: 'https://api.github.com/repos/trapexit/mergerfs-tools/contents/src')

`tools`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Array of desired tools to sync. (default: `[]` _all tools_)

`symlink`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Whether or not to provide symlinks (default: `false`)

`symlink_path`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Specify path where symlinks should be created (default: `'/usr/local/sbin'`)


### mergerfs_pool
```ruby
mergerfs_pool 'name' do
  mount_point                String # defaults to 'name' if not specified
  srcmounts                  Array
  options                    Array
  automount                  TrueClass, FalseClass
  notifies                   # see description
  subscribes                 # see description
  action                     Symbol # defaults to :create if not specified
end
```

#### Properties
`mount_point`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Directory where pool will be mounted.

`srcmounts`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Array of srcmounts to be used in pool. (default: `[]`)

`options`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mount options for pool. (default: `['defaults', 'allow_other']`)

`automount`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Whether or not to ensure pool is mounted. (default: `false`)

## License and Authors

Author:: Heig Gregorian (theheig@gmail.com)

[mergerfs]: https://github.com/trapexit/mergerfs
[mergerfs-tools]: https://github.com/trapexit/mergerfs-tools
