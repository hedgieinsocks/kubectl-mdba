#!/usr/bin/env bats

setup() {
  bats_require_minimum_version 1.5.0
  load ../kubectl-mdba
  KMDBA_KUBECTL="${BATS_TEST_DIRNAME}/mock-kubectl"
}

@test "show_help: should succeed and print help message" {
  run -0 show_help
  [[ "${output}" =~ "kubectl mdba helps" ]]
}

@test "show_version: should succeed and print script version" {
  run -0 show_version
  [[ "${output}" =~ "kubectl mdba version" ]]
}

@test "check_globals: should succeed" {
  run -0 check_globals
}

@test "check_globals: should fail with 'KMDBA_BACKUP_THREADS is not allowed integer' error" {
  KMDBA_BACKUP_THREADS=10
  run -1 check_globals
  [[ "${output}" =~ "KMDBA_BACKUP_THREADS is not allowed integer" ]]
}

@test "check_globals: should fail with 'KMDBA_IGNORE_PRIMARY_MISMATCH is not allowed integer' error" {
  KMDBA_IGNORE_PRIMARY_MISMATCH=3
  run -1 check_globals
  [[ "${output}" =~ "KMDBA_IGNORE_PRIMARY_MISMATCH is not allowed integer" ]]
}

@test "check_globals: should fail with 'KMDBA_SKIP_CONFIRMATION is not allowed integer' error" {
  KMDBA_SKIP_CONFIRMATION=3
  run -1 check_globals
  [[ "${output}" =~ "KMDBA_SKIP_CONFIRMATION is not allowed integer" ]]
}

@test "check_globals: should fail with 'KMDBA_RECREATE_STEP is not allowed integer' error" {
  KMDBA_RECREATE_STEP=20
  run -1 check_globals
  [[ "${output}" =~ "KMDBA_RECREATE_STEP is not allowed integer" ]]
}

@test "check_globals: should fail with 'KMDBA_GTID is not set' error" {
  KMDBA_RECREATE_STEP=8
  run -1 check_globals
  echo "${output}"
  [[ "${output}" =~ "KMDBA_GTID is not set" ]]
}

@test "check_globals: should fail with 'KMDBA_STREAM_PORT is not allowed integer' error" {
  KMDBA_STREAM_PORT=99999
  run -1 check_globals
  [[ "${output}" =~ "KMDBA_STREAM_PORT is not allowed integer" ]]
}

@test "check_globals: should fail with 'KMDBA_BACKUP_DIR is not within' error" {
  KMDBA_BACKUP_DIR="/tmp/backup"
  run -1 check_globals
  [[ "${output}" =~ "KMDBA_BACKUP_DIR is not within" ]]
}

@test "check_globals: should fail with 'KMDBA_RESTORE_DIR is not within' error" {
  KMDBA_RESTORE_DIR="/tmp/restore"
  run -1 check_globals
  [[ "${output}" =~ "KMDBA_RESTORE_DIR is not within" ]]
}

@test "check_dependencies: should succeed" {
  alias jq=":"
  run -0 check_dependencies
}

@test "check_dependencies: should fail with 'not available' error" {
  PATH="" run -1 check_dependencies
  [[ "${output}" =~ "not available" ]]
}

@test "colorize: should succeed and print given text" {
  run -0 bats_pipe echo "hello world!" \| colorize yaml
  [[ "${output}" =~ "hello world!" ]]
}

@test "highlight: should succeed and print text in cyan" {
  run -0 highlight "${CYA}" "make me cyan"
  [[ "${output}" == "$(tput setaf 5)make me cyan$(tput sgr0)" ]]
}

@test "err: should fail with 'test error' error" {
  run -1 err "test error"
  [[ "${output}" =~ "test error" ]]
}

@test "step: should succeed and print formatted message" {
  run -0 step 1 replica mary-ok-1 "hedgehogs are cute"
  [[ "${output}" =~ 1/14.*replica.*mary-ok-1.*hedgehogs\ are\ cute ]]
}

@test "parse_input: should succeed" {
  run -0 parse_input
}

@test "parse_input: -h should succeed" {
  run -0 parse_input -h
}

@test "parse_input: --help should succeed" {
  run -0 parse_input --help
}

@test "parse_input: -v should succeed" {
  run -0 parse_input -v
}

@test "parse_input: --version should succeed" {
  run -0 parse_input --version
}

@test "parse_input: -n should succeed" {
  run -0 parse_input ls -n database
}

@test "parse_input: --namespace should succeed" {
  run -0 parse_input ls --namespace database
}

@test "parse_input: -n should fail with 'requires an argument' error" {
  run -1 parse_input ls -n
  [[ "${output}" =~ "requires an argument" ]]
}

