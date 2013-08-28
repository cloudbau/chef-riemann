#
# Cookbook Name:: riemann-server
# Recipe:: server
#
# Copyright (C) 2013 cloudbau GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

include_recipe 'runit'
include_recipe 'java'

user "riemann" do
  home "/home/riemann"
  shell "/bin/bash"
  system true
end

if platform_family?("debian")

  remote_file "/tmp/riemann_#{node[:riemann][:server][:version]}_all.deb" do
    source "http://aphyr.com/riemann/riemann_#{node[:riemann][:server][:version]}_all.deb"
    mode 0644
    not_if "dpkg -s riemann | grep Version | grep #{node[:riemann][:server][:version]}"
    notifies :install, "dpkg_package[/tmp/riemann_#{node[:riemann][:server][:version]}_all.deb]", :immediately
  end

  dpkg_package "/tmp/riemann_#{node[:riemann][:server][:version]}_all.deb" do
    action :nothing
  end

elsif platform?("redhat", "centos", "fedora", "amazon", "scientific")

  include_recipe "yum::epel"
  
  remote_file "/tmp/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm" do
    source "http://aphyr.com/riemann/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm"
    mode 0644
  end

  yum_package "/tmp/riemann-#{node[:riemann][:server][:version]}-1.noarch.rpm"

end

runit_service "riemann"

service "riemann" do
  supports :restart => true
  action [:start]
end

node.set[:riemann][:server][:service] = true
node.set[:riemann][:server][:bind_ip] = node[:ipaddress] unless node[:riemann][:server][:bind_ip]

template "/etc/riemann/riemann.config" do
  source "riemann.config.erb"
  owner "root"
  group "root"
  mode 0644

  notifies :restart, resources(:service => 'riemann')
  variables :bind_ip => node[:riemann][:server][:bind_ip]
end

directory "/var/log/riemann/" do
  mode 0755
  owner 'riemann'
  group 'riemann'
  action :create
end

directory "/usr/lib/riemann" do
  mode 0775
  owner 'riemann'
  group 'riemann'
  action :create
end
