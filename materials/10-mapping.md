---
title: "Mapping"
---

::: {.callout-tip}
#### Learning Objectives

- Understand what mapping is and why the need to map to a reference genome.
- To introduce mapping and variant calling software, BWA, SAMtools, bcftools.
- To show how sequence variation data such as SNPs and INDELs can be viewed in
single and multiple BAM files, and VCF variant filtering using simple genome browsers.
- To recognise what the main steps are in processing raw sequencing short read data to generate consensus genome sequences.

:::

## Mapping to a reference

The purpose of mapping sequence reads to a reference genome is to identify any phylogenetic-informative DNA changes (normally single nucleotide polymorphisms (SNPs)) in your samples relative to the reference.   For the positions in the reference genome where we don't see any differences in the mapped samples, we assume that that the nucleotide in that position is the one found in the reference.  There are a number of different tools for mapping sequence data to a reference genome (`bwa`, `bowtie2`) and calling variants (`bcftools`, `freebayes`), but the easiest way to do this is to use a pipeline such as [nf-core/bactmap](https://nf-co.re/bactmap).  `nf-core/bactmap` is a bioinformatics best-practice analysis pipeline for mapping short reads from bacterial whole genome sequences to a reference sequence, identifying the variants in each sample and creating a multiple sequence alignment that can then be used to create a phylogeny.  The pipeline is built using Nextflow, a workflow tool to run tasks across multiple compute infrastructures in a very portable manner. It uses Docker/Singularity containers making installation trivial and results highly reproducible.

### Picking a reference

Picking the best reference for your dataset is very important as this can have a large effect on the phylogenetic tree that's constructed. For some species with low diversity e.g. *M. tuberculosis*, it is usual to use the same reference (the lab strain H37v) regardless of what your dataset is comprised of. If your dataset is comprised of a single lineage (e.g. ST, CC), the best reference to use is one that is from the same or a closely related lineage.  For many of the most commonly sequenced bacteria, there are several different reference sequences available in public databases such as RefSeq, meaning that, in most instances, you can find a suitable reference.  However, for more diverse organisms, a single reference may not represent all the samples in your dataset.  In this instance, you may want consider comparing the similarity of your samples to a number of different reference sequences and pick the one that is similar to most samples in your dataset.