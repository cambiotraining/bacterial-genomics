---
title: "Identifying vaccine candidates with reverse vaccinology"
---

::: {.callout-tip}
## Learning Objectives

- Understand the principles of reverse vaccinology and its application in vaccine development.
- Learn the key steps involved in a reverse vaccinology workflow, from genome sequencing to candidate selection.
- Gain hands-on experience with bioinformatics tools used in reverse vaccinology, including PSORTb, CD-HIT, and DIAMOND.

:::

## The Traditional vs. Reverse Vaccinology Approach
To understand the innovation of reverse vaccinology, it's helpful to compare it to the conventional method.

- **Traditional Vaccinology (Forward)**: This classic method involves growing large quantities of a pathogen in the lab, inactivating it, and then breaking it down to isolate its constituent parts (like surface proteins or polysaccharides). These isolated components are then tested, often through a long process of trial and error, to see if they can induce a protective immune response. This approach is limited to pathogens that can be cultured in the lab and often only identifies the most abundant components, potentially missing other effective antigens.

- **Reverse Vaccinology (Backward)**: This modern approach begins with the complete genomic sequence of the pathogen. Using computational tools (a process known as in silico analysis), the entire genome is scanned to predict which genes code for proteins that are likely to be good vaccine candidates. This allows for a comprehensive and rational selection of targets before any lab work on the pathogen itself even begins.

## The Reverse Vaccinology Workflow

The process can be broken down into five key steps, moving from the digital sequence to a tangible vaccine candidate.

1. Genome Sequencing and *In Silico* Analysis
The process starts by sequencing the entire genome of the target bacterium. Bioinformatics software then analyzes this genetic information to create a list of potential antigens. The algorithms prioritize genes that code for proteins with desirable characteristics, such as:

    - Surface Location: Proteins that are secreted or located on the pathogen's outer surface are ideal targets because they are easily accessible to the host's immune system.

    - Virulence Factors: Proteins critical for the bacterium's survival or ability to cause disease are excellent candidates.

    - Broad Conservation: The protein should be present in most or all strains of the pathogen to ensure the vaccine provides broad protection.

    - No Human Homology: The selected proteins must be dissimilar to human proteins to prevent the immune system from attacking the body's own cells (autoimmunity).

2. Cloning and Expression
The genes that were flagged as promising candidates during the in silico screening are then synthesized and cloned into a laboratory expression system, typically *E. coli*. This turns the bacteria into tiny factories that produce large quantities of the selected proteins for testing.

3. Immunological Screening 
The purified proteins are used to immunize lab animals, such as mice. Scientists then analyze the animals' immune response by:

    - Measuring antibody levels in their blood serum.

    - Testing whether these antibodies can effectively kill the target bacterium in a lab setting (e.g., through a serum bactericidal assay).

4. Candidate Validation
Proteins that elicit a strong, protective immune response in the animal models are identified as the top vaccine candidates. These candidates undergo further testing to confirm their potential before moving into human clinical trials.

For the purposes of this training course, we will focus on the first step: Genome sequencing and *in silico* analysis.

## Case study: the Meningococcus B (MenB) vaccine

The most prominent success story for reverse vaccinology is the development of the vaccine against *Neisseria meningitidis* serogroup B (MenB), a leading cause of bacterial meningitis.

For decades, a MenB vaccine remained elusive. Traditional vaccine strategies often target the polysaccharide capsule surrounding the bacteria. However, the MenB capsule is chemically identical to a molecule found on human nerve cells, so using it in a vaccine could trigger a dangerous autoimmune reaction.

By applying reverse vaccinology, researchers sequenced the MenB genome and identified hundreds of potential protein antigens. After extensive screening, a few key proteins were selected that induced a robust and protective immune response. These proteins formed the basis of the **Bexsero (4CMenB)** vaccine, which is now used worldwide to prevent MenB disease. This breakthrough would have been incredibly difficult, if not impossible, using conventional methods alone.

