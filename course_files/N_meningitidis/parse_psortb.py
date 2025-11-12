import sys
import os
import pandas as pd

def parse_psortb_results(filepath):
    """
    Parses a PSORTb v3.0 output file to extract the sequence ID
    and the final predicted subcellular localization.

    Args:
        filepath (str): The path to the PSORTb output file.

    Returns:
        pandas.DataFrame: A DataFrame with two columns: 'Protein_ID' and 'Predicted_Location'.
                          Returns an empty DataFrame if the file cannot be parsed.
    """
    results = []
    current_protein_id = None
    found_prediction_header = False

    try:
        with open(filepath, 'r') as f:
            for line in f:
                clean_line = line.strip()

                if not clean_line:
                    continue

                # Capture the Sequence ID
                if clean_line.startswith('SeqID:'):
                    # Reset flags when a new protein entry is found
                    found_prediction_header = False
                    current_protein_id = None # Reset to ensure we get a new one

                    parts = clean_line.split(None, 1)
                    # Check if there is an ID after 'SeqID:'
                    if len(parts) > 1:
                        # Take only the first part of the ID line (e.g., 'OMNDEE_00001')
                        protein_info = parts[1].split()
                        if protein_info:
                            current_protein_id = protein_info[0]

                # Look for the header line that precedes the prediction
                elif clean_line.startswith('Final Prediction:'):
                    if current_protein_id:
                        found_prediction_header = True

                # If the header was the previous line, this line has the prediction
                elif found_prediction_header:
                    parts = clean_line.split()
                    if len(parts) > 0:
                        location = parts[0]
                        results.append({'Protein_ID': current_protein_id, 'Predicted_Location': location})
                        # Reset everything for the next protein block
                        current_protein_id = None
                        found_prediction_header = False

    except FileNotFoundError:
        print(f"Error: The file '{filepath}' was not found.")
        return pd.DataFrame(columns=['Protein_ID', 'Predicted_Location'])
    except Exception as e:
        print(f"An error occurred while parsing the file: {e}")
        return pd.DataFrame(columns=['Protein_ID', 'Predicted_Location'])

    return pd.DataFrame(results)

if __name__ == '__main__':
    # --- How to use this script ---
    # 1. Save this script as 'parse_psortb.py'.
    # 2. Open your terminal or command prompt.
    # 3. Run the script by providing the path to your PSORTb results file as an argument.
    #
    # Example:
    # python parse_psortb.py /path/to/strainA/psortb_output.txt
    #
    # The script will create a new file named 'strainA_locations.csv'
    # in your current working directory.
    # --------------------------------

    if len(sys.argv) != 2:
        print("Usage: python parse_psortb.py <path_to_psortb_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    results_df = parse_psortb_results(input_file)

    if not results_df.empty:
        # Get the absolute path of the directory containing the input file
        dir_path = os.path.dirname(os.path.abspath(input_file))
        # Use the name of that directory as the prefix
        prefix = os.path.basename(dir_path)

        # Create the output filename
        output_filename = f"{prefix}_locations.csv"

        # Save the DataFrame to the new CSV file
        results_df.to_csv(output_filename, index=False)

        print(f"Successfully parsed {len(results_df)} proteins.")
        print(f"Results saved to: {output_filename}")
    else:
        # Add a message for when no results are found
        print("Parsing complete, but no valid protein predictions were found.")
        print("Please check that the input file is not empty and is a valid PSORTb output file.")
