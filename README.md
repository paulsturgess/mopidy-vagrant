# Mopidy install using Vagrant & Chef #

An Ubuntu install of the latest dev version of [Mopidy](http://www.mopidy.com).

Note the version of [Libspotify](https://developer.spotify.com/technologies/libspotify/) installed is hardcoded and must be compatible with the latest version of [pyspotify](http://pyspotify.mopidy.com/en/latest/).

The Libspotify version can be updated in the [Chef](http://wiki.opscode.com/display/chef/Home) recipe at `/cookbooks/recipes/default.rb`

You will need to update `/Vagrantfile` with your [Spotify](http://www.spotify.com/) premium credentials.

## Install Vagrant ##

Download [Vagrant](http://vagrantup.com)

## Install the VM ##

    $ vagrant up

## Enable audio ##

At this point audio will not work. It needs to be enabled for the VM.

With your vm running, find out its' name via:

    $ VBoxManage list runningvms

Copy the name of the vm and enable audio:

    $ vagrant halt
    $ VBoxManage modifyvm your_vm_name --audio coreaudio --audiocontroller hda

Test your audio

    $ vagrant up
    $ vagrant ssh
    $ gst-launch-0.10 audiotestsrc ! autoaudiosink

Test mopidy via mpc (a command line mpd client)

    $ mopidy &
    $ mpc add spotify:track:4hR2PmKODnlFa5fe8iWzeo
    $ mpc play