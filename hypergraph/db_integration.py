#!/usr/bin/env python3
"""
Database Integration for SCMLex Hypergraph

Integrates the hypergraph with Neon/Supabase PostgreSQL databases:
1. Create database schema
2. Load nodes and edges
3. Create indexes for efficient queries
4. Provide SQL query examples
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Any

# Database connection info from environment
SUPABASE_URL = os.getenv('SUPABASE_URL', '')
SUPABASE_KEY = os.getenv('SUPABASE_KEY', '')

class DatabaseIntegration:
    """Integrate hypergraph with PostgreSQL database"""
    
    def __init__(self):
        self.schema_sql = []
        self.insert_sql = []
        
    def generate_schema(self) -> str:
        """Generate PostgreSQL schema for hypergraph"""
        schema = """
-- SCMLex Hypergraph Database Schema
-- Version: 1.0
-- Date: 2025-10-23

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- NODES TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS scmlex_nodes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    node_id TEXT UNIQUE NOT NULL,
    node_type TEXT NOT NULL CHECK (node_type IN ('principle', 'rule', 'concept', 'domain')),
    level INTEGER,
    name TEXT NOT NULL,
    description TEXT,
    
    -- Principle-specific fields
    provenance TEXT,
    application_context TEXT,
    
    -- Rule-specific fields
    jurisdiction TEXT,
    legal_domain TEXT,
    
    -- Common fields
    confidence DECIMAL(3,2) DEFAULT 1.0,
    inference_type TEXT,
    
    -- Array fields
    domains TEXT[],
    derived_from TEXT[],
    
    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_nodes_type ON scmlex_nodes(node_type);
CREATE INDEX IF NOT EXISTS idx_nodes_level ON scmlex_nodes(level);
CREATE INDEX IF NOT EXISTS idx_nodes_name ON scmlex_nodes(name);
CREATE INDEX IF NOT EXISTS idx_nodes_jurisdiction ON scmlex_nodes(jurisdiction);
CREATE INDEX IF NOT EXISTS idx_nodes_legal_domain ON scmlex_nodes(legal_domain);
CREATE INDEX IF NOT EXISTS idx_nodes_domains ON scmlex_nodes USING GIN(domains);

-- Full-text search index
CREATE INDEX IF NOT EXISTS idx_nodes_search ON scmlex_nodes 
    USING GIN(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- ============================================================================
-- EDGES TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS scmlex_edges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    edge_id TEXT UNIQUE,
    edge_type TEXT NOT NULL CHECK (edge_type IN ('relationship', 'derivation', 'domain_membership')),
    source_node_id TEXT NOT NULL REFERENCES scmlex_nodes(node_id),
    target_node_id TEXT NOT NULL REFERENCES scmlex_nodes(node_id),
    
    -- Edge attributes
    relationship_name TEXT,
    inference_type TEXT,
    confidence_impact DECIMAL(3,2),
    strength DECIMAL(3,2),
    description TEXT,
    
    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT fk_source FOREIGN KEY (source_node_id) REFERENCES scmlex_nodes(node_id),
    CONSTRAINT fk_target FOREIGN KEY (target_node_id) REFERENCES scmlex_nodes(node_id)
);

-- Indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_edges_type ON scmlex_edges(edge_type);
CREATE INDEX IF NOT EXISTS idx_edges_source ON scmlex_edges(source_node_id);
CREATE INDEX IF NOT EXISTS idx_edges_target ON scmlex_edges(target_node_id);
CREATE INDEX IF NOT EXISTS idx_edges_source_target ON scmlex_edges(source_node_id, target_node_id);

-- ============================================================================
-- HYPEREDGES TABLE (for edges connecting multiple nodes)
-- ============================================================================

CREATE TABLE IF NOT EXISTS scmlex_hyperedges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hyperedge_id TEXT UNIQUE NOT NULL,
    hyperedge_type TEXT NOT NULL,
    source_nodes TEXT[] NOT NULL,
    target_node TEXT,
    target_nodes TEXT[],
    
    -- Attributes
    inference_type TEXT,
    confidence_impact DECIMAL(3,2),
    relationship_name TEXT,
    strength DECIMAL(3,2),
    description TEXT,
    
    -- Metadata
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hyperedges_type ON scmlex_hyperedges(hyperedge_type);
CREATE INDEX IF NOT EXISTS idx_hyperedges_sources ON scmlex_hyperedges USING GIN(source_nodes);

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

