#!/usr/bin/env python3

import os
import sys
import glob
import argparse
import pandas as pd

def parser_args(args=None):
    """ 
    Function for input arguments for merge_staph_data.py
    """
    Description = 'Merge Pathogenwatch output and sample_info.csv to create a summary table'
    Epilog = """Example usage: python merge_staph_data.py """
    parser = argparse.ArgumentParser(description=Description, epilog=Epilog)
    parser.add_argument("-s", "--sample_info", type=str, default="sample_info.csv", help="Sample metadata file (default: 'sample_info.csv').")
    parser.add_argument("-t", "--typing_file", type=str, default="pathogenwatch-typing.csv", help="Pathogenwatch typing file (default: 'pathogenwatch-typing.csv').")
    parser.add_argument("-a", "--amr_file", type=str, default="pathogenwatch-amr-profile.csv", help="Pathogenwatch AMR file (default: 'pathogenwatch-amr-profile.csv').")
    parser.add_argument("-o", "--output_file", type=str, default="staph_metadata.tsv", help="Merged Staph summary file (default: 'staph_metadata.tsv').")
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

def read_pathogenwatch(pw_out):
    """ 
    Function for reading Pathogenwatch CSV files
    """
    pw_out_read = pd.read_csv(pw_out, sep=',')

    return pw_out_read

def metadata_merge(df1, df2, on_column):
    """ 
    Function for merging two dataframes using a column name
    """
    merged_df = pd.merge(df1, df2, on = on_column)

    return merged_df

def pathogenwatch_rename(df):
    """ 
    Function for renaming sample names to remove '_contigs' and
    renaming column 'NAME' to 'sample'
    """
    df['NAME'] = df['NAME'].str.replace('_contigs','')
    df = df.rename(columns = {'NAME' : 'sample'})

    return df

def main(args=None):
    args = parser_args(args)

    ## Create output directory if it doesn't exist
    out_dir = os.path.dirname(args.output_file)
    make_dir(out_dir)

    ## Read in sample info file
    sample_info = read_sample_info(args.sample_info)

    ## Read in Pathogenwatch typing file
    typing = read_pathogenwatch(args.typing_file)

    ## Read in Pathogenwatch AMR file
    amr_profile = read_pathogenwatch(args.amr_file)

    ## Merge Pathogenwatch outputs
    merged_pw_df = metadata_merge(typing, amr_profile, 'NAME')

    ## Edit Pathogenwatch dataframe
    merged_pw_df = pathogenwatch_rename(merged_pw_df)

    ## Merge sample_info.csv and Pathogenwatch dataframe
    final_merged_df = metadata_merge(sample_info, merged_pw_df, 'sample')
    
    ## Write output file
    final_merged_df.to_csv(args.output_file, sep = '\t', header = True, index = False)

if __name__ == '__main__':
    sys.exit(main())