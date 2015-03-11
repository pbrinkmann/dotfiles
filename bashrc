export LANG='en_US.UTF-8'

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

color_red="\[\e[0;31m\]"
color_red_un="\e[0;31m"
color_green="\[\e[0;32m\]"
color_yellow="\[\e[0;33m\]"
color_blue="\[\e[0;34m\]"
color_magenta="\[\e[0;35m\]"
color_cyan="\[\e[0;36m\]"
color_white="\[\e[0;37m\]"
color_red_bold="\[\e[1;31m\]"
color_green_bold="\[\e[1;32m\]"
color_yellow_bold="\[\e[1;33m\]"
color_blue_bold="\[\e[1;34m\]"
color_magenta_bold="\[\e[1;35m\]"
color_cyan_bold="\[\e[1;36m\]"
color_none="\[\e[0m\]"
color_none_un="\e[0m"

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# more history pls (default is 500)
export HISTSIZE=10000
export HISTFILESIZE=10000

# let's make ls a little more pretty
# see http://linux-sxs.org/housekeeping/lscolors.html for more info
export LS_COLORS="ex=33:di=35"

# color stderr red on debian (doesn't seem to work for centos)
if [[ -e /etc/debian_version && -e ~/.dotfiles/stderred/lib64/stderred.so ]]; then
    export LD_PRELOAD="$HOME/.dotfiles/stderred/lib64/stderred.so"
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

alias ls='ls --color=auto -F'
alias l='ls --color=auto -F'
alias grep="grep --color"
alias more="less -M"

alias sg='egrep -i -R --exclude-dir="*.svn*"'
alias svnstat='svn --ignore-externals status | egrep -v "^X"'
alias svnurl='svn info | grep "^URL" | sed "s/URL: //"'
alias pt='perltidy -pbp -l=100 -nst -b -nse -nasc'
alias auas='sudo aptitude update && sudo aptitude safe-upgrade -V'
alias d='sudo docker'
# Deletes all docker containers
alias d_rmall='for i in $(d ps -a | grep "Exited " | awk "{ print \$1 }"); do d rm $i; done'
# Deletes any untagged images
alias d_rmoi='for i in $(d images | grep "<none>.*<none>" | awk "{print \$3}"); do d rmi $i; done'
alias gcam='git commit -am'
alias gp='git push'

# stuipd terminals!   fix the backspace doing funny things in vi
stty erase ^H

export PATH="$PATH:~/.dotfiles:."
export EDITOR=vim

# tell bash tabcompletion to ignore .svn dirs
export FIGNORE=.svn:.git

. ~/.dotfiles/going


function prompt_f ()
{
    local EXIT_STATUS=$?

    # uncomment this if using 'expect' and it's having trouble recognizing the shell prompt
    #if [[ $PS1 == *EXPECT* ]]; then
    #    return
    #fi

    local ps1_status_color ps1_status ps1_path_color ps1_user_color ps1_fullpath ps1_host_color

    #
    # Set prompt color based on exit status of previous command
    #
    if [ $EXIT_STATUS -eq 0 ]; then
        ps1_status_color=${color_green}
    else
        ps1_status_color=${color_red_bold}
    fi

    #
    # Are we the root user?
    #
    ps1_path_color=${color_none}
    if [ $USER == "root" ]; then
        ps1_user_color=${color_yellow_bold}
    else
        ps1_user_color=${color_cyan}
    fi

    ps1_host_color="$(get_host_color)"

    ps1_fullpath="${ps1_status_color}[${ps1_user_color}\\u${color_none}@${ps1_host_color}\\h${color_none}:${ps1_path_color}\\w${ps1_status_color}]${color_none}"


   suspended=$(jobs | wc -l)
    if [[ $suspended -eq 0 ]]; then
        suspended=""
    else
        suspended="${suspended}z "
    fi

    PS1="${ps1_fullpath} $suspended\\$ "
}

#
# This can be overridden to provide differnt logic for coloring the host portion of the prompt
#
function get_host_color()
{
    echo "${color_blue}"
}

# prepends text file(s)
function prepend() 
{  
    if [ $# -lt 2 ]
    then
        echo "usage:"
        echo "prepend 'text to prepend' file1 file2 ..."
    fi

    prependtext="$1"
    shift

    for i in $@
    do 
        echo "$prependtext" | cat - $i > /tmp/prependout && mv /tmp/prependout $i
    done
}


PS1="NOTHING"
PROMPT_COMMAND="prompt_f"


# Execute host-specific stuff
HOSTFILE1=~/.dotfiles/hosts/`hostname`
if [ -e $HOSTFILE1 ]
then
    . $HOSTFILE1
fi
HOSTFILE2=~/.hosts_extra/`hostname`
if [ -e $HOSTFILE2 ]
then
    . $HOSTFILE2
fi

# clearkey <hostname> to clear a bad host from .ssh/known_hosts
function clearkey() {
    ssh-keygen -R $1
    local H=$(host $1 | grep 'has address' | head -1 | awk '{ print $4 }')
    if [[ "$H" != "" ]]; then
        ssh-keygen -R  "$H"
    fi
}

function tabname {
    printf "\e]1;$1\a"
}
   
function winname {
    printf "\e]2;$1\a"
}

tabname $(hostname)


# for Mac OS X crontab editing
if [[ $(uname -a) =~ Darwin ]]
then
    alias crontab="VIM_CRONTAB=true crontab"
fi


if  df . | grep '100%' >/dev/null
then
    echo ''
    echo '-------------------------------------------------------'
    echo '!! The partition your home dir is on is out of space !!'
    echo '-------------------------------------------------------'
    echo ''
    df -h .
fi

