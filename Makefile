SHPEC_URL = https://raw.githubusercontent.com/rylnd/shpec/master/bin/shpec
SHPEC_BIN = .bin/shpec
SHOVE_URL = https://github.com/key-amb/shove
SHOVE_BIN = .config/bin/shove
VERSION   = $(_ENHANCD_VERSION)

.PHONY: all shpec test_ shove test clean man

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
	$(SHOVE_BIN)/bin/shove ./test/*_test.sh

clean:
	rm -rf $(SHPEC_BIN)

release:
	git tag -a $(VERSION) -m $(VERSION)
	git push origin $(VERSION)

man:
	a2x \
		--format=manpage \
		--doctype=manpage \
		--destination=doc/man/man1 \
		doc/enhancd.txt
	rm doc/enhancd.xml
