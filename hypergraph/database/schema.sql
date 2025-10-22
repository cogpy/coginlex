
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
