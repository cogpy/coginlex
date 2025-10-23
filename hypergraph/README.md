# SCMLex Universal Hypergraph

**Version:** 1.0  
**Date:** October 23, 2025  
**Repository:** https://github.com/cogpy/chainlex

## Overview

The SCMLex Universal Hypergraph is a comprehensive graph-based representation of the ChainLex legal frameworks, integrating **2,306 nodes** and **80+ edges** representing legal principles, rules, and their relationships. It enables sophisticated legal reasoning, query processing, and visualization.

## Key Features

- **Multi-level Architecture:** Level 1 principles → Level 2+ jurisdiction-specific rules
- **Hyperedge Support:** Edges connecting multiple nodes for complex relationships
- **Rich Metadata:** Confidence levels, provenance, inference types
- **Multiple Export Formats:** GraphML, JSON, Pickle, Neo4j Cypher, SQL
- **Query Interface:** Python API for graph traversal and analysis
- **Visualizations:** Statistical dashboards, network diagrams, hierarchy charts
- **Database Integration:** PostgreSQL schema for Neon/Supabase

## Statistics

| Metric | Count |
|:-------|------:|
| **Total Nodes** | 2,306 |
| **Principles (Level 1)** | 63 |
| **Rules (Level 2+)** | 2,215 |
| **Domains** | 28 |
| **Total Edges** | 80 |
| **Relationships** | 59 |
| **Derivations** | 21 |
| **Hyperedges** | 20 |

### Top Legal Domains

1. **Civil Law:** 358 nodes
2. **International Law:** 358 nodes
3. **Construction Law:** 348 nodes
4. **Labour Law:** 341 nodes
5. **Criminal Law:** 336 nodes

## Architecture

### Node Types

1. **Principle Nodes (Level 1)**
   - First-order legal principles
   - Universal maxims (e.g., pacta-sunt-servanda)
   - Confidence: 1.0 (explicitly stated)
   - 63 principles total

2. **Rule Nodes (Level 2+)**
   - Jurisdiction-specific legal rules
   - Derived from Level 1 principles
   - Confidence: 0.95 (derived)
   - 2,215 rules total

3. **Domain Nodes**
   - Legal domain classifications
   - Hierarchical organization
   - 28 domains total

### Edge Types

1. **Derivation Edges**
   - Connect Level 1 principles to Level 2+ rules
   - Indicate inference type (deductive, inductive, abductive, analogical)
   - Include confidence impact

2. **Relationship Edges**
   - Connect related principles
   - Indicate relationship strength (0.0-1.0)
   - Support inference chain building

3. **Domain Membership Edges**
   - Connect entities to their domains
   - Support domain-specific queries

## File Structure

```
hypergraph/
├── README.md                          # This file
├── SCHEMA.md                          # Detailed schema documentation
│
├── extract_tuples.py                  # Extract entities from Scheme files
├── build_hypergraph.py                # Build NetworkX hypergraph
├── query_hypergraph.py                # Query and traversal functions
├── visualize_hypergraph.py            # Visualization tools
├── db_integration.py                  # Database schema generation
├── db_connect.py                      # Database connection utility
│
├── tuples.json                        # Extracted entity-relation tuples (1.1 MB)
├── scmlex_hypergraph.json             # Hypergraph in JSON format (834 KB)
├── scmlex_hypergraph.graphml          # GraphML for Gephi/Cytoscape (843 KB)
├── scmlex_hypergraph.pkl              # Python pickle format (462 KB)
├── scmlex_hypergraph_neo4j.cypher     # Neo4j import script (501 KB)
├── hypergraph_stats.json              # Statistics summary
│
├── visualizations/
│   ├── domain_distribution.png        # Domain bar chart
│   ├── node_types.png                 # Node type pie chart
│   ├── principle_network.png          # Principle relationship network
│   ├── level_hierarchy.png            # Level 1 → Level 2 hierarchy
│   └── statistics_dashboard.png       # Comprehensive dashboard
│
└── database/
    ├── README.md                      # Database setup instructions
    ├── CONNECTION_GUIDE.md            # Connection examples and troubleshooting
    ├── schema.sql                     # PostgreSQL schema
    └── sample_queries.sql             # Example SQL queries
```

## Usage

### 1. Extract Tuples from Scheme Files

```bash
python3 extract_tuples.py /path/to/chainlex /path/to/output.json
```

