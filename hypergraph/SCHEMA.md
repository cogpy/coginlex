# SCMLex Hypergraph Schema

**Version:** 1.0  
**Date:** October 23, 2025  
**Purpose:** Universal hypergraph representation of legal entity-relation tuples

## Overview

The SCMLex Hypergraph is a universal graph structure that represents all legal concepts, principles, rules, and their relationships from the ChainLex legal frameworks. It enables sophisticated legal reasoning, query processing, and visualization.

## Core Concepts

### Hypergraph vs. Regular Graph

A **hypergraph** extends a regular graph by allowing edges (called **hyperedges**) to connect any number of nodes, not just two. This is essential for legal reasoning where:

- A single legal rule may depend on multiple principles
- A legal concept may relate to multiple domains simultaneously
- Inference chains involve multiple intermediate steps

**Example:**
```
Regular Graph:    A ----edge----> B
Hypergraph:       A ----hyperedge----> {B, C, D}
```

## Node Types

### 1. Principle Nodes (Level 1)

**Purpose:** Represent first-order legal principles from `known_laws.scm`

**Attributes:**
- `node_id`: Unique identifier (UUID)
- `node_type`: "principle"
- `level`: 1
- `name`: Principle name (e.g., "pacta-sunt-servanda")
- `description`: Human-readable description
- `domains`: List of applicable legal domains
- `confidence`: 1.0 (explicitly stated)
- `provenance`: Historical/jurisdictional origin
- `inference_type`: Type of inference (deductive, inductive, abductive, analogical)
- `application_context`: Where this principle applies

**Example:**
```json
{
  "node_id": "uuid-1234",
  "node_type": "principle",
  "level": 1,
  "name": "pacta-sunt-servanda",
  "description": "Agreements must be kept",
  "domains": ["contract", "civil", "international"],
  "confidence": 1.0,
  "provenance": "Roman law, universally recognized",
  "inference_type": "deductive",
  "application_context": "Binding force of contracts"
}
```

### 2. Rule Nodes (Level 2+)

**Purpose:** Represent jurisdiction-specific legal rules

**Attributes:**
- `node_id`: Unique identifier (UUID)
- `node_type`: "rule"
- `level`: 2+ (derived from Level 1)
- `name`: Rule name (e.g., "contract-valid?")
- `description`: What the rule determines
- `jurisdiction`: Country code (e.g., "ZA")
- `legal_domain`: Primary domain (e.g., "civil")
- `sub_domains`: Sub-domains (e.g., ["contract", "delict"])
- `confidence`: Derived confidence (0.0-1.0)
- `derived_from`: List of Level 1 principle IDs
- `inference_type`: How it was derived
- `implementation`: Function signature

**Example:**
```json
{
  "node_id": "uuid-5678",
  "node_type": "rule",
  "level": 2,
  "name": "contract-valid?",
  "description": "Determines if a contract is valid under SA law",
  "jurisdiction": "ZA",
  "legal_domain": "civil",
  "sub_domains": ["contract"],
  "confidence": 0.95,
  "derived_from": ["uuid-1234", "uuid-2345"],
  "inference_type": "deductive",
  "implementation": "(define (contract-valid? contract) ...)"
}
```

### 3. Concept Nodes

**Purpose:** Represent legal concepts that are not principles or rules

**Attributes:**
- `node_id`: Unique identifier (UUID)
- `node_type`: "concept"
- `name`: Concept name (e.g., "legal-capacity")
- `description`: What the concept represents
- `domains`: Applicable domains
- `related_principles`: Related Level 1 principles
- `related_rules`: Related Level 2+ rules

**Example:**
```json
{
  "node_id": "uuid-9012",
  "node_type": "concept",
  "name": "legal-capacity",
  "description": "Ability to enter into legal relations",
  "domains": ["civil", "contract", "criminal"],
  "related_principles": ["compos-mentis", "doli-incapax"],
  "related_rules": ["legal-capacity?", "capacity-of-parties?"]
}
```

### 4. Domain Nodes

**Purpose:** Represent legal domains and their hierarchies

**Attributes:**
- `node_id`: Unique identifier (UUID)
- `node_type`: "domain"
- `name`: Domain name (e.g., "contract")
- `parent_domain`: Parent domain (e.g., "civil")
- `sub_domains`: Child domains
- `description`: Domain description

