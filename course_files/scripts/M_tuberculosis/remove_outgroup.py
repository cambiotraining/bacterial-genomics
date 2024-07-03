#!/usr/bin/env python3

import os
import sys
import argparse
from Bio import Phylo

def parser_args(args=None):
    """ 
    Function for input arguments for remove_outgroup.py
    """
    Description = 'Read a phylogenetic tree and remove a specified outgroup'
    Epilog = """Example usage: python remove_outgroup.py -i rooted_tree.newick -g OUTGROUP -o rooted_tree_no_outgroup.newick"""
    parser = argparse.ArgumentParser(description=Description, epilog=Epilog)
    parser.add_argument("-i", "--input_tree", help="Phylogenetic tree in Newick format")
    parser.add_argument("-g", "--outgroup", help="Name of outgroup to remove from tree")
    parser.add_argument("-o", "--output_tree", help="Rooted phylogenetic tree with outgroup removed")
    return parser.parse_args(args)

def make_dir(path):
    """ 
    Function for making a directory from a provided path
    """
    if not len(path) == 0:
        try:
            os.makedirs(path)
        except OSError as exception:
            if exception.errno != errno.EEXIST:
                raise

def drop_outgroup(input_file, output_file, outgroup):
    """ 
    Function for removing an outgroup from a phylogenetic tree
    """
    # Read the tree from the file
    tree = Phylo.read(input_file, 'newick')
    
    # Find the outgroup clade
    outgroup_clade = tree.find_any(name=outgroup)
    
    if outgroup_clade:
        # Remove the outgroup clade from the tree
        tree.prune(outgroup_clade)
    else:
        print(f"Outgroup '{outgroup}' not found in the tree.")
    
    # Write the rooted tree to the output file
    Phylo.write(tree, output_file, 'newick')
    print(f"Tree with outgroup removed written to {output_file}")

def main(args=None):
    args = parser_args(args)

    ## Create output directory if it doesn't exist
    out_dir = os.path.dirname(args.output_tree)
    make_dir(out_dir)

    ## Read in and root phylogenetic tree
    input_file = args.input_tree
    output_file = args.output_tree
    outgroup = args.outgroup

    drop_outgroup(input_file, output_file, outgroup)

if __name__ == '__main__':
    sys.exit(main())