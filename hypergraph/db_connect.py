#!/usr/bin/env python3
"""
Database Connection Utility for SCMLex Hypergraph

This script provides utilities for connecting to the Neon PostgreSQL database
and managing database operations for the SCMLex hypergraph.

Usage:
    python hypergraph/db_connect.py --test              # Test connection
    python hypergraph/db_connect.py --init              # Initialize schema
    python hypergraph/db_connect.py --load              # Load hypergraph data
    python hypergraph/db_connect.py --query <query>     # Execute a query
"""

import os
import sys
import argparse
from pathlib import Path
from typing import Optional, Dict, Any, List
import json

try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
except ImportError:
    print("Error: psycopg2 not installed. Install with: pip install psycopg2-binary")
    sys.exit(1)

try:
    from dotenv import load_dotenv
except ImportError:
    print("Warning: python-dotenv not installed. Install with: pip install python-dotenv")
    load_dotenv = None


class DatabaseConnection:
    """Manages PostgreSQL database connections for SCMLex Hypergraph"""
    
    def __init__(self, connection_string: Optional[str] = None):
        """
        Initialize database connection.
        
        Args:
            connection_string: PostgreSQL connection string. If None, reads from environment.
        """
        # Load environment variables if available
        if load_dotenv is not None:
            env_path = Path(__file__).parent.parent / '.env'
            if env_path.exists():
                load_dotenv(env_path)
        
        # Get connection string from parameter or environment
        self.connection_string = connection_string or os.getenv('DATABASE_URL')
        
        if not self.connection_string:
            # Try to build from individual parameters
            host = os.getenv('DB_HOST')
            port = os.getenv('DB_PORT', '5432')
            dbname = os.getenv('DB_NAME')
            user = os.getenv('DB_USER')
            password = os.getenv('DB_PASSWORD')
            sslmode = os.getenv('DB_SSLMODE', 'require')
            
            if all([host, dbname, user, password]):
                self.connection_string = (
                    f"postgresql://{user}:{password}@{host}:{port}/{dbname}"
                    f"?sslmode={sslmode}"
                )
                channel_binding = os.getenv('DB_CHANNEL_BINDING')
                if channel_binding:
                    self.connection_string += f"&channel_binding={channel_binding}"
        
        if not self.connection_string:
            raise ValueError(
                "Database connection string not found. "
                "Set DATABASE_URL environment variable or create .env file. "
                "See .env.example for template."
            )
        
        self.conn = None
        self.cursor = None
    
    def connect(self) -> bool:
        """
        Establish database connection.
        
        Returns:
            True if connection successful, False otherwise
        """
        try:
            self.conn = psycopg2.connect(self.connection_string)
            self.cursor = self.conn.cursor(cursor_factory=RealDictCursor)
            return True
        except psycopg2.Error as e:
            print(f"Error connecting to database: {e}")
            return False
    
    def disconnect(self):
        """Close database connection."""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
    
    def test_connection(self) -> bool:
        """
        Test database connection.
        
        Returns:
            True if connection successful, False otherwise
        """
        if not self.connect():
            return False
        
        try:
            self.cursor.execute("SELECT version();")
            version = self.cursor.fetchone()
            print("✅ Database connection successful!")
            print(f"PostgreSQL version: {version['version']}")
            
            # Check if tables exist
            self.cursor.execute("""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name IN ('scmlex_nodes', 'scmlex_edges', 'scmlex_hyperedges')
                ORDER BY table_name;
            """)
            tables = self.cursor.fetchall()
            
            if tables:
                print(f"\n✅ Found {len(tables)} SCMLex tables:")
                for table in tables:
                    print(f"   - {table['table_name']}")
            else:
                print("\n⚠️  No SCMLex tables found. Run with --init to initialize schema.")
            
            return True
        except psycopg2.Error as e:
            print(f"❌ Error testing connection: {e}")
            return False
        finally:
            self.disconnect()
    
    def execute_sql_file(self, sql_file: Path) -> bool:
        """
        Execute SQL commands from a file.
        
        Args:
            sql_file: Path to SQL file
            
        Returns:
            True if successful, False otherwise
        """
        if not sql_file.exists():
            print(f"❌ SQL file not found: {sql_file}")
            return False
        
        if not self.connect():
            return False
        
        try:
            with open(sql_file, 'r') as f:
                sql = f.read()
            
            self.cursor.execute(sql)
            self.conn.commit()
            print(f"✅ Successfully executed: {sql_file.name}")
            return True
        except psycopg2.Error as e:
            print(f"❌ Error executing SQL file: {e}")
            self.conn.rollback()
            return False
        finally:
            self.disconnect()
    
    def initialize_schema(self) -> bool:
        """
        Initialize database schema.
        
        Returns:
            True if successful, False otherwise
        """
        schema_file = Path(__file__).parent / 'database' / 'schema.sql'
        print(f"Initializing database schema from: {schema_file}")
        return self.execute_sql_file(schema_file)
    
    def load_hypergraph_data(self) -> bool:
        """
        Load hypergraph data from JSON into database.
        
        Returns:
            True if successful, False otherwise
        """
        tuples_file = Path(__file__).parent / 'tuples.json'
        
        if not tuples_file.exists():
            print(f"❌ Tuples file not found: {tuples_file}")
            print("   Run build_hypergraph.py first to generate tuples.json")
            return False
        
        if not self.connect():
            return False
        
        try:
            with open(tuples_file, 'r') as f:
                data = json.load(f)
            
            # Load nodes
            principles = data.get('nodes', {}).get('principles', [])
            print(f"Loading {len(principles)} principles...")
            
            for principle in principles:
                domains_array = principle.get('domains', [])
                
                self.cursor.execute("""
                    INSERT INTO scmlex_nodes (
                        node_id, node_type, level, name, description, 
                        domains, confidence, provenance, inference_type, application_context
                    ) VALUES (
                        %s, 'principle', 1, %s, %s, %s, %s, %s, %s, %s
                    ) ON CONFLICT (node_id) DO NOTHING;
                """, (
                    principle['node_id'],
                    principle.get('name', ''),
                    principle.get('description', ''),
                    domains_array,
                    principle.get('confidence', 1.0),
                    principle.get('provenance', ''),
                    principle.get('inference_type', ''),
                    principle.get('application_context', '')
                ))
            
            self.conn.commit()
            print(f"✅ Successfully loaded {len(principles)} principles")
            
            # Get statistics
            self.cursor.execute("SELECT * FROM v_hypergraph_statistics;")
            stats = self.cursor.fetchone()
            if stats:
                print("\n📊 Database Statistics:")
                print(f"   Total nodes: {stats['total_nodes']}")
                print(f"   Principles: {stats['principle_count']}")
                print(f"   Rules: {stats['rule_count']}")
                print(f"   Total edges: {stats['total_edges']}")
            
            return True
        except psycopg2.Error as e:
            print(f"❌ Error loading data: {e}")
            self.conn.rollback()
            return False
        except Exception as e:
            print(f"❌ Error processing data: {e}")
            return False
        finally:
            self.disconnect()
    
    def execute_query(self, query: str) -> Optional[List[Dict[str, Any]]]:
        """
        Execute a SQL query and return results.
        
        Args:
            query: SQL query to execute
            
        Returns:
            List of results as dictionaries, or None if error
        """
        if not self.connect():
            return None
        
        try:
            self.cursor.execute(query)
            results = self.cursor.fetchall()
            return [dict(row) for row in results]
        except psycopg2.Error as e:
            print(f"❌ Error executing query: {e}")
            return None
        finally:
            self.disconnect()