**Example:**
```json
{
  "node_id": "uuid-3456",
  "node_type": "domain",
  "name": "contract",
  "parent_domain": "civil",
  "sub_domains": ["offer", "acceptance", "consideration"],
  "description": "Contract law domain"
}
```

## Hyperedge Types

### 1. Derivation Hyperedges

**Purpose:** Connect Level 1 principles to Level 2+ rules they derive

**Attributes:**
- `hyperedge_id`: Unique identifier (UUID)
- `hyperedge_type`: "derivation"
- `source_nodes`: List of Level 1 principle IDs
- `target_node`: Level 2+ rule ID
- `inference_type`: Type of inference used
- `confidence_impact`: How confidence was computed
- `description`: How the derivation works

**Example:**
```json
{
  "hyperedge_id": "uuid-edge-1",
  "hyperedge_type": "derivation",
  "source_nodes": ["uuid-1234", "uuid-2345", "uuid-3456"],
  "target_node": "uuid-5678",
  "inference_type": "deductive",
  "confidence_impact": 0.95,
  "description": "contract-valid? derives from pacta-sunt-servanda, consensus-ad-idem, consideration-exists"
}
```

### 2. Relationship Hyperedges

**Purpose:** Connect related principles (e.g., "related-principles" in Level 1)

**Attributes:**
- `hyperedge_id`: Unique identifier (UUID)
- `hyperedge_type`: "relationship"
- `relationship_name`: Type of relationship (e.g., "related-to", "supports", "conflicts-with")
- `source_node`: Source principle/rule ID
- `target_nodes`: List of related principle/rule IDs
- `strength`: Relationship strength (0.0-1.0)

**Example:**
```json
{
  "hyperedge_id": "uuid-edge-2",
  "hyperedge_type": "relationship",
  "relationship_name": "related-to",
  "source_node": "uuid-1234",
  "target_nodes": ["uuid-2345", "uuid-3456"],
  "strength": 0.9
}
```

### 3. Domain Membership Hyperedges

**Purpose:** Connect principles/rules to their domains

**Attributes:**
- `hyperedge_id`: Unique identifier (UUID)
- `hyperedge_type`: "domain_membership"
- `entity_node`: Principle/rule ID
- `domain_nodes`: List of domain IDs
- `primary`: Boolean (is this the primary domain?)

**Example:**
```json
{
  "hyperedge_id": "uuid-edge-3",
  "hyperedge_type": "domain_membership",
  "entity_node": "uuid-1234",
  "domain_nodes": ["uuid-domain-1", "uuid-domain-2"],
  "primary": true
}
```

### 4. Inference Chain Hyperedges

**Purpose:** Represent complete inference chains from Level 1 to specific conclusions

**Attributes:**
- `hyperedge_id`: Unique identifier (UUID)
- `hyperedge_type`: "inference_chain"
- `chain_nodes`: Ordered list of node IDs in the chain
- `start_node`: Starting principle ID
- `end_node`: Ending rule/conclusion ID
- `chain_length`: Number of steps
- `cumulative_confidence`: Product of all confidence levels

**Example:**
```json
{
  "hyperedge_id": "uuid-edge-4",
  "hyperedge_type": "inference_chain",
  "chain_nodes": ["uuid-1", "uuid-2", "uuid-3", "uuid-4"],
  "start_node": "uuid-1",
  "end_node": "uuid-4",
  "chain_length": 3,
  "cumulative_confidence": 0.857
}
```

## Graph Structure

### Hierarchical Levels

```
Level 1: First-Order Principles (60+ nodes)
    ↓ (derivation hyperedges)
Level 2: Jurisdiction-Specific Rules (800+ nodes)
    ↓ (application hyperedges)
Level 3: Case-Specific Applications (dynamic)
```

### Domain Hierarchy

```
Root
├── Civil Law
│   ├── Contract Law
│   │   ├── Offer
│   │   ├── Acceptance
│   │   └── Consideration
│   ├── Delict Law
│   │   ├── Wrongfulness
│   │   ├── Fault
│   │   └── Causation
│   └── Property Law
├── Criminal Law
│   ├── Actus Reus
│   ├── Mens Rea
│   └── Defences
├── Constitutional Law
├── Administrative Law
├── Labour Law
├── Environmental Law
└── International Law
```