**Output:** JSON file with all entity-relation tuples

### 2. Build Hypergraph

```bash
python3 build_hypergraph.py tuples.json /path/to/output/dir
```

**Outputs:**
- `scmlex_hypergraph.graphml` - For Gephi, Cytoscape
- `scmlex_hypergraph.json` - JSON format
- `scmlex_hypergraph.pkl` - Python pickle
- `scmlex_hypergraph_neo4j.cypher` - Neo4j import
- `hypergraph_stats.json` - Statistics

### 3. Query the Hypergraph

```python
from query_hypergraph import HypergraphQuery

# Load hypergraph
query = HypergraphQuery("scmlex_hypergraph.pkl")

# Find principles by domain
principles = query.find_principles_by_domain('contract')

# Find rules derived from a principle
rules = query.find_rules_derived_from_principle('pacta-sunt-servanda')

# Find related principles
related = query.find_related_principles('pacta-sunt-servanda')

# Build inference chain
chain = query.build_inference_chain('pacta-sunt-servanda', 'contract-valid?')

# Search by keyword
results = query.search_by_keyword('contract', node_type='rule')

# Get domain statistics
stats = query.get_domain_statistics('contract')
```

### 4. Generate Visualizations

```bash
python3 visualize_hypergraph.py scmlex_hypergraph.pkl /path/to/output/dir
```

**Outputs:**
- `domain_distribution.png` - Domain bar chart
- `node_types.png` - Node type pie chart
- `principle_network.png` - Principle relationship network
- `level_hierarchy.png` - Level 1 → Level 2 hierarchy
- `statistics_dashboard.png` - Comprehensive dashboard

### 5. Database Integration

#### Setup PostgreSQL Database

**Quick Start:**
```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Configure connection
cp .env.example .env
# Edit .env with your Neon database credentials

# 3. Test connection
python hypergraph/db_connect.py --test

# 4. Initialize schema and load data
python hypergraph/db_connect.py --init
python hypergraph/db_connect.py --load
```

**Manual Setup:**
```bash
# Using psql with connection string
psql 'postgresql://user:password@host/database?sslmode=require' -f database/schema.sql

# Or use Neon/Supabase SQL Editor
```

See [database/README.md](database/README.md) for detailed instructions and [database/CONNECTION_GUIDE.md](database/CONNECTION_GUIDE.md) for connection examples.

#### Run Sample Queries

```bash
# Using the utility
python hypergraph/db_connect.py --query "SELECT * FROM find_principles_by_domain('contract');"

# Or using psql
psql $DATABASE_URL -c "SELECT * FROM find_principles_by_domain('contract');"
```

```sql
-- Find contract law principles
SELECT * FROM find_principles_by_domain('contract');

-- Find rules derived from pacta-sunt-servanda
SELECT * FROM find_rules_from_principle('pacta-sunt-servanda');

-- Full-text search
SELECT * FROM search_nodes('contract') LIMIT 10;

-- Get statistics
SELECT * FROM v_hypergraph_statistics;
```

## Query Examples

### Python API

```python
from query_hypergraph import HypergraphQuery

query = HypergraphQuery("scmlex_hypergraph.pkl")

# Example 1: Find all contract law principles
principles = query.find_principles_by_domain('contract')
for p in principles:
    print(f"{p['name']}: {p['description']}")

# Example 2: Find South African civil law rules
rules = query.find_rules_by_jurisdiction('ZA', 'civil')
print(f"Found {len(rules)} rules")

# Example 3: Build inference chain
chain = query.build_inference_chain('pacta-sunt-servanda', 'contract-valid?')
if chain:
    for step in chain:
        print(f"Step {step['step']}: {step['name']} (Level {step['level']})")
    confidence = query.compute_path_confidence(chain)
    print(f"Path confidence: {confidence}")

# Example 4: Find related principles
related = query.find_related_principles('pacta-sunt-servanda')
for r in related:
    print(f"{r['name']} (strength: {r['strength']})")

# Example 5: Search by keyword
results = query.search_by_keyword('delict')
for r in results:
    print(f"{r['name']} ({r['type']}): {r['description'][:60]}...")
```

### SQL Queries

