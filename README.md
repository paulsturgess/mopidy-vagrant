# Mopidy install using Vagrant & Chef #

An Ubuntu install of the latest dev version of [Mopidy](http://www.mopidy.com).

Note the version of [Libspotify](https://developer.spotify.com/technologies/libspotify/) installed is hardcoded and must be compatible with the latest version of [pyspotify](http://pyspotify.mopidy.com/en/latest/).

The Libspotify version can be updated in the [Chef](http://wiki.opscode.com/display/chef/Home) recipe at `/cookbooks/recipes/default.rb`

You will need to set the environment variables `SPOTIFY_USERNAME` and `SPOTIFY_PASSWORD` with your [Spotify](http://www.spotify.com/) premium credentials.

## Install Vagrant ##

Download [Vagrant](http://vagrantup.com)

## Install the VM ##

    $ vagrant up

## Test your audio ##

    $ vagrant ssh
    $ gst-launch-0.10 audiotestsrc ! autoaudiosink

You should get a sound if everything has installed correctly

## Test mopidy via mpc ##

MPC is a command line mpd client

    $ mopidy &
    $ mpc add spotify:track:4hR2PmKODnlFa5fe8iWzeo
    $ mpc play