## Data Storage Format

### JSON-LD Format

For semantic web compatibility and RDF integration:

```json
{
  "@context": {
    "@vocab": "http://chainlex.org/schema#",
    "scm": "http://chainlex.org/scheme#",
    "legal": "http://chainlex.org/legal#"
  },
  "@graph": [
    {
      "@id": "scm:pacta-sunt-servanda",
      "@type": "legal:Principle",
      "legal:level": 1,
      "legal:name": "pacta-sunt-servanda",
      "legal:description": "Agreements must be kept",
      "legal:domains": ["contract", "civil", "international"],
      "legal:confidence": 1.0
    }
  ]
}
```

### Graph Database Format (Neo4j/ArangoDB)

**Nodes:**
```cypher
CREATE (p:Principle {
  id: 'pacta-sunt-servanda',
  level: 1,
  name: 'pacta-sunt-servanda',
  description: 'Agreements must be kept',
  domains: ['contract', 'civil', 'international'],
  confidence: 1.0
})
```

**Relationships:**
```cypher
MATCH (p1:Principle {id: 'pacta-sunt-servanda'})
MATCH (r:Rule {id: 'contract-valid?'})
CREATE (p1)-[:DERIVES {inference_type: 'deductive', confidence: 0.95}]->(r)
```

### Python NetworkX Format

```python
import networkx as nx

G = nx.DiGraph()

# Add nodes
G.add_node('pacta-sunt-servanda', 
           node_type='principle',
           level=1,
           confidence=1.0,
           domains=['contract', 'civil'])

# Add edges
G.add_edge('pacta-sunt-servanda', 'contract-valid?',
           edge_type='derivation',
           inference_type='deductive',
           confidence=0.95)
```

## Query Patterns

### 1. Find All Principles in a Domain

```python
def get_principles_by_domain(graph, domain):
    return [node for node, data in graph.nodes(data=True)
            if data.get('node_type') == 'principle' 
            and domain in data.get('domains', [])]
```

### 2. Find Derivation Chain

```python
def find_derivation_chain(graph, start_principle, end_rule):
    return nx.shortest_path(graph, start_principle, end_rule)
```

### 3. Find Related Principles

```python
def find_related_principles(graph, principle_id):
    return list(graph.neighbors(principle_id))
```

### 4. Compute Inference Confidence

```python
def compute_path_confidence(graph, path):
    confidence = 1.0
    for i in range(len(path) - 1):
        edge_data = graph.get_edge_data(path[i], path[i+1])
        confidence *= edge_data.get('confidence', 1.0)
    return confidence
```

## Statistics

### Expected Graph Size

| Metric | Count |
|:-------|------:|
| Level 1 Principle Nodes | 60+ |
| Level 2+ Rule Nodes | 800+ |
| Concept Nodes | 200+ |
| Domain Nodes | 50+ |
| Total Nodes | ~1,100+ |
| Derivation Hyperedges | ~1,500+ |
| Relationship Hyperedges | ~2,000+ |
| Domain Membership Hyperedges | ~1,500+ |
| Total Hyperedges | ~5,000+ |

### Complexity Metrics

- **Average Node Degree:** 8-10
- **Graph Diameter:** 4-6 (max path length)
- **Clustering Coefficient:** 0.3-0.5
- **Density:** 0.004-0.006

## Implementation Technologies

### Recommended Stack

1. **Graph Database:** Neo4j or ArangoDB for production
2. **In-Memory:** NetworkX for analysis and prototyping
3. **Visualization:** D3.js + Anime.js for interactive visualization
4. **Query Language:** Cypher (Neo4j) or AQL (ArangoDB)
5. **API:** GraphQL for querying

### Alternative Stack

1. **RDF Store:** Apache Jena or Blazegraph
2. **Query Language:** SPARQL
3. **Format:** JSON-LD for semantic web integration
4. **Visualization:** Cytoscape.js

## Next Steps

1. Extract entity-relation tuples from all Scheme files
2. Build hypergraph structure in NetworkX
3. Implement query and traversal functions
4. Create visualization tools
5. Export to Neo4j/ArangoDB
6. Integrate with Supabase/Neon for persistence

