
file '/var/tmp/file.txt' do
  content "chef serverspec handler file resource test\n"
  mode 0777
  owner 'root'
  group 'root'
  action :create
end

cookbook_file '/var/tmp/cookbook_file.txt' do
  source 'cookbook_file.txt'
  mode 0777
  owner 'root'
  group 'root'
  action :create
end

remote_file '/var/tmp/remote_file.txt' do
  source 'http://www.kanzaki.com/parts/me.gif'
  mode 0777
  owner 'root'
  group 'root'
  action :create
end

directory '/var/tmp/directory' do
  mode 0777
  owner 'root'
  group 'root'
  action :create
end

remote_directory '/var/tmp/remote_directory' do
  source 'remote_directory'
  mode 0777
  owner 'root'
  group 'root'
  action :create
end

template '/var/tmp/template.txt' do
  source 'template.txt.erb'
  mode 0777
  owner 'root'
  group 'root'
  variables(:val1 => 'val1', :val2 => 'val2', :val3 => 'val3')
  action :create
end

package 'httpd' do
  action :install
end

link '/var/tmp/link' do
  owner 'root'
  to '/var/tmp/file.txt'
end

user 'tily' do
  uid 500
  home '/home/tily'
  shell '/bin/bash'
  action :create
end

group 'tily' do
  action :create
end

service 'httpd' do
  action :start
end

service 'httpd' do
  action :enable
end

cron 'chef_serverspec_handler_cron_test' do
  minute "0"
  hour "20"
  day "*"
  month "10"
  weekday "1-5"
  command 'echo hello > /var/tmp/cron.txt'
  action :create
end
