#
# Cookbook Name:: test_hg_mergerfs
# Recipe:: default
#
# Copyright (c) 2016 Heig Gregorian, All Rights Reserved.

base_dir = '/mnt'
(1..10).map { |x| x.to_s.rjust(2, '0') }.each do |i|
  directory File.join(base_dir, "data-#{i}")
end

## Install 'mergerfs'
mergerfs_package '2.16.1'

## Install 'mergerfs-tools
mergerfs_tools 'master' do
  target '/opt/mergerfs-tools/bin'
end

## Configure 'mergerfs' pool
mergerfs_pool '/storage' do
  srcmounts ['/mnt/data-*']
  options ['defaults', 'moveonenospc=true', 'allow_other', 'minfreespace=10G', 'fsname=yugeData']
  automount true
end