```sql
-- Find most connected principles
SELECT 
    n.name,
    COUNT(e.id) as connection_count
FROM scmlex_nodes n
LEFT JOIN scmlex_edges e ON n.node_id = e.source_node_id
WHERE n.node_type = 'principle'
GROUP BY n.name
ORDER BY connection_count DESC
LIMIT 10;

-- Find inference chains (2-hop paths)
SELECT 
    p.name as principle,
    i.name as intermediate,
    r.name as rule
FROM scmlex_edges e1
JOIN scmlex_edges e2 ON e1.target_node_id = e2.source_node_id
JOIN scmlex_nodes p ON e1.source_node_id = p.node_id
JOIN scmlex_nodes i ON e1.target_node_id = i.node_id
JOIN scmlex_nodes r ON e2.target_node_id = r.node_id
WHERE p.node_type = 'principle' AND r.node_type = 'rule'
LIMIT 10;

-- Get domain statistics
SELECT 
    UNNEST(domains) as domain,
    COUNT(*) as principle_count
FROM scmlex_nodes
WHERE node_type = 'principle'
GROUP BY domain
ORDER BY principle_count DESC;
```

## Integration with External Tools

### Gephi (Network Visualization)

1. Open Gephi
2. File → Open → Select `scmlex_hypergraph.graphml`
3. Choose "Directed Graph"
4. Apply layout (e.g., Force Atlas 2)
5. Color nodes by `node_type`
6. Size nodes by degree

### Neo4j (Graph Database)

```bash
# Import Cypher script
cat scmlex_hypergraph_neo4j.cypher | cypher-shell -u neo4j -p password

# Or use Neo4j Browser
# Copy and paste the Cypher script
```

### Cytoscape (Biological Networks)

1. Open Cytoscape
2. File → Import → Network from File
3. Select `scmlex_hypergraph.graphml`
4. Apply style based on node attributes

## Advanced Features

### Hyperedge Support

The hypergraph supports edges connecting multiple nodes:

```python
# Example: A rule derived from multiple principles
{
  "hyperedge_id": "uuid-123",
  "hyperedge_type": "derivation",
  "source_nodes": ["principle-1", "principle-2", "principle-3"],
  "target_node": "rule-1",
  "inference_type": "deductive",
  "confidence_impact": 0.95
}
```

### Confidence Computation

Confidence levels are computed based on inference type:

- **Deductive:** 0.95 (preserves most confidence)
- **Inductive:** 0.80 (reduces confidence)
- **Abductive:** 0.70 (more uncertain)
- **Analogical:** 0.65 (most uncertain)

Path confidence is the product of all confidence levels along the path.

### Inference Chain Building

Build complete inference chains from principles to rules:

```python
chain = query.build_inference_chain('pacta-sunt-servanda', 'contract-valid?')
# Returns: [principle] → [intermediate] → [rule]
```

## Performance Considerations

- **Graph Loading:** ~1 second for 2,306 nodes
- **Query Time:** <100ms for most queries
- **Memory Usage:** ~50 MB for full graph
- **Database Size:** ~10 MB for PostgreSQL

## Future Enhancements

### Short-term
- [ ] Add more derivation edges (currently only 21)
- [ ] Implement graph algorithms (PageRank, centrality)
- [ ] Add temporal evolution tracking
- [ ] Create interactive web visualization (D3.js + Anime.js)

### Medium-term
- [ ] Integrate with machine learning models
- [ ] Add case law citations as nodes
- [ ] Implement automated inference engine
- [ ] Create natural language query interface

### Long-term
- [ ] Expand to other jurisdictions (UK, US, EU)
- [ ] Add multilingual support
- [ ] Implement real-time updates
- [ ] Create legal reasoning API

## Contributing

To extend the hypergraph:

1. Add new principles to `lv1/known_laws.scm`
2. Add new rules to jurisdiction-specific files
3. Run extraction: `python3 extract_tuples.py`
4. Rebuild hypergraph: `python3 build_hypergraph.py`
5. Regenerate visualizations: `python3 visualize_hypergraph.py`
6. Commit changes to repository

## License

See LICENSE file in the repository root.

## References

- [ChainLex Repository](https://github.com/cogpy/chainlex)
- [NetworkX Documentation](https://networkx.org/)
- [Neo4j Graph Database](https://neo4j.com/)
- [Gephi Visualization](https://gephi.org/)
- [GraphML Format](http://graphml.graphdrawing.org/)

## Contact

For questions or issues, please open an issue on the GitHub repository.

