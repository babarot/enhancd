#!/bin/bash

cat <<EOT
test: shpec
	@# do not use shebang
	@bash shpec ./test/enhancd_test.sh
	@rm -rf ./shpec

clean:
	rm -rf ./shpec
EOT