## Running a reverse vaccinology workflow

The purpose of this exercise is to familiarize you with the types of analyses involved in a reverse vaccinology workflow. We will not be running a complete analysis here, but rather focusing on the key steps. The end point of this exercise will be a list of potential vaccine candidates.  We have provided a mamba environment with all the necessary software pre-installed.  Before we start, please activate the environment:

```bash
mamba activate reverse-vaccinology
```

Now navigate to the `N_meningitidis` directory within the course materials.

### Genome annotation

The first step is to identify all the potential genes and translate them into protein sequences. We have used **Bakta** for this (you should already be familiar with Bakta as `assembleBAC` runs Bakta as part of the annotation step) and have provided the protein sequences that Bakta predicted. These are in files with the suffix `.faa` located within the `data/faa` folder.

### Subcellular location prediction

Now, we need to predict where each protein resides in the cell. We are interested in **Outer Membrane and Secreted proteins**. We will use `PSORTb`, a bioinformatics tool that predicts the subcellular localization of bacterial proteins based on their amino acid sequences. It uses a combination of machine learning algorithms and curated databases to classify proteins into different cellular compartments, such as cytoplasm, inner membrane, periplasm, outer membrane, and extracellular space.  The command for running `PSORTb` is as follows:

```bash
./psortb_app -i data/faa/ERX029793.faa -r results/psortb/ERX029793 -n
``` 

The options used are: 

- `-i` - the input file containing amino acid sequences in FASTA format.
- `-r` - the output directory where results will be saved.
- `-n` - specifies that the input sequences are from a Gram-negative bacterium.

:::{.callout-exercise}
#### Run PSORTb on *Neisseria meningitidis* amino acid sequences

To run PSORTb on the `.faa` files produced by Bakta,  we have provided a script called `01-run_psortb.sh`, located in the `scripts` folder. As PSORTb can take some time to run, we will only be running it on two of the faa files. For the downstream analyses, we will use pre-computed results for all samples.

- Open the script, which you will notice is composed of two sections: 
    - `#### Settings ####` where we define some variables for input and output files names. If you were running this script on your own data, you may want to edit the directories in this section.
    - `#### Analysis ####` this is where `PSORTb` is run on each amino acid file. You should not change the code in this section.
- Run the script with `bash scripts/01-run_psortb.sh`. If the script is running successfully it should print a message on the screen as the samples are processed.
- Once the analysis finishes open the `ERX109731_locations.csv` file in the `results/psortb/locations` folder. How many proteins were predicted to be located in the Outer Membrane? Hint you can use `grep` to count the number of lines containing "OuterMembrane".

:::{.callout-answer}

We opened the script `01-run_psortb.sh` and these are the settings we used:

- `aa_dir="data/faa"` - the name of the directory with .faa files in it.
- `outdir="results/psortb"` - the name of the directory where we want to save our results.

We then ran the script using `bash scripts/01-run_psortb.sh`. The script prints a message while it's running:

```bash
Saving results to /rds/project/rds-PzYD5LltalA/Teaching/bacterial_genomics/N_meningitidis/results/psortb/ERX029793/20251030144956_psortb_gramneg.txt
Successfully parsed 1954 proteins.
Results saved to: ERX029793_locations.csv
```
PSORTb creates a text file for each set of amino acids containing the protein ID and its predicted location (e.g., "OuterMembrane", "Cytoplasmic", "Secreted"). Once PSORTb has finished running, the script extracts the predicted locations and saves them in a csv file for easier analysis.

To count the number of proteins predicted to be located in the Outer Membrane in the `ERX029793_locations.csv` file, we can use the following command:

```bash
grep -c "OuterMembrane" results/psortb/locations/ERX029793_locations.csv
```

This tells us that there are **43** proteins predicted to be located in the Outer Membrane.
:::
:::

### Conservation analysis

