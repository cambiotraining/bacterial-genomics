#!/usr/bin/env python3

import os
import sys
import glob
import argparse
import pandas as pd

def parser_args(args=None):
    """ 
    Function for input arguments for merge_tb_data.py
    """
    Description = 'Merge TB-profiler output and sample_info.csv to create a summary table'
    Epilog = """Example usage: python merge_tb_data.py """
    parser = argparse.ArgumentParser(description=Description, epilog=Epilog)
    parser.add_argument("-s", "--sample_info", type=str, default="sample_info.csv", help="Sample metadata file (default: 'sample_info.csv').")
    parser.add_argument("-t", "--tbp_file", type=str, default="tbprofiler.txt", help="TB-profiler summary file (default: 'tbprofiler.txt').")
    parser.add_argument("-o", "--output_file", type=str, default="TB_metadata.tsv", help="Merged TB summary file (default: 'TB_metadata.tsv').")
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

def read_sample_info(sample_info):
    """ 
    Function for reading sample_info.csv
    """
    sample_info_read = pd.read_csv(sample_info, sep=',')

    return sample_info_read

def read_tbprofiler(tbp_out):
    """ 
    Function for reading tb-profiler summary file
    """
    tbp_out_read = pd.read_csv(tbp_out, sep='\t')

    return tbp_out_read

def metadata_merge(df1, df2):
    """ 
    Function for merging two dataframes using the column 'sample'
    """
    merged = pd.merge(df1, df2, on = ['sample'])

    return merged

def main(args=None):
    args = parser_args(args)

    ## Create output directory if it doesn't exist
    out_dir = os.path.dirname(args.output_file)
    make_dir(out_dir)

    ## Read in sample info file
    sample_info = read_sample_info(args.sample_info)

    ## Read in TB-profiler output file
    tb_profiler = read_tbprofiler(args.tbp_file)

    ## Merge sample info and TB-profiler outputs
    merged_df = metadata_merge(sample_info, tb_profiler)
    
    ## Write output file
    merged_df.to_csv(args.output_file, sep = '\t', header = True, index = False)

if __name__ == '__main__':
    sys.exit(main())