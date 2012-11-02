# Mopidy install using Vagrant & Chef #

An Ubuntu Lucid install of the latest dev version of [Mopidy](http://www.mopidy.com).

Handles the installation of all relevant dependencies for Mopidy.

You will need to set the environment variables `SPOTIFY_USERNAME` and `SPOTIFY_PASSWORD` with your [Spotify](http://www.spotify.com/) premium credentials.

## Install Vagrant ##

Get yourself a copy of [Vagrant](http://vagrantup.com)

## Install the VM ##

    $ git clone git@github.com:paulsturgess/mopidy-vagrant.git
    $ cd mopidy-vagrant
    $ vagrant up

The first time the box is installed will take a while as a copy of the Ubuntu VM will need to be downloaded.

## Test your audio ##

    $ vagrant ssh
    $ gst-launch-0.10 audiotestsrc ! autoaudiosink

You should get a sound if everything has installed correctly

## Test mopidy via mpc ##

[mpc](http://linux.die.net/man/1/mpc) is a command line [mpd](http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki) client that works with Mopidy

    $ mopidy &
    $ mpc add spotify:track:1QXzQKmQiDOzGHwSXVdHTp
    $ mpc play