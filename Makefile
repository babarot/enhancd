SHPEC_URL = https://raw.githubusercontent.com/rylnd/shpec/master/bin/shpec
SHPEC_BIN = .config/bin/shpec
SHOVE_URL = https://github.com/key-amb/shove
SHOVE_BIN = .config/bin/shove

.PHONY: all shpec test clean

all:

shpec:
	@test -f ./shpec || curl -L $(SHPEC_URL) -o $(SHPEC_BIN)
	@test -x $(SHPEC_BIN) || chmod 755 $(SHPEC_BIN)

test_: shpec
	@# do not use shebang
	@bash $(SHPEC_BIN) ./test/enhancd_test.sh
	@rm -rf $(SHPEC_BIN)

shove:
	@test -d $(SHOVE_BIN) || git clone $(SHOVE_URL) $(SHOVE_BIN)

test: shove
	@$(SHOVE_BIN)/bin/shove ./test/enhancd_test.sh

clean:
	rm -rf $(SHPEC_BIN)

release:
	git tag -a $(VERSION) -m $(VERSION)
	git push origin $(VERSION)
