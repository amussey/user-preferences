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

zsh: brew
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
	command -v subl >/dev/null 2>&1 || { sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/bin/subl; }
endif

bootstrap: sublime vagrant zsh
