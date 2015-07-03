helper = WDweb::Helper.new("2.1.2", 'web')

#apt get update
execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

user helper.user do
  home helper.home
  shell '/bin/bash'
end

remote_directory helper.home do
  user helper.user
  files_owner helper.user
  source 'home-web'
end

execute "copy-ssh" do
  command  "cd #{helper.home} ; cp -r ~vagrant/.ssh . && chmod 700 .ssh && chown -R #{helper.user} .ssh"
end

package 'git'

directory(helper.rbenv_home('plugins')) do
  user helper.user
end

git(helper.rbenv_home('plugins/ruby-build')) do
  repository 'https://github.com/sstephenson/rbenv.git'
  user helper.user
  revision 'v20140702'
end

%w[build-essential bison openssl libreadline6 libreadline6-dev
  zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0
  libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf
  libc6-dev ssl-cert subversion].each do |p|
    package p
end

%w[nodejs npm].each {|p| package p}

execute "node-packages" do
  command "npm install -g coffee-script@1.6.3"
end
# annoyingly mac and ubuntu use different commands for node
link "/usr/bin/node" do
  to  "/usr/bin/nodejs"
end

# ruby necessary libs by plataform
#%w{ tar bash curl git build-essential bison openssl libreadline6 libreadline6-dev
#	zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0
#	libsqlite3-dev sqlite3 autoconf
#	libc6-dev ssl-cert subversion nodejs ruby }.each do |ruby_required_lib|
#  package ruby_required_lib
#end

#necessary for admin
%w{ tmux htop }.each do |admin_lib|
  package admin_lib
end

#bare minimum for install other dependencies
chef_gem 'bundler'

#mongo db installation
package 'mongodb'

#Imagemagick
package 'imagemagick'

#nogokiri
package "libxslt1-dev"
