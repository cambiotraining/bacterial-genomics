import argparse
import pandas as pd
import sys
import os
import glob
from Bio import SeqIO

def load_locations(location_path_pattern):
    """
    Loads and combines one or more PSORTb location CSV files from a glob pattern.
    Renames 'Predicted_Location' to 'Location' internally.
    """
    print(f"Searching for location files with pattern: {location_path_pattern}")
    location_files = glob.glob(location_path_pattern)
    
    if not location_files:
        print(f"Warning: No files found matching '{location_path_pattern}'", file=sys.stderr)
        return pd.DataFrame(columns=['Protein_ID', 'Location']).set_index('Protein_ID')

    print(f"Found {len(location_files)} location files to combine.")
    
    df_list = []
    for f in location_files:
        try:
            df = pd.read_csv(f)
            # Check for the headers the user specified
            if 'Protein_ID' not in df.columns or 'Predicted_Location' not in df.columns:
                # Also check for the old header, just in case
                if 'Protein_ID' not in df.columns or 'Location' not in df.columns:
                    print(f"Warning: Skipping file {f} - missing 'Protein_ID' or 'Predicted_Location'/'Location' column.", file=sys.stderr)
                    continue
            
            # Rename the user's header to the one the script expects internally
            if 'Predicted_Location' in df.columns:
                df.rename(columns={'Predicted_Location': 'Location'}, inplace=True)

            df_list.append(df)
        except Exception as e:
            print(f"Warning: Could not parse {f}. Error: {e}", file=sys.stderr)
            
    if not df_list:
        print("Error: No valid location files could be read.", file=sys.stderr)
        return pd.DataFrame(columns=['Protein_ID', 'Location']).set_index('Protein_ID')

    combined_df = pd.concat(df_list, ignore_index=True)
    combined_df.drop_duplicates(subset=['Protein_ID'], inplace=True)
    combined_df.set_index('Protein_ID', inplace=True)
    print(f"Loaded {len(combined_df)} unique protein locations.")
    return combined_df

def load_diamond_results(file_path, columns, job_name):
    """
    Loads a DIAMOND output TSV file, keeps only the first hit per protein.
    """
    print(f"Loading {job_name} results from: {file_path}")
    try:
        df = pd.read_csv(
            file_path, 
            sep='\t', 
            header=None, 
            names=columns
        )
        # Keep only the best hit (first one listed) for each protein
        df.drop_duplicates(subset=['Protein_ID'], keep='first', inplace=True)
        df.set_index('Protein_ID', inplace=True)
        print(f"Found {len(df)} unique hits.")
        return df
    except FileNotFoundError:
        print(f"Error: {job_name} file not found at {file_path}", file=sys.stderr)
        return pd.DataFrame(columns=columns[1:]).set_index('Protein_ID') # Return empty, indexed DF
    except pd.errors.EmptyDataError:
        print(f"Warning: {job_name} file is empty: {file_path}", file=sys.stderr)
        return pd.DataFrame(columns=columns[1:]).set_index('Protein_ID')
    except Exception as e:
        print(f"Error reading {file_path}: {e}", file=sys.stderr)
        sys.exit(1)
        
def load_core_gene_ids(fasta_file):
    """Loads gene IDs from a FASTA file header."""
    print(f"Loading core gene IDs from {fasta_file}...")
    ids = set()
    try:
        for record in SeqIO.parse(fasta_file, "fasta"):
            ids.add(record.id)
        
        if not ids:
            print(f"Error: No sequences found in {fasta_file}", file=sys.stderr)
            sys.exit(1)
            
        print(f"Found {len(ids)} core gene IDs.")
    except FileNotFoundError:
        print(f"Error: Core FASTA file not found at {fasta_file}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error parsing {fasta_file}: {e}", file=sys.stderr)
        sys.exit(1)
    return ids