@test "parse_input: --namespace should fail with 'requires an argument' error" {
  run -1 parse_input ls --namespace
  [[ "${output}" =~ "requires an argument" ]]
}

@test "parse_input: -y should succeed" {
  run -0 parse_input -y
}

@test "parse_input: --yes should succeed" {
  run -0 parse_input --yes
}

@test "parse_input: -p should succeed" {
  run -0 parse_input recreate mary-ok-1 -p 5555
}

@test "parse_input: --port should succeed" {
  run -0 parse_input recreate mary-ok-1 --port 5555
}

@test "parse_input: -p should fail with 'requires an argument' error" {
  run -1 parse_input recreate mary-ok-1 -p
  [[ "${output}" =~ "requires an argument" ]]
}

@test "parse_input: --port should fail with 'requires an argument' error" {
  run -1 parse_input recreate mary-ok-1 --port
  [[ "${output}" =~ "requires an argument" ]]
}

@test "parse_input: -t should succeed" {
  run -0 parse_input recreate mary-ok-1 -t 4
}

@test "parse_input: --threads should succeed" {
  run -0 parse_input recreate mary-ok-1 --threads 4
}

@test "parse_input: -t should fail with 'requires an argument' error" {
  run -1 parse_input recreate mary-ok-1 -t
  [[ "${output}" =~ "requires an argument" ]]
}

@test "parse_input: --threads should fail with 'requires an argument' error" {
  run -1 parse_input recreate mary-ok-1 --threads
  [[ "${output}" =~ "requires an argument" ]]
}

@test "parse_input: -s should succeed" {
  run -0 parse_input recreate mary-ok-1 -s 4
}

@test "parse_input: --step should succeed" {
  run -0 parse_input recreate mary-ok-1 --step 4
}

@test "parse_input: -s should fail with 'requires an argument' error" {
  run -1 parse_input recreate mary-ok-1 -s
  [[ "${output}" =~ "requires an argument" ]]
}

@test "parse_input: --step should fail with 'requires an argument' error" {
  run -1 parse_input recreate mary-ok-1 --step
  [[ "${output}" =~ "requires an argument" ]]
}

@test "parse_input: -f should succeed" {
  run -0 parse_input recreate mary-ok-1 -f
}

@test "parse_input: --force should succeed" {
  run -0 parse_input recreate mary-ok-1 --force
}

@test "parse_input: -m should fail with 'invalid option' error" {
  run -1 parse_input recreate -m
  [[ "${output}" =~ "invalid option" ]]
}

@test "parse_input: --moo should fail with 'invalid option' error" {
  run -1 parse_input recreate --moo
  [[ "${output}" =~ "invalid option" ]]
}

@test "parse_input: foo should fail with 'invalid command' error" {
  run -1 parse_input foo
  [[ "${output}" =~ "invalid command" ]]
}

@test "parse_input: ls should succeed" {
  run -0 parse_input ls
}

@test "parse_input: ls mary-ok should succeed" {
  run -0 parse_input ls mary-ok
}

@test "parse_input: ls should fail with 'multiple targets provided' error" {
  run -1 parse_input ls mary-ok mary-bad
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: top should succeed" {
  run -0 parse_input top
}

@test "parse_input: top mary-ok should succeed" {
  run -0 parse_input top mary-ok
}

@test "parse_input: top should fail with 'multiple targets provided' error" {
  run -1 parse_input top mary-ok mary-bad
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: status should succeed" {
  run -0 parse_input status mary-ok
}

@test "parse_input: status should fail with 'no target provided' error" {
  run -1 parse_input status
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: status should fail with 'multiple targets provided' error" {
  run -1 parse_input status mary-ok mary-bad
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: suspend should succeed" {
  run -0 parse_input suspend mary-ok
}

@test "parse_input: suspend should fail with 'no target provided' error" {
  run -1 parse_input suspend
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: suspend should fail with 'multiple targets provided' error" {
  run -1 parse_input suspend mary-ok mary-bad
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: unsuspend should succeed" {
  run -0 parse_input unsuspend mary-ok
}

@test "parse_input: unsuspend should fail with 'no target provided' error" {
  run -1 parse_input unsuspend
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: unsuspend should fail with 'multiple targets provided' error" {
  run -1 parse_input unsuspend mary-ok mary-bad
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: enter should succeed" {
  run -0 parse_input enter mary-ok-0
}

@test "parse_input: enter should fail with 'no target provided' error" {
  run -1 parse_input enter
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: enter should fail with 'multiple targets provided' error" {
  run -1 parse_input enter mary-ok-1 mary-ok-2
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: sql should succeed" {
  run -0 parse_input sql mary-ok-0
}

