---
title: "Panaroo"
---

::: {.callout-tip}
## Learning Objectives

- Use Panaroo to generate a core gene alignment.
- Produce a phylogenetic tree from a core gene alignment.
:::


## Core genome alignment generation with `Panaroo`  {#sec-panaroo}

The software [`Panaroo`](https://gtonkinhill.github.io/panaroo/) was developed to analyse bacterial pan-genomes. 
It is able to identify orthologous sequences between a set of sequences, which it uses to produce a multiple sequence alignment of the core genome. 
The output alignment it produces can then be used to build our phylogenetic tree in the next step.

As input to `Panaroo` we will use the gene annotations for our newly assembled genomes, which were produced by the [assembleBAC pipeline](20-assemblebac.md) using `Bakta`. 

First, let's activate the `panaroo` software environment:

```bash
mamba activate panaroo
```

To run `Panaroo` on our samples we can use the following commands:

```bash
# create output directory
mkdir results/panaroo

# run panaroo
panaroo \
  --input results/assemblebac/annotation/*.gff3 \
  --out_dir results/panaroo \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.98 \
  --remove-invalid-genes \
  --threads 8
```

The options used are: 

- `--input` - all the input annotation files, in the `Panaroo`-compatible GFF3 format. Notice how we used the `*` wildcard to match all the files in the folder. 
- `--out_dir` - the output directory we want to save the results into.
- `--clean-mode` - determines the stringency of `Panaroo` in including genes within its pan-genome graph for gene clustering and core gene identification. The available modes are 'strict', 'moderate', and 'sensitive'. These modes balance eliminating probable contaminants against preserving valid annotations like infrequent plasmids. In our case we used 'strict' mode, as we are interested in building a core gene alignment for phylogenetics, so including rare plasmids is less important for our downstream task.
- `--alignment` - whether we want to produce an alignment of core genes or all genes (pangenome alignment). In our case we want to only consider the core genes, to build a phylogeny.
- `--core_threshold` - the fraction of input genomes where a gene has to be found to be considered a "core gene". In our case we've set this to a very high value, to ensure most of our samples have the gene.
- `--remove-invalid-genes` - this is recommended to remove annotations that are incompatible with the annotation format expected by `Panaroo`. 
- `--threads` - how many CPUs we want to use for parallel computations.

`Panaroo` can takle a long time to run, so be prepared to wait a while for its analysis to finish <i class="fa-solid fa-mug-hot"></i>. 

Once it finishes, we can see the output it produces:

```bash
ls results/panaroo
```

```
aligned_gene_sequences/               core_alignment_header.embl        gene_presence_absence_roary.csv
alignment_entropy.csv                 core_gene_alignment.aln           pan_genome_reference.fa
combined_DNA_CDS.fasta                core_gene_alignment_filtered.aln  pre_filt_graph.gml
combined_protein_CDS.fasta            final_graph.gml                   struct_presence_absence.Rtab
combined_protein_cdhit_out.txt        gene_data.csv                     summary_statistics.txt
combined_protein_cdhit_out.txt.clstr  gene_presence_absence.Rtab
core_alignment_filtered_header.embl   gene_presence_absence.csv
```

There are several output files generated, which can be generated for more advanced analysis and visualisation (see [`Panaroo` documentation](https://gtonkinhill.github.io/panaroo/#/gettingstarted/quickstart) for details). 
For our purpose of creating a phylogeny from the core genome alignment, we need the file `core_gene_alignment_filtered.aln`, which is a file in FASTA format. 
We can take a quick look at this file: 

```bash
head results/panaroo/core_gene_alignment_filtered.aln
```

```
>ERX3876945_ERR3864892_T1
atgcaacaatcagacgtcattagtgctgccaaaaaatatatggaatctattcatcaaaat
gattatacaggccatgatattgcgcatgtatatcgtgtcactgctttagctaaatcaatc
gctgaaaatgaaggtgttaatgatactttagtcattgaactcgcatgtttgcttcatgat
accgttgacgaaaaagttgtagatgctaacaaacaatatgttgaattgaagtcattttta
tcttctttatcactatcaaccgaagatcaagagcacattttatttattattaataatatg
agctatcgcaatggcaaaaatgatcatgtcactttatctttagaaggtcaaattgtcagg
gatgcagatcgtcttgatgctataggcgctataggtgttgcacgaacatttcaatttgca
ggacactttggtgaaccaatgtggacagaacatatgtcactagataagattaatgatgat
ttagttgaacagttgccaccatctgcaattaagcatttctttgaaaaattacttaagtta
```

We can see this contains a sequence named "ERX3876945_ERR3864892_T1", which corresponds to one of the genomes we included in our dataset. 
We can look at all the sequence names in the FASTA file: 

```bash
grep ">" results/panaroo/core_gene_alignment_filtered.aln
```

```
>ERX3876945_ERR3864892_T1
>ERX3876948_ERR3864895_T1
>ERX3876909_ERR3864856_T1
>ERX3876942_ERR3864889_T1
>ERX3876935_ERR3864882_T1
>ERX3876905_ERR3864852_T1
>ERX3876940_ERR3864887_T1
>ERX3876954_ERR3864901_T1

... more output omitted to save space ...
```

We can see each input genomes, assembled and annotated by us, appears once.

:::{.callout-note collapse=true}
#### Preparing GFF files for `Panaroo` (click to see details)

`Panaroo` requires GFF files in a non-standard format. 
They are similar to standard GFF files, but they also include the genome sequence itself at the end of the file. 
By default, `Bakta` (which we used [earlier](20-assemblebac.md) to annotate our assembled genomes) already produces files in this non-standard GFF format. 

However, GFF files downloaded from NCBI will not be in this non-standard format. To convert the files to the required format, the `Panaroo` developers provide us with a [Python script](https://raw.githubusercontent.com/gtonkinhill/panaroo/master/scripts/convert_refseq_to_prokka_gff.py) that can do this conversion: 

```bash
python3 convert_refseq_to_prokka_gff.py -g annotation.gff -f genome.fna -o new.gff
```

- `-g` is the original GFF (for example downloaded from NCBI).
- `-f` is the corresponding FASTA file with the genome (also downloaded from NCBI).
- `-o` is the name for the output file.

This is a bit more advanced, and is included here for interested users. We already prepared all the files for constructing a phylogeny, so you don't need to worry about this for the course. 
:::

:::{.callout-exercise}
#### Core genome alignment

Using Panaroo, perform a core genome alignment for your assembled sequences.

- Activate the software environment: `mamba activate panaroo`.
- Fix the script we provide in `scripts/02-run_panaroo.sh`. See @sec-panaroo if you need a hint of how to fix the code in the script.
- Run the script using `bash scripts/02-run_panaroo.sh`.
- When the analysis starts you will get several messages and progress bars print on the screen.

This analysis takes a long time to run, so you can leave it running, open a new terminal and continue to the next exercise.

:::{.callout-answer}

The fixed code for our script is:

```bash
#!/bin/bash

# create output directory
mkdir -p results/panaroo/

# Run panaroo
panaroo \
  --input results/assemblebac/annotation/*.gff3 \
  --out_dir results/panaroo \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.98 \
  --remove-invalid-genes \
  --threads 8
```
As it runs, Panaroo prints several messages to the screen.

We specified results/panaroo as the output file for the core genome aligner Panaroo. We can see all the output files it generated:

```bash
ls results/panaroo
```

```
aligned_gene_sequences                core_alignment_header.embl        gene_presence_absence_roary.csv
alignment_entropy.csv                 core_gene_alignment.aln           pan_genome_reference.fa
combined_DNA_CDS.fasta                core_gene_alignment_filtered.aln  pre_filt_graph.gml
combined_protein_CDS.fasta            final_graph.gml                   struct_presence_absence.Rtab
combined_protein_cdhit_out.txt        gene_data.csv                     summary_statistics.txt
combined_protein_cdhit_out.txt.clstr  gene_presence_absence.Rtab
core_alignment_filtered_header.embl   gene_presence_absence.csv
```

:::
:::

:::{.callout-exercise}
#### Tree inference

<i class="fa-solid fa-triangle-exclamation"></i> 
Because `Panaroo` takes a long time to run, we provide pre-processed results in the folder `preprocessed/panaroo`, which you can use as input to `IQ-TREE` in this exercise.

Produce a tree from the core genome alignment from the previous step. 

- Activate the software environment: `mamba activate iqtree`.
- Fix the script provided in `scripts/03-run_iqtree.sh`. See @sec-iqtree if you need a hint of how to fix the code in the script.
- Run the script using `bash scripts/03-run_iqtree.sh`. Several messages will be printed on the screen while `IQ-TREE` runs. 

:::{.callout-hint}
For _SNP-sites_: 

- The input alignment should be the output from the `panaroo` program found in `results/panaroo/` (or in the `preprocessed` folder if you are still waiting for your analysis to finish).

:::

:::{.callout-answer}

The fixed script is: 

```bash
#!/bin/bash

# create output directory
mkdir -p results/iqtree/

# extract variable sites
snp-sites results/panaroo/core_gene_alignment_filtered.aln > results/snp-sites/core_gene_alignment_snps.aln

# count invariant sites
snp-sites -C results/panaroo/core_gene_alignment_filtered.aln > results/snp-sites/constant_sites.txt

# Run iqtree
iqtree \
  -fconst $(cat results/snp-sites/constant_sites.txt) \
  -s results/snp-sites/core_gene_alignment_snps.aln \
  --prefix results/iqtree/School_Staph \
  -nt AUTO \
  -ntmax 8 \
  -mem 8G \
  -m MFP \
  -bb 1000
```

- We extract the variant sites and count of invariant sites using `SNP-sites`.
- As input to both `snp-sites` steps, we use the `core_gene_alignment_snps.aln` alignment produced by _Panaroo_ in the previous step of our analysis.
- The number of constant sites was specified with `$(cat results/snp-sites/constant_sites.txt)` to directly add the contents of the `constant_sites.txt` file, without having to open the file to obtain these numbers.
- We use as prefix for our output files "School_Staph" (since we are using the data from the schools Staph paper), so all the output file names will be named as such.
- We automatically detect the number of threads/CPUs for parallel computation.

After the analysis runs we get several output files in our directory: 

```bash
ls results/iqtree/
```

```
School_Staph.bionj  School_Staph.ckp.gz  School_Staph.iqtree  
School_Staph.log    School_Staph.mldist  School_Staph.treefile
```

The main file of interest is `School_Staph.treefile`, which contains our tree in the standard [Newick format](https://en.wikipedia.org/wiki/Newick_format). 
:::
:::

## Summary

::: {.callout-tip}
## Key Points

- _Panaroo_ can be used to generate a core gene alignment.
- It can use as input GFF files generated by an annotation software such as _Bakta_. 
- IQ-Tree can be used for tree inference, based on the output from _Panaroo_'s core gene alignment. 

:::