def main():
    parser = argparse.ArgumentParser(
        description="Combine PSORTb and DIAMOND results for a core set of genes to identify vaccine candidates."
    )
    
    # --- Input Files ---
    parser.add_argument(
        "--core_fasta",
        required=True,
        help="Path to the FASTA file containing the core genes to analyze (e.g., 'core_genome_sequences.fa')."
    )
    parser.add_argument(
        "--locations",
        required=True,
        help="Path/glob pattern to the parsed PSORTb location CSV files (e.g., 'results/psortb/*.csv')."
    )
    parser.add_argument(
        "--function",
        required=True,
        help="Path to the DIAMOND blastp output against Swiss-Prot (function.tsv)."
    )
    parser.add_argument(
        "--human",
        required=True,
        help="Path to the DIAMOND blastp output against the human proteome (human_homology.tsv)."
    )
    
    # --- Output File ---
    parser.add_argument(
        "--output",
        required=True,
        help="Name of the final output CSV file (e.g., 'vaccine_candidates.csv')."
    )
    
    # --- Filtering Options ---
    parser.add_argument(
        "--locations_to_keep",
        nargs='+',
        default=['OuterMembrane', 'Secreted'],
        help="List of PSORTb locations to keep (default: OuterMembrane Secreted)."
    )
    parser.add_argument(
        "--keep_unknown",
        action="store_true",
        help="Include proteins with 'Unknown' location in the final list."
    )
    
    args = parser.parse_args()

    # --- 1. Load Core Gene IDs ---
    core_gene_ids = load_core_gene_ids(args.core_fasta)

    # --- 2. Load PSORTb location data ---
    locations_df = load_locations(args.locations)
    if locations_df.empty and '*' not in args.locations:
        # Exit if a specific file was given but not found/parsed
        print("Error: Location file was not valid. Exiting.", file=sys.stderr)
        return
    elif locations_df.empty:
        print("Warning: No location data loaded. Proceeding without location info.")


    # --- 3. Load DIAMOND function results ---
    function_df = load_diamond_results(
        args.function, 
        ['Protein_ID', 'Function', 'E-Value'],
        "DIAMOND function search"
    )

    # --- 4. Load DIAMOND human homology results ---
    human_hits_df = load_diamond_results(
        args.human, 
        ['Protein_ID', 'Human_Hit', 'Human_Pident'],
        "DIAMOND human homology search"
    )
    # Get set of proteins with any human hit for fast filtering
    human_hit_ids = set(human_hits_df.index)

    # --- 5. Combine all data ---
    print("Combining all data sources...")
    
    # Start with a DataFrame of just our core genes
    final_df = pd.DataFrame(list(core_gene_ids), columns=['Protein_ID'])
    final_df.set_index('Protein_ID', inplace=True)

    # Merge with locations (left merge keeps all core genes)
    final_df = final_df.merge(locations_df, left_index=True, right_index=True, how='left')

    # Merge with function (left merge keeps all core genes)
    final_df = final_df.merge(function_df, left_index=True, right_index=True, how='left')

    # --- 6. Filter for ideal candidates ---
    print("Filtering for ideal vaccine candidates...")
    
    # 1. Filter by location
    location_mask = final_df['Location'].isin(args.locations_to_keep)
    
    # 2. Filter out human homology hits
    human_mask = ~final_df.index.isin(human_hit_ids)
    
    # 3. Handle 'unknown' locations
    if args.keep_unknown:
        location_mask = location_mask | (final_df['Location'] == 'Unknown')
    else:
        # If location data was missing (NaN), treat it as not a valid location
        location_mask = location_mask & final_df['Location'].notna()


    ideal_candidates_df = final_df[location_mask & human_mask].copy()

    # --- 7. Format and Save ---
    print("Formatting final table...")
    
    # Fill in missing values for clarity in the final table
    ideal_candidates_df.loc[:, 'Function'] = ideal_candidates_df['Function'].fillna('No hit')
    ideal_candidates_df.loc[:, 'Location'] = ideal_candidates_df['Location'].fillna('N/A')
    
    # Define final output columns
    final_columns = [
        'Location',
        'Function',
        'E-Value'
    ]
    
    # Ensure all final columns exist, even if diamond files were empty
    for col in final_columns:
        if col not in ideal_candidates_df:
            ideal_candidates_df[col] = 'N/A'
            
    # Reorder and keep only final columns
    final_output_df = ideal_candidates_df[final_columns]
    
    # Sort by location
    final_output_df.sort_values(by='Location', inplace=True)

    # Save to file
    try:
        final_output_df.to_csv(args.output)
        print(f"\n--- Success! ---")
        print(f"Filtered {len(final_df)} core genes down to {len(final_output_df)} candidates.")
        print(f"Final candidate list saved to: {args.output}")

    except Exception as e:
        print(f"\nError: Could not save output file to {args.output}", file=sys.stderr)
        print(f"Details: {e}")

if __name__ == "__main__":
    
    # --- How to use this script ---
    # 1. Make sure you have pandas and biopython installed:
    #    mamba install pandas biopython
    # 2. Save this script as 'combine_results_core.py'.
    # 3. Run the script from your terminal:
    #
    # python combine_results_core.py \
    #   --core_fasta core_genome_sequences.fa \
    #   --locations "results/psortb/*.csv" \
    #   --function homology/function.tsv \
    #   --human homology/human_homology.tsv \
    #   --output vaccine_candidates.csv
    #
    # 4. To also keep 'Unknown' locations:
    # python combine_results_core.py ... --keep_unknown
    # --------------------------------
    
    main()