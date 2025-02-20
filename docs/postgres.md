# Postgresql notes

## Commands

```bash
brew services start postgresql # brew services start postgresql@14
initdb -E UTF-8 /usr/local/bin/postgresql
pg_ctl -D /usr/local/bin/postgresql -l logfile start
sudo lsof -i :5432
sudo pkill -u postgres
```
