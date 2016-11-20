#
# Cookbook Name:: fake_mounts
# Recipe:: default
#
# Copyright (c) 2016 Heig Gregorian, All Rights Reserved.

base_dir = '/mnt'
(1..10).map { |x| x.to_s.rjust(2, '0') }.each do |i|
  directory File.join(base_dir, "data-#{i}")
end
