#!/usr/bin/env python3
"""
Query and Traversal Functions for SCMLex Hypergraph

Provides sophisticated query capabilities for legal reasoning:
1. Find principles by domain
2. Find rules derived from principles
3. Build inference chains
4. Compute confidence paths
5. Find related concepts
6. Domain-specific queries
"""

import pickle
import json
import networkx as nx
from pathlib import Path
from typing import List, Dict, Any, Optional, Set, Tuple
from collections import defaultdict

class HypergraphQuery:
    """Query interface for SCMLex Hypergraph"""
    
    def __init__(self, hypergraph_file: str):
        """Load hypergraph from pickle file"""
        print(f"Loading hypergraph from {hypergraph_file}...")
        with open(hypergraph_file, 'rb') as f:
            data = pickle.load(f)
        
        self.graph = data['graph']
        self.hyperedges = data['hyperedges']
        self.node_index = data['node_index']
        self.stats = data['stats']
        
        print(f"✅ Loaded: {self.graph.number_of_nodes()} nodes, {self.graph.number_of_edges()} edges")
    
    def find_principles_by_domain(self, domain: str) -> List[Dict]:
        """Find all Level 1 principles applicable to a domain"""
        results = []
        for node_id, data in self.graph.nodes(data=True):
            if data.get('node_type') == 'principle':
                domains = data.get('domains', [])
                if isinstance(domains, str):
                    domains = domains.split(',')
                if domain in domains:
                    results.append({
                        'id': node_id,
                        'name': data.get('name', ''),
                        'description': data.get('description', ''),
                        'confidence': data.get('confidence', 1.0),
                        'domains': domains
                    })
        return results
    
    def find_rules_by_jurisdiction(self, jurisdiction: str, domain: Optional[str] = None) -> List[Dict]:
        """Find all rules for a specific jurisdiction and optionally domain"""
        results = []
        for node_id, data in self.graph.nodes(data=True):
            if data.get('node_type') == 'rule':
                if data.get('jurisdiction', '').upper() == jurisdiction.upper():
                    if domain is None or data.get('legal_domain') == domain:
                        results.append({
                            'id': node_id,
                            'name': data.get('name', ''),
                            'description': data.get('description', ''),
                            'jurisdiction': data.get('jurisdiction', ''),
                            'legal_domain': data.get('legal_domain', ''),
                            'confidence': data.get('confidence', 0.95)
                        })
        return results
    
    def find_rules_derived_from_principle(self, principle_name: str) -> List[Dict]:
        """Find all rules derived from a specific principle"""
        # Get principle node ID
        principle_id = self.node_index.get(principle_name)
        if not principle_id:
            return []
        
        results = []
        # Find all outgoing derivation edges
        for _, target, data in self.graph.out_edges(principle_id, data=True):
            if data.get('edge_type') == 'derivation':
                target_data = self.graph.nodes[target]
                results.append({
                    'id': target,
                    'name': target_data.get('name', ''),
                    'description': target_data.get('description', ''),
                    'jurisdiction': target_data.get('jurisdiction', ''),
                    'legal_domain': target_data.get('legal_domain', ''),
                    'confidence': target_data.get('confidence', 0.95),
                    'inference_type': data.get('inference_type', 'deductive')
                })
        return results
    
    def find_related_principles(self, principle_name: str) -> List[Dict]:
        """Find all principles related to a given principle"""
        principle_id = self.node_index.get(principle_name)
        if not principle_id:
            return []
        
        results = []
        # Find all relationship edges
        for _, target, data in self.graph.out_edges(principle_id, data=True):
            if data.get('edge_type') == 'relationship':
                target_data = self.graph.nodes[target]
                if target_data.get('node_type') == 'principle':
                    results.append({
                        'id': target,
                        'name': target_data.get('name', ''),
                        'description': target_data.get('description', ''),
                        'relationship': data.get('relationship_name', 'related-to'),
                        'strength': data.get('strength', 0.9)
                    })
        return results
    
    def build_inference_chain(self, start_principle: str, end_rule: str) -> Optional[List[Dict]]:
        """Build an inference chain from a principle to a rule"""
        start_id = self.node_index.get(start_principle)
        end_id = self.node_index.get(end_rule)
        
        if not start_id or not end_id:
            return None
        
        try:
            # Find shortest path
            path = nx.shortest_path(self.graph, start_id, end_id)
            
            # Build chain with details
            chain = []
            for i, node_id in enumerate(path):
                node_data = self.graph.nodes[node_id]
                chain_item = {
                    'step': i + 1,
                    'id': node_id,
                    'name': node_data.get('name', ''),
                    'type': node_data.get('node_type', ''),
                    'level': node_data.get('level', 0),
                    'confidence': node_data.get('confidence', 1.0)
                }
                
                # Add edge information if not the last node
                if i < len(path) - 1:
                    edge_data = self.graph.get_edge_data(node_id, path[i+1])
                    if edge_data:
                        # Handle MultiDiGraph - get first edge
                        if isinstance(edge_data, dict) and 0 in edge_data:
                            edge_data = edge_data[0]
                        chain_item['edge_to_next'] = {
                            'type': edge_data.get('edge_type', ''),
                            'inference_type': edge_data.get('inference_type', ''),
                            'confidence_impact': edge_data.get('confidence_impact', 1.0)
                        }
                
                chain.append(chain_item)
            
            return chain
        except nx.NetworkXNoPath:
            return None
    
    def compute_path_confidence(self, path: List[Dict]) -> float:
        """Compute cumulative confidence along an inference chain"""
        confidence = 1.0
        for item in path:
            confidence *= item.get('confidence', 1.0)
            if 'edge_to_next' in item:
                confidence *= item['edge_to_next'].get('confidence_impact', 1.0)
        return round(confidence, 4)
    
    def find_all_paths(self, start_principle: str, end_rule: str, max_length: int = 5) -> List[List[Dict]]:
        """Find all paths from principle to rule up to max_length"""
        start_id = self.node_index.get(start_principle)
        end_id = self.node_index.get(end_rule)
        
        if not start_id or not end_id:
            return []
        
        try:
            all_paths = []
            for path in nx.all_simple_paths(self.graph, start_id, end_id, cutoff=max_length):
                # Build detailed path
                detailed_path = []
                for i, node_id in enumerate(path):
                    node_data = self.graph.nodes[node_id]
                    detailed_path.append({
                        'step': i + 1,
                        'id': node_id,
                        'name': node_data.get('name', ''),
                        'type': node_data.get('node_type', ''),
                        'confidence': node_data.get('confidence', 1.0)
                    })
                all_paths.append(detailed_path)
            return all_paths
        except nx.NetworkXNoPath:
            return []
    
    def get_principle_by_name(self, name: str) -> Optional[Dict]:
        """Get full details of a principle by name"""
        node_id = self.node_index.get(name)
        if not node_id:
            return None
        
        data = self.graph.nodes[node_id]
        return {
            'id': node_id,
            'name': data.get('name', ''),
            'description': data.get('description', ''),
            'domains': data.get('domains', []),
            'confidence': data.get('confidence', 1.0),
            'provenance': data.get('provenance', ''),
            'inference_type': data.get('inference_type', ''),
            'application_context': data.get('application_context', '')
        }
    
    def get_rule_by_name(self, name: str) -> Optional[Dict]:
        """Get full details of a rule by name"""
        node_id = self.node_index.get(name)
        if not node_id:
            return None
        
        data = self.graph.nodes[node_id]
        return {
            'id': node_id,
            'name': data.get('name', ''),
            'description': data.get('description', ''),
            'jurisdiction': data.get('jurisdiction', ''),
            'legal_domain': data.get('legal_domain', ''),
            'confidence': data.get('confidence', 0.95),
            'level': data.get('level', 2),
            'derived_from': data.get('derived_from', []),
            'inference_type': data.get('inference_type', 'deductive')
        }
    
    def search_by_keyword(self, keyword: str, node_type: Optional[str] = None) -> List[Dict]:
        """Search for nodes by keyword in name or description"""
        keyword_lower = keyword.lower()
        results = []
        
        for node_id, data in self.graph.nodes(data=True):
            if node_type and data.get('node_type') != node_type:
                continue
            
            name = data.get('name', '').lower()
            description = data.get('description', '').lower()
            
            if keyword_lower in name or keyword_lower in description:
                results.append({
                    'id': node_id,
                    'type': data.get('node_type', ''),
                    'name': data.get('name', ''),
                    'description': data.get('description', ''),
                    'relevance': 'name' if keyword_lower in name else 'description'
                })
        
        return results
    
    def get_domain_statistics(self, domain: str) -> Dict:
        """Get statistics for a specific legal domain"""
        principles = self.find_principles_by_domain(domain)
        
        # Count rules in this domain
        rule_count = 0
        jurisdictions = set()
        for node_id, data in self.graph.nodes(data=True):
            if data.get('node_type') == 'rule' and data.get('legal_domain') == domain:
                rule_count += 1
                jurisdictions.add(data.get('jurisdiction', ''))
        
        return {
            'domain': domain,
            'principle_count': len(principles),
            'rule_count': rule_count,
            'jurisdictions': list(jurisdictions),
            'principles': [p['name'] for p in principles]
        }
    
    def export_subgraph(self, node_ids: List[str], output_file: str):
        """Export a subgraph containing specific nodes"""
        subgraph = self.graph.subgraph(node_ids)
        
        data = {
            'nodes': [],
            'edges': []
        }
        
        for node_id in subgraph.nodes():
            node_data = dict(self.graph.nodes[node_id])
            node_data['id'] = node_id
            data['nodes'].append(node_data)
        
        for source, target, edge_data in subgraph.edges(data=True):
            edge_dict = dict(edge_data)
            edge_dict['source'] = source
            edge_dict['target'] = target
            data['edges'].append(edge_dict)
        
        with open(output_file, 'w') as f:
            json.dump(data, f, indent=2)
        
        print(f"✅ Subgraph exported to {output_file}")

