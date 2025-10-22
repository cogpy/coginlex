# SCMLex Hypergraph Database Integration

## Setup Instructions

### 1. Create Database

Using Neon or Supabase, create a new PostgreSQL database.

### 2. Run Schema Script

```bash
psql -h your-host -U your-user -d your-database -f schema.sql
```

Or use the Supabase SQL Editor to execute the schema.

### 3. Load Data

Use the Python script or manual SQL inserts to load the hypergraph data.

### 4. Run Sample Queries

```bash
psql -h your-host -U your-user -d your-database -f sample_queries.sql
```

## Query Functions

- `find_principles_by_domain(domain_name)` - Find principles for a domain
- `find_rules_from_principle(principle_name)` - Find derived rules
- `search_nodes(keyword)` - Full-text search

## Views

- `v_level1_principles` - All Level 1 principles
- `v_rules_by_jurisdiction` - Rules grouped by jurisdiction
- `v_principle_rule_derivations` - Principle-to-rule derivations
- `v_hypergraph_statistics` - Overall statistics
