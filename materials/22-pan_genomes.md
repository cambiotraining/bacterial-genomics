---
title: "Introduction to Pan-genomes"
---

::: {.callout-tip}
## Learning Objectives

- Understand what a pan-genome is.

:::

## Pan-genome analysis

The concept of a bacterial pan-genome refers to the full complement of genes in a bacterial species. It is divided into two parts: the core genome and the accessory genome. The core genome consists of genes that are present in all strains of the species, which are typically essential for basic functions and survival. The accessory genome includes genes that are not present in all strains but may be found in one or more strains; these genes often confer specialized functions, such as antibiotic resistance or the ability to metabolize certain substrates.

The significance of bacterial pan-genomes in microbial genomics lies in their ability to provide insights into the genetic diversity, evolutionary history, and adaptive capabilities of bacterial species. By studying the pan-genome, researchers can identify genes that are crucial for the survival of a species across different environments, as well as genes that allow certain strains to thrive in specific niches or confer pathogenicity.

## Core gene alignment

When you have a very diverse dataset where no single reference is going to accurately reflect the population structure withn your dataset, then a reference independent approach such as constructing a core gene alignment (an alignment consisting of the genes present in all or nearly all of the genomes included) as part of a pan-genome analysis is the best way to build a multiple sequence alignment for phylogenetic inference.  

There are several tools available to do this including `roary`, `Panaroo` and `panX`.  It's important to note that because the alignments produced using these tools only contain the genes found in all or nearly all of the samples, the amount of potentially phylogenetically informative information is reduced.  For this reason, core gene based phylogenies are useful for looking at a whole species but it's generally preferable to perform clustering and create new sub-trees using reference mapping if you're interested in examining the relationship between more closely related genomes.



## Summary

::: {.callout-tip}
## Key Points

:::