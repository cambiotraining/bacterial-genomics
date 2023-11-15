---
title: "Assembly Quality"
---

::: {.callout-tip}
## Learning Objectives

After this section you should be able to:

- List common indicators to assess the quality of a genome assembly.
- Discuss general assembly statistics that can be used to assess genome contiguity and completeness. 
- Examine assembly graphs and use them to determine the contiguity of an assembly.
- Apply specialised software to assess the genome completeness as well as potential contamination.

:::

## Assembly quality

Before we do any further analyses, we need to assess the quality of our genome assemblies. The quality of a genome assembly can be influenced by various factors that impact its accuracy and completeness, from sample collection, to sequencing, to the bioinformatic analysis. 
To assess the quality of an assembly, several key indicators can be examined:

- **Completeness:** the extent to which the genome is accurately represented in the assembly, including both core and accessory genes.
- **Contiguity:** refers to how long the sequences are without gaps. A highly contiguous assembly means that longer stretches are assembled without interruptions, the best being chromosome-level assemblies. A less contiguous assembly will be represented in more separate fragments.
- **Contamination:** the presence of DNA from other species or sources in the assembly.
- **Accuracy/correctness:** how closely the assembled sequence matches the true sequence of the genome.

Evaluating these factors collectively provides insights into the reliability and utility of the genome assembly for further analysis and interpretation.

For the purposes of time, we didn't run bacQC on our _Staphylococcus aureus dataset_. However, we've provided the results for our contamination check using `Kraken 2` in `results/bacQC/metadata/species_composition.tsv` along with the other summary results produced by bacQC.

Since our samples are taken from a published dataset, we expected little or no contamination but this is not always the case so it's important still to do quality control of data taken from public databases to ensure that it is suitable for the analysis you're running.  For instance, contamination with another *Staphylococcus* species or even another bacterial species altogether would have affected the accuracy of our assemblies.

Let's now turn to some of the other metrics to help us assess our assemblies' quality.

