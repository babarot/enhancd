# shpec
TEST_FILE = enhancd.t
SHPEC_URL = https://raw.githubusercontent.com/rylnd/shpec/master/bin/shpec

.PHONY: all init test

all: init test

init:
	@test -x shpec || curl -L $(SHPEC_URL) -o shpec && chmod 755 shpec

test:
	@test -f $(TEST_FILE) || sed -e 's/::/_/g' enhancd.sh >$(TEST_FILE)
	./shpec $(PWD)/enhancd_test.sh
	@rm -f $(PWD)/$(TEST_FILE) $(PWD)/shpec

clean:
	rm -rf $(PWD)/$(TEST_FILE) $(PWD)/shpec
