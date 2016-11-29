#
# Cookbook Name:: hg_mergerfs
# Resource:: mergerfs_pool
#
# Copyright (c) 2016 Heig Gregorian, All Rights Reserved.

resource_name :mergerfs_pool
default_action :create

property :mount_point, String, name_property: true
property :srcmounts, Array, required: true
property :options, Array, required: false, default: %w(defaults allow_other)
property :automount, [TrueClass, FalseClass], required: false, default: false

action :create do
  ## Create pool mount point
  directory "Create #{new_resource.mount_point}" do
    path new_resource.mount_point
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end

  ## Create fstab entry, but do not mount
  ## NOTE: mount resource doesn't handle mounting properly when wildcards are involved
  mount "Create fstab entry for '#{mount_point}'" do
    mount_point new_resource.mount_point
    device srcmounts.join(':')
    fstype 'fuse.mergerfs'
    options new_resource.options
    dump 0
    pass 0
    action :enable
  end

  ## Mount if 'automount' specified
  execute "mount #{mount_point}" do
    command "mount #{mount_point}"
    action mounted?(mount_point) ? :nothing : :run
    only_if { new_resource.automount }
  end
end

def mounted?(mount_point)
  !::File.readlines('/proc/mounts').grep(/\s+#{mount_point}\s+/).empty?
end
