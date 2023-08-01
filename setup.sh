#!/bin/env bash

# USAGE: Automate the installation of my environment on supported platforms

# REFERENCE: https://www.shellcheck.net/

# MISC
printf "████████████████████\n" >> setuplog.txt # Distinguish each setup instance

# GLOBAL VARIABLES
PLATFORM=$(uname | tr "[:upper:]" "[:lower:]")

# FUNCTIONS
ask_prompt() { # Usage: prompt user, read input, if input matches glob patterns then yield 0:success, if not 1:failure
	unset ans
	while [ -z $ans  ]; do
	 printf "\e[33m%s [y/N]\e[0m\e[34m " "$1"
	  read -r ans
	 printf "\e[0m\r" # Reset and mv cursor to the beginning of the line
	done
	
	[[ "$ans" = [Yy]* ]] && return 0 || return 1
}

load_viz() { # Should only be used for commands that do not expend too much time and require sudo
	("$@" >> setuplog.txt 2>&1) & # Run a command in a subshell in the background and redirect stdout/err to setuplog
	pidn="$!"                     # Acquire the process id number
	
	if [[ "$#" -gt 0 ]]; then
		loadchar=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" "▇" "▆" "▅" "▄" "▃" "▁")
		for (( i=1; ;i++ )); do
			sleep 0.1
			printf "\t\e[33mWaiting on %s %s\e[0m\r" "$1" "${loadchar[$((i % ${#loadchar[@]}))]}"
			[[ "$i" == "${#loadchar}" ]] && i=1
			ps -p "$pidn" -o pid= > /dev/null 2>&1 # Check if process exists 
			[[ "$?" = 1 ]] && printf "\t\033[0K\e[33mFinished \e[0m\e[32m✓\e[0m\r\n" && break
		done
	else
		printf "Usage: load_viz <command> [...]\n\tload_viz echo Hi\n"
	fi  
}

init_brew() {
	printf "\e[33mChecking for brew on %s.\e[0m\n" "$PLATFORM"
	
	if ! brew --version >> setuplog.txt 2>&1; then # Redirect stdout/err to setuplog while checking
		printf "\e[31mHOMEBREW IS NOT INSTALLED!\e[0m\n"
		if ask_prompt "Do you want to install it?"; then
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		else
			return 0
		fi
	else
		printf "\e[32mHOMEBREW IS ALREADY INSTALLED!\e[0m\n"
	fi
	
	ask_prompt "Do you want to initiate brew bundle (may require sudo)?" && brew bundle;
	ask_prompt "Do you want to remove setuplog?" && printf "\e[33mremoved\e[0m: %s\n" "$(rm -v ./setuplog.txt)";
  return 0
}

# PLATFORM CHECK
# load_viz sleep 3
# load_viz dd if=/dev/random iflag=fullblock bs=1G count=1 of=rand.txt

if [[ "$PLATFORM" = "darwin" ]]; then
	init_brew
elif [[ "$PLATFORM" = ["gnu""linux"]*["gnu""linux"] ]]; then
	printf "\e[34mNo implementation here yet.\e[0m\n"
else
	printf "\e[31m%s is not supported.\e[0m\n" "$PLATFORM"
fi

# ...

unset PLATFORM
unset -f ask_prompt load_viz init_brew 

exit 0
