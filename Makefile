SHPEC_URL = https://raw.githubusercontent.com/rylnd/shpec/master/bin/shpec
SHPEC_BIN = .config/bin/shpec

.PHONY: all shpec test clean

all:

shpec:
	@test -f ./shpec || curl -L $(SHPEC_URL) -o $(SHPEC_BIN)
	@test -x $(SHPEC_BIN) || chmod 755 $(SHPEC_BIN)

test: shpec
	@# do not use shebang
	@bash $(SHPEC_BIN) ./test/enhancd_test.sh
	@rm -rf $(SHPEC_BIN)

clean:
	rm -rf $(SHPEC_BIN)
