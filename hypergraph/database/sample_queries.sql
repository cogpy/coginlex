
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
