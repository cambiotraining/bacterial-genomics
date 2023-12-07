---
title: "Introduction to Pan-genomes"
---

::: {.callout-tip}
## Learning Objectives

- Define what a pan-genome is and the difference between "core" and "accessory" genomes.
- Describe how the study of pan-genomes helps in understanding the biology of a bacterial species. 
- Describe what a core gene alignment is and in which situations it is necessary for phylogenetic inference.
:::

## Pan-genome analysis

The concept of a bacterial pan-genome refers to the full complement of genes in a bacterial species. It is divided into two parts: the **core genome** and the **accessory genome**. The core genome consists of genes that are present in all strains of the species, which are typically essential for basic functions and survival. The accessory genome includes genes that are not present in all strains but may be found in one or more strains; these genes often confer specialized functions, such as antibiotic resistance or the ability to metabolise certain substrates.

The significance of bacterial pan-genomes in microbial genomics lies in their ability to provide insights into the genetic diversity, evolutionary history, and adaptive capabilities of bacterial species. By studying the pan-genome, researchers can identify genes that are crucial for the survival of a species across different environments, as well as genes that allow certain strains to thrive in specific niches or confer pathogenicity.

## Core gene alignment

When you have a very diverse dataset where no single reference accurately reflects the population structure within your dataset, it is challenging to create a sequence alignment using the entire genomes. In such cases, it is more effective to use a reference-independent approach. One way to do this is by constructing a core gene alignment, which includes genes present in nearly all the genomes in the dataset. This core gene alignment is a key part of a pan-genome analysis and is considered the best method for building a multiple sequence alignment for phylogenetic inference in these cases.  

There are several tools available to do this including `roary`, `Panaroo` and `panX`.  It is important to note that because the alignments produced using these tools only contain the genes found in all or nearly all of the samples, the amount of phylogenetically informative sites is reduced.  For this reason, core gene-based phylogenies are useful for looking at the broader diversity in a species. To examine the relationship between more closely related genomes, it is preferable to perform clustering and create new sub-trees using reference-based alignment.

## Summary

::: {.callout-tip}
## Key Points

- A pan-genome includes all the genes in a bacterial species, with "core" genes being present in (nearly) all individuals and "accessory" genes being those unique to only some.
- Examining the pan-genomes of a species can reveal shared and unique genetic traits, giving insights into its biology and adaptability. This includes understanding the evolution of antimicrobial resistance, which is of relevance to public health.
- A core gene alignment consists of identifying genes found in almost all the genomes in a dataset and performing a multiple sequence alignment from them. 
- Core gene alignments are used to obtain more accurate phylogenetic trees in highly diverse species.

:::