UNAME := $(shell uname)

.PHONY: limechat

keybindings:
ifeq ($(UNAME), Darwin)
	-mkdir ~/Library/KeyBindings
	cp ./files/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding2.dict
endif

karabiner:
ifeq ($(UNAME), Darwin)
	cp ./files/Karabiner_private.xml ~/Library/Application\ Support/Karabiner/private.xml
	./files/Karabiner_settings.sh
endif

limechat:
ifeq ($(UNAME), Darwin)
	cp LimeChat/Themes/* ~/Library/Application\ Support/LimeChat/Themes/
endif

brew:
ifeq ($(UNAME), Darwin)
	command -v brew >/dev/null 2>&1 || { ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }
	brew install caskroom/cask/brew-cask
	brew tap caskroom/versions
endif

vagrant: brew
ifeq ($(UNAME), Darwin)
	brew cask install virtualbox
	brew cask install vagrant
	brew cask install vagrant-manager
endif

zsh: brew zshrc_files
ifeq ($(UNAME), Darwin)
	command -v zsh >/dev/null 2>&1 || { echo "ZSH already installed and configured."; exit 1; }
	brew install zsh
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	cp ./.zprezto/modules/prompt/functions/prompt_amussey_setup ~/.zprezto/modules/prompt/functions/prompt_amussey_setup
	cp ./.zpreztorc ~/.zpreztorc
	cp ./.zshrc ~/.zshrc
endif

sublime:
ifeq ($(UNAME), Darwin)
	command -v subl >/dev/null 2>&1 || { sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl; }
endif

photos:  # Stop Photos from automatically opening when an SD card is plugged in.
ifeq ($(UNAME), Darwin)
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
endif

save_panel:  # Make the save panel automatically expand.
ifeq ($(UNAME), Darwin)
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
endif

ffmpeg:  # Install ffmpeg.
ifeq ($(UNAME), Darwin)
	curl http://www.ffmpegmac.net/resources/SnowLeopard_Lion_Mountain_Lion_Mavericks_Yosemite_El-Captain_06.07.2016.zip -O
	unzip SnowLeopard_Lion_Mountain_Lion_Mavericks_Yosemite_El-Captain_06.07.2016.zip
	rm SnowLeopard_Lion_Mountain_Lion_Mavericks_Yosemite_El-Captain_06.07.2016.zip
	mv ff* /usr/local/bin
endif

zshrc_files:
	cp -r .zshrc-files ~

common_packages: brew
ifeq ($(UNAME), Darwin)
	brew install htop
endif

# Common packages for Macs.
mac: osx
osx: bootstrap
bootstrap: sublime vagrant zsh common_packages
