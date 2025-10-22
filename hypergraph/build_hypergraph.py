#!/usr/bin/env python3
"""
Build SCMLex Hypergraph from Extracted Tuples

This script constructs a NetworkX-based hypergraph from the extracted
entity-relation tuples, providing:
1. Graph construction with nodes and edges
2. Hyperedge support (edges connecting multiple nodes)
3. Graph statistics and analysis
4. Export to multiple formats (GraphML, JSON, Neo4j)
"""

import json
import networkx as nx
from pathlib import Path
from typing import Dict, List, Any
from collections import defaultdict, Counter
import pickle

class SCMLexHypergraph:
    """Universal hypergraph for legal reasoning"""
    
    def __init__(self):
        self.graph = nx.MultiDiGraph()  # Directed graph with multiple edges
        self.hyperedges = []  # Store hyperedges separately
        self.node_index = {}  # Map node names to IDs
        self.stats = {}
        
    def load_from_tuples(self, tuples_file: str):
        """Load graph from extracted tuples JSON"""
        print(f"Loading tuples from {tuples_file}...")
        
        with open(tuples_file, 'r') as f:
            data = json.load(f)
        
        # Add nodes
        self._add_principles(data['nodes']['principles'])
        self._add_rules(data['nodes']['rules'])
        self._add_concepts(data['nodes']['concepts'])
        self._add_domains(data['nodes']['domains'])
        
        # Add hyperedges
        self._add_relationships(data['hyperedges']['relationships'])
        self._add_derivations(data['hyperedges']['derivations'])
        
        # Compute statistics
        self._compute_statistics()
        
        print(f"\n✅ Hypergraph constructed:")
        print(f"   Nodes: {self.graph.number_of_nodes()}")
        print(f"   Edges: {self.graph.number_of_edges()}")
        print(f"   Hyperedges: {len(self.hyperedges)}")
    
    def _add_principles(self, principles: List[Dict]):
        """Add Level 1 principle nodes"""
        print(f"Adding {len(principles)} principles...")
        for p in principles:
            node_id = p['node_id']
            self.graph.add_node(
                node_id,
                node_type='principle',
                level=1,
                name=p.get('name', ''),
                description=p.get('description', ''),
                domains=p.get('domains', []),
                confidence=p.get('confidence', 1.0),
                provenance=p.get('provenance', ''),
                inference_type=p.get('inference_type', ''),
                application_context=p.get('application_context', '')
            )
            # Index by name for easy lookup
            if 'name' in p:
                self.node_index[p['name']] = node_id
    
    def _add_rules(self, rules: List[Dict]):
        """Add Level 2+ rule nodes"""
        print(f"Adding {len(rules)} rules...")
        for r in rules:
            node_id = r['node_id']
            self.graph.add_node(
                node_id,
                node_type='rule',
                level=r.get('level', 2),
                name=r.get('name', ''),
                description=r.get('description', ''),
                jurisdiction=r.get('jurisdiction', ''),
                legal_domain=r.get('legal_domain', ''),
                confidence=r.get('confidence', 0.95),
                derived_from=r.get('derived_from', []),
                inference_type=r.get('inference_type', 'deductive')
            )
            if 'name' in r:
                self.node_index[r['name']] = node_id
    
    def _add_concepts(self, concepts: List[Dict]):
        """Add concept nodes"""
        if concepts:
            print(f"Adding {len(concepts)} concepts...")
            for c in concepts:
                node_id = c['node_id']
                self.graph.add_node(
                    node_id,
                    node_type='concept',
                    name=c.get('name', ''),
                    description=c.get('description', ''),
                    domains=c.get('domains', [])
                )
                if 'name' in c:
                    self.node_index[c['name']] = node_id
    
    def _add_domains(self, domains: List[Dict]):
        """Add domain nodes"""
        print(f"Adding {len(domains)} domains...")
        for d in domains:
            node_id = d['node_id']
            self.graph.add_node(
                node_id,
                node_type='domain',
                name=d.get('name', '')
            )
            if 'name' in d:
                self.node_index[d['name']] = node_id
    
    def _add_relationships(self, relationships: List[Dict]):
        """Add relationship edges between principles"""
        print(f"Adding {len(relationships)} relationships...")
        for rel in relationships:
            source = rel['source_node']
            # Handle both single target and multiple targets
            targets = rel.get('target_nodes', [rel.get('target_node')])
            if not isinstance(targets, list):
                targets = [targets]
            
            for target in targets:
                # Resolve names to IDs if needed
                source_id = self.node_index.get(source, source)
                target_id = self.node_index.get(target, target)
                
                if self.graph.has_node(source_id) and self.graph.has_node(target_id):
                    self.graph.add_edge(
                        source_id,
                        target_id,
                        edge_type='relationship',
                        relationship_name=rel.get('relationship_name', 'related-to'),
                        strength=rel.get('strength', 0.9),
                        hyperedge_id=rel.get('hyperedge_id', '')
                    )
            
            # Store as hyperedge if multiple targets
            if len(targets) > 1:
                self.hyperedges.append(rel)
    
    def _add_derivations(self, derivations: List[Dict]):
        """Add derivation edges from principles to rules"""
        print(f"Adding {len(derivations)} derivations...")
        for deriv in derivations:
            source_nodes = deriv.get('source_nodes', [])
            target_node = deriv.get('target_node', '')
            
            # Add edges from each source principle to the target rule
            for source in source_nodes:
                source_id = self.node_index.get(source, source)
                target_id = target_node
                
                if self.graph.has_node(source_id) and self.graph.has_node(target_id):
                    self.graph.add_edge(
                        source_id,
                        target_id,
                        edge_type='derivation',
                        inference_type=deriv.get('inference_type', 'deductive'),
                        confidence_impact=deriv.get('confidence_impact', 0.95),
                        hyperedge_id=deriv.get('hyperedge_id', ''),
                        description=deriv.get('description', '')
                    )
            
            # Store as hyperedge
            self.hyperedges.append(deriv)
    
    def _compute_statistics(self):
        """Compute graph statistics"""
        print("\nComputing graph statistics...")
        
        # Node statistics
        node_types = Counter(nx.get_node_attributes(self.graph, 'node_type').values())
        
        # Edge statistics
        edge_types = Counter(nx.get_edge_attributes(self.graph, 'edge_type').values())
        
        # Domain statistics
        domains = []
        for node, data in self.graph.nodes(data=True):
            if 'domains' in data:
                domains.extend(data['domains'])
            elif 'legal_domain' in data:
                domains.append(data['legal_domain'])
        domain_counts = Counter(domains)
        
        # Level statistics
        levels = Counter(nx.get_node_attributes(self.graph, 'level').values())
        
        # Connectivity statistics
        if self.graph.number_of_nodes() > 0:
            avg_degree = sum(dict(self.graph.degree()).values()) / self.graph.number_of_nodes()
        else:
            avg_degree = 0
        
        self.stats = {
            'total_nodes': self.graph.number_of_nodes(),
            'total_edges': self.graph.number_of_edges(),
            'total_hyperedges': len(self.hyperedges),
            'node_types': dict(node_types),
            'edge_types': dict(edge_types),
            'levels': dict(levels),
            'top_domains': dict(domain_counts.most_common(10)),
            'average_degree': round(avg_degree, 2),
            'density': round(nx.density(self.graph), 6),
            'is_connected': nx.is_weakly_connected(self.graph) if self.graph.number_of_nodes() > 0 else False
        }
        
        # Print statistics
        print("\n" + "="*60)
        print("HYPERGRAPH STATISTICS")
        print("="*60)
        print(f"Total Nodes: {self.stats['total_nodes']}")
        print(f"Total Edges: {self.stats['total_edges']}")
        print(f"Total Hyperedges: {self.stats['total_hyperedges']}")
        print(f"\nNode Types:")
        for ntype, count in self.stats['node_types'].items():
            print(f"  {ntype}: {count}")
        print(f"\nEdge Types:")
        for etype, count in self.stats['edge_types'].items():
            print(f"  {etype}: {count}")
        print(f"\nLevels:")
        for level, count in self.stats['levels'].items():
            print(f"  Level {level}: {count}")
        print(f"\nTop Domains:")
        for domain, count in list(self.stats['top_domains'].items())[:5]:
            print(f"  {domain}: {count}")
        print(f"\nConnectivity:")
        print(f"  Average Degree: {self.stats['average_degree']}")
        print(f"  Density: {self.stats['density']}")
        print(f"  Weakly Connected: {self.stats['is_connected']}")
        print("="*60)
    
    def export_graphml(self, output_path: str):
        """Export to GraphML format (for Gephi, Cytoscape)"""
        print(f"\nExporting to GraphML: {output_path}")
        # Create a copy and convert list attributes to strings for GraphML compatibility
        graph_copy = self.graph.copy()
        for node, data in graph_copy.nodes(data=True):
            for key, value in list(data.items()):
                if isinstance(value, list):
                    data[key] = ','.join(str(v) for v in value)
        for u, v, key, data in graph_copy.edges(keys=True, data=True):
            for attr, value in list(data.items()):
                if isinstance(value, list):
                    data[attr] = ','.join(str(val) for val in value)
        nx.write_graphml(graph_copy, output_path)
        print(f"✅ GraphML exported")
    
    def export_json(self, output_path: str):
        """Export to JSON format"""
        print(f"\nExporting to JSON: {output_path}")
        data = nx.node_link_data(self.graph)
        data['hyperedges'] = self.hyperedges
        data['statistics'] = self.stats
        
        with open(output_path, 'w') as f:
            json.dump(data, f, indent=2)
        print(f"✅ JSON exported")
    
    def export_pickle(self, output_path: str):
        """Export to Python pickle format"""
        print(f"\nExporting to Pickle: {output_path}")
        with open(output_path, 'wb') as f:
            pickle.dump({
                'graph': self.graph,
                'hyperedges': self.hyperedges,
                'node_index': self.node_index,
                'stats': self.stats
            }, f)
        print(f"✅ Pickle exported")
    
    def export_neo4j_cypher(self, output_path: str):
        """Export to Neo4j Cypher statements"""
        print(f"\nExporting to Neo4j Cypher: {output_path}")
        
        with open(output_path, 'w') as f:
            # Write header
            f.write("// SCMLex Hypergraph - Neo4j Import Script\n")
            f.write("// Generated: 2025-10-23\n\n")
            
            # Create constraints
            f.write("// Create constraints\n")
            f.write("CREATE CONSTRAINT principle_id IF NOT EXISTS FOR (p:Principle) REQUIRE p.id IS UNIQUE;\n")
            f.write("CREATE CONSTRAINT rule_id IF NOT EXISTS FOR (r:Rule) REQUIRE r.id IS UNIQUE;\n")
            f.write("CREATE CONSTRAINT domain_id IF NOT EXISTS FOR (d:Domain) REQUIRE d.id IS UNIQUE;\n\n")
            
            # Create nodes
            f.write("// Create nodes\n")
            for node_id, data in self.graph.nodes(data=True):
                node_type = data.get('node_type', 'Unknown')
                label = node_type.capitalize()
                
                props = {
                    'id': node_id,
                    'name': data.get('name', ''),
                    'description': data.get('description', '').replace("'", "\\'").replace('"', '\\"')
                }
                
                # Add type-specific properties
                if node_type == 'principle':
                    props.update({
                        'level': data.get('level', 1),
                        'confidence': data.get('confidence', 1.0),
                        'provenance': data.get('provenance', ''),
                        'inference_type': data.get('inference_type', '')
                    })
                elif node_type == 'rule':
                    props.update({
                        'level': data.get('level', 2),
                        'jurisdiction': data.get('jurisdiction', ''),
                        'legal_domain': data.get('legal_domain', ''),
                        'confidence': data.get('confidence', 0.95)
                    })
                
                # Format properties
                props_str = ', '.join([f"{k}: '{v}'" if isinstance(v, str) else f"{k}: {v}" 
                                      for k, v in props.items() if v])
                
                f.write(f"CREATE (:{label} {{{props_str}}});\n")
            
            f.write("\n// Create relationships\n")
            for source, target, data in self.graph.edges(data=True):
                edge_type = data.get('edge_type', 'RELATES_TO').upper()
                props = {k: v for k, v in data.items() if k != 'edge_type' and v}
                props_str = ', '.join([f"{k}: '{v}'" if isinstance(v, str) else f"{k}: {v}" 
                                      for k, v in props.items()])
                
                f.write(f"MATCH (a {{id: '{source}'}}), (b {{id: '{target}'}}) ")
                f.write(f"CREATE (a)-[:{edge_type} {{{props_str}}}]->(b);\n")
        
        print(f"✅ Neo4j Cypher exported")

def main():
    """Main execution"""
    import sys
    
    tuples_file = sys.argv[1] if len(sys.argv) > 1 else "/home/ubuntu/chainlex/hypergraph/tuples.json"
    output_dir = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("/home/ubuntu/chainlex/hypergraph")
    
    # Build hypergraph
    hypergraph = SCMLexHypergraph()
    hypergraph.load_from_tuples(tuples_file)
    
    # Export to multiple formats
    hypergraph.export_graphml(str(output_dir / "scmlex_hypergraph.graphml"))
    hypergraph.export_json(str(output_dir / "scmlex_hypergraph.json"))
    hypergraph.export_pickle(str(output_dir / "scmlex_hypergraph.pkl"))
    hypergraph.export_neo4j_cypher(str(output_dir / "scmlex_hypergraph_neo4j.cypher"))
    
    # Save statistics
    with open(output_dir / "hypergraph_stats.json", 'w') as f:
        json.dump(hypergraph.stats, f, indent=2)
    
    print("\n✅ Hypergraph construction complete!")
    print(f"   Output directory: {output_dir}")

if __name__ == "__main__":
    main()

