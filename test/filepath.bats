# load ../src/filepath.sh

setup() {
  source $BATS_TEST_DIRNAME/../src/filepath.sh
  source $BATS_TEST_DIRNAME/../src/command.sh
}

@test "__enhancd::filepath::split_list" {
  run __enhancd::filepath::split_list
  [ "${status}" -eq 1 ]

  run __enhancd::filepath::split_list non_exists_commnad:echo:ls
  [ "${output}" = "echo" ]

  run __enhancd::filepath::split_list non_exists_commnad:ls
  [ "${output}" = "ls" ]
}
