### INSTALL USEFUL SERVER TOOLS ###

include_recipe "build-essential"
execute "Install vim" do
  command "sudo apt-get install vim -y -q"
  action :run
end

#### MOPIDY DEPENDENCIES ####

include_recipe "python"

execute "Setup Mopidy APT archive" do
  command <<-EOH
    wget -q -O - http://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
    sudo wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list
  EOH
  action :run
end

execute "Update APT" do
  command "sudo apt-get update"
  action :run
end

bash "Install pykka" do
  code "sudo pip install -U pykka"
  action :run
end

package "python-gst0.10"

bash "Install python-dev" do
  code "sudo apt-get install python-dev -y -q"
  action :run
end

bash "Install gstreamer" do
  code "sudo apt-get install gstreamer0.10-alsa gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly gstreamer0.10-tools -y -q"
  action :run
end

#### MOPIDY SPOTIFY DEPENDENCIES ####

bash "Install libspotify" do
  code <<-EOH
    wget https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-i686-release.tar.gz
    tar zxfv libspotify-12.1.51-Linux-i686-release.tar.gz
    cd libspotify-12.1.51-Linux-i686-release
    sudo make install prefix=/usr/local
    sudo ldconfig
  EOH
  action :run
end

bash "Install latest dev version of pyspotify" do
  code "sudo pip install -U pyspotify==dev"
  action :run
end

#### INSTALL MOPIDY ####

bash "Install latest dev version of Mopidy" do
  code "sudo pip install mopidy==dev"
  action :run
end

#### MOPIDY CONFIG ####

system_username = node[:mopidy][:system_user]

bash "create mopidy config directory" do
  code "mkdir -p /home/#{system_username}/.config/mopidy"
  action :run
end

template "/home/#{system_username}/.config/mopidy/settings.py" do
  source "settings.py.erb"
  mode 0644
  owner system_username
  group system_username
  variables(
    :spotify_username => node[:mopidy][:spotify_username],
    :spotify_password => node[:mopidy][:spotify_password]
  )
end

bash "create mopidy logfile" do
  code "touch /var/log/mopidy.log && chmod 644 /var/log/mopidy.log && chown #{system_username}:root /var/log/mopidy.log"
  action :run
end

template "/etc/init/mopidy.conf" do
  source "mopidy.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :mopidy_username => system_username,
    :mopidy_log_path => "/var/log/mopidy.log"
  )
end

#### MPD CLIENT ####

bash "Install mpc" do
  code "sudo apt-get install mpc -y -q"
  action :run
end

#### SYSTEM AUDIO SETUP ####

execute "Install alsamixer" do
  command "sudo apt-get install alsa-utils"
  action :run
end

execute "Add system user to audio group" do
  command "sudo adduser #{system_username} audio"
  action :run
end