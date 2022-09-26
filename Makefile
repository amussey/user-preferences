SHELL = /bin/bash
UNAME := $(shell uname)
WSL_UNAME := $(shell grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null && echo "WSL-$$(uname)" || uname)
RUNTIME := $(shell date '+%Y-%m-%d_%H-%M-%S')

.PHONY: limechat

keybindings:  ## OSX: Update the keybindings to better match Windows.
ifeq ($(UNAME), Darwin)
	-mkdir ~/Library/KeyBindings
	touch ~/Library/KeyBindings/DefaultKeyBinding.dict
	mv ~/Library/KeyBindings/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict.$(RUNTIME)
	cp ./files/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict
endif

karabiner:
ifeq ($(UNAME), Darwin)
	cp ./files/Karabiner_private.xml ~/Library/Application\ Support/Karabiner/private.xml
	./files/Karabiner_settings.sh
endif

android: ## OSX: Install the tools necessary for working with Android development.
android: brew
ifeq ($(UNAME), Darwin)
	brew install --cask android-file-transfer
	brew install --cask android-platform-tools
	brew install --cask java
	brew install apktool
endif

aws: ## OS: Install tools helpful for working with AWS.
ifeq ($(UNAME), Darwin)
	brew install awscli
	brew install --cask aws-vpn-client
endif

limechat: ## OSX: Add additional themes for the Limechat IRC client.
ifeq ($(UNAME), Darwin)
	cp LimeChat/Themes/* ~/Library/Application\ Support/LimeChat/Themes/
endif

brew: ## OSX: Install `brew`.
ifeq ($(UNAME), Darwin)
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
endif

vagrant: ## OSX: Install VirtualBox and Vagrant.
vagrant: brew
ifeq ($(UNAME), Darwin)
	brew cask install virtualbox
	brew cask install vagrant
	brew cask install vagrant-manager
endif

git: ## Set my default git config.
	git config --global user.name "Andrew Mussey"
	git config --global user.email "git@amussey.com"

zsh: brew zshrc_files
ifeq ($(UNAME), Darwin)
	command -v zsh >/dev/null 2>&1 || { echo "ZSH already installed and configured."; exit 1; }
	brew install zsh
endif
ifeq ($(UNAME), Linux)
	sudo apt-get install zsh
endif
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "$${ZDOTDIR:-$${HOME}}/.zprezto"
	cp ./.zprezto/modules/prompt/functions/prompt_amussey_setup ~/.zprezto/modules/prompt/functions/prompt_amussey_setup
	cp ./.zpreztorc ~/.zpreztorc
	cp ./.zshrc ~/.zshrc

sublime: brew
ifeq ($(UNAME), Darwin)
	brew cask install sublime-text
	command -v subl >/dev/null 2>&1 || { sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl; }
endif

vscode: brew
ifeq ($(UNAME), Darwin)
	brew install --cask visual-studio-code
	mv ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/Code/User/settings.$(RUNTIME).json"
	cp ./VSCode/settings.json ~/Library/Application\ Support/Code/User/settings.json
endif

python: ## OSX: Install Python 2 and 3 with Tkinter support.
ifeq ($(UNAME), Darwin)
	brew install tcl-tk
	brew install python --use-brewed-tk
	brew install python3 --use-brewed-tk
endif

photos: ## OSX: Stop Photos from automatically opening when an SD card is plugged in.
ifeq ($(UNAME), Darwin)
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
endif

screenshots: ## OSX: Change the directory screenshots are saved to.
ifeq ($(UNAME), Darwin)
	mkdir -p ~/Pictures/Screenshots
	defaults write com.apple.screencapture location ~/Pictures/Screenshots
endif

save_panel: ## OSX: Make the save panel automatically expand.
ifeq ($(UNAME), Darwin)
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
endif

ffmpeg: ## OSX: Install ffmpeg.
ifeq ($(UNAME), Darwin)
	curl http://www.ffmpegmac.net/resources/SnowLeopard_Lion_Mountain_Lion_Mavericks_Yosemite_El-Captain_06.07.2016.zip -O
	unzip SnowLeopard_Lion_Mountain_Lion_Mavericks_Yosemite_El-Captain_06.07.2016.zip
	rm SnowLeopard_Lion_Mountain_Lion_Mavericks_Yosemite_El-Captain_06.07.2016.zip
	mv ff* /usr/local/bin
endif

duplicati: ## Install the Duplicati backup software.
ifeq ($(UNAME), Darwin)
	brew cask install duplicati
	sudo curl https://gist.githubusercontent.com/mohakshah/6ec2351bcf8e6898b4a3f79bfc2f12cf/raw/458edb327a7e2a75d1bbd70888dc39b9a3743065/net.duplicati.tray-icon.plist -o /Library/LaunchAgents/net.duplicati.tray-icon.plist
	sudo curl https://gist.githubusercontent.com/mohakshah/6ec2351bcf8e6898b4a3f79bfc2f12cf/raw/458edb327a7e2a75d1bbd70888dc39b9a3743065/net.duplicati.server.plist -o /Library/LaunchDaemons/net.duplicati.server.plist
	sudo launchctl load -w /Library/LaunchDaemons/net.duplicati.server.plist
endif

zshrc_files:
	cp -r .zshrc-files ~

spotify: ## Install Spotify and configure common settings.
spotify: brew
ifeq ($(UNAME), Darwin)
	brew cask install spotify
	if [ ! $$(grep "storage.size" "$$HOME/Library/Application Support/Spotify/prefs") ] ; \
	then echo "storage.size=2048" >> "$$HOME/Library/Application Support/Spotify/prefs" ; \
	else echo "prefs already updated." ; \
	fi
endif

common_packages: brew sublime vagrant spotify android
ifeq ($(UNAME), Darwin)
	brew install htop
	brew install terraform
	brew cask install android-file-transfer
	brew cask install arq
	brew cask install bartender
	brew cask install caffeine
	brew cask install cd-to-iterm
	brew cask install clocker
	brew cask install db-browser-for-sqlite
	brew cask install docker
	brew cask install docker-toolbox
	brew cask install dropbox
	brew cask install firefox
	brew cask install franz
	brew cask install gfxcardstatus
	brew cask install google-chrome
	brew cask install grammarly
	brew cask install grandperspective
	brew cask install handbrake
	brew cask install iterm2
	brew cask install keka
	brew cask install private-internet-access
	brew cask install simplenote
	brew cask install spectacle
	brew cask install steam
	brew cask install teamviewer
	brew cask install tunnelblick
	brew cask install vlc
	brew cask install vnc-viewer
endif
ifeq ($(UNAME), Linux)
	apt-get update
	apt-get install \
		build-essential \
		curl \
		git \
		htop \
		lsb_release \
		make \
		software-properties-common \
		wget \
		python-pip \
		python3-pip \
		;
endif

# Common packages for Macs.
mac: ## Install common packages for Macs.
mac: osx

osx: ## Alias for `make mac`
osx: bootstrap
bootstrap: sublime vagrant zsh common_packages


.SILENT: help
.PHONY: help
help: ## This help dialog.
	echo -e  "You can run the following commands from this Makefile:\n"
	IFS=$$'\n' ; \
	help_lines=(`fgrep -h "## " $(MAKEFILE_LIST) | grep -v '^[#[:space:]]' | sed -e 's/\\$$//' | sort`) ; \
	for help_line in $${help_lines[@]}; do \
	    IFS=$$'#' ; \
	    help_split=($$help_line) ; \
	    help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
	    help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
	    printf "  %-40s %s\n" $$help_command $$help_info ; \
	done
