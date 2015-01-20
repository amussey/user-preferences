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
