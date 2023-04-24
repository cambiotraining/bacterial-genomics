---
title: "Gubbins"
---

::: {.callout-tip}
#### Learning Objectives

- Understand what Gubbins does. 

:::

Gubbins (Genealogies Unbiased By recomBinations In Nucleotide Sequences) is an algorithm that iteratively identifies loci containing elevated densities of base substitutions while concurrently constructing a phylogeny based on the putative point mutations outside of these regions.  We're going to use Gubbins to identify the recombinant regions in the alignment we generated using `nf-core/bactmap`.

## Visualizing recombinant regions

The outputs from `Gubbins` can be visualised using [`Phandango`](https://jameshadfield.github.io/phandango/#/).  Click on the link then drag the following files onto the Gubbins page: