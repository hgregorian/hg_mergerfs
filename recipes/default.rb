#
# Cookbook Name:: hg_mergerfs
# Recipe:: default
#
# Copyright (c) 2016 Heig Gregorian, All Rights Reserved.

include_recipe 'yum-epel::default'

package 'package dependencies' do
  package_name %w(gcc-c++ git python34)
end

%w(rest-client mixlib-versioning mixlib-shellout).each do |gem_name|
  chef_gem gem_name do
    compile_time false
  end
end

## Install mergerfs (or upgrade or downgrade, depends on version provided)
mergerfs_package node['hg_mergerfs']['package_version']

## Install mergerfs-tools
mergerfs_tools node['hg_mergerfs']['tools_version'] do
  target node['hg_mergerfs']['tools_path']
end

## Define mergerfs pool(s) in /etc/fstab and mount (optional)
node['hg_mergerfs']['filesystems'].each do |entry|
  directory entry['filesystem'] do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end
  mount entry['filesystem'] do
    device entry['srcmounts'].join(':')
    fstype 'fuse.mergerfs'
    options entry['options']
    dump 0
    pass 0
    action :enable
  end
  mount_action = (entry['automount'] && ::File.readlines('/proc/mounts').grep(/\s+#{entry['filesystem']}\s+/).empty?) ? :run : :nothing
  execute "mount #{entry['filesystem']}" do
    command "mount #{entry['filesystem']}"
    action mount_action
  end
end
