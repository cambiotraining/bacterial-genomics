---
title: "Introduction to QC"
---

::: {.callout-tip}
## Learning Objectives

- To perform a QC assessment of high throughput next generation sequence data
- Interpret and critically evaluate data quality reports
- To identify possible contamination in high throughput sequence data

:::

## Introduction

Before we delve into having a look at our own genomic data. Lets take time to explore what to look out for when performing **Q**uality **C**ontrol **(QC)** checks on our sequence data. 
For this course, we will largely focus on next generation sequences obtained from Illumina sequencers. 
As you may already know from [Introduction to NGS](01-intro_ngs.md), the main output files expected from our Illumina sequencer are `.fastq` files.

## QC assessment of NGS data

As you may already know, **QC** is an important part of any analysis. In this section we are going to look at some of the metrics and graphs that can be used to assess the QC of NGS data. 

### Base quality

[Illumina sequencing](https://en.wikipedia.org/wiki/Illumina_dye_sequencing) technology relies on sequencing by synthesis. One of the most common problems with this is __dephasing__. For each sequencing cycle, there is a possibility that the replication machinery slips and either incorporates more than one nucleotide or perhaps misses to incorporate one at all. The more cycles that are run (i.e. the longer the read length gets), the greater the accumulation of these types of errors gets. This leads to a heterogeneous population in the cluster, and a decreased signal purity, which in turn reduces the precision of the base calling. The figure below shows an example of this.

![Base Quality](images/base_qual.png)

Because of dephasing, it is possible to have high-quality data at the beginning of the read but really low-quality data towards the end of the read. In those cases you can decide to trim off the low-quality reads. In this course, we'll do this using the tool [`fastp`](https://www.ncbi.nlm.nih.gov/pubmed/30423086/). In addition to trimming and removing low quality reads, `fastp` will also be used to trim off Illumina adapter/primer sequences.

The figures below show an example of high-quality read data (left) and poor quality read data (right).

::: {layout-ncol=2}

![High-quality read data](images/base_qual_pass.png)

![Poor quality read data](images/base_qual_fail.png)

:::

In addition to __Phasing noise__ and __signal decay__ resulting from dephasing issues described above, there are several different reasons for a base to be called incorrectly. You can lookup these later by clicking [here](10.1093/bib/bbq077).


### Mismatches per cycle

Aligning reads to a high-quality reference genome can provide insight to the quality of a sequencing run by showing you the mismatches to the reference sequence. This can help you detect cycle-specific errors. Mismatches can occur due to two main causes, sequencing errors and differences between your sample and the reference genome, which is important to bear in mind when interpreting mismatch graphs. The figures below show an example of a good run (top) and a bad one (bottom). In the first figure, the distribution of the number of mismatches is even between the cycles, which is what we would expect from a good run. However, in the second figure, two cycles stand out with a lot of mismatches compared to the other cycles.

![Good run](images/mismatch_per_cycle_pass.png)

![Poor run](images/mismatch_per_cycle_fail.png)


### GC bias
It is a good idea to compare the GC content of the reads against the expected distribution in a reference sequence. The GC content varies between species, so a shift in GC content like the one seen below (right image) could be an indication of sample contamination. In the left image below, we can see that the GC content of the sample is about the same as for the theoretical reference, at ~65%. However, in the right figure, the GC content of the sample shows two distributions: one is closer to 40% and the other closer to 65%, indicating that there is an issue with this sample, likely contamination. 


::: {layout-ncol=2}

![Single GC distribution](images/gc_pass.png)

![Double GC distribution](images/gc_fail.png)

:::

### GC content by cycle
Looking at the GC content per cycle can help detect if the adapter sequence was trimmed. For a random library, it is expected to be little to no difference between the different bases of a sequence run, so the lines in this plot should be parallel with each other like in the first of the two figures below. In the second of the figures, the initial spikes are likely due to adapter sequences that have not been removed. 

![Good run](images/acgt_per_cycle_pass.png)

![Poor run](images/acgt_per_cycle_fail.png)


#### Insert size
For paired-end sequencing the size of DNA fragments also matters. In the first of the examples below, the insert size peaks around 440 bp. In the second however, there is also a peak at around 200 bp. This indicates that there was an issue with the fragment size selection during library prep.

![Good run](images/insert_size_pass.png)

![Poor run](images/insert_size_fail.png)


### Insertions/Deletions per cycle
Sometimes, air bubbles occur in the flow cell, which can manifest as false indels. The spike in the second image provides an example of how this can look.

![Good run](images/indels-per-cycle.pass.png)

![Poor run](images/indels-per-cycle.fail.png)


## Summary

::: {.callout-tip}
## Key Points

:::

## References
Information on this page has been adapted and modified from the following sources:

- https://github.com/sanger-pathogens/QC-training

- https://github.com/rpetit3/fastq-scan

- https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

- https://github.com/OpenGene/fastp

- https://github.com/DerrickWood/kraken2

- https://github.com/jenniferlu717/Bracken

- https://github.com/ewels/MultiQC