def main():
    """Example queries"""
    import sys
    
    hypergraph_file = sys.argv[1] if len(sys.argv) > 1 else "/home/ubuntu/chainlex/hypergraph/scmlex_hypergraph.pkl"
    
    query = HypergraphQuery(hypergraph_file)
    
    print("\n" + "="*60)
    print("EXAMPLE QUERIES")
    print("="*60)
    
    # Query 1: Find contract law principles
    print("\n1. Principles in Contract Law:")
    principles = query.find_principles_by_domain('contract')
    for p in principles[:5]:
        print(f"   - {p['name']}: {p['description'][:60]}...")
    print(f"   Total: {len(principles)} principles")
    
    # Query 2: Find South African civil law rules
    print("\n2. South African Civil Law Rules:")
    rules = query.find_rules_by_jurisdiction('ZA', 'civil')
    for r in rules[:5]:
        print(f"   - {r['name']}: {r['description'][:60]}...")
    print(f"   Total: {len(rules)} rules")
    
    # Query 3: Find rules derived from pacta-sunt-servanda
    print("\n3. Rules derived from 'pacta-sunt-servanda':")
    derived = query.find_rules_derived_from_principle('pacta-sunt-servanda')
    for r in derived[:5]:
        print(f"   - {r['name']} ({r['legal_domain']})")
    print(f"   Total: {len(derived)} rules")
    
    # Query 4: Find related principles
    print("\n4. Principles related to 'pacta-sunt-servanda':")
    related = query.find_related_principles('pacta-sunt-servanda')
    for r in related[:5]:
        print(f"   - {r['name']} (strength: {r['strength']})")
    print(f"   Total: {len(related)} related principles")
    
    # Query 5: Search by keyword
    print("\n5. Search for 'contract':")
    search_results = query.search_by_keyword('contract', node_type='rule')
    for r in search_results[:5]:
        print(f"   - {r['name']} ({r['type']})")
    print(f"   Total: {len(search_results)} results")
    
    # Query 6: Domain statistics
    print("\n6. Contract Law Domain Statistics:")
    stats = query.get_domain_statistics('contract')
    print(f"   Principles: {stats['principle_count']}")
    print(f"   Rules: {stats['rule_count']}")
    print(f"   Jurisdictions: {', '.join(stats['jurisdictions'])}")
    
    print("\n" + "="*60)
    print("✅ Query examples complete!")

if __name__ == "__main__":
    main()

