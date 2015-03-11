dotfiles
========

This is a collection of my dotfiles.  It should be usable on any standard Mac or Linux system.

It's not really meant for general use, but with a few tweaks (ex, changing the personal info in the gitconfig file) it should be useable by anyone.

Installation
============

Clone it:

    git clone https://github.com/pbrinkmann/dotfiles.git .dotfiles
    
Then run the _deploy_ script to copy all the files into their proper place (and backup any existing files):

    cd .dotfiles
    ./deploy

What's Included
===============

vim:  ":help myplugins"
bash: handful of tweaks, aliases and util functions
git:  some useful aliases and general preferences

Bash Per-Host Commands
======================
If you want to add host-specific bash commands, you can place files in one of two locations with the hostname. The bashrc sources:

* ~/.dotfiles/hosts/`hostname`
* ~/.hosts_extra/`hostname`


Bash/Git Config/SSH Config Extra Commands
=========================================
For the bashrc, gitconfig and sshconfig files, if a ~/.${config_name}_extra file exists, its contents will be added to the one from git on deploy.  This allows servers that are under configuration management to have specific commmands added that are unique to that environment.




