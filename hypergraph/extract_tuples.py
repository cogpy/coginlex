#!/usr/bin/env python3
"""
Extract Entity-Relation Tuples from ChainLex Scheme Files

This script parses all Scheme (.scm) files in the ChainLex repository and extracts:
1. Principle definitions (Level 1)
2. Rule definitions (Level 2+)
3. Relationships between principles
4. Derivations from principles to rules
5. Domain memberships

Output: JSON file with all extracted tuples ready for hypergraph construction
"""

import re
import json
import uuid
from pathlib import Path
from typing import Dict, List, Tuple, Set
from collections import defaultdict

class SchemeParser:
    """Parser for extracting legal entities and relations from Scheme files"""
    
    def __init__(self, repo_path: str):
        self.repo_path = Path(repo_path)
        self.principles = {}
        self.rules = {}
        self.concepts = {}
        self.domains = set()
        self.relationships = []
        self.derivations = []
        
    def parse_all(self):
        """Parse all Scheme files in the repository"""
        print("Parsing ChainLex repository...")
        
        # Parse Level 1 principles
        known_laws_file = self.repo_path / "lv1" / "known_laws.scm"
        if known_laws_file.exists():
            print(f"Parsing Level 1: {known_laws_file}")
            self.parse_known_laws(known_laws_file)
        
        # Parse jurisdiction-specific frameworks
        for domain_dir in self.repo_path.iterdir():
            if domain_dir.is_dir() and domain_dir.name not in ['lv1', 'hypergraph', '.git']:
                for scm_file in domain_dir.rglob("*.scm"):
                    if 'enhanced' not in scm_file.name:  # Skip enhanced versions for now
                        print(f"Parsing Level 2+: {scm_file}")
                        self.parse_jurisdiction_file(scm_file)
        
        print(f"\nExtraction complete:")
        print(f"  Principles: {len(self.principles)}")
        print(f"  Rules: {len(self.rules)}")
        print(f"  Concepts: {len(self.concepts)}")
        print(f"  Domains: {len(self.domains)}")
        print(f"  Relationships: {len(self.relationships)}")
        print(f"  Derivations: {len(self.derivations)}")
    
    def parse_known_laws(self, file_path: Path):
        """Parse known_laws.scm to extract Level 1 principles"""
        content = file_path.read_text()
        
        # Pattern to match principle definitions
        # (define principle-name
        #   (make-principle
        #    'name 'principle-name
        #    'description "..."
        #    ...))
        
        pattern = r'\(define\s+([a-z\-]+)\s+\(make-principle\s+(.*?)\)\)'
        
        for match in re.finditer(pattern, content, re.DOTALL):
            principle_var = match.group(1)
            principle_body = match.group(2)
            
            principle = self.parse_principle_body(principle_var, principle_body)
            if principle:
                self.principles[principle['node_id']] = principle
                
                # Extract domains
                for domain in principle.get('domains', []):
                    self.domains.add(domain)
                
                # Extract relationships
                for related in principle.get('related_principles', []):
                    self.relationships.append({
                        'hyperedge_id': str(uuid.uuid4()),
                        'hyperedge_type': 'relationship',
                        'relationship_name': 'related-to',
                        'source_node': principle['node_id'],
                        'target_node': related,
                        'strength': 0.9
                    })
    
    def parse_principle_body(self, var_name: str, body: str) -> Dict:
        """Parse the body of a make-principle call"""
        principle = {
            'node_id': str(uuid.uuid4()),
            'node_type': 'principle',
            'level': 1,
            'name': var_name,
            'confidence': 1.0
        }
        
        # Extract attributes
        attributes = {
            'name': r"'name\s+'([a-z\-]+)",
            'description': r"'description\s+\"([^\"]+)\"",
            'domain': r"'domain\s+'?\(([^\)]+)\)",
            'provenance': r"'provenance\s+\"([^\"]+)\"",
            'related-principles': r"'related-principles\s+'?\(([^\)]+)\)",
            'inference-type': r"'inference-type\s+'([a-z\-]+)",
            'application-context': r"'application-context\s+\"([^\"]+)\""
        }
        
        for attr, pattern in attributes.items():
            match = re.search(pattern, body)
            if match:
                value = match.group(1).strip()
                
                if attr == 'domain':
                    # Parse list of domains
                    domains = [d.strip() for d in value.split() if d.strip()]
                    principle['domains'] = domains
                elif attr == 'related-principles':
                    # Parse list of related principles
                    related = [r.strip() for r in value.split() if r.strip()]
                    principle['related_principles'] = related
                elif attr == 'inference-type':
                    principle['inference_type'] = value
                elif attr == 'application-context':
                    principle['application_context'] = value
                elif attr == 'description':
                    principle['description'] = value
                elif attr == 'provenance':
                    principle['provenance'] = value
        
        return principle
    
    def parse_jurisdiction_file(self, file_path: Path):
        """Parse jurisdiction-specific Scheme files to extract rules"""
        content = file_path.read_text()
        
        # Determine jurisdiction and domain from path
        # e.g., civ/za/south_african_civil_law.scm -> jurisdiction=ZA, domain=civil
        parts = file_path.parts
        domain_code = parts[-3] if len(parts) >= 3 else 'unknown'
        jurisdiction = parts[-2].upper() if len(parts) >= 2 else 'ZA'
        
        domain_mapping = {
            'adm': 'administrative',
            'civ': 'civil',
            'con': 'constitutional',
            'cri': 'criminal',
            'cst': 'construction',
            'env': 'environmental',
            'int': 'international',
            'lab': 'labour'
        }
        
        legal_domain = domain_mapping.get(domain_code, domain_code)
        self.domains.add(legal_domain)
        
        # Pattern to match function definitions
        # (define function-name (lambda (args) body))
        # or
        # (define (function-name args) body)
        
        pattern1 = r'\(define\s+([a-z\-\?]+)\s+\(lambda\s+\(([^\)]*)\)\s+(.*?)\)\)'
        pattern2 = r'\(define\s+\(([a-z\-\?]+)\s+([^\)]*)\)\s+(.*?)\n\)'
        
        for pattern in [pattern1, pattern2]:
            for match in re.finditer(pattern, content, re.DOTALL):
                func_name = match.group(1)
                func_args = match.group(2)
                func_body = match.group(3)
                
                # Look for docstring (comment before or after definition)
                docstring = self.extract_docstring(content, func_name)
                
                # Extract cross-references to Level 1 principles
                cross_refs = self.extract_cross_references(func_body, docstring)
                
                rule = {
                    'node_id': str(uuid.uuid4()),
                    'node_type': 'rule',
                    'level': 2,
                    'name': func_name,
                    'description': docstring or f"Rule: {func_name}",
                    'jurisdiction': jurisdiction,
                    'legal_domain': legal_domain,
                    'confidence': 0.95,
                    'derived_from': cross_refs,
                    'inference_type': 'deductive',
                    'implementation': f"(define ({func_name} {func_args}) ...)"
                }
                
                self.rules[rule['node_id']] = rule
                
                # Create derivation hyperedges
                if cross_refs:
                    self.derivations.append({
                        'hyperedge_id': str(uuid.uuid4()),
                        'hyperedge_type': 'derivation',
                        'source_nodes': cross_refs,
                        'target_node': rule['node_id'],
                        'inference_type': 'deductive',
                        'confidence_impact': 0.95,
                        'description': f"{func_name} derives from Level 1 principles"
                    })
    
    def extract_docstring(self, content: str, func_name: str) -> str:
        """Extract docstring for a function"""
        # Look for comment with function name
        pattern = rf';;\s*{func_name}[^\n]*\n;;\s*([^\n]+)'
        match = re.search(pattern, content)
        if match:
            return match.group(1).strip()
        
        # Look for string literal after definition
        pattern = rf'\(define.*{func_name}.*\n\s*"([^"]+)"'
        match = re.search(pattern, content, re.DOTALL)
        if match:
            return match.group(1).strip()
        
        return ""
    
    def extract_cross_references(self, func_body: str, docstring: str) -> List[str]:
        """Extract cross-references to Level 1 principles"""
        cross_refs = []
        
        # Look for "Cross-reference:" in docstring
        if docstring:
            pattern = r'Cross-reference:\s*([a-z\-,\s]+)'
            match = re.search(pattern, docstring, re.IGNORECASE)
            if match:
                refs = match.group(1)
                cross_refs = [r.strip() for r in refs.split(',') if r.strip()]
        
        # Look for principle names in function body
        for principle_name in self.principles.values():
            name = principle_name.get('name', '')
            if name and name in func_body:
                if name not in cross_refs:
                    cross_refs.append(name)
        
        return cross_refs
    
    def export_to_json(self, output_path: str):
        """Export all extracted data to JSON"""
        data = {
            'metadata': {
                'version': '1.0',
                'generated': '2025-10-23',
                'source': 'ChainLex Repository',
                'description': 'Entity-relation tuples for SCMLex Hypergraph'
            },
            'statistics': {
                'principle_count': len(self.principles),
                'rule_count': len(self.rules),
                'concept_count': len(self.concepts),
                'domain_count': len(self.domains),
                'relationship_count': len(self.relationships),
                'derivation_count': len(self.derivations)
            },
            'nodes': {
                'principles': list(self.principles.values()),
                'rules': list(self.rules.values()),
                'concepts': list(self.concepts.values()),
                'domains': [{'node_id': str(uuid.uuid4()), 
                            'node_type': 'domain', 
                            'name': d} for d in self.domains]
            },
            'hyperedges': {
                'relationships': self.relationships,
                'derivations': self.derivations
            }
        }
        
        output_file = Path(output_path)
        output_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_file, 'w') as f:
            json.dump(data, f, indent=2)
        
        print(f"\nExported to: {output_file}")
        print(f"File size: {output_file.stat().st_size / 1024:.2f} KB")

def main():
    """Main execution"""
    import sys
    
    repo_path = sys.argv[1] if len(sys.argv) > 1 else "/home/ubuntu/chainlex"
    output_path = sys.argv[2] if len(sys.argv) > 2 else "/home/ubuntu/chainlex/hypergraph/tuples.json"
    
    parser = SchemeParser(repo_path)
    parser.parse_all()
    parser.export_to_json(output_path)
    
    print("\n✅ Extraction complete!")

if __name__ == "__main__":
    main()

