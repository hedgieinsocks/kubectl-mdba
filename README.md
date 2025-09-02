![kubectl-mdba project cover](img/cover.png)

# 🦭 kubectl-mdba

`kubectl-mdba` (mariadb administrator) is a `kubectl` plugin that helps manage [mariadb-operator](https://github.com/mariadb-operator) semi-sync replication clusters

## Disclaimer

* This project is not affiliated with MariaDB Foundation or MariaDB Operator in any way.
* It has not been verified by MariaDB Operator, and no representations are made regarding the quality of the upstream software.
* Intended for mariadb-operator `v25.8.2`

## Dependencies

* `jq` - https://github.com/jqlang/jq

Optionally, you can install the following tools to improve the output of some commands:

* `bat` - https://github.com/sharkdp/bat
* `yq` -  https://github.com/mikefarah/yq (or https://github.com/kislyuk/yq)

## Installation

### Krew

```sh
❯ kubectl krew install mdba
```

### Manual

Place `kubectl-mdba` into the directory within your `$PATH` (e.g. `~/.local/bin`)

### Completion

Place `kubectl_complete-mdba` into the directory within your `$PATH` (e.g. `~/.local/bin`)

## Customization

You can `export` the following variables to tweak the plugin's behaviour.

| VARIABLE                        | DEFAULT                        | DETAILS                                                                    |
|---------------------------------|--------------------------------|----------------------------------------------------------------------------|
| `KMDBA_KUBECTL`                 | `kubectl`                      | kubectl binary name                                                        |
| `KMDBA_NAMESPACE`               | `default`                      | default k8s namespace                                                      |
| `KMDBA_RECREATE_STEP`           | `1`                            | initial step number from `1` to `14` for replica recreation                |
| `KMDBA_BACKUP_THREADS`          | `1`                            | number of threads from `1` to `8` to use for parallel datafiles transfer   |
| `KMDBA_STREAM_PORT`             | `4444`                         | default port from `1024` to `65535` for backup stream                      |
| `KMDBA_SKIP_CONFIRMATION`       | `0`                            | skip confirmation                  |
| `KMDBA_IGNORE_PRIMARY_MISMATCH` | `0`                            | ignore mismatched desired and current primary pod indexes                  |
| `KMDBA_BACKUP_DIR`              | `/var/lib/mysql/.kmdba_backup`  | tmp directory in `/var/lib/mysql/` to accept backup stream                 |
| `KMDBA_RESTORE_DIR`             | `/var/lib/mysql/.kmdba_restore` | tmp directory in `/var/lib/mysql/` for restored backup                     |

## Usage

```
kubectl mdba helps manage mariadb-operator semi-sync replication clusters

Usage:
  kubectl mdba <command> [<target>]

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
  skip <replica>            skip erroneous transactions
  prom <replica>            promote replica to primary
  recreate <replica>        recreate replica from primary

Flags:
  -h, --help                show this message
  -v, --version             show plugin version
  -n, --namespace <ns>      set namespace scope
  -y, --yes                 skip confirmation

Recreate Flags:
  -f, --force               ignore primary index mismatch
  -p, --port <num>          port for backup stream (default: 4444)
  -t, --threads <num>       parallel threads {1..8} for datafiles transfer (default: 1)
  -s, --step <num>          step {1..14} to start from (default: 1)
```

## Links

* https://mariadb.com/kb/en/setting-up-a-replica-with-mariabackup
* https://github.com/mariadb-operator/mariadb-operator/issues/141
