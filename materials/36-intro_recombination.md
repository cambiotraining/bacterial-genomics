---
title: "What is Recombination?"
---

::: {.callout-tip}
#### Learning Objectives

- Understand what recombination is.

:::

### Removing recombination

Recombination in bacteria is characterized by DNA transfer from one organism or strain (the donor) to another organism/strain (the recipient) or the uptake of exogenous DNA from the surrounding environment.  Broadly, there are three different types of bacterial recombination:

- Transformation: the uptake of exogenous DNA from the environment
- Transduction: virus-mediated (phage) transfer of DNA between bacteria
- Conjugation: the transfer of DNA from one bacterium to another via cell-to-cell contact

The sequences transferred via recombination can influence genome-wide measures of sequence simularity more than vertically-inherited point mutations that are the signal of shared common ancestor.  Thus, identifying recombinant regions and accounting for their potentially different phylogenetic history is crucial when examining the evolutionary history of bacteria.  In practice, what this means is that we remove (mask) previously identified recombinant regions in our multiple sequence alignmnents before we proceed with phylogenetic tree inference.  The two most commonly used tools to do this are `Gubbins` and `ClonalFrameML`. It's important to note that `Gubbins` cannot be used on the core gene alignment produced by tools like `roary` or `panaroo` as Gubbins requires a whole genome alignment as input in order to analyse the spatial distribution of base substitutions.  For this reason, the finer scale phylogenetic structure of phylogenetic trees generated using a core gene alignment may be less accurate.  If we want to properly account for recombination in this instance, typically we would perform some kind of clustering on our initial tree, then map sequence data for the samples within a cluster to a suitable reference before running our recombination removal tool of choice.