import pandas as pd
import argparse
import os
import glob

def combine_and_filter(locations_files, conservation_file, function_file, human_homology_file, output_file):
    """
    Combines outputs from PSORTb, CD-HIT, and DIAMOND to generate a prioritized
    list of vaccine candidates.

    Args:
        locations_files (list): List of paths to the parsed PSORTb locations CSV files.
        conservation_file (str): Path to the parsed CD-HIT conservation CSV.
        function_file (str): Path to the DIAMOND output for functional annotation (TSV).
        human_homology_file (str): Path to the DIAMOND output for human homology (TSV).
        output_file (str): Path to save the final results CSV.
    """
    try:
        # --- 1. Load all data sources into pandas DataFrames ---
        print("Loading and combining location files...")
        all_locations_dfs = []
        for file in locations_files:
            try:
                df = pd.read_csv(file)
                all_locations_dfs.append(df)
            except FileNotFoundError:
                print(f"Warning: Location file not found and will be skipped: {file}")
        
        if not all_locations_dfs:
            print("\nError: No valid location files were found from the provided pattern. Exiting.")
            return

        locations_df = pd.concat(all_locations_dfs, ignore_index=True)
        print(f"Loaded a total of {len(locations_df)} location predictions from {len(locations_files)} files.")
        
        print("Loading other data files...")
        conservation_df = pd.read_csv(conservation_file)

        # DIAMOND outputs have no headers, so we assign them
        function_cols = ['Protein_ID', 'Function', 'E_value_Function']
        function_df = pd.read_csv(function_file, sep='\t', header=None, names=function_cols)
        # We only need the best functional annotation for each protein
        function_df = function_df.drop_duplicates(subset=['Protein_ID'], keep='first')


        human_cols = ['Protein_ID', 'Human_Hit', 'E_value_Human', 'Percent_Identity_Human']
        human_homology_df = pd.read_csv(human_homology_file, sep='\t', header=None, names=human_cols)
        
        print(f"Loaded {len(conservation_df)} conservation entries.")

        # --- 2. Safety Screen: Identify proteins with human homology ---
        # Any protein with a hit in this file is considered unsafe and will be excluded.
        unsafe_proteins = set(human_homology_df['Protein_ID'])
        print(f"Found {len(unsafe_proteins)} proteins with potential human homology. They will be excluded.")

        # --- 3. Merge the datasets ---
        print("Merging datasets...")
        # Start by merging the core protein information (location and conservation)
        # Using an outer merge to keep all proteins from both files initially
        merged_df = pd.merge(locations_df, conservation_df, on='Protein_ID', how='outer')

        # Add the functional annotation
        merged_df = pd.merge(merged_df, function_df[['Protein_ID', 'Function']], on='Protein_ID', how='left')

        # --- 4. Filter to find ideal candidates ---
        print("Filtering for ideal vaccine candidates...")
        # Rule 1: Must be accessible to the immune system (OuterMembrane or Secreted)
        candidate_df = merged_df[merged_df['Predicted_Location'].isin(['OuterMembrane', 'Secreted'])].copy()
        print(f"Found {len(candidate_df)} proteins in accessible locations.")

        # Rule 2: Must be safe (not in our unsafe_proteins set)
        candidate_df = candidate_df[~candidate_df['Protein_ID'].isin(unsafe_proteins)]
        print(f"Found {len(candidate_df)} candidates that passed the human homology safety screen.")
        
        # Rule 3 (Optional but recommended): High conservation for broad coverage
        candidate_df = candidate_df[candidate_df['Conservation_Percent'] >= 90.0]
        print(f"Found {len(candidate_df)} candidates with >= 90% conservation.")

        # --- 5. Finalize and save the output ---
        if not candidate_df.empty:
            # Sort by conservation to show the most promising candidates first
            candidate_df = candidate_df.sort_values(by='Conservation_Percent', ascending=False)
            
            # Reorder columns for clarity
            final_columns = [
                'Protein_ID', 'Predicted_Location', 'Conservation_Percent', 
                'Strain_Count', 'Cluster_Name', 'Function'
            ]
            candidate_df = candidate_df[final_columns]

            candidate_df.to_csv(output_file, index=False)
            print("\n--- Success! ---")
            print(f"Found {len(candidate_df)} potential vaccine candidates.")
            print(f"Results saved to: {output_file}")
        else:
            print("\n--- No Candidates Found ---")
            print("No proteins met all the filtering criteria.")

    except FileNotFoundError as e:
        print(f"\nError: Input file not found - {e}")
    except Exception as e:
        print(f"\nAn unexpected error occurred: {e}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Combine PSORTb, CD-HIT, and DIAMOND results to find vaccine candidates."
    )
    parser.add_argument(
        '--locations', required=True, help="Path/glob pattern to the parsed PSORTb locations CSV files (e.g., 'results/psortb/*.csv')."
    )
    parser.add_argument(
        '--conservation', required=True, help="Path to the parsed CD-HIT conservation CSV file."
    )
    parser.add_argument(
        '--function', required=True, help="Path to the DIAMOND functional annotation TSV file (vs Swiss-Prot)."
    )
    parser.add_argument(
        '--human', required=True, help="Path to the DIAMOND human homology TSV file."
    )
    parser.add_argument(
        '--output', required=True, help="Path for the final output CSV file."
    )

    args = parser.parse_args()

    # --- How to use this script ---
    # 1. Save this script as 'combine_results.py'.
    # 2. Open your terminal and activate your conda environment.
    # 3. Run the script, providing paths for all input files and an output file name.
    #    The --locations argument should be a string in quotes with a wildcard (*).
    #
    # Example command:
    # python combine_results.py \
    #   --locations "locations/*.csv" \
    #   --conservation conservation/clusters_conservation.csv \
    #   --function homology/function.tsv \
    #   --human homology/human_homology.tsv \
    #   --output vaccine_candidates.csv
    # --------------------------------

    # Expand the glob pattern from the --locations argument into a list of file paths
    location_files_list = glob.glob(args.locations)

    combine_and_filter(
        location_files_list,
        args.conservation,
        args.function,
        args.human,
        args.output
    )