@test "parse_input: sql should fail with 'no target provided' error" {
  run -1 parse_input sql
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: sql should fail with 'multiple targets provided' error" {
  run -1 parse_input sql mary-ok-1 mary-ok-2
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: proc should succeed" {
  run -0 parse_input proc mary-ok-0
}

@test "parse_input: proc should fail with 'no target provided' error" {
  run -1 parse_input proc
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: proc should fail with 'multiple targets provided' error" {
  run -1 parse_input proc mary-ok-1 mary-ok-2
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: du should succeed" {
  run -0 parse_input du mary-ok-0
}

@test "parse_input: du should fail with 'no target provided' error" {
  run -1 parse_input du
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: du should fail with 'multiple targets provided' error" {
  run -1 parse_input du mary-ok-1 mary-ok-2
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: repl should succeed" {
  run -0 parse_input repl mary-ok-1
}

@test "parse_input: repl should fail with 'no target provided' error" {
  run -1 parse_input repl
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: repl should fail with 'multiple targets provided' error" {
  run -1 parse_input repl mary-ok-1 mary-ok-2
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: prom should succeed" {
  run -0 parse_input prom mary-ok-1
}

@test "parse_input: prom should fail with 'no target provided' error" {
  run -1 parse_input prom
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: prom should fail with 'multiple targets provided' error" {
  run -1 parse_input prom mary-ok-1 mary-ok-2
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "parse_input: recreate should succeed" {
  run -0 parse_input recreate mary-ok-1
}

@test "parse_input: recreate should fail with 'no target provided' error" {
  run -1 parse_input recreate
  [[ "${output}" =~ "no target provided" ]]
}

@test "parse_input: recreate should fail with 'multiple targets provided' error" {
  run -1 parse_input recreate mary-ok-1 mary-ok-2
  [[ "${output}" =~ "multiple targets provided" ]]
}

@test "get_pod: should succeed" {
  run -0 get_pod mary-ok-0
}

@test "get_pod: should fail with 'not found' error" {
  run -1 get_pod mary-fake-0
  [[ "${output}" =~ "not found" ]]
}

@test "get_pod: should fail with 'not a mariadb pod' error" {
  run -1 get_pod not-mary-0
  [[ "${output}" =~ "not a mariadb pod" ]]
}

@test "get_mariadb: should succeed" {
  run -0 get_mariadb mary-ok
}

@test "get_mariadb: should fail with 'not found' error" {
  run -1 get_mariadb mary-fake
  [[ "${output}" =~ "not found" ]]
}

@test "assert_replication_enabled: should succeed" {
  MARIADB_REPLICATION="true"
  run -0 assert_replication_enabled
}

@test "assert_replication_enabled: should fail with 'replication is disabled' error" {
  MARIADB_REPLICATION=""
  run -1 assert_replication_enabled
  [[ "${output}" =~ "replication is disabled" ]]
}

@test "is_suspended: should succeed" {
  MARIADB_SUSPEND="true"
  run -0 is_suspended
}

@test "is_suspended: should fail" {
  MARIADB_SUSPEND="false"
  run -1 is_suspended
}

@test "is_primary_index_mismatched: should succeed" {
  MARIADB_DESIRED_PRIMARY_INDEX=0
  MARIADB_CURRENT_PRIMARY_INDEX=0
  run -0 is_primary_index_mismatched
}

@test "is_primary_index_mismatched: should fail with 'aborted due to mismatched' error" {
  MARIADB_DESIRED_PRIMARY_INDEX=0
  MARIADB_CURRENT_PRIMARY_INDEX=1
  run -1 is_primary_index_mismatched
  [[ "${output}" =~ "aborted due to mismatched" ]]
}

@test "is_replica: should succeed" {
  MARIADB_CURRENT_PRIMARY_INDEX=0
  run -0 is_replica mary-ok-1
}

@test "is_replica: should fail with 'not a replica' error" {
  MARIADB_CURRENT_PRIMARY_INDEX=0
  run -1 is_replica mary-ok-0
  [[ "${output}" =~ "is not a replica" ]]
}

@test "suspend_mariadb: should succeed" {
  run -0 suspend_mariadb mary-ok
}

@test "unsuspend_mariadb: should succeed" {
  run -0 suspend_mariadb mary-suspended
}

@test "mdba_ls: should succeed and print all resources" {
  run -0 mdba_ls
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

@test "mdba_ls: should succeed and print only matched resources" {
  KMDBA_TARGET="mary-boo"
  run -0 mdba_ls
  [[ "${lines[1]}" =~ "mary-boo" ]]
  [[ "${lines[3]}" =~ "mary-boo-0" ]]
  [[ "${lines[4]}" =~ "mary-boo-1" ]]
}

@test "mdba_status: should succeed" {
  KMDBA_TARGET="mary-ok"
  run -0 mdba_status
  [[ "${output}" =~ "automaticFailover" ]]
}

@test "mdba_suspend: should succeed" {
  KMDBA_TARGET="mary-ok"
  run -0 mdba_suspend
  [[ "${output}" == "mariadb.k8s.mariadb.com/mary-ok patched" ]]
}

@test "mdba_suspend: should fail with 'already suspended' error" {
  KMDBA_TARGET="mary-suspended"
  run -1 mdba_suspend
  [[ "${output}" =~ "already suspended" ]]
}

@test "mdba_unsuspend: should succeed" {
  KMDBA_TARGET="mary-suspended"
  run -0 mdba_unsuspend
  [[ "${output}" == "mariadb.k8s.mariadb.com/mary-suspended patched" ]]
}

@test "mdba_unsuspend: should fail with 'not suspended' error" {
  KMDBA_TARGET="mary-ok"
  run -1 mdba_unsuspend
  [[ "${output}" =~ "not suspended" ]]
}

@test "mdba_top: should succeed and print all resources" {
  run -0 mdba_top
  [[ "${lines[1]}" =~ "mary-foo-0" ]]
  [[ "${lines[2]}" =~ "mary-foo-1" ]]
  [[ "${lines[3]}" =~ "mary-boo-0" ]]
  [[ "${lines[4]}" =~ "mary-boo-1" ]]
  [[ "${lines[5]}" =~ "mary-moo-0" ]]
  [[ "${lines[6]}" =~ "mary-moo-1" ]]
}

@test "mdba_top: should succeed and print only matched resources" {
  KMDBA_TARGET="mary-boo"
  run -0 mdba_top
  [[ "${lines[1]}" =~ "mary-boo-0" ]]
  [[ "${lines[2]}" =~ "mary-boo-1" ]]
}

@test "mdba_repl: should succeed and print replication info" {
  KMDBA_TARGET="mary-ok-1"
  run -0 mdba_repl
  [[ "${output}" =~ "Last_SQL_Error" ]]
}

@test "mdba_repl: should fail with 'not a replica' error" {
  KMDBA_TARGET="mary-ok-0"
  run -1 mdba_repl
  [[ "${output}" =~ "not a replica" ]]
}

@test "mdba_repl: should fail with 'replication is disabled' error" {
  KMDBA_TARGET="mary-norepl-0"
  run -1 mdba_repl
  [[ "${output}" =~ "replication is disabled" ]]
}

@test "mdba_skip: should succeed and print replication info" {
  KMDBA_TARGET="mary-ok-1"
  run -0 mdba_skip
  [[ "${output}" =~ "Last_SQL_Error" ]]
}

@test "mdba_skip: should fail with 'not a replica' error" {
  KMDBA_TARGET="mary-ok-0"
  run -1 mdba_repl
  [[ "${output}" =~ "not a replica" ]]
}

@test "mdba_skip: should fail with 'replication is disabled' error" {
  KMDBA_TARGET="mary-norepl-0"
  run -1 mdba_skip
  [[ "${output}" =~ "replication is disabled" ]]
}

@test "mdba_prom: should fail with 'not a replica' error" {
  KMDBA_TARGET="mary-ok-0"
  run -1 mdba_prom
  [[ "${output}" =~ "not a replica" ]]
}

@test "mdba_prom: should fail with 'replication is disabled' error" {
  KMDBA_TARGET="mary-norepl-0"
  run -1 mdba_prom
  [[ "${output}" =~ "replication is disabled" ]]
}

@test "mdba_prom: should fail with 'aborted due to mismatch' error" {
  KMDBA_TARGET="mary-switch-1"
  run -1 mdba_prom
  [[ "${output}" =~ "aborted due to mismatch" ]]
}

@test "mdba_recreate: should fail with 'not a replica' error" {
  KMDBA_TARGET="mary-ok-0"
  run -1 mdba_recreate
  [[ "${output}" =~ "not a replica" ]]
}

@test "mdba_recreate: should fail with 'replication is disabled' error" {
  KMDBA_TARGET="mary-norepl-0"
  run -1 mdba_recreate
  [[ "${output}" =~ "replication is disabled" ]]
}

@test "mdba_recreate: should fail with 'aborted due to mismatch' error" {
  KMDBA_TARGET="mary-switch-1"
  run -1 mdba_recreate
  [[ "${output}" =~ "aborted due to mismatch" ]]
}