![Image source: [Bretaudeau et al. (2023) Galaxy Training](https://training.galaxyproject.org/training-material/topics/assembly/tutorials/assembly-quality-control/slides-plain.html)](https://training.galaxyproject.org/training-material/topics/assembly/images/genome-qc/3C.png)


## Contiguity

One of the outputs from running assembleBAC is a summary file containing the `Quast` outputs for each sample.  This file can be found in `results/assembleBAC/metadata/transposed_report.csv`.

You can open it with a spreadsheet software such as _Excel_ from our file browser <i class="fa-solid fa-folder"></i>. 
Alternatively you can print it directly on the terminal in a nice format using the `column` command, as shown here for the samples we've been using as an example ((for brevity, we only show some columns of most interest):): 

```bash
column -t -s "," results/assembleBAC/metadata/transposed_report.csv
```

```
Assembly	# contigs (>= 0 bp)	# contigs (>= 1000 bp)	Total length (>= 0 bp)	Largest contig	N50
CTMA_1432	2	2	4103466	3057934	3057934
```

The columns are: 

- **Assembly** - our sample ID.
- **# contigs (>= 0 bp)** - the total number of contigs in each of our assemblies.
- **# contigs (>= 1000 bp)** - the total number of contigs > 1000 bp in each of our assemblies.
- **Total length (>= 0 bp)** - the total length of our assembled fragments. 
- **Largest contig** - the largest assembled fragment.
- **N50** - a metric indicating the length of the shortest fragment, from the group of fragments that together represent at least 50% of the total genome. A higher N50 value suggests better contig lengths.

To interpret these statistics, it helps to compare them with other well-assembled _Staphylococcus aureus_ genomes. 
For example, let's take the first MRSA genome that was sequenced, [XXXX]('NCBI link'), as our reference for comparison. 
This genome is X Mb long and is composed of a single chromosome.

We can see that all of our assemblies reached a total length of around XX to XX Mb, which matches the expected length from our reference genome.
This indicates that we managed to assemble most of the expected genome. 
However, we can see that there is a variation in the number of fragments in the final assemblies (i.e. their contiguity). 
For instance, isolates X and X were assembled to a small number of fragments each, suggesting good assemblies. For several other isolates our assemblies were more fragmented, in particular X and X, which had hundreds of fragments. 
This indicates less contiguous sequences.

## Completeness

We now turn to assessing **genome completeness**, i.e. whether we managed to recover most of the known _Staphylococcus aureus_ genome, or whether we have large fractions missing. We can assess this by using [`CheckM2`](https://github.com/chklovski/CheckM2) which was run as part of the assembleBAC pipeline. This tool assesses the completeness of the assembled genomes based on other similar organisms in public databases, in addition to contamination scores. The output file from assembleBAC summarising the `CheckM2` results is a tab-delimited file called `checkm2_summary.tsv`. This file can be found in `results/assembleBAC/metadata/` and can be opened in a spreadsheet software such as _Excel_. Here is an example result (for brevity, we only show some columns of most interest):

```
Name       Completeness  Contamination  Genome_Size  GC_Content  Total_Coding_Sequences
isolate01  92.51         5.19           4192535      0.48        5375
```
These columns indicate:

- **Name** - our sample name.
- **Completeness** - how complete our genome was inferred to be as a percentage; this is based on the machine learning models used and the organisms present in the database.
- **Contamination** - the percentage of the assembly estimated to be contaminated with other organisms (indicating our assembly isn't "pure"). 
- **Genome_Size** - how big the genome is estimated to be, based on other similar genomes present in the database. 
  The [XXXX]('NCBI link') is X Mb in total, so these values make sense. 
- **GC_Content** - the percentage of G's and C's in the genome, which is relatively constant within a species. 
  The _S. aureus_ GC content is X%, so again these values make sense.
- **Total_Coding_Sequences** - the total number of coding sequences (genes) that were identified by _CheckM2_. 
  The [reference genome]('NCBI link') indicates  annotated genes, so the values obtained could be overestimated.

From this analysis, we can assess that our genome assemblies are good quality, with around 90% of the genome assembled. 
Despite earlier assessing that some of the isolates have more fragmented assemblies (e.g. isolates 5 and 9), they still have >85% completeness according to _CheckM2_. 

It is worth noting that the assessment from _CheckM2_ is an approximation based on other genomes in the database. 
In diverse species such as _S. aureus_ the completeness may be underestimated, because each individual strain will only carry part of the _pangenome_ for that species.

## Accuracy

Assessing the accuracy of our genome includes addressing issues such as:

- **Repeat resolution:** the ability of the assembly to accurately distinguish and represent repetitive regions within the genome.
- **Structural variations:** detecting large-scale changes, such as insertions, deletions, or rearrangements in the genome structure.
- **Sequencing errors:** identifying whether errors from the sequencing reads have persisted in the final assembly, including single-nucleotide errors or minor insertions/deletions.

Assessing these aspects of a genome assembly can be challenging, primarily because the true state of the organism's genome is often unknown, especially in the case of new genome assemblies. 

## Exercises 

:::{.callout-exercise}
#### Assembly contiguity

To assess the contiguity of your assemblies, you ran `QUAST` as part of the assembleBAC pipeline:Open the file `transposed_report.csv` in the metadata directory of your assembleBAC results directory. This should open the file in _Excel_. 
- Answer the following questions: 
  - Was the assembly length what you expect for _Staphylococcus aureus_?
  - Did your samples have good contiguity (number of fragments)?
  - Do you think any of the samples are not of sufficient quality to include in further analyses?

:::{.callout-answer}
For the dataset we are using, we had our file in `results/assembleBAC/transposed_report.csv`. 
We opened this table in _Excel_ and this is what we obtained: 

```
Assembly	# contigs (>= 0 bp)	# contigs (>= 1000 bp)	# contigs (>= 5000 bp)	# contigs (>= 10000 bp)	# contigs (>= 25000 bp)	# contigs (>= 50000 bp)	Total length (>= 0 bp)	Total length (>= 1000 bp)	Total length (>= 5000 bp)	Total length (>= 10000 bp)	Total length (>= 25000 bp)	Total length (>= 50000 bp)	# contigs	Largest contig	Total length	GC (%)	N50	N90	auN	L50	L90	# N's per 100 kbp
CTMA_1432	2	2	2	2	2	2	4103466	4103466	4103466	4103466	4103466	4103466	2	3057934	4103466	47.50	3057934	1045532	2545189.2	1	2	0.00
```

The assembly lengths obtained were all around 2 Mb, which is expected for this species. 

The contiguity of our assemblies seemed excellent, with only up to XX fragments. Some samples even had X fragments assembled, suggesting we managed to mostly reassemble our genomes. 

Isolates XX and XX have more than X contigs. We may want to consider removing these isolates as they may affect our pan-genome calculation in the next section.

:::
:::

:::{.callout-exercise}
#### Assembly completeness

To assess the completeness of your assembly, we ran the _CheckM2_ software on your assembly files as part of the assembleBAC pipeline.
Go to the output folder and open the `checkm2_summary.tsv` file in _Excel_. 
  Answer the following questions: 
  - Did you manage to achieve >90% completeness for your genomes?
  - Was there evidence of substantial contamination in your assemblies?
  - Was the GC content what you expected for this species?

:::{.callout-answer}

We opened the file `results/assembleBAC/metadata/checkm2_summary.tsv` in _Excel_ and this is what we obtained: 

```
Name	Completeness	Contamination	Completeness_Model_Used	Translation_Table_Used	Coding_Density	Contig_N50	Average_Gene_Length	Genome_Size	GC_Content	Total_Coding_Sequences	Additional_Notes
CTMA_1402	99.99	1.16	Neural Network (Specific Model)	11	0.865	3058794	310.65996343692865	4118479	0.47	3829	None
```

We can see from this that: 

- We achieved ~90% completeness (according to _CheckM2_'s database) for all our samples. 
- There was no evidence of strong contamination affecting our assemblies (all ~5% or below).
- The GC content was XX%, which is what is expected for _Staphylococcus aureus_. 
:::
:::

## Summary

::: {.callout-tip}
#### Key Points

- Key aspects to evaluate an assembly quality include: 
  - Contiguity: how continuous the final assembly is (the best assembly would be chromosome-level).
  - Completeness: whether the entire genome of the species was captured.
- Common indicators for evaluating the contiguity of a genome assembly include metrics like N50, fragment count and total assembly size.
- Specialised software tools, like _CheckM2_, enable the assessment of genome completeness and contamination by comparing the assembly to known reference genomes and identifying missing or unexpected genes and sequences.

:::