-- View: All Level 1 Principles
CREATE OR REPLACE VIEW v_level1_principles AS
SELECT 
    node_id,
    name,
    description,
    domains,
    confidence,
    provenance
FROM scmlex_nodes
WHERE node_type = 'principle' AND level = 1
ORDER BY name;

-- View: Rules by Jurisdiction
CREATE OR REPLACE VIEW v_rules_by_jurisdiction AS
SELECT 
    jurisdiction,
    legal_domain,
    COUNT(*) as rule_count
FROM scmlex_nodes
WHERE node_type = 'rule'
GROUP BY jurisdiction, legal_domain
ORDER BY jurisdiction, legal_domain;

-- View: Principle-Rule Derivations
CREATE OR REPLACE VIEW v_principle_rule_derivations AS
SELECT 
    p.name as principle_name,
    r.name as rule_name,
    r.jurisdiction,
    r.legal_domain,
    e.inference_type,
    e.confidence_impact
FROM scmlex_edges e
JOIN scmlex_nodes p ON e.source_node_id = p.node_id
JOIN scmlex_nodes r ON e.target_node_id = r.node_id
WHERE e.edge_type = 'derivation'
    AND p.node_type = 'principle'
    AND r.node_type = 'rule';

-- ============================================================================
-- FUNCTIONS FOR GRAPH QUERIES
-- ============================================================================

