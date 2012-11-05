### UPDATE APT ###
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

### INSTALL USEFUL SERVER TOOLS ###
include_recipe "build-essential"
apt_package "vim"

#### MOPIDY DEPENDENCIES ####
include_recipe "python"

bash "Install pykka" do
  code "sudo pip install -U pykka"
  action :run
end

package "python-gst0.10"

apt_package "python-dev"

apt_package "gstreamer0.10-alsa"
apt_package "gstreamer0.10-plugins-good"
apt_package "gstreamer0.10-plugins-ugly"
apt_package "gstreamer0.10-tools"
apt_package "python-spotify"

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
apt_package "mpc"


#### SYSTEM AUDIO SETUP ####
apt_package "alsa"
apt_package "alsa-utils"

execute "Add system user to audio group" do
  command "sudo adduser #{system_username} audio"
  action :run
end

execute "Turn up the volume" do
  command <<-EOS
    amixer -c 0 set Master playback 100% unmute
    amixer -c 0 set Headphone playback 100% unmute
    amixer -c 0 set Speaker playback 100% unmute
  EOS
  action :run
end