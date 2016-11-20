#
# Cookbook Name:: hg_mergerfs
# Resource:: mergerfs_tools
#
# Copyright (c) 2016 Heig Gregorian, All Rights Reserved.

resource_name :mergerfs_tools
default_action :install

property :commit, String, name_property: true
property :base_url, String, required: false, default: 'https://api.github.com/repos/trapexit/mergerfs-tools/contents/src'
property :target, String, required: false, default: '/opt/mergerfs-tools/bin'
property :tools, Array, required: false, default: []
property :symlink, [TrueClass, FalseClass], required: false, default: true

action :install do
  tools_url = "#{base_url}?ref=#{commit}"

  ## Create target
  directory target do
    recursive true
  end

  ## Retrieve metadata hash for tools info, filtered by wanted tools
  get_tools_hash(tools_url, tools).each do |name, attrs|
    tool_path = ::File.join(target, name)

    ## Retrieve tool unless its git hash blob matches metadata
    remote_file tool_path do
      source attrs['download_url']
      mode '0755'
      not_if { git_hash_object(tool_path) == attrs['sha'] }
    end

    ## Provide symlink for tool in /usr/local/sbin/
    link ::File.join('/usr/local/sbin', name) do
      to tool_path
    end if symlink
  end

  ## Purge unmanaged files from target directory
  managed_directory target

  ## Optionally purge associated symlink
  if symlink
    directory_contents = ::Dir.glob("#{new_resource.target}/*")
    managed_entries = run_context.resource_collection.all_resources.map do |r|
      r.name.to_s if r.name.to_s.start_with?("#{new_resource.target}/")
    end.compact
    entries_to_remove = directory_contents - managed_entries
    Chef::Log.warn(entries_to_remove.to_s)
    entries_to_remove.each do |e|
      link_path = ::File.join('/usr/local/sbin', ::File.basename(e))
      link "Remove link #{link_path}" do
        target_file link_path
        action :delete
      end
    end
  end
end

## Method to retrieve information for given mergerfs tools
def get_tools_hash(url, filter)
  require 'rest-client'
  require 'json'

  tools_hash = {}
  response = RestClient.get(url)
  json = JSON.parse(response)

  json.each do |x|
    next unless filter.empty? || filter.include?(x['name'])
    tools_hash[x['name']] = {
      'sha' => x['sha'],
      'download_url' => x['download_url']
    }
  end
  tools_hash
end

## Method to calculate git hash blob for a given file
def git_hash_object(path)
  require 'mixlib/shellout'
  begin
    Mixlib::ShellOut.new("git hash-object #{path}").run_command.stdout.chomp
  rescue
    ''
  end
end
