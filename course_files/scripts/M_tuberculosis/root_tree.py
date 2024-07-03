#!/usr/bin/env python3

import os
import sys
import argparse
from Bio import Phylo

def parser_args(args=None):
    """ 
    Function for input arguments for root_tree.py
    """
    Description = 'Read and root a phylogenetic tree'
    Epilog = """Example usage: python root_tree.py -i tree.newick -g OUTGROUP -o rooted_tree.newick"""
    parser = argparse.ArgumentParser(description=Description, epilog=Epilog)
    parser.add_argument("-i", "--input_tree", help="Phylogenetic tree in Newick format")
    parser.add_argument("-g", "--outgroup", help="Name of outgroup to root tree with")
    parser.add_argument("-o", "--output_tree", help="Rooted phylogenetic tree")
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

def read_and_root_tree(input_file, output_file, outgroup=None):
    """ 
    Function for reading and rooting a phylogenetic tree
    """
    # Read the tree from the file
    tree = Phylo.read(input_file, 'newick')
    
    # If an outgroup is specified, root the tree using the outgroup
    if outgroup:
        tree.root_with_outgroup(outgroup)
    else:
        # Otherwise, root the tree at the midpoint
        tree.root_at_midpoint()
    
    # Write the rooted tree to the output file
    Phylo.write(tree, output_file, 'newick')
    print(f"Rooted tree written to {output_file}")

def main(args=None):
    args = parser_args(args)

    ## Create output directory if it doesn't exist
    out_dir = os.path.dirname(args.output_tree)
    make_dir(out_dir)

    ## Read in and root phylogenetic tree
    input_file = args.input_tree
    output_file = args.output_tree
    outgroup = args.outgroup  # Optional: specify the outgroup for rooting

    read_and_root_tree(input_file, output_file, outgroup)

if __name__ == '__main__':
    sys.exit(main())