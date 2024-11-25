#!/usr/bin/env bats

KMDB="${BATS_TEST_DIRNAME}/../kubectl-mdb"

setup() {
  export KMDB_KUBECTL="${BATS_TEST_DIRNAME}/mock-kubectl"
  bat() { cat; }; export -f bat
}

@test "no args: should fail and show 'no command provided' error" {
  run "${KMDB}"
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "no command provided" ]]
}

@test "-h: should succeed and show help" {
  run "${KMDB}" -h
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${lines[0]}" =~ "kubectl mdb helps" ]]
}

@test "--help: should succeed and show help" {
  run "${KMDB}" --help
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${lines[0]}" =~ "kubectl mdb helps" ]]
}

@test "-v: should succeed and show plugin version" {
  run "${KMDB}" -v
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${output}" =~ "kubectl mdb version" ]]
}

@test "--version: should succeed and show plugin version" {
  run "${KMDB}" --version
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${output}" =~ "kubectl mdb version" ]]
}

@test "-n: should fail and show 'requires an argument' error" {
  run "${KMDB}" status mary-ok -n
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "requires an argument" ]]
}

@test "-f: should fail and show 'invalid option' error" {
  run "${KMDB}" status mary-ok -f
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "invalid option" ]]
}

@test "--fake: should fail and show 'invalid option' error" {
  run "${KMDB}" status mary-ok --fake
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "invalid option" ]]
}

@test "fake: should fail and show 'invalid command' error" {
  run "${KMDB}" fake
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "invalid command" ]]
}

@test "ls: should succeed and show all resources" {
  run "${KMDB}" ls
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${lines[1]}" =~ "mary-foo" ]]
  [[ "${lines[2]}" =~ "mary-boo" ]]
  [[ "${lines[3]}" =~ "mary-moo" ]]
  [[ "${lines[5]}" =~ "mary-foo-0" ]]
  [[ "${lines[6]}" =~ "mary-foo-1" ]]
  [[ "${lines[7]}" =~ "mary-boo-0" ]]
  [[ "${lines[8]}" =~ "mary-boo-1" ]]
  [[ "${lines[9]}" =~ "mary-moo-0" ]]
  [[ "${lines[10]}" =~ "mary-moo-1" ]]
}

@test "ls: should succeed and show matched resources" {
  run "${KMDB}" ls mary-boo
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${lines[1]}" =~ "mary-boo" ]]
  [[ "${lines[3]}" =~ "mary-boo-0" ]]
  [[ "${lines[4]}" =~ "mary-boo-1" ]]
}

@test "status: should succeed and show yaml output" {
  run "${KMDB}" status mary-ok
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${lines[0]}" =~ "automaticFailover: true" ]]
}

@test "status: should fail and show 'not found' error" {
  run "${KMDB}" status mary-fake
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not found" ]]
}

@test "status: should fail and show 'no target provided' error" {
  run "${KMDB}" status
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "no target provided" ]]
}

@test "status: should fail and show 'multiple targets provided' error" {
  run "${KMDB}" status mary-ok mary-fake
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "suspend: should succeed and show patched message" {
  run "${KMDB}" suspend mary-ok
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "mariadb.k8s.mariadb.com/mary-ok patched" ]]
}

@test "suspend: should fail and show 'already suspended' error" {
  run "${KMDB}" suspend mary-suspended
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "already suspended" ]]
}

@test "unsuspend: should succeed and print patched message" {
  run "${KMDB}" unsuspend mary-suspended
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${output}" == "mariadb.k8s.mariadb.com/mary-suspended patched" ]]
}

@test "unsuspend: should fail and show 'not suspended' error" {
  run "${KMDB}" unsuspend mary-ok
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not suspended" ]]
}

@test "enter: should succeed" {
  run "${KMDB}" enter mary-ok-0
  echo "${output}"
  [[ "${status}" -eq 0 ]]
}

@test "enter: should fail and show 'not found' error" {
  run "${KMDB}" enter mary-fake-0
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not found" ]]
}

@test "enter: should fail and show 'not a mariadb pod' error" {
  run "${KMDB}" enter not-mary-0
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not a mariadb pod" ]]
}

@test "enter: should fail and show 'no target provided' error" {
  run "${KMDB}" enter
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "no target provided" ]]
}

@test "enter: should fail and show 'multiple targets provided' error" {
  run "${KMDB}" enter mary-ok-0 mary-ok-1
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "top: should succeed and show all resources" {
  run "${KMDB}" top
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${lines[1]}" =~ "mary-foo-0" ]]
  [[ "${lines[2]}" =~ "mary-foo-1" ]]
  [[ "${lines[3]}" =~ "mary-boo-0" ]]
  [[ "${lines[4]}" =~ "mary-boo-1" ]]
  [[ "${lines[5]}" =~ "mary-moo-0" ]]
  [[ "${lines[6]}" =~ "mary-moo-1" ]]
}

@test "top: should succeed and show matched resources" {
  run "${KMDB}" top mary-boo
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${lines[1]}" =~ "mary-boo-0" ]]
  [[ "${lines[2]}" =~ "mary-boo-1" ]]
}

@test "repl: should succeed and show replication info" {
  run "${KMDB}" repl mary-ok-1
  echo "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${lines[0]}" == "Last_SQL_Error:" ]]
}

@test "repl: should fail and show 'not a replica' error" {
  run "${KMDB}" repl mary-ok-0
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not a replica" ]]
}

@test "repl: should fail and show 'replication is disabled' error" {
  run "${KMDB}" repl mary-norepl-0
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "replication is disabled" ]]
}

@test "prom: should fail and show 'not a replica' error" {
  run "${KMDB}" prom mary-ok-0
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not a replica" ]]
}

@test "prom: should fail and show 'replication is disabled' error" {
  run "${KMDB}" prom mary-norepl-0
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "replication is disabled" ]]
}

@test "prom: should fail and show 'aborted due to mismatch' error" {
  run "${KMDB}" prom mary-switch-1
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "aborted due to mismatch" ]]
}

@test "recreate: should fail and show 'not a replica' error" {
  run "${KMDB}" recreate mary-ok-0
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not a replica" ]]
}

@test "recreate: should fail and show 'replication is disabled' error" {
  run "${KMDB}" recreate mary-norepl-0
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "replication is disabled" ]]
}

@test "recreate: should fail and show 'aborted due to mismatch' error" {
  run "${KMDB}" recreate mary-switch-1
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "aborted due to mismatch" ]]
}

@test "recreate: should fail and show 'not allowed integer' error 1" {
  KMDB_BACKUP_THREADS=10 run "${KMDB}" recreate mary-switch-1
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not allowed integer" ]]
}

@test "recreate: should fail and show 'not allowed integer' error 2" {
  KMDB_STREAM_PORT=678 run "${KMDB}" recreate mary-switch-1
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not allowed integer" ]]
}

@test "recreate: should fail and show 'not within /var/lib/mysql/' error 1" {
  KMDB_BACKUP_DIR=/var/lib/tmp/backup run "${KMDB}" recreate mary-switch-1
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not within /var/lib/mysql/" ]]
}

@test "recreate: should fail and show 'not within /var/lib/mysql/' error 2" {
  KMDB_RESTORE_DIR=/var/lib/tmp/restore run "${KMDB}" recreate mary-switch-1
  echo "${output}"
  [[ "${status}" -eq 1 ]]
  [[ "${output}" =~ "not within /var/lib/mysql/" ]]
}
