### PostgreSQL Setup on Arch

1. **Install**

```bash
sudo pacman -S postgresql
```

2. **Init database cluster**

```bash
sudo chown -R postgres:postgres /var/lib/postgres
sudo -iu postgres initdb -D /var/lib/postgres/data --locale=en_US.UTF-8 --encoding=UTF8
```

3. **Start + Enable service**

```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

4. **Verify**

```bash
sudo -iu postgres psql -c "SELECT version();"
```

---

If service fails → check logs, remove leftover `postmaster.pid`, or re-init `/var/lib/postgres/data`.

---
### Enter psql shell:
```
sudo -u postgres psql
```



