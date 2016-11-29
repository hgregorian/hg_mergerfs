#
# Cookbook Name:: hg_mergerfs
# Resource:: mergerfs_package
#
# Copyright (c) 2016 Heig Gregorian, All Rights Reserved.

resource_name :mergerfs_package
default_action :install

property :version, String, name_property: true
property :tags_url, String, required: false, default: 'https://api.github.com/repos/trapexit/mergerfs/git/refs/tags'
property :release_url, String, required: false, default: 'https://github.com/trapexit/mergerfs/releases/download/'

action :install do
  include_recipe 'yum-epel::default'

  target_version = (version.nil? || version.to_sym == :latest) ? get_tags(tags_url).last : version

  package_name = ::File.basename(source_url(release_url, target_version))
  remote_file "#{Chef::Config[:file_cache_path]}/#{package_name}" do
    source source_url(release_url, target_version)
    action :create
  end

  ## Prerequisite for downgrading since Chef's implementatio of `yum localinstall` doesn't consider downgrades
  yum_package 'downgrade mergerfs' do
    package_name 'mergerfs'
    action :remove
    only_if do
      version_compare(node['packages'].fetch('mergerfs', {}).fetch('version', '0.0.0'), target_version)
    end
  end

  yum_package 'mergerfs' do
    source "#{Chef::Config[:file_cache_path]}/#{package_name}"
  end
end

## Retrieve tags for Github project
def get_tags(url)
  require 'net/http'
  require 'json'
  response = Net::HTTP.get(URI(url))
  json = JSON.parse(response)
  json.map { |x| x['ref'].split('/').last }
end

## Construct and return source URL for package
def source_url(base_url, vers)
  package_name = case node['platform_version'].to_i
                 when 6
                   "mergerfs-#{vers}-1.el6.x86_64.rpm"
                 when 7
                   "mergerfs-#{vers}-1.el7.centos.x86_64.rpm"
                 end
  ::File.join(base_url, version, package_name)
end

# Compares versions and returns the following:
#   true => vers_a is greater than vers_b
#   false => vers_a is NOT greater than vers_b
def version_compare(vers_a, vers_b)
  require 'mixlib/versioning'
  Mixlib::Versioning.parse(vers_a) > Mixlib::Versioning.parse(vers_b)
end
