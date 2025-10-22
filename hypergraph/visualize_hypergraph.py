#!/usr/bin/env python3
"""
Visualization Tools for SCMLex Hypergraph

Creates various visualizations:
1. Domain distribution charts
2. Principle-Rule network diagrams
3. Inference chain visualizations
4. Statistical dashboards
"""

import pickle
import json
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from pathlib import Path
from typing import List, Dict, Any
from collections import Counter

class HypergraphVisualizer:
    """Visualization tools for SCMLex Hypergraph"""
    
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
    
    def visualize_domain_distribution(self, output_file: str):
        """Create bar chart of domain distribution"""
        print(f"\nCreating domain distribution chart...")
        
        # Count nodes by domain
        domain_counts = Counter()
        for node_id, data in self.graph.nodes(data=True):
            if 'domains' in data:
                domains = data['domains']
                if isinstance(domains, str):
                    domains = domains.split(',')
                for domain in domains:
                    domain_counts[domain.strip()] += 1
            elif 'legal_domain' in data:
                domain_counts[data['legal_domain']] += 1
        
        # Get top 15 domains
        top_domains = domain_counts.most_common(15)
        domains = [d[0] for d in top_domains]
        counts = [d[1] for d in top_domains]
        
        # Create chart
        fig, ax = plt.subplots(figsize=(12, 8))
        bars = ax.barh(domains, counts, color='steelblue')
        
        # Add value labels
        for i, (bar, count) in enumerate(zip(bars, counts)):
            ax.text(count + 5, i, str(count), va='center', fontsize=10)
        
        ax.set_xlabel('Number of Nodes', fontsize=12)
        ax.set_ylabel('Legal Domain', fontsize=12)
        ax.set_title('SCMLex Hypergraph: Domain Distribution', fontsize=14, fontweight='bold')
        ax.grid(axis='x', alpha=0.3)
        
        plt.tight_layout()
        plt.savefig(output_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"✅ Saved: {output_file}")
    
    def visualize_node_types(self, output_file: str):
        """Create pie chart of node types"""
        print(f"\nCreating node types chart...")
        
        node_types = self.stats.get('node_types', {})
        
        # Create pie chart
        fig, ax = plt.subplots(figsize=(10, 8))
        
        colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A']
        explode = [0.05 if v == max(node_types.values()) else 0 for v in node_types.values()]
        
        wedges, texts, autotexts = ax.pie(
            node_types.values(),
            labels=node_types.keys(),
            autopct='%1.1f%%',
            colors=colors,
            explode=explode,
            startangle=90,
            textprops={'fontsize': 12}
        )
        
        # Add count labels
        for i, (label, count) in enumerate(node_types.items()):
            texts[i].set_text(f'{label.capitalize()}\n({count})')
        
        ax.set_title('SCMLex Hypergraph: Node Type Distribution', 
                    fontsize=14, fontweight='bold', pad=20)
        
        plt.tight_layout()
        plt.savefig(output_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"✅ Saved: {output_file}")
    
    def visualize_principle_network(self, output_file: str, max_nodes: int = 50):
        """Create network diagram of principles and their relationships"""
        print(f"\nCreating principle network diagram...")
        
        # Extract subgraph of principles only
        principle_nodes = [n for n, d in self.graph.nodes(data=True) 
                          if d.get('node_type') == 'principle'][:max_nodes]
        
        subgraph = self.graph.subgraph(principle_nodes)
        
        if subgraph.number_of_nodes() == 0:
            print("⚠️  No principles found for visualization")
            return
        
        # Create layout
        fig, ax = plt.subplots(figsize=(16, 12))
        
        # Use spring layout for better spacing
        pos = nx.spring_layout(subgraph, k=2, iterations=50, seed=42)
        
        # Draw nodes
        node_colors = []
        for node in subgraph.nodes():
            data = self.graph.nodes[node]
            domains = data.get('domains', [])
            if isinstance(domains, str):
                domains = domains.split(',')
            # Color by primary domain
            if 'contract' in domains:
                node_colors.append('#FF6B6B')
            elif 'criminal' in domains:
                node_colors.append('#4ECDC4')
            elif 'civil' in domains:
                node_colors.append('#45B7D1')
            else:
                node_colors.append('#95E1D3')
        
        nx.draw_networkx_nodes(subgraph, pos, 
                              node_color=node_colors,
                              node_size=800,
                              alpha=0.9,
                              ax=ax)
        
        # Draw edges
        nx.draw_networkx_edges(subgraph, pos,
                              edge_color='gray',
                              alpha=0.5,
                              arrows=True,
                              arrowsize=15,
                              width=1.5,
                              ax=ax)
        
        # Draw labels
        labels = {n: self.graph.nodes[n].get('name', '')[:15] for n in subgraph.nodes()}
        nx.draw_networkx_labels(subgraph, pos, labels,
                               font_size=8,
                               font_weight='bold',
                               ax=ax)
        
        # Add legend
        legend_elements = [
            mpatches.Patch(color='#FF6B6B', label='Contract Law'),
            mpatches.Patch(color='#4ECDC4', label='Criminal Law'),
            mpatches.Patch(color='#45B7D1', label='Civil Law'),
            mpatches.Patch(color='#95E1D3', label='Other')
        ]
        ax.legend(handles=legend_elements, loc='upper right', fontsize=10)
        
        ax.set_title(f'SCMLex Hypergraph: Principle Network (Top {len(principle_nodes)} Principles)',
                    fontsize=14, fontweight='bold', pad=20)
        ax.axis('off')
        
        plt.tight_layout()
        plt.savefig(output_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"✅ Saved: {output_file}")
    
    def visualize_level_hierarchy(self, output_file: str):
        """Create visualization showing Level 1 -> Level 2 hierarchy"""
        print(f"\nCreating level hierarchy diagram...")
        
        # Get sample of Level 1 and Level 2 nodes
        level1_nodes = [n for n, d in self.graph.nodes(data=True) 
                       if d.get('level') == 1][:10]
        
        # Get Level 2 nodes connected to these Level 1 nodes
        level2_nodes = set()
        for l1_node in level1_nodes:
            for _, target, data in self.graph.out_edges(l1_node, data=True):
                if data.get('edge_type') == 'derivation':
                    level2_nodes.add(target)
                    if len(level2_nodes) >= 20:
                        break
        
        # Create subgraph
        all_nodes = level1_nodes + list(level2_nodes)
        subgraph = self.graph.subgraph(all_nodes)
        
        if subgraph.number_of_nodes() == 0:
            print("⚠️  No hierarchy found for visualization")
            return
        
        # Create hierarchical layout
        fig, ax = plt.subplots(figsize=(16, 12))
        
        # Manual positioning: Level 1 on top, Level 2 below
        pos = {}
        l1_count = len(level1_nodes)
        l2_count = len(level2_nodes)
        
        # Position Level 1 nodes
        for i, node in enumerate(level1_nodes):
            pos[node] = (i * (10 / max(l1_count, 1)), 2)
        
        # Position Level 2 nodes
        for i, node in enumerate(level2_nodes):
            pos[node] = (i * (10 / max(l2_count, 1)), 0)
        
        # Draw Level 1 nodes (principles)
        nx.draw_networkx_nodes(subgraph, pos,
                              nodelist=level1_nodes,
                              node_color='#FF6B6B',
                              node_size=1000,
                              alpha=0.9,
                              label='Level 1 Principles',
                              ax=ax)
        
        # Draw Level 2 nodes (rules)
        nx.draw_networkx_nodes(subgraph, pos,
                              nodelist=list(level2_nodes),
                              node_color='#4ECDC4',
                              node_size=600,
                              alpha=0.9,
                              label='Level 2 Rules',
                              ax=ax)
        
        # Draw derivation edges
        derivation_edges = [(u, v) for u, v, d in subgraph.edges(data=True)
                           if d.get('edge_type') == 'derivation']
        nx.draw_networkx_edges(subgraph, pos,
                              edgelist=derivation_edges,
                              edge_color='green',
                              alpha=0.6,
                              arrows=True,
                              arrowsize=15,
                              width=2,
                              ax=ax)
        
        # Draw labels
        labels = {n: self.graph.nodes[n].get('name', '')[:12] for n in subgraph.nodes()}
        nx.draw_networkx_labels(subgraph, pos, labels,
                               font_size=7,
                               font_weight='bold',
                               ax=ax)
        
        ax.legend(loc='upper right', fontsize=12)
        ax.set_title('SCMLex Hypergraph: Level 1 → Level 2 Derivation Hierarchy',
                    fontsize=14, fontweight='bold', pad=20)
        ax.axis('off')
        
        plt.tight_layout()
        plt.savefig(output_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"✅ Saved: {output_file}")
    
    def create_statistics_dashboard(self, output_file: str):
        """Create comprehensive statistics dashboard"""
        print(f"\nCreating statistics dashboard...")
        
        fig = plt.figure(figsize=(16, 10))
        gs = fig.add_gridspec(3, 3, hspace=0.3, wspace=0.3)
        
        # 1. Node types (pie chart)
        ax1 = fig.add_subplot(gs[0, 0])
        node_types = self.stats.get('node_types', {})
        ax1.pie(node_types.values(), labels=node_types.keys(), autopct='%1.1f%%',
               colors=['#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A'])
        ax1.set_title('Node Types', fontweight='bold')
        
        # 2. Top domains (bar chart)
        ax2 = fig.add_subplot(gs[0, 1:])
        top_domains = list(self.stats.get('top_domains', {}).items())[:8]
        domains = [d[0] for d in top_domains]
        counts = [d[1] for d in top_domains]
        ax2.barh(domains, counts, color='steelblue')
        ax2.set_xlabel('Count')
        ax2.set_title('Top Legal Domains', fontweight='bold')
        ax2.grid(axis='x', alpha=0.3)
        
        # 3. Edge types (bar chart)
        ax3 = fig.add_subplot(gs[1, 0])
        edge_types = self.stats.get('edge_types', {})
        ax3.bar(edge_types.keys(), edge_types.values(), color='coral')
        ax3.set_ylabel('Count')
        ax3.set_title('Edge Types', fontweight='bold')
        ax3.grid(axis='y', alpha=0.3)
        
        # 4. Level distribution
        ax4 = fig.add_subplot(gs[1, 1])
        levels = self.stats.get('levels', {})
        ax4.bar([f'Level {k}' for k in levels.keys()], levels.values(), color='lightgreen')
        ax4.set_ylabel('Count')
        ax4.set_title('Level Distribution', fontweight='bold')
        ax4.grid(axis='y', alpha=0.3)
        
        # 5. Key statistics (text)
        ax5 = fig.add_subplot(gs[1, 2])
        ax5.axis('off')
        stats_text = f"""
        KEY STATISTICS
        
        Total Nodes: {self.stats.get('total_nodes', 0):,}
        Total Edges: {self.stats.get('total_edges', 0):,}
        Total Hyperedges: {self.stats.get('total_hyperedges', 0):,}
        
        Average Degree: {self.stats.get('average_degree', 0):.2f}
        Graph Density: {self.stats.get('density', 0):.6f}
        
        Connected: {self.stats.get('is_connected', False)}
        """
        ax5.text(0.1, 0.5, stats_text, fontsize=11, family='monospace',
                verticalalignment='center')
        
        # 6. Degree distribution (if available)
        ax6 = fig.add_subplot(gs[2, :])
        degrees = [d for n, d in self.graph.degree()]
        if degrees:
            ax6.hist(degrees, bins=30, color='purple', alpha=0.7, edgecolor='black')
            ax6.set_xlabel('Node Degree')
            ax6.set_ylabel('Frequency')
            ax6.set_title('Degree Distribution', fontweight='bold')
            ax6.grid(axis='y', alpha=0.3)
        
        fig.suptitle('SCMLex Hypergraph: Statistics Dashboard', 
                    fontsize=16, fontweight='bold', y=0.98)
        
        plt.savefig(output_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"✅ Saved: {output_file}")

def main():
    """Generate all visualizations"""
    import sys
    
    hypergraph_file = sys.argv[1] if len(sys.argv) > 1 else "/home/ubuntu/chainlex/hypergraph/scmlex_hypergraph.pkl"
    output_dir = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("/home/ubuntu/chainlex/hypergraph/visualizations")
    
    output_dir.mkdir(exist_ok=True)
    
    viz = HypergraphVisualizer(hypergraph_file)
    
    print("\n" + "="*60)
    print("GENERATING VISUALIZATIONS")
    print("="*60)
    
    viz.visualize_domain_distribution(str(output_dir / "domain_distribution.png"))
    viz.visualize_node_types(str(output_dir / "node_types.png"))
    viz.visualize_principle_network(str(output_dir / "principle_network.png"))
    viz.visualize_level_hierarchy(str(output_dir / "level_hierarchy.png"))
    viz.create_statistics_dashboard(str(output_dir / "statistics_dashboard.png"))
    
    print("\n" + "="*60)
    print(f"✅ All visualizations saved to: {output_dir}")
    print("="*60)

if __name__ == "__main__":
    main()

