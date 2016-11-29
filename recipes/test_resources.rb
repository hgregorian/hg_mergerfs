#
# Cookbook Name:: hg_mergerfs
# Recipe:: test_resources
#
# Copyright (c) 2016 Heig Gregorian, All Rights Reserved.

(1..10).map { |x| x.to_s.rjust(2, '0') }.each do |i|
  directory "/mnt/#{i}-data"
end

## Install 'mergerfs'
mergerfs_package '2.16.1'

## Install 'mergerfs-tools
mergerfs_tools '/opt/mergerfs-tools/bin' do
  commit 'master'
  symlink true
  symlink_path '/usr/local/sbin'
end

## Configure 'mergerfs' pool
mergerfs_pool '/storage' do
  srcmounts ['/mnt/*-data']
  options ['defaults', 'moveonenospc=true', 'allow_other', 'minfreespace=10G', 'fsname=yugeData']
  automount true
end
