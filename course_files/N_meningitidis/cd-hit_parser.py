import sys
import os
import pandas as pd
import re

def parse_cdhit_clusters(filepath, total_strains):
    """
    Parses a CD-HIT .clstr file to determine cluster membership and conservation.

    Args:
        filepath (str): The path to the CD-HIT .clstr file.
        total_strains (int): The total number of strains being analyzed.

    Returns:
        pandas.DataFrame: A DataFrame with columns 'Protein_ID', 'Cluster_Name',
                          'Strain_Count', and 'Conservation_Percent'.
    """
    if total_strains == 0:
        print("Error: Total number of strains cannot be zero.")
        return pd.DataFrame()

    cluster_data = {}
    current_cluster_name = None

    try:
        with open(filepath, 'r') as f:
            for line in f:
                # A new cluster is indicated by a line starting with ">"
                if line.startswith('>'):
                    current_cluster_name = line.strip().replace('>', '').replace(' ', '_')
                    cluster_data[current_cluster_name] = {'proteins': [], 'strains': set()}
                    continue

                # Parse the protein information line
                if current_cluster_name:
                    # Regex to find the protein ID, capturing the text between '>' and '...'
                    match = re.search(r'>([^.]+)\.\.\.', line)
                    if match:
                        full_protein_id = match.group(1)
                        # Assume the strain name is the part before the first "|" or "_"
                        # This makes it more robust for different FASTA header formats.
                        strain_id = re.split(r'[|_]', full_protein_id)[0]

                        cluster_data[current_cluster_name]['proteins'].append(full_protein_id)
                        cluster_data[current_cluster_name]['strains'].add(strain_id)

    except FileNotFoundError:
        print(f"Error: The file '{filepath}' was not found.")
        return pd.DataFrame()
    except Exception as e:
        print(f"An error occurred while parsing the file: {e}")
        return pd.DataFrame()

    # Process the parsed data to create the final output rows
    output_rows = []
    for cluster_name, data in cluster_data.items():
        strain_count = len(data['strains'])
        conservation = (strain_count / total_strains) * 100

        for protein_id in data['proteins']:
            output_rows.append({
                'Protein_ID': protein_id,
                'Cluster_Name': cluster_name,
                'Strain_Count': strain_count,
                'Conservation_Percent': round(conservation, 2)
            })

    return pd.DataFrame(output_rows)

if __name__ == '__main__':
    # --- How to use this script ---
    # 1. Save this script as 'parse_cdhit.py'.
    # 2. Open your terminal or command prompt.
    # 3. Run the script by providing the path to your .clstr file and the
    #    total number of strains as arguments.
    #
    # Example (if you analyzed 50 strains):
    # python parse_cdhit.py /path/to/clusters/conserved_clusters.txt.clstr 50
    #
    # The script will create a file named 'conserved_clusters_conservation.csv'
    # inside the /path/to/clusters/ directory.
    # --------------------------------

    if len(sys.argv) != 3:
        print("Usage: python parse_cdhit.py <path_to_clstr_file> <total_num_strains>")
        sys.exit(1)

    input_file = sys.argv[1]
    try:
        total_strains_arg = int(sys.argv[2])
    except ValueError:
        print("Error: The total number of strains must be an integer.")
        sys.exit(1)

    results_df = parse_cdhit_clusters(input_file, total_strains_arg)

    if not results_df.empty:
        # Get the directory where the input file is located
        output_dir = os.path.dirname(os.path.abspath(input_file))

        # Create a descriptive output filename from the input file's name
        base_name = os.path.basename(input_file)
        prefix = base_name.split('.')[0]
        output_filename = f"{prefix}_conservation.csv"

        # Join the output directory and filename to create the full path
        output_filepath = os.path.join(output_dir, output_filename)

        results_df.to_csv(output_filepath, index=False)
        print(f"Successfully processed {len(results_df)} proteins.")
        print(f"Results saved to: {output_filepath}")
    else:
        print("Parsing complete, but no valid cluster data was found.")