def main():
    """Main entry point for database utility."""
    parser = argparse.ArgumentParser(
        description='SCMLex Hypergraph Database Utility',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python hypergraph/db_connect.py --test              # Test connection
  python hypergraph/db_connect.py --init              # Initialize schema
  python hypergraph/db_connect.py --load              # Load data
  python hypergraph/db_connect.py --query "SELECT * FROM v_hypergraph_statistics;"
        """
    )
    
    parser.add_argument('--test', action='store_true',
                       help='Test database connection')
    parser.add_argument('--init', action='store_true',
                       help='Initialize database schema')
    parser.add_argument('--load', action='store_true',
                       help='Load hypergraph data into database')
    parser.add_argument('--query', type=str,
                       help='Execute a SQL query')
    parser.add_argument('--connection-string', type=str,
                       help='Database connection string (overrides environment)')
    
    args = parser.parse_args()
    
    # Show help if no arguments
    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(0)
    
    try:
        db = DatabaseConnection(args.connection_string)
        
        if args.test:
            success = db.test_connection()
            sys.exit(0 if success else 1)
        
        if args.init:
            success = db.initialize_schema()
            sys.exit(0 if success else 1)
        
        if args.load:
            success = db.load_hypergraph_data()
            sys.exit(0 if success else 1)
        
        if args.query:
            results = db.execute_query(args.query)
            if results is not None:
                print(json.dumps(results, indent=2, default=str))
                sys.exit(0)
            else:
                sys.exit(1)
    
    except ValueError as e:
        print(f"❌ Configuration Error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Unexpected Error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
