![kubectl-mdb project cover](img/cover.png)

# 🦭 kubectl-mdb

`kubectl-mdb` is a `kubectl` plugin that helps interact with [mariadb-operator](https://github.com/mariadb-operator) semi-sync replication clusters.

## Disclaimer

* This project is not affiliated with MariaDB Foundation or MariaDB Operator in any way.
* It has not been verified by MariaDB Operator, and no representations are made regarding the quality of the upstream software.
* Written for mariadb-operator `v0.36.0`

## Dependencies

* `jq` - https://github.com/jqlang/jq

Optionally, you can install the following tools to improve the output of some commands:

* `bat` - https://github.com/sharkdp/bat
* `yq` -  https://github.com/mikefarah/yq (or https://github.com/kislyuk/yq)

## Installation

Place `kubectl-mdb` (and optionally `kubectl_complete-mdb`) into the directory within your `PATH` (e.g. `~/.local/bin` or `~/.krew/bin`)

## Customization

You can `export` the following variables to tweak the plugin's behaviour.

| VARIABLE              | DEFAULT                        | DETAILS                                                                    |
|-----------------------|--------------------------------|----------------------------------------------------------------------------|
| `KMDB_KUBECTL`        | `kubectl`                      | kubectl binary name                                                        |
| `KMDB_NAMESPACE`      | `default`                      | default k8s namespace                                                      |
| `KMDB_BACKUP_THREADS` | `1`                            | number of threads from `1` to `8` to use for parallel datafiles transfer   |
| `KMDB_BACKUP_DIR`     | `/var/lib/mysql/.kmdb_backup`  | tmp directory in `/var/lib/mysql/` to accept backup stream                 |
| `KMDB_RESTORE_DIR`    | `/var/lib/mysql/.kmdb_restore` | tmp directory in `/var/lib/mysql/` for restored backup                     |
| `KMDB_STREAM_PORT`    | `4444`                         | default port from `1024` to `65535` for backup stream                      |

## Usage

```
kubectl mdb helps interact with mariadb-operator semi-sync replication clusters

Usage:
  kubectl mdb <command> [<target>]

Commands:
  ls [<mariadb>]            list mariadbs with their pods
  status <mariadb>          check mariadb status
  suspend <mariadb>         pause mariadb reconciliation
  unsuspend <mariadb>       resume mariadb reconciliation
  enter <pod>               exec into pod
  sql <pod>                 launch mariadb shell
  proc <pod>                print processlist
  du <pod>                  calculate database disk usage
  top [<pod>]               display cpu and ram usage
  repl <replica>            check replication status
  prom <replica>            promote replica to primary
  recreate <replica>        recreate replica from primary

Flags:
  -n, --namespace <ns>      set namespace scope
  -v, --version             show plugin version
  -h, --help                show this message
```

## Links

* https://mariadb.com/kb/en/setting-up-a-replica-with-mariabackup
* https://github.com/mariadb-operator/mariadb-operator/issues/141