To find proteins that are present in most of our strains, we can cluster all proteins from all genomes using `CD-HIT`.  We have provided faa files for all samples in the `data/faa` folder. `CD-HIT` will group similar proteins together based on a specified sequence identity threshold. For this exercise, we will use a threshold of 95% identity, meaning that proteins that are at least 95% identical will be grouped into the same cluster. This helps us identify conserved proteins across different strains of *Neisseria meningitidis*.  To run `CD-HIT`, we can use the following command:

```bash
# run cd-hit to cluster proteins at 95% identity
cd-hit -i data/faa/all_proteins.faa -o results/cd-hit/conserved_clusters.txt -c 0.95 -d 0
```

The options we used are:

- `-i` - the input file containing all amino acid sequences in FASTA format.
- `-o` - the output file where clustered results will be saved.
- `-c` - the sequence identity threshold (0.95 for 95% identity).
- `-d` - controls the length of the description in the output file (0 means full length).

:::{.callout-exercise}
#### Run CD-HIT on *Neisseria meningitidis* amino acid sequences

To run CD-HIT on the `.faa` files produced by Bakta,  we have provided a script called `02-run_cd-hit.sh`, located in the `scripts` folder.  

- Open the script, which you will notice is composed of two sections: 
    - `#### Settings ####` where we define some variables for input and output files names. If you were running this script on your own data, you may want to edit the directories in this section.
    - `#### Analysis ####` this is where `CD-HIT` is run on each amino acid file. You should not change the code in this section.
- Run the script with `bash scripts/02-run_cd-hit.sh`. If the script is running successfully it should print a message on the screen as the samples are processed.
- How many clusters were identified by CD-HIT? Hint: You can find this information in the output printed to the screen while the script is running.

:::{.callout-answer}

We opened the script `02-run_cd-hit.sh` and these are the settings we used:

- `aa_dir="data/faa""` - the name of the directory with .faa files in it.
- `outdir="results/cd-hit"` - the name of the directory where we want to save our results.

We then ran the script using `bash scripts/03-run_cd-hit.sh`. The script prints a message while it's running:

```bash
================================================================
Program: CD-HIT, V4.8.1 (+OpenMP), Apr 24 2025, 22:00:32
Command: cd-hit -i results/cd-hit/all_proteins.faa -o
         results/cd-hit/conserved_clusters.txt -c 0.95 -d 0

Started: Thu Oct 30 15:31:39 2025
================================================================
                            Output
----------------------------------------------------------------
total seq: 133420
```
CD-HIT creates a text file containing clusters of similar proteins. Each cluster represents a group of proteins that are highly similar to each other, indicating they may be the same protein found in different strains. Like the PSORTb script, once CD-HIT has finished running, the script extracts the clustering information and saves it in a csv file for easier analysis.

CD-HIT identified a total of 5,667 clusters from the 133,420 input protein sequences.
:::
:::

### Functional annotation and human homology check

For function and safety, we will use `DIAMOND`, an ultra-fast alternative to `BLAST`. We will use it to compare our protein sequences against two databases:

1. **Swiss-Prot**: A high-quality, manually curated database for functional annotation.
2. **Human Proteome**: For checking against human proteins to avoid autoimmunity.

The first step will give us the likely function of each protein, while the second step will help us filter out any proteins that are too similar to human proteins and should therefore be avoided as vaccine candidates.  The diamond commands we will use are as follows:

```bash
# Search against Swiss-Prot for functional annotation
diamond blastp -d databases/swissprot.dmnd -q results/cd-hit/all_proteins.faa -o results/homology_searches/function.tsv --outfmt 6 qseqid stitle evalue 

# Search against Human Proteome for homology check
diamond blastp -d databases/human_proteome.dmnd -q results/cd-hit/all_proteins.faa -o results/homology_searches/human_homology.tsv --outfmt 6 qseqid stitle evalue pident 
```

The options we used are:

- `-d` - the database to search against (Swiss-Prot or Human Proteome).
- `-q` - the input file containing amino acid sequences in FASTA format.
- `-o` - the output file where results will be saved.
- `--outfmt 6` - specifies the output format (tabular format with specific fields).

