# PostgreSQL Setup on Arch

## 1. Install

```bash
sudo pacman -S postgresql
```

## 2. Initialize the database cluster

Run as the `postgres` user that the package creates:

```bash
sudo chown -R postgres:postgres /var/lib/postgres
sudo -iu postgres initdb -D /var/lib/postgres/data --locale=en_US.UTF-8 --encoding=UTF8
```

## 3. Start and enable the service

```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

## 4. Verify

```bash
sudo -iu postgres psql -c "SELECT version();"
```

## Enter the psql shell

```bash
sudo -u postgres psql
```

## Troubleshooting

If the service fails to start:

- Check the logs: `journalctl -u postgresql`
- Remove a leftover lock file: `/var/lib/postgres/data/postmaster.pid`
- As a last resort, re-initialize `/var/lib/postgres/data` (step 2).
