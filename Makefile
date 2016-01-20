SHPEC_URL = https://raw.githubusercontent.com/rylnd/shpec/master/bin/shpec

.PHONY: all shpec test clean

all:

shpec:
	@test -f ./shpec || curl -L $(SHPEC_URL) -o shpec
	@test -x ./shpec || chmod 755 ./shpec

test: shpec
	@./shpec ./test/enhancd_test.sh
	@rm -rf ./shpec

clean:
	rm -rf ./shpec