-- Function: Find principles by domain
CREATE OR REPLACE FUNCTION find_principles_by_domain(domain_name TEXT)
RETURNS TABLE (
    node_id TEXT,
    name TEXT,
    description TEXT,
    confidence DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.node_id,
        n.name,
        n.description,
        n.confidence
    FROM scmlex_nodes n
    WHERE n.node_type = 'principle'
        AND domain_name = ANY(n.domains);
END;
$$ LANGUAGE plpgsql;

-- Function: Find rules derived from principle
CREATE OR REPLACE FUNCTION find_rules_from_principle(principle_name TEXT)
RETURNS TABLE (
    rule_name TEXT,
    jurisdiction TEXT,
    legal_domain TEXT,
    confidence DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.name,
        r.jurisdiction,
        r.legal_domain,
        r.confidence
    FROM scmlex_edges e
    JOIN scmlex_nodes p ON e.source_node_id = p.node_id
    JOIN scmlex_nodes r ON e.target_node_id = r.node_id
    WHERE p.name = principle_name
        AND e.edge_type = 'derivation'
        AND r.node_type = 'rule';
END;
$$ LANGUAGE plpgsql;

-- Function: Search nodes by keyword
CREATE OR REPLACE FUNCTION search_nodes(keyword TEXT)
RETURNS TABLE (
    node_id TEXT,
    node_type TEXT,
    name TEXT,
    description TEXT,
    relevance REAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.node_id,
        n.node_type,
        n.name,
        n.description,
        ts_rank(to_tsvector('english', n.name || ' ' || COALESCE(n.description, '')),
                plainto_tsquery('english', keyword)) as relevance
    FROM scmlex_nodes n
    WHERE to_tsvector('english', n.name || ' ' || COALESCE(n.description, '')) 
          @@ plainto_tsquery('english', keyword)
    ORDER BY relevance DESC;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- STATISTICS VIEW
-- ============================================================================

CREATE OR REPLACE VIEW v_hypergraph_statistics AS
SELECT 
    (SELECT COUNT(*) FROM scmlex_nodes) as total_nodes,
    (SELECT COUNT(*) FROM scmlex_nodes WHERE node_type = 'principle') as principle_count,
    (SELECT COUNT(*) FROM scmlex_nodes WHERE node_type = 'rule') as rule_count,
    (SELECT COUNT(*) FROM scmlex_nodes WHERE node_type = 'domain') as domain_count,
    (SELECT COUNT(*) FROM scmlex_edges) as total_edges,
    (SELECT COUNT(*) FROM scmlex_edges WHERE edge_type = 'derivation') as derivation_count,
    (SELECT COUNT(*) FROM scmlex_edges WHERE edge_type = 'relationship') as relationship_count,
    (SELECT COUNT(*) FROM scmlex_hyperedges) as hyperedge_count;

-- ============================================================================
-- SAMPLE QUERIES
-- ============================================================================

-- Query 1: Get all contract law principles
-- SELECT * FROM find_principles_by_domain('contract');

-- Query 2: Find rules derived from pacta-sunt-servanda
-- SELECT * FROM find_rules_from_principle('pacta-sunt-servanda');

-- Query 3: Search for "contract" in all nodes
-- SELECT * FROM search_nodes('contract') LIMIT 10;

-- Query 4: Get statistics
-- SELECT * FROM v_hypergraph_statistics;

-- Query 5: Find most connected principles (by outgoing edges)
-- SELECT 
--     n.name,
--     COUNT(e.id) as connection_count
-- FROM scmlex_nodes n
-- LEFT JOIN scmlex_edges e ON n.node_id = e.source_node_id
-- WHERE n.node_type = 'principle'
-- GROUP BY n.name
-- ORDER BY connection_count DESC
-- LIMIT 10;
"""
        return schema
    
    def generate_data_load_script(self, tuples_file: str) -> str:
        """Generate SQL script to load data from JSON"""
        with open(tuples_file, 'r') as f:
            data = json.load(f)
        
        script = "-- Data Load Script for SCMLex Hypergraph\n\n"
        script += "BEGIN;\n\n"
        
        # Load principles
        script += "-- Load Level 1 Principles\n"
        for principle in data['nodes']['principles']:
            domains_array = "{" + ",".join(f'"{d}"' for d in principle.get('domains', [])) + "}"
            script += f"""
INSERT INTO scmlex_nodes (node_id, node_type, level, name, description, domains, confidence, provenance, inference_type, application_context)
VALUES (
    '{principle['node_id']}',
    'principle',
    1,
    '{principle.get('name', '').replace("'", "''")}',
    '{principle.get('description', '').replace("'", "''")}',
    ARRAY{domains_array},
    {principle.get('confidence', 1.0)},
    '{principle.get('provenance', '').replace("'", "''")}',
    '{principle.get('inference_type', '')}',
    '{principle.get('application_context', '').replace("'", "''")}'
) ON CONFLICT (node_id) DO NOTHING;
"""
        
        script += "\nCOMMIT;\n"
        return script
    
    def export_schema(self, output_file: str):
        """Export schema to SQL file"""
        schema = self.generate_schema()
        with open(output_file, 'w') as f:
            f.write(schema)
        print(f"✅ Schema exported to: {output_file}")
    
    def export_sample_queries(self, output_file: str):
        """Export sample queries to SQL file"""
        queries = """
-- SCMLex Hypergraph: Sample Queries
-- Version: 1.0

-- ============================================================================
-- BASIC QUERIES
-- ============================================================================

-- 1. Get all Level 1 principles
SELECT * FROM v_level1_principles;

-- 2. Count nodes by type
SELECT node_type, COUNT(*) as count
FROM scmlex_nodes
GROUP BY node_type
ORDER BY count DESC;

-- 3. Get rules for South African civil law
SELECT name, description
FROM scmlex_nodes
WHERE node_type = 'rule'
    AND jurisdiction = 'ZA'
    AND legal_domain = 'civil'
LIMIT 10;

-- ============================================================================
-- DOMAIN QUERIES
-- ============================================================================

-- 4. Find all contract law principles
SELECT * FROM find_principles_by_domain('contract');

-- 5. Get domain statistics
SELECT 
    UNNEST(domains) as domain,
    COUNT(*) as principle_count
FROM scmlex_nodes
WHERE node_type = 'principle'
GROUP BY domain
ORDER BY principle_count DESC;

-- ============================================================================
-- RELATIONSHIP QUERIES
-- ============================================================================

-- 6. Find rules derived from pacta-sunt-servanda
SELECT * FROM find_rules_from_principle('pacta-sunt-servanda');

-- 7. Find related principles
SELECT 
    p1.name as principle,
    p2.name as related_principle,
    e.relationship_name,
    e.strength
FROM scmlex_edges e
JOIN scmlex_nodes p1 ON e.source_node_id = p1.node_id
JOIN scmlex_nodes p2 ON e.target_node_id = p2.node_id
WHERE e.edge_type = 'relationship'
    AND p1.name = 'pacta-sunt-servanda';

-- ============================================================================
-- SEARCH QUERIES
-- ============================================================================

-- 8. Full-text search for "contract"
SELECT * FROM search_nodes('contract') LIMIT 10;

-- 9. Find principles with highest confidence
SELECT name, description, confidence
FROM scmlex_nodes
WHERE node_type = 'principle'
ORDER BY confidence DESC
LIMIT 10;

-- ============================================================================
-- GRAPH ANALYSIS QUERIES
-- ============================================================================

-- 10. Find most connected principles
SELECT 
    n.name,
    COUNT(e.id) as outgoing_edges
FROM scmlex_nodes n
LEFT JOIN scmlex_edges e ON n.node_id = e.source_node_id
WHERE n.node_type = 'principle'
GROUP BY n.name
ORDER BY outgoing_edges DESC
LIMIT 10;

-- 11. Find principles with no derivations
SELECT name, description
FROM scmlex_nodes n
WHERE n.node_type = 'principle'
    AND NOT EXISTS (
        SELECT 1 FROM scmlex_edges e
        WHERE e.source_node_id = n.node_id
            AND e.edge_type = 'derivation'
    );

-- 12. Get hypergraph statistics
SELECT * FROM v_hypergraph_statistics;

-- ============================================================================
-- JURISDICTION QUERIES
-- ============================================================================

-- 13. Rules by jurisdiction
SELECT * FROM v_rules_by_jurisdiction;

-- 14. Get all South African rules
SELECT legal_domain, COUNT(*) as rule_count
FROM scmlex_nodes
WHERE jurisdiction = 'ZA' AND node_type = 'rule'
GROUP BY legal_domain
ORDER BY rule_count DESC;

-- ============================================================================
-- ADVANCED QUERIES
-- ============================================================================

-- 15. Find inference chains (2-hop paths)
SELECT 
    p.name as principle,
    i.name as intermediate,
    r.name as rule,
    e1.inference_type as first_inference,
    e2.inference_type as second_inference
FROM scmlex_edges e1
JOIN scmlex_edges e2 ON e1.target_node_id = e2.source_node_id
JOIN scmlex_nodes p ON e1.source_node_id = p.node_id
JOIN scmlex_nodes i ON e1.target_node_id = i.node_id
JOIN scmlex_nodes r ON e2.target_node_id = r.node_id
WHERE p.node_type = 'principle'
    AND r.node_type = 'rule'
LIMIT 10;
"""
        with open(output_file, 'w') as f:
            f.write(queries)
        print(f"✅ Sample queries exported to: {output_file}")

def main():
    """Generate database integration files"""
    import sys
    
    output_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/home/ubuntu/chainlex/hypergraph/database")
    output_dir.mkdir(exist_ok=True)
    
    db = DatabaseIntegration()
    
    print("="*60)
    print("GENERATING DATABASE INTEGRATION FILES")
    print("="*60)
    
    # Export schema
    db.export_schema(str(output_dir / "schema.sql"))
    
    # Export sample queries
    db.export_sample_queries(str(output_dir / "sample_queries.sql"))
    
    # Create README
    readme = """# SCMLex Hypergraph Database Integration

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
"""
    
    with open(output_dir / "README.md", 'w') as f:
        f.write(readme)
    
    print(f"✅ README exported to: {output_dir / 'README.md'}")
    
    print("\n" + "="*60)
    print("✅ Database integration files generated!")
    print(f"   Output directory: {output_dir}")
    print("="*60)

if __name__ == "__main__":
    main()

