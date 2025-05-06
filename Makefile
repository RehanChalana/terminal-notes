INSTALL_PATH=/usr/local/bin/tnotes
SCRIPT_PATH=$(CURDIR)/note.sh

install:
	chmod +x note.sh
	sudo ln -sf $(SCRIPT_PATH) $(INSTALL_PATH)
	@echo "Installed as 'tnotes'"

uninstall:
	sudo rm -f $(INSTALL_PATH)
	@echo "Uninstalled 'tnotes' command"