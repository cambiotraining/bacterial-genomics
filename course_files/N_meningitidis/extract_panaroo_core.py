import argparse
import sys
import re
from Bio import SeqIO
from Bio.Seq import Seq

def extract_core_sequences(gene_list_embl_file, ref_fasta_file, output_file, do_translate, trans_table):
    """
    Extracts core gene sequences from a Panaroo pan-genome reference FASTA file
    based on a list of gene IDs provided in a separate EMBL file.
    This version uses regex for robust parsing of the EMBL file.
    Can optionally translate nucleotide sequences to protein.
    """
    try:
        # --- Step 1: Identify core genes from the EMBL file using regex ---
        print(f"Loading core gene IDs from: {gene_list_embl_file}")
        core_gene_set = set()
        
        try:
            with open(gene_list_embl_file, 'r') as f:
                embl_content = f.read()

            # Regex to find all instances of /label=some_gene_name.aln
            # It captures the gene name (e.g., 'group_231.aln')
            # Works with or without quotes around the label value.
            label_matches = re.findall(r'/label="?([\w.-]+)"?', embl_content)

            if not label_matches:
                print(f"Error: No /label tags found in {gene_list_embl_file} using regex.", file=sys.stderr)
                print("Please check your input file.")
                return

            for label in label_matches:
                # Remove .aln from the end, if it exists
                gene_name = label
                if gene_name.endswith('.aln'):
                    gene_name = gene_name[:-4]  # Slice to remove '.aln'
                
                core_gene_set.add(gene_name)

        except Exception as e:
            print(f"\nError: Could not read or parse the gene list file {gene_list_embl_file}.", file=sys.stderr)
            print(f"Details: {e}")
            return
        
        if not core_gene_set:
            print(f"Error: No gene IDs were successfully extracted from {gene_list_embl_file}.")
            print("Please check your input file.")
            return

        print(f"Identified {len(core_gene_set)} unique core gene IDs.")

        # --- Step 2: Parse the FASTA file and extract core sequences ---
        print(f"Parsing pan-genome reference FASTA: {ref_fasta_file}")
        
        core_sequences_found = 0
        total_genes_parsed = 0
        
        # Open the output file to write in a memory-efficient streaming manner
        with open(output_file, 'w') as out_handle:
            # Use SeqIO.parse for efficient, one-by-one FASTA record parsing
            for record in SeqIO.parse(ref_fasta_file, "fasta"):
                total_genes_parsed += 1
                # The record.id (e.g., 'group_123') should match the IDs from the EMBL file
                if record.id in core_gene_set:
                    
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
                    
                    # Write the record (either original nucleotide or new protein)
                    SeqIO.write(record, out_handle, "fasta")
                    core_sequences_found += 1
        
        print(f"\n--- Success! ---")
        print(f"Parsed {total_genes_parsed} total genes from the reference file.")
        
        if do_translate:
            print(f"Extracted and translated {core_sequences_found} core sequences to: {output_file}")
        else:
            print(f"Extracted and wrote {core_sequences_found} core sequences to: {output_file}")
        
        if core_sequences_found < len(core_gene_set):
            print(f"Warning: {len(core_gene_set) - core_sequences_found} gene IDs from your EMBL file")
            print("         were not found in the pan_genome_reference.fa file.")
            print("         (This can be normal if some genes had no sequence in the reference).")


    except FileNotFoundError as e:
        print(f"\nError: File not found - {e}", file=sys.stderr)
    except Exception as e:
        print(f"\nAn unexpected error occurred: {e}", file=sys.stderr)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Extract core gene sequences from a Panaroo pan-genome and optionally translate them."
    )
    
    parser.add_argument(
        "--gene_list_embl",
        required=True,
        help="Path to an EMBL file containing /label tags for core genes (e.g., 'core_alignment_filtered_header.embl')."
    )
    parser.add_argument(
        "--ref_fasta",
        required=True,
        help="Path to the 'pan_genome_reference.fa' file from Panaroo."
    )
    parser.add_argument(
        "--output",
        required=True,
        help="Path for the output FASTA file (e.g., 'core_genome_sequences.fa')."
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
    # 1. Make sure you have biopython installed:
    #    mamba install biopython
    # 2. Save this script as 'extract_panaroo_core.py'.
    #
    # 3. To extract NUCLEOTIDES (default):
    # python extract_panaroo_core.py \
    #   --gene_list_embl /path/to/panaroo_output/core_alignment_filtered_header.embl \
    #   --ref_fasta /path/to/panaroo_output/pan_genome_reference.fa \
    #   --output core_nucleotide_sequences.fa
    #
    # 4. To extract and TRANSLATE to PROTEIN:
    # python extract_panaroo_core.py \
    #   --gene_list_embl /path/to/panaroo_output/core_alignment_filtered_header.embl \
    #   --ref_fasta /path/to/panaroo_output/pan_genome_reference.fa \
    #   --output core_protein_sequences.fa \
    #   --translate
    # --------------------------------

    extract_core_sequences(
        args.gene_list_embl, 
        args.ref_fasta, 
        args.output, 
        args.translate, 
        args.table
    )