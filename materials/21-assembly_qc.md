---
title: "Assembly Quality"
---

::: {.callout-tip}
## Learning Objectives

- List common indicators to assess the quality of a genome assembly.
- Discuss general assembly statistics that can be used to assess genome contiguity and completeness. 

:::

## Assembly quality

Before we do any further analyses, we need to assess the quality of our genome assemblies. The quality of a genome assembly can be influenced by various factors that impact its accuracy and completeness, from sample collection, to sequencing, to the bioinformatic analysis. 
To assess the quality of an assembly, several key indicators can be examined:

- **Completeness:** the extent to which the genome is accurately represented in the assembly, including both core and accessory genes.
- **Contiguity:** refers to how long the sequences are without gaps. A highly contiguous assembly means that longer stretches are assembled without interruptions, the best being chromosome-level assemblies. A less contiguous assembly will be represented in more separate fragments.
- **Contamination:** the presence of DNA from other species or sources in the assembly.
- **Accuracy/correctness:** how closely the assembled sequence matches the true sequence of the genome.

Evaluating these factors collectively provides insights into the reliability and utility of the genome assembly for further analysis and interpretation.

For the purposes of time, we didn't run `bacQC` on our _Staphylococcus aureus dataset_. However, we've provided the results for our contamination check using `Kraken 2` in `preprocessed/bacqc/metadata/species_composition.tsv` along with the other summary results produced by bacQC.

Since our samples are taken from a published dataset, we expected little or no contamination, but this is not always the case. So, it is important still to do quality control of data taken from public databases, to ensure that it is suitable for the analysis you're running.  For instance, contamination with another _Staphylococcus_ species or even another bacterial species altogether would have affected the accuracy of our assemblies.

Let's now turn to some of the other metrics to help us assess our assemblies' quality.

![Image source: [Bretaudeau et al. (2023) Galaxy Training](https://training.galaxyproject.org/training-material/topics/assembly/tutorials/assembly-quality-control/slides-plain.html)](https://training.galaxyproject.org/training-material/topics/assembly/images/genome-qc/3C.png)


## Contiguity

One of the outputs from running `assembleBAC` is a summary file containing the `Quast` outputs for each sample.  This file can be found in `preprocessed/assemblebac/metadata/transposed_report.tsv`.

You can open it with a spreadsheet software such as _Excel_ from our file browser <i class="fa-solid fa-folder"></i> (for brevity, we only show the columns of most interest): 

```
Assembly	# contigs (>= 0 bp)	# contigs (>= 1000 bp)	Total length (>= 0 bp)	Largest contig	N50
ERX3876932_ERR3864879_T1_contigs	77	40	2848635	484893	109559
ERX3876949_ERR3864896_T1_contigs	70	18	2683262	493468	251833
ERX3876930_ERR3864877_T1_contigs	84	20	2729135	557153	251805
ERX3876908_ERR3864855_T1_contigs	45	13	2717933	792936	707553
ERX3876945_ERR3864892_T1_contigs	30	9	2670961	1351816	1351816
```

The columns are: 

- **Assembly** - our sample ID.
- **# contigs (>= 0 bp)** - the total number of contigs in each of our assemblies.
- **# contigs (>= 1000 bp)** - the total number of contigs > 1000 bp in each of our assemblies.
- **Total length (>= 0 bp)** - the total length of our assembled fragments. 
- **Largest contig** - the largest assembled fragment.
- **N50** - a metric indicating the length of the shortest fragment, from the group of fragments that together represent at least 50% of the total genome. A higher N50 value suggests better contig lengths.

To interpret these statistics, it helps to compare them with other well-assembled _Staphylococcus aureus_ genomes. 
For example, let's take the first MRSA genome that was sequenced, [N315](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000009645.1/), as our reference for comparison. This genome is 2.8 Mb long and is composed of a single chromosome.

We can see that all of our assemblies reached a total length of around 2.7 to 2.9 Mb, which matches the expected length from our reference genome. This indicates that we managed to assemble most of the expected genome. 
However, we can see that there is a variation in the number of fragments in the final assemblies (i.e. their contiguity). 
For instance, isolates ERX3876936_ERR3864883 and ERX3876945_ERR3864892 were assembled to a small number of fragments each, suggesting good assemblies. For several other isolates our assemblies were more fragmented, in particular ERX3876939_ERR3864886  which had more than 200 fragments. This indicates less contiguous sequences.

## Completeness

We now turn to assessing **genome completeness**, i.e. whether we managed to recover most of the known _Staphylococcus aureus_ genome, or whether we have large fractions missing. We can assess this by using [`CheckM2`](https://github.com/chklovski/CheckM2) which was run as part of the `assembleBAC` pipeline. This tool assesses the completeness of the assembled genomes based on other similar organisms in public databases, in addition to contamination scores. The output file from `assembleBAC` summarising the `CheckM2` results is a tab-delimited file called `checkm2_summary.tsv`. This file can be found in `preprocessed/assemblebac/metadata/` and can be opened in a spreadsheet software such as _Excel_. Here is an example result (for brevity, we only show the columns of most interest):

```
Name	Completeness	Contamination	Genome_Size	GC_Content	Total_Coding_Sequences
ERX3876905_ERR3864852_T1_contigs	100	0.22	2743298	0.33	2585
ERX3876907_ERR3864854_T1_contigs	100	0.49	2900162	0.33	2765
ERX3876908_ERR3864855_T1_contigs	100	0.07	2717933	0.33	2534
ERX3876909_ERR3864856_T1_contigs	100	0.17	2854371	0.33	2711
ERX3876929_ERR3864876_T1_contigs	100	0.1	2675834	0.33	2464
```
These columns indicate:

- **Name** - our sample name.
- **Completeness** - how complete our genome was inferred to be as a percentage; this is based on the machine learning models used and the organisms present in the database.
- **Contamination** - the percentage of the assembly estimated to be contaminated with other organisms (indicating our assembly isn't "pure"). 
- **Genome_Size** - how big the genome is estimated to be, based on other similar genomes present in the database. 
  The [N315](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000009645.1/) is 2.8 Mb in total, so these values make sense. 
- **GC_Content** - the percentage of G's and C's in the genome, which is relatively constant within a species. 
  The _S. aureus_ GC content is approximately 33%, so again these values make sense.
- **Total_Coding_Sequences** - the total number of coding sequences (genes) that were identified by _CheckM2_. 
  The [N315](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000009645.1/) indicates  annotated genes, so the values obtained could be overestimated.

From this analysis, we can assess that our genome assemblies are good quality, with 100% of the genome assembled for all our isolates. 
It is worth noting that the assessment from _CheckM2_ is an approximation based on other genomes in the database. 
In diverse species such as _S. aureus_ the completeness may be underestimated, because each individual strain will only carry part of the _pan-genome_ for that species.

## Accuracy

Assessing the accuracy of our genome includes addressing issues such as:

- **Repeat resolution:** the ability of the assembly to accurately distinguish and represent repetitive regions within the genome.
- **Structural variations:** detecting large-scale changes, such as insertions, deletions, or rearrangements in the genome structure.
- **Sequencing errors:** identifying whether errors from the sequencing reads have persisted in the final assembly, including single-nucleotide errors or minor insertions/deletions.

Assessing these aspects of a genome assembly can be challenging, primarily because the true state of the organism's genome is often unknown, especially in the case of new genome assemblies. 

:::{.callout-exercise}
#### Exercise: Assembly contiguity

To assess the contiguity of your assemblies, you ran `QUAST` as part of the assembleBAC pipeline. Open the file `transposed_report.tsv` in the `preprocessed/assemblebac/metadata` directory. This should open the file in _Excel_. 
- Answer the following questions: 
  - Was the assembly length what you expect for _Staphylococcus aureus_?
  - Did your samples have good contiguity (number of fragments)?
  - Do you think any of the samples are not of sufficient quality to include in further analyses?

:::{.callout-answer}
For the dataset we are using, we had our file in `preprocessed/assembleBAC/transposed_report.tsv`. 
We opened this table in _Excel_ and this is what we obtained: 

```
Assembly	# contigs (>= 0 bp)	# contigs (>= 1000 bp)	# contigs (>= 5000 bp)	# contigs (>= 10000 bp)	# contigs (>= 25000 bp)	# contigs (>= 50000 bp)	Total length (>= 0 bp)	Total length (>= 1000 bp)	Total length (>= 5000 bp)	Total length (>= 10000 bp)	Total length (>= 25000 bp)	Total length (>= 50000 bp)	# contigs	Largest contig	Total length	GC (%)	N50	N90	auN	L50	L90	# N's per 100 kbp
ERX3876932_ERR3864879_T1_contigs	77	40	36	29	25	20	2848635	2836870	2827630	2778943	2698417	2521114	47	484893	2841571	32.73	109559	41891	191514.9	6	21	0
ERX3876949_ERR3864896_T1_contigs	70	18	16	15	14	11	2683262	2671100	2666432	2659228	2636490	2507149	21	493468	2673387	32.69	251833	78361	283091.3	4	10	0
ERX3876930_ERR3864877_T1_contigs	84	20	20	18	15	11	2729135	2714469	2714469	2701567	2644913	2501830	25	557153	2717749	32.7	251805	52910	319559.1	4	10	0
```

The assembly lengths obtained were all around 2.7 to 2.8 Mb, which is expected for this species. 

The contiguity of our assemblies seemed excellent, with only up to 205 fragments. Some samples even had fewer than 50 fragments assembled, suggesting we managed to mostly reassemble our genomes. 

Isolate ERX3876939_ERR3864886_T1_contigs has more than 200 contigs. A this is higher than the number obtained for the rest of our assembled genomeWe may want to consider removing this isolate as it may affect our pan-genome calculation in the next section. However, as the rest of the metrics for this genome look alright, let's leave it in for now.

:::
:::

:::{.callout-exercise}
#### Exercise: Assembly completeness

To assess the completeness of your assembly, we ran the _CheckM2_ software on your assembly files as part of the assembleBAC pipeline.
Go to the ``preprocessed/assemblebac/metadata/`` directory and open the `checkm2_summary.tsv` file in _Excel_. 
  Answer the following questions: 
  - Did you manage to achieve >90% completeness for your genomes?
  - Was there evidence of substantial contamination in your assemblies?
  - Was the GC content what you expected for this species?

:::{.callout-answer}

We opened the file `preprocessed/assemblebac/metadata/checkm2_summary.tsv` in _Excel_ and this is what we obtained: 

```
Name	Completeness	Contamination	Completeness_Model_Used	Translation_Table_Used	Coding_Density	Contig_N50	Average_Gene_Length	Genome_Size	GC_Content	Total_Coding_Sequences	Additional_Notes
ERX3876905_ERR3864852_T1_contigs	100	0.22	Neural Network (Specific Model)	11	0.841	188199	297.9439072	2743298	0.33	2585	None
ERX3876907_ERR3864854_T1_contigs	100	0.49	Neural Network (Specific Model)	11	0.839	174940	293.8538879	2900162	0.33	2765	None
ERX3876908_ERR3864855_T1_contigs	100	0.07	Neural Network (Specific Model)	11	0.841	707553	301.2190213	2717933	0.33	2534	None
ERX3876909_ERR3864856_T1_contigs	100	0.17	Neural Network (Specific Model)	11	0.84	181628	295.3832534	2854371	0.33	2711	None
ERX3876929_ERR3864876_T1_contigs	100	0.1	Neural Network (Specific Model)	11	0.841	605766	304.9176136	2675834	0.33	2464	None
```

We can see from this that: 

- We achieved 100% completeness (according to _CheckM2_'s database) for all our samples. 
- There was no evidence of strong contamination affecting our assemblies (all ~5% or below).
- The GC content was 33%, which is what is expected for _Staphylococcus aureus_. 
:::
:::

## Summary

::: {.callout-tip}
#### Key Points

- Key aspects to evaluate an assembly quality include: 
  - Contiguity: how continuous the final assembly is (the best assembly would be chromosome-level).
  - Completeness: whether the entire genome of the species was captured.
- Common indicators for evaluating the contiguity of a genome assembly include metrics like N50, fragment count and total assembly size.
- Specialised software tools, like _QUAST_ and _CheckM2_, enable the assessment of genome completeness and contamination by comparing the assembly to known reference genomes and identifying missing or unexpected genes and sequences.

:::