# SCMLex Hypergraph Database Integration

This directory contains the database schema and utilities for integrating the SCMLex Hypergraph with PostgreSQL (Neon/Supabase).

## Quick Start

### 1. Prerequisites

Install required Python packages:

```bash
pip install psycopg2-binary python-dotenv
```

### 2. Configure Database Connection

Copy the example environment file and add your database credentials:

```bash
cp .env.example .env
```

Edit `.env` and update with your Neon database connection string:

```bash
DATABASE_URL=postgresql://neondb_owner:your_password@your-host.neon.tech/neondb?sslmode=require&channel_binding=require
```

**Example Connection String Format:**
```
postgresql://neondb_owner:npg_Grj0PVmlpZI7@ep-empty-thunder-a8k9q552-pooler.eastus2.azure.neon.tech/neondb?sslmode=require&channel_binding=require
```

### 3. Test Connection

```bash
python hypergraph/db_connect.py --test
```

### 4. Initialize Database Schema

```bash
python hypergraph/db_connect.py --init
```

This will create all necessary tables, indexes, views, and functions.

### 5. Load Hypergraph Data

```bash
# First, ensure tuples.json is generated
python hypergraph/build_hypergraph.py

# Then load into database
python hypergraph/db_connect.py --load
```

## Usage

### Using the Database Utility

The `db_connect.py` utility provides several commands:

```bash
# Test database connection
python hypergraph/db_connect.py --test

# Initialize schema
python hypergraph/db_connect.py --init

# Load hypergraph data
python hypergraph/db_connect.py --load

# Execute a custom query
python hypergraph/db_connect.py --query "SELECT * FROM v_hypergraph_statistics;"
```

### Direct psql Connection

You can also connect directly using psql:

```bash
# Using connection string from .env
psql $DATABASE_URL

# Or using full connection string
psql 'postgresql://neondb_owner:your_password@your-host.neon.tech/neondb?sslmode=require&channel_binding=require'
```

### Running Sample Queries

```bash
# Using psql
psql $DATABASE_URL -f hypergraph/database/sample_queries.sql

# Or using the utility
python hypergraph/db_connect.py --query "$(cat hypergraph/database/sample_queries.sql)"
```

## Database Schema

The schema includes:

### Tables
- `scmlex_nodes` - Legal principles, rules, concepts, and domains
- `scmlex_edges` - Relationships and derivations between nodes
- `scmlex_hyperedges` - Multi-node relationships

### Views
- `v_level1_principles` - All Level 1 principles
- `v_rules_by_jurisdiction` - Rules grouped by jurisdiction
- `v_principle_rule_derivations` - Principle-to-rule derivations
- `v_hypergraph_statistics` - Overall statistics

### Functions
- `find_principles_by_domain(domain_name)` - Find principles for a domain
- `find_rules_from_principle(principle_name)` - Find derived rules
- `search_nodes(keyword)` - Full-text search

## Query Examples

### Get Statistics
```sql
SELECT * FROM v_hypergraph_statistics;
```

### Find Contract Law Principles
```sql
SELECT * FROM find_principles_by_domain('contract');
```

### Search for Keywords
```sql
SELECT * FROM search_nodes('contract') LIMIT 10;
```

### Find Rules Derived from a Principle
```sql
SELECT * FROM find_rules_from_principle('pacta-sunt-servanda');
```

## Neon Database Features

This integration is optimized for Neon PostgreSQL:

- **Serverless PostgreSQL** - Automatic scaling and connection pooling
- **Branching** - Create database branches for testing
- **Point-in-time Recovery** - Restore to any point in time
- **SSL/TLS** - Secure connections with `sslmode=require`
- **Channel Binding** - Enhanced security with `channel_binding=require`

## Troubleshooting

### Connection Issues

If you get connection errors:

1. Verify your `.env` file has the correct credentials
2. Check that your IP is allowed in Neon console (if IP restrictions are enabled)
3. Ensure `psycopg2-binary` is installed: `pip install psycopg2-binary`
4. Test with direct psql connection first

### Schema Issues

If tables don't exist:

```bash
python hypergraph/db_connect.py --init
```

### Data Loading Issues

If data isn't loading:

1. Ensure `tuples.json` exists: `python hypergraph/build_hypergraph.py`
2. Check database logs for errors
3. Verify schema is initialized

## Security Notes

- **Never commit `.env` files** - They contain sensitive credentials
- The `.env` file is excluded via `.gitignore`
- Use `.env.example` as a template only
- For production, use environment variables or secure secret management
