test -f "$TESTDIR/.zcompdump" && rm "$TESTDIR/.zcompdump"

source "$TESTDIR/../enhancd.sh"
export ENV_AUTHORIZATION_FILE="$PWD/.env_auth"
