#!/usr/bin/env python3
"""
Agentic Template Provisioning Script
Provisions AI-specific configurations and project types based on user selection.
"""

import os
import shutil
import json
import yaml
import argparse
import re
from pathlib import Path

class TemplateProvisioner:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.templates_dir = self.base_dir / "templates"
        self.common_dir = self.base_dir / "common"
        
    def load_config(self):
        """Load the mapping configuration from map.yaml"""
        with open(self.base_dir / "map.yaml", 'r') as f:
            return yaml.safe_load(f)
    
    def substitute_variables(self, content, variables):
        """Substitute template variables in content"""
        if isinstance(content, str):
            for key, value in variables.items():
                content = content.replace(f"{{{{{key}}}}}", str(value))
        return content
    
    def process_file_with_variables(self, from_path, to_path, variables):
        """Copy file and substitute variables"""
        try:
            with open(from_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Substitute variables
            content = self.substitute_variables(content, variables)
            
            with open(to_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"  Processed {from_path} -> {to_path}")
        except UnicodeDecodeError:
            # Binary file, just copy
            shutil.copy2(from_path, to_path)
            print(f"  Copied {from_path} -> {to_path}")
            
    def provision_project_type(self, project_type, variables=None):
        """Provision base project structure for specified project type"""
        config = self.load_config()
        
        if 'project_types' not in config or project_type not in config['project_types']:
            raise ValueError(f"Unknown project type: {project_type}")
        
        project_config = config['project_types'][project_type]
        default_variables = config.get('template_vars', {})
        
        # Merge variables
        if variables:
            default_variables.update(variables)
        
        print(f"Provisioning {project_config['name']}...")
        print(f"  Description: {project_config['description']}")
        
        for file_config in project_config['files']:
            from_path = self.base_dir / file_config['from']
            to_path = self.base_dir / file_config['to']
            
            # Create target directory if it doesn't exist
            to_path.parent.mkdir(parents=True, exist_ok=True)
            
            if from_path.is_file():
                self.process_file_with_variables(from_path, to_path, default_variables)
            elif from_path.is_dir():
                if to_path.exists():
                    shutil.rmtree(to_path)
                self.copy_directory_with_variables(from_path, to_path, default_variables)
            else:
                print(f"  Warning: Source not found: {from_path}")
        
        print(f"Project type '{project_type}' provisioned successfully!")
    
    def copy_directory_with_variables(self, from_dir, to_dir, variables):
        """Copy directory recursively and substitute variables in text files"""
        for item in from_dir.rglob('*'):
            if item.is_file():
                relative_path = item.relative_to(from_dir)
                target_file = to_dir / relative_path
                target_file.parent.mkdir(parents=True, exist_ok=True)
                
                self.process_file_with_variables(item, target_file, variables)
        
        print(f"  Copied directory {from_dir} -> {to_dir}")
            
    def provision_ai_tool(self, ai_tool):
        """Provision template for specified AI tool"""
        config = self.load_config()
        
        if ai_tool not in config['targets']:
            raise ValueError(f"Unknown AI tool: {ai_tool}")
            
        target_config = config['targets'][ai_tool]
        
        print(f"Provisioning AI tool configuration for {ai_tool}...")
        
        for copy_instruction in target_config['copies']:
            from_path = self.base_dir / copy_instruction['from']
            to_path = self.base_dir / copy_instruction['to']
            
            # Create target directory if it doesn't exist
            to_path.parent.mkdir(parents=True, exist_ok=True)
            
            if from_path.is_file():
                shutil.copy2(from_path, to_path)
                print(f"  Copied {from_path} -> {to_path}")
            elif from_path.is_dir():
                if to_path.exists():
                    shutil.rmtree(to_path)
                shutil.copytree(from_path, to_path)
                print(f"  Copied directory {from_path} -> {to_path}")
            else:
                print(f"  Warning: Source not found: {from_path}")
                
        print(f"AI tool configuration for {ai_tool} completed!")
        
    def list_available_ai_tools(self):
        """List all available AI tool templates"""
        config = self.load_config()
        return list(config['targets'].keys())
    
    def list_available_project_types(self):
        """List all available project types"""
        config = self.load_config()
        return config.get('project_types', {})
        
    def clean_provisioned_files(self, ai_tool):
        """Clean up provisioned files for specified AI tool"""
        config = self.load_config()
        
        if ai_tool not in config['targets']:
            raise ValueError(f"Unknown AI tool: {ai_tool}")
            
        target_config = config['targets'][ai_tool]
        
        print(f"Cleaning provisioned files for {ai_tool}...")
        
        for copy_instruction in target_config['copies']:
            to_path = self.base_dir / copy_instruction['to']
            
            if to_path.exists():
                if to_path.is_file():
                    to_path.unlink()
                    print(f"  Removed {to_path}")
                elif to_path.is_dir():
                    shutil.rmtree(to_path)
                    print(f"  Removed directory {to_path}")
                    
        print(f"Cleanup for {ai_tool} completed!")

def main():
    parser = argparse.ArgumentParser(description='Provision AI tool templates and project types')
    
    subparsers = parser.add_subparsers(dest='command', help='Available commands')
    
    # List command
    list_parser = subparsers.add_parser('list', help='List available templates')
    list_parser.add_argument('--type', choices=['ai-tools', 'projects', 'all'], 
                           default='all', help='Type of templates to list')
    
    # Provision command
    provision_parser = subparsers.add_parser('provision', help='Provision templates')
    provision_parser.add_argument('--ai-tool', '-t', 
                                help='AI tool to provision (claude-code, copilot, windsurf, cursor)')
    provision_parser.add_argument('--project-type', '-p',
                                help='Project type to provision (docusaurus, mkdocs, minimal)')
    provision_parser.add_argument('--project-name', default='my-project',
                                help='Project name for variable substitution')
    provision_parser.add_argument('--project-title', 
                                help='Project title for variable substitution')
    provision_parser.add_argument('--project-description', default='A new project',
                                help='Project description for variable substitution')
    provision_parser.add_argument('--project-url', default='https://example.com',
                                help='Project URL for variable substitution')
    provision_parser.add_argument('--project-repo-url', 
                                help='Project repository URL for variable substitution')
    
    # Clean command
    clean_parser = subparsers.add_parser('clean', help='Clean provisioned files')
    clean_parser.add_argument('--ai-tool', '-t', required=True,
                            help='AI tool to clean (claude-code, copilot, windsurf, cursor)')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return 1
    
    provisioner = TemplateProvisioner()
    
    try:
        if args.command == 'list':
            config = provisioner.load_config()
            
            if args.type in ['ai-tools', 'all']:
                ai_tools = provisioner.list_available_ai_tools()
                print("Available AI Tools:")
                for tool in ai_tools:
                    print(f"  - {tool}")
                print()
            
            if args.type in ['projects', 'all']:
                project_types = provisioner.list_available_project_types()
                print("Available Project Types:")
                for ptype, config in project_types.items():
                    print(f"  - {ptype}: {config['name']}")
                    print(f"    {config['description']}")
                print()
                
        elif args.command == 'provision':
            variables = {
                'PROJECT_NAME': args.project_name,
                'PROJECT_TITLE': args.project_title or args.project_name.replace('-', ' ').title(),
                'PROJECT_DESCRIPTION': args.project_description,
                'PROJECT_URL': args.project_url,
                'PROJECT_REPO_URL': args.project_repo_url or f"https://github.com/example/{args.project_name}",
                'PROJECT_BASE_URL': '/',
                'PROJECT_TAGLINE': args.project_description,
            }
            
            if args.project_type:
                provisioner.provision_project_type(args.project_type, variables)
            
            if args.ai_tool:
                provisioner.provision_ai_tool(args.ai_tool)
                
            if not args.project_type and not args.ai_tool:
                print("Error: Specify either --project-type or --ai-tool (or both)")
                return 1
                
        elif args.command == 'clean':
            provisioner.clean_provisioned_files(args.ai_tool)
            
    except ValueError as e:
        print(f"Error: {e}")
        return 1
    except Exception as e:
        print(f"Unexpected error: {e}")
        return 1
            
    return 0

if __name__ == "__main__":
    exit(main())