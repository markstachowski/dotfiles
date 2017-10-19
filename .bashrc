# Amar Paul's .bashrc

# read .profile
[[ -r ~/.profile ]] && source ~/.profile

# and temporary aliases
[[ -r ~/.bash_aliases_tmp ]] && source ~/.bash_aliases_tmp

# Python shell tab completion
export PYTHONSTARTUP="$(/usr/local/bin/python2 -m jedi repl)"

# Set default editor
export EDITOR="nvim"

################
##
## Personal aliases, functions
##
################

###
# Common aliases, command improvements:
###

# ls, grep, mkdir, tmux improvements
alias ll="ls -lhFG"
alias la="ll -a"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias ggrep="ggrep --color=auto"
alias cclear="cd; clear"

# always use homebrew python?
alias python='python2'

# Make new directory and immediately cd into it (from Nate Landau's, link below)
# should the -p flag be included?
mcd () { mkdir -p "$1" && cd "$1"; }

# Use neovim instead of vim
alias vi="nvim"
alias vim="nvim"
vimdiff () { nvim -d "$@" ;}

# TODO:
# [c|h]cat needs improvement
# use `highlight` for colorized cat
ccat () {
  if [ -f "$1" ]; then
    case "$1" in
		# force configuration file syntax for rc and profile files
		*rc|*profile)
			highlight -O xterm256 --style=zenburn --syntax=conf -i "$1"
			;;
		*)
			highlight -O xterm256 --style=zenburn -i "$1"
			;;
    esac
  else
    echo "$1"" is not a valid file"
  fi
}

# Use modified `ccat` function and `nl` to add line numbering
hcat () {
  NUMBER=0

  while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -n)
      NUMBER=1
      ;;
    *)
      if [ $NUMBER -eq 0 ]
      then
        ccat "$key"
      else
        ccat "$key" | nl
      fi
      ;;
  esac
  shift
  done

  unset NUMBER
}

# make tmux easier to check
alias tmux-ls="/usr/local/bin/tmux list-sessions"
# tmux-a [index]	: attaches to the index of given session
# tmux-a			: tries to attach to last session; if none active, creates new one
tmux-a () {
	sessions=`tmux list-sessions 2>/dev/null`
	# if there are tmux sessions, connect to the last one or the one specified by $1
	if [[ $? -eq 0 ]]
	then
		# if there's an argument given then connect to given session
		if [[ -n "$1" ]]
		then
			tmux attach -t "$1"
			#return $?
		else
			# no argument, and tmux is running: attach to the most recent session
			tmux attach
			#return $?
		fi
	else
		# tmux isn't running: start it up
		tmux
		#return 0
	fi
}

###
# Some function calls to ricing.sh (in case I call from cmd line)
###

day () { ~/.config/scripts/ricing.sh day ;}
night () { ~/.config/scripts/ricing.sh night ;}

###
# General computer mgmt aliases and functions
###

# Open the screensaver with `lock`. Set preferences to lock the screen after 5s of screensaver
SCREEN_ENGINE="/System/Library/Frameworks/ScreenSaver.framework/Versions/Current/Resources/ScreenSaverEngine.app"
alias lock="open -a $SCREEN_ENGINE"

# reboot wifi (my router will occasionally boot my computer off)
alias wifi-toggle="networksetup -setairportpower en0 off; \
					sleep 2; \
					networksetup -setairportpower en0 on"

# copy with a progress bar.
# check how this works for Mac
#alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"


###
# http://tex.stackexchange.com/questions/43057/macosx-pdf-viewer-automatic-reload-on-file-modification
# setup Skim for vim latex pdf previewing
# defaults write -app Skim SKAutoReloadFileUpdate -boolean true
#
# http://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
# xtest for xQuartz?
# defaults write org.x.X11 enable_test_extensions -boolean true

###
# Following suggestions are from:
# http://natelandau.com/my-mac-osx-bash_profile/

# Prevent power button from immediately sleeping display
alias PowerSleepOff='defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no'
alias PowerSleepOn='defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool yes'

# Move default screencap location (only have to run this once, but saved here just in case)
# Where I want them saved:
alias picDls='defaults write com.apple.screencapture location ~/Downloads/; killall SystemUIServer'
# Actual default:
alias picDef='defaults write com.apple.screencapture location ~/Desktop/; killall SystemUIServer'

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
alias delDS="find . -type f -name '*.DS_Store' -ls -delete"

# true by default
export FINDER_SHOW_HIDDEN=1
toggleFinderHidden () {
	if [[ $FINDER_SHOW_HIDDEN -eq 0 ]]
	then
		export FINDER_SHOW_HIDDEN=1
		defaults write com.apple.finder ShowAllFiles true
		killall Finder
	else
		export FINDER_SHOW_HIDDEN=0
		defaults write com.apple.finder ShowAllFiles false
		killall Finder
	fi
}

# Show desktop icons by default
export DESKTOP_SHOW=1
toggleDesktop () {
	if [[ $DESKTOP_SHOW -eq 0 ]]
	then
		export DESKTOP_SHOW=1
		defaults write com.apple.finder CreateDesktop true
		killall Finder
	else
		export DESKTOP_SHOW=0
		defaults write com.apple.finder CreateDesktop false
		killall Finder
	fi
}

###
# End of Nate Landau's suggestions
###
