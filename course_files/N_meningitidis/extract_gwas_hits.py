import argparse
import pandas as pd
import sys
from Bio import SeqIO
from Bio.Seq import Seq

def extract_gwas_hits(hits_file, pan_fasta, output_fasta, gene_column, do_translate, trans_table):
    """
    Extracts gene sequences from a pan-genome FASTA file based on a list of
    significant gene names from a Pyseer (or similar) TSV file.
    Can optionally translate them to amino acid sequences.
    """
    try:
        # --- Step 1: Get the list of significant gene IDs from the TSV ---
        print(f"Loading significant gene IDs from: {hits_file}")
        try:
            hits_df = pd.read_csv(hits_file, sep='\t')
        except FileNotFoundError:
            print(f"Error: Hits file not found at {hits_file}", file=sys.stderr)
            return
        except pd.errors.EmptyDataError:
            print(f"Error: Hits file is empty: {hits_file}", file=sys.stderr)
            return
        except Exception as e:
            print(f"Error reading {hits_file}: {e}", file=sys.stderr)
            return

        if gene_column not in hits_df.columns:
            print(f"Error: Column '{gene_column}' not found in {hits_file}.", file=sys.stderr)
            print(f"Available columns are: {list(hits_df.columns)}")
            return

        # Get the set of unique gene IDs
        gene_ids_to_extract = set(hits_df[gene_column].unique())

        if not gene_ids_to_extract:
            print(f"Error: No gene IDs found in the '{gene_column}' column.")
            return

        print(f"Found {len(gene_ids_to_extract)} unique significant gene IDs to extract.")

        # --- Step 2: Parse the FASTA file and extract sequences ---
        print(f"Parsing pan-genome reference FASTA: {pan_fasta}")
        
        sequences_found = 0
        total_genes_parsed = 0
        
        # Open the output file to write in a memory-efficient streaming manner
        with open(output_fasta, 'w') as out_handle:
            # Use SeqIO.parse for efficient, one-by-one FASTA record parsing
            for record in SeqIO.parse(pan_fasta, "fasta"):
                total_genes_parsed += 1
                # The record.id (e.g., 'group_123') should match the IDs from the TSV
                if record.id in gene_ids_to_extract:
                    
                    if do_translate:
                        # --- TRANSLATION STEP ---
                        nuc_seq = record.seq
                        
                        # Trim sequence to be a multiple of 3 to avoid errors
                        trimmed_length = len(nuc_seq) - (len(nuc_seq) % 3)
                        
                        if trimmed_length < 3: # Need at least one full codon
                            print(f"Warning: Skipping {record.id} for translation (length {len(nuc_seq)} < 3).", file=sys.stderr)
                            continue
                        
                        trimmed_seq = nuc_seq[:trimmed_length]
                        
                        try:
                            # Translate using specified table, stop at first STOP codon
                            protein_seq = trimmed_seq.translate(table=trans_table, to_stop=True)
                            
                            # Update the record object with the new protein sequence
                            record.seq = protein_seq
                            # Update the description to note the translation
                            record.description += f" [translated, table {trans_table}]"
                            
                        except Exception as e:
                            print(f"Warning: Could not translate {record.id}. Skipping. Error: {e}", file=sys.stderr)
                            continue

                    # If the gene is in our significant set, write it
                    SeqIO.write(record, out_handle, "fasta")
                    sequences_found += 1
        
        print(f"\n--- Success! ---")
        print(f"Parsed {total_genes_parsed} total genes from the reference file.")
        
        if do_translate:
            print(f"Extracted and translated {sequences_found} significant sequences to: {output_fasta}")
        else:
            print(f"Extracted and wrote {sequences_found} significant sequences to: {output_fasta}")

        
        if sequences_found < len(gene_ids_to_extract):
            print(f"Warning: {len(gene_ids_to_extract) - sequences_found} gene IDs from your TSV file")
            print("         were not found in the pan_genome_reference.fa file.")


    except FileNotFoundError as e:
        print(f"\nError: File not found - {e.F_OK}", file=sys.stderr)
    except Exception as e:
        print(f"\nAn unexpected error occurred: {e}", file=sys.stderr)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Extract gene sequences from a pan-genome FASTA using a list from a TSV file."
    )
    
    parser.add_argument(
        "--hits_file",
        required=True,
        help="Path to the significant hits TSV file (e.g., 'significant_hits.tsv')."
    )
    parser.add_argument(
        "--pan_fasta",
        required=True,
        help="Path to the 'pan_genome_reference.fa' file from Panaroo."
    )
    parser.add_argument(
        "--output_fasta",
        required=True,
        help="Path for the output FASTA file (e.g., 'gwas_hit_sequences.fa')."
    )
    parser.add_argument(
        "--gene_column",
        default="variant",
        help="Name of the column in the TSV file that contains the gene names (default: 'variant')."
    )
    parser.add_argument(
        "--translate",
        action="store_true", # This makes it a boolean flag
        help="Translate the extracted nucleotide sequences to amino acid sequences."
    )
    parser.add_argument(
        "--table",
        type=int,
        default=11,
        help="NCBI translation table to use if --translate is set (default: 11 for bacteria)."
    )
    
    args = parser.parse_args()

    # --- How to use this script ---
    # 1. Make sure you have pandas and biopython installed:
    #    mamba install pandas biopython
    # 2. Save this script as 'extract_gwas_hits.py'.
    # 3. Run the script from your terminal:
    #
    # 4. To extract NUCLEOTIDES:
    # python extract_gwas_hits.py \
    #   --hits_file significant_hits.tsv \
    #   --pan_fasta /path/to/pan_genome_reference.fa \
    #   --output_fasta gwas_hit_sequences.fa
    #
    # 5. To extract and TRANSLATE to PROTEIN:
    # python extract_gwas_hits.py \
    #   --hits_file significant_hits.tsv \
    #   --pan_fasta /path/to/pan_genome_reference.fa \
    #   --output_fasta gwas_hit_protein_sequences.fa \
    #   --translate
    #
    # 6. If your gene names are in a different column:
    # python extract_gwas_hits.py \
    #   --hits_file significant_hits.tsv \
    #   --pan_fasta /path/to/pan_genome_reference.fa \
    #   --output_fasta gwas_hit_sequences.fa \
    #   --gene_column name
    # --------------------------------

    extract_gwas_hits(
        args.hits_file, 
        args.pan_fasta, 
        args.output_fasta, 
        args.gene_column,
        args.translate,
        args.table
    )

