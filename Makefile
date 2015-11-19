# shpec
SHPEC_URL = https://raw.githubusercontent.com/rylnd/shpec/master/bin/shpec

.PHONY: all init test

all: init test

init:
	@test -x shpec || curl -L $(SHPEC_URL) -o shpec

test:
	@bash shpec test/enhancd_test.sh
	@rm -rf ./shpec

clean:
	rm -rf ./shpec
