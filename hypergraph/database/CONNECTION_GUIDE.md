# Database Connection Quick Reference

This document provides quick reference for connecting to the SCMLex Hypergraph PostgreSQL database.

## Connection String Format

The Neon PostgreSQL connection string follows this format:

```
postgresql://[username]:[password]@[host]/[database]?sslmode=require&channel_binding=require
```

## Example Connection

```bash
# Using psql directly
psql 'postgresql://neondb_owner:npg_Grj0PVmlpZI7@ep-empty-thunder-a8k9q552-pooler.eastus2.azure.neon.tech/neondb?sslmode=require&channel_binding=require'

# Using environment variable (recommended)
export DATABASE_URL='postgresql://neondb_owner:your_password@your-host.neon.tech/neondb?sslmode=require&channel_binding=require'
psql $DATABASE_URL
```

## Python Connection

```python
import psycopg2
from psycopg2.extras import RealDictCursor

# Using connection string
conn = psycopg2.connect(
    "postgresql://neondb_owner:your_password@your-host.neon.tech/neondb?sslmode=require&channel_binding=require"
)

# Or using individual parameters
conn = psycopg2.connect(
    host="your-host.neon.tech",
    port=5432,
    database="neondb",
    user="neondb_owner",
    password="your_password",
    sslmode="require"
)

cursor = conn.cursor(cursor_factory=RealDictCursor)
cursor.execute("SELECT version();")
print(cursor.fetchone())
conn.close()
```

## Using the Utility Script

The `db_connect.py` utility provides convenience commands:

```bash
# Test connection
python hypergraph/db_connect.py --test

# Initialize schema
python hypergraph/db_connect.py --init

# Load data
python hypergraph/db_connect.py --load

# Run query
python hypergraph/db_connect.py --query "SELECT * FROM v_hypergraph_statistics;"
```

## Common Queries

```sql
-- Get all principles
SELECT * FROM v_level1_principles;

-- Find contract principles
SELECT * FROM find_principles_by_domain('contract');

-- Search for keywords
SELECT * FROM search_nodes('contract');

-- Get statistics
SELECT * FROM v_hypergraph_statistics;
```

## Troubleshooting

### Connection Refused
- Check that the host is correct
- Verify SSL mode is set to 'require'
- Ensure your IP is whitelisted in Neon console

### Authentication Failed
- Verify username and password are correct
- Check that the database name is correct
- Ensure URL encoding for special characters in password

### SSL/TLS Issues
- Ensure `sslmode=require` is in the connection string
- For enhanced security, use `channel_binding=require`
- Update psycopg2: `pip install --upgrade psycopg2-binary`

## Security Best Practices

1. **Never commit credentials** - Use `.env` files (excluded via `.gitignore`)
2. **Use environment variables** - Store `DATABASE_URL` in environment
3. **Enable SSL** - Always use `sslmode=require`
4. **Rotate passwords** - Change database passwords periodically
5. **Limit access** - Use IP whitelisting in Neon console
6. **Use read-only users** - For query-only applications

## Resources

- [Neon Documentation](https://neon.tech/docs)
- [psycopg2 Documentation](https://www.psycopg.org/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