:::{.callout-exercise}
#### Run DIAMOND on *Neisseria meningitidis* amino acid sequences
We have provided a script to run `DIAMOND` on all the protein sequences against the two databases. The script is called `03-run_diamond.sh` and is located in the `scripts` folder.

- Open the script, which you will notice is composed of two sections: 
    - `#### Settings ####` where we define some variables for input and output files names. If you were running this script on your own data, you may want to edit the directories in this section.
    - `#### Analysis ####` this is where `DIAMOND` is run on each amino acid file. You should not change the code in this section.
- Run the script with `bash scripts/03-run_diamond.sh`. If the script is running successfully it should print a message on the screen as the samples are processed.

:::{.callout-answer}

We opened the script `03-run_diamond.sh` and these are the settings we used:

- `aa_dir="results/cd-hit""` - the name of the directory with .faa files in it.
- `outdir="results/homology_searches"` - the name of the directory where we want to save our results.
- `swissprot_db="databases/swissprot.dmnd"` - path to Swiss-Prot database
- `human_db="databases/human_proteome.dmnd"` - path to Human Proteome database

We then ran the script using `bash scripts/03-run_diamond.sh`. The script prints a message while it's running:

```bash
diamond v2.1.13.167 (C) Max Planck Society for the Advancement of Science, Benjamin Buchfink, University of Tuebingen
Documentation, support and updates available at http://www.diamondsearch.org
Please cite: http://dx.doi.org/10.1038/s41592-021-01101-x Nature Methods (2021)

#CPU threads: 76
Scoring parameters: (Matrix=BLOSUM62 Lambda=0.267 K=0.041 Penalties=11/1)

```
The script will produce two sets of results: one for the Swiss-Prot database (`function.tsv`) and another for the human proteome (`human_homology.tsv`). Each result file contains information about the best match for each protein, including the protein's function (from Swiss-Prot) and any significant similarity to human proteins. 
:::
:::

### Compiling vaccine candidates

Now that we have all the necessary data, we can compile a list of potential vaccine candidates by integrating the results from PSORTb, CD-HIT, and DIAMOND. We have provided a script called `combine_results.py` that does just that. This script takes the outputs from the previous analyses and combines them into a single CSV file called `vaccine_candidates.csv`. This file contains all the relevant information for each protein, including its predicted location, conservation across strains, functional annotation, and human homology status. To run the script, simply execute the following command in your terminal:

```bash
python scripts/combine_results.py --locations "preprocessed/psortb/locations/*.csv" --conservation results/cd-hit/conserved_clusters_conservation.csv --function results/homology_searches/function.tsv --human results/homology_searches/human_homology.tsv --output vaccine_candidates.csv
```

Open the `vaccine_candidates.csv` file to explore the compiled data. The four proteins included in the MenB vaccine are fHbp, NHBA, NadA, PorA. Are they present in this list? You may need to search by their gene names or their product descriptions. Unfortunately, due to the small number of genomes we are using in this exercise, it is unlikely that the four vaccine components will be present in the final list.

For the purposes of this training course, we selected a small number of *Neisseria meningitidis* genomes at random. In a real reverse vaccinology study, you would typically analyze a much larger dataset to ensure that the identified vaccine candidates are broadly conserved across diverse strains of the pathogen.

## Summary

::: {.callout-tip}
#### Key Points

- Reverse vaccinology is a genome-based approach to identify potential vaccine candidates by analyzing the genetic makeup of pathogens.
- The workflow involves genome sequencing, subcellular location prediction, conservation analysis, functional annotation, and human homology checks.
- Bioinformatics tools like PSORTb, CD-HIT, and DIAMOND play crucial roles in the reverse vaccinology process.
- The MenB vaccine is a successful example of reverse vaccinology, demonstrating its potential to revolutionize vaccine development.
:::