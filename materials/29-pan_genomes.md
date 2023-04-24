---
title: "Introduction to Pan-genomes"
---

::: {.callout-tip}
#### Learning Objectives

- Understand what a pan-genome is.

:::

## Pan-genome analysis

When you have a very diverse dataset where no single reference is going to accurately reflect the population structure withn your dataset, then a reference independent approach such as constructing a core gene alignment as part of a pan-genome analysis is the best way to build a multiple sequence alignmnet for phylogenetic inference.  There are several tools available to do this including `roary`, `panaroo` and `panX`.  It's important to note that the alignments produced using these tools only contain the genes found in all or nearly all of the samples meaning that the amount of potentially phylogenetically informative information is reduced.  For this reason, core gene based phylogenies are useful for looking at a whole species but it's generally preferable to perform clustering and create new sub-trees using reference mapping if you're interested in examining the relationship between more closely related genomes.