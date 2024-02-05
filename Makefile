all: install

.PHONY: install update doc gz
install:
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
doc:
gz:
