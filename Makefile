UNAME := $(shell uname)

.PHONY: limechat

keybindings:
ifeq ($(UNAME), Darwin)
	-mkdir ~/Library/KeyBindings
	cp ./files/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding2.dict
endif


limechat:
ifeq ($(UNAME), Darwin)
	cp LimeChat/Themes/* ~/Library/Application\ Support/LimeChat/Themes/
endif
