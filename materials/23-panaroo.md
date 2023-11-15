---
title: "Panaroo"
---

::: {.callout-tip}
## Learning Objectives

- Understand why to use Panaroo.
- Understand what a core gene alignment is.
- Use the core genome alignment from panaroo to build a tree

:::

## Core genome alignment: `panaroo`

The software [_Panaroo_](https://gtonkinhill.github.io/panaroo/) was developed to analyse bacterial pangenomes. 
It is able to identify orthologous sequences between a set of sequences, which it uses to produce a multiple sequence alignment of the core genome. 
The output alignment it produces can then be used to build our phylogenetic trees in the next step.

As input to _Panaroo_ we will use: 

- The gene annotations for our newly assembled genomes, which were produced by the [assembleBAC pipeline](20-assemblebac.md) using _Bakta_. 


To run _Panaroo_ on our samples we can use the following commands:

```bash
# create output directory
mamba activate panaroo

mkdir results/panaroo

# run panaroo
panaroo \
  --input results/assembleBAC/annotation/*.gff \
  --out_dir results/panaroo \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.98 \
  --remove-invalid-genes \
  --threads 8
```

The options used are: 

- `--input` - all the input annotation files, in the _Panaroo_-compatible GFF format. Notice how we used the `*` wildcard to match all the files in the folder. 
- `--out_dir` - the output directory we want to save the results into.
- `--clean-mode` - determines the stringency of _Panaroo_ in including genes within its pangenome graph for gene clustering and core gene identification. The available modes are 'strict', 'moderate', and 'sensitive'. These modes balance eliminating probable contaminants against preserving valid annotations like infrequent plasmids. In our case we used 'strict' mode, as we are interested in building a core gene alignment for phylogenetics, so including rare plasmids is less important for our downstream task.
- `--alignment` - whether we want to produce an alignment of core genes or all genes (pangenome alignment). In our case we want to only consider the core genes, to build a phylogeny.
- `--core_threshold` - the fraction of input genomes where a gene has to be found to be considered a "core gene". In our case we've set this to a very high value, to ensure most of our samples have the gene.
- `--remove-invalid-genes` - this is recommended to remove annotations that are incompatible with the annotation format expected by _Panaroo_. 
- `--threads` - how many CPUs we want to use for parallel computations.

_Panaroo_ takes a long time to run, so be prepared to wait a while for its analysis to finish <i class="fa-solid fa-mug-hot"></i>. 

Once it finishes, we can see the output it produces:

```bash
ls results/panaroo
```

```
aligned_gene_sequences/                core_alignment_header.embl        gene_presence_absence_roary.csv
alignment_entropy.csv                 core_gene_alignment.aln           pan_genome_reference.fa
combined_DNA_CDS.fasta                core_gene_alignment_filtered.aln  pre_filt_graph.gml
combined_protein_CDS.fasta            final_graph.gml                   struct_presence_absence.Rtab
combined_protein_cdhit_out.txt        gene_data.csv                     summary_statistics.txt
combined_protein_cdhit_out.txt.clstr  gene_presence_absence.Rtab
core_alignment_filtered_header.embl   gene_presence_absence.csv
```

There are several output files generated, which can be generated for more advanced analysis and visualisation (see [_Panaroo_ documentation](https://gtonkinhill.github.io/panaroo/#/gettingstarted/quickstart) for details). 
For our purpose of creating a phylogeny from the core genome alignment, we need the file `core_gene_alignment_filtered.aln`, which is a file in FASTA format. 
We can take a quick look at this file: 

```bash
head results/panaroo/core_gene_alignment_filtered.aln
```

```
>GCF_015482825.1_ASM1548282v1_genomic
atggctatttatctgactgaattatcgccggaaacgttgacattcccctctccttttact
gcgttagatgaccctaacggcctgcttgcatttggcggcgatctccgtcttgaacgaatt
tgggcggcttatcaacaaggcattttcccttggtatggccctgaagacccgattttgtgg
tggagcccttccccacgtgccgtgtttgaccctactcggtttcaacctgcc-aaaagcgt
gaagaagttccaacgtaaacatcagtatcgggttagcgtcaatcacgcgacgtcgcaagt
gattgagcagtgcgcgctcactcgccctgcggatcaacgttggctcaatgactcaatgcg
ccatgcgtatggcgagttggcgaaacaaggtcgttgccattctgttgaggtgtggcaggg
cgaacaactggtgggtgggctttatggcatttccgttggccaactgttttgtggcgaatc
catgtttagcctcgcaaccaatgcctcgaaaattgcgctttggta-tttttgcgaccatt
```

We can see this contains a sequence named "GCF_015482825.1_ASM1548282v1_genomic", which corresponds to one of the NCBI genomes we downloaded. 
We can look at all the sequence names in the FASTA file: 

```bash
grep ">" results/panaroo/core_gene_alignment_filtered.aln
```

```
>GCF_015482825.1_ASM1548282v1_genomic
>GCF_019704235.1_ASM1970423v1_genomic
>GCF_013357625.1_ASM1335762v1_genomic
>GCF_017948285.1_ASM1794828v1_genomic
>GCF_009763825.1_ASM976382v1_genomic
>isolate01
>GCF_013357665.1_ASM1335766v1_genomic
>GCF_009762915.1_ASM976291v1_genomic
>GCF_009762985.1_ASM976298v1_genomic

... more output omitted to save space ...
```

We can see each input genome appears once, including the "isolateXX" genomes assembled and annotated by us.

:::{.callout-note collapse=true}
#### Preparing GFF files for _Panaroo_ (click to see details)

_Panaroo_ requires GFF files in a non-standard format. 
They are similar to standard GFF files, but they also include the genome sequence itself at the end of the file. 
By default, _Bakta_ (which we used [earlier](20-assemblebac.md) to annotate our assembled genomes) already produces files in this non-standard GFF format. 

However, GFF files downloaded from NCBI will not be in this non-standard format. 
To convert the files to the required format, the _Panaroo_ developers provide us with a [Python script](https://raw.githubusercontent.com/gtonkinhill/panaroo/master/scripts/convert_refseq_to_prokka_gff.py) that can do this conversion: 

```bash
python3 convert_refseq_to_prokka_gff.py -g annotation.gff -f genome.fna -o new.gff
```

- `-g` is the original GFF (for example downloaded from NCBI).
- `-f` is the corresponding FASTA file with the genome (also downloaded from NCBI).
- `-o` is the name for the output file.

This is a bit more advanced, and is included here for interested users. 
We already prepared all the files for performing a phylogeny, so you don't need to worry about this for the course. 
:::


## Summary

::: {.callout-tip}
## Key Points

:::