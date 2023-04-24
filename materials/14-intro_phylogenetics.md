---
title: "Introduction to Phylogenetics"
---

::: {.callout-tip}
#### Learning Objectives

- Understand the basics of how phylogeny trees are constructed using maximum likelihood methods.

:::

## 10.2 Phylogenetic tree inference

A phylogenetic tree is a graph (structure) representing evolutionary history and shared ancestry. It depicts the lines of evolutionary descent of different species, lineages or genes from a common ancestor. A phylogenetic tree is made of nodes and edges, with one edge connecting two nodes.

A node can represent an extant species, and extinct one, or a sampled pathogen: these are all cases of "terminal" nodes, nodes in the tree connected to only one edge, and usually associated with data, such as a genome sequence.

A tree also contains "internal" nodes: these usually represent most recent common ancestors (MRCAs) of groups of terminal nodes, and are typically not associated with observed data, although genome sequences and other features of these ancestors can be statistically inferred. An internal node is most often connected to 3 branches (two descendants and one ancestral), but a multifurcation node can have any number >2 of descendant branches.

![Newick Format Example tree](../fig/NewickExample.png)

### Tree topology

A clade is the set of all terminal nodes descending from the same ancestor. Each branch and internal node in a tree is associated with a clade. If two trees have the same clades, we say that they have the same topology. If they have the same clades and the same branch lengths, the two tree are equivalent, that is, they represent the same evolutionary history.

### Uses of phlogenetic trees

In may cases, the phylogenetic tree represents the end results of an analysis, for example if we are interested in the evolutionary history of a set of species.

However, in many cases a phylogenetic tree represents an intermediate step, and there are many ways in which phylogenetic trees can be used to help understand evolution and the spread of infectious disease.

In many cases, we may want to know more about genome evolution, for example about mutational pressures, but more frequently about selective pressures. Selection can affect genome evolution in many ways such as slowing down evolution of portion of the genome in which changes are deleterious ("purifying selection"). Instead, "positive selection" can favor changes at certain positions of the genome, effectively accelerating their evolution. Using genome data and phylogenetic trees, molecular evolution methods can infer different types of selection acting in different parts of the genome and different branches of a tree.

### Newick format

We often need to represent trees in text format, for example to communicate them as input or output of phylogenetic inference software.
The Newick format is the most common text format for phylogenetic trees.

The Newick format encloses each subtree (the part of a tree relating the terminal nodes part of the same clade) with parenthesis, and separates the two child nodes of the same internal node with a ",". At the end of a Newick tree there is always a ";".

For example, the Newick format of a rooted tree relating two samples "S1" and "S2", with distances from the root respectively of 0.1 and 0.2, is

`(S1:0.1,S2:0.2);`

If we add a third sample "S3" as an outgroup, the tree might become

`((S1:0.1,S2:0.2):0.3,S3:0.4);`

### Methods for inferring phylogenetic trees

A few different methods exist for inferring phylogenetic trees:

- Distance-based methods such as Neighbour-Joining and UPGMA
- Parsimony-based phylogenetics 
- Maximum likelihood methods making use of nuclotide substitution models

#### Distance-based methods

These are the simplest and fastest phylogenetic methods we can use and are often a useful way to have a quick look at our data before running more robust phylogenetic methods.  Here, we infer evolutionary distances from the multiple sequence alignment. In the example below there is 1 subsitution out of 16 informative columns (we exclude columns with gaps or N's) so the distance is approximately 1/16:

![Evolutionary distance between two sequences](../fig/phylo_distance_alignment.png)

Typically, we have multiple sequences in an alignment so here we would generate a matrix of pairwise distances between all samples (distance matrix) and then use Neighbour-Joining or UPGMA to infer our phylogeny:

![Distance matrix to Neighbour-Joining tree](../fig/phylo_matrix_nj.png)

#### Parsimony methods

Maximum parsimony methods assume that the best phylogenetic tree requires the fewest number of mutations to explain the data (i.e. the simplest explanation is the most likely one).  By reconstructing the ancestral sequences (at each node), maximum parsimony methods evaluate the number of mutations required by a tree then modify the tree a little bit at a time to improve it.

![Maximum parsimony](../fig/phylo_max_parsimony.png)

Maximum parsimony is an intuitive and simple method and is reasonably fast to run.  However, because the most parsimonius tree is always the shortest tree, compared to the hypothetical "true" tree it will often underestimate the actual evolutionary change that may have occurred.


#### Maximum likelihood methods

The most commonly encountered phylogenetic method when working with bacterial genome datasets is maximum likelihood.  These methods use probabilistic models of genome evolution to evaluate trees and whilst similar to maximum parsimony, they allow statistical flexibility by permitting varying rates of evolution across different lineages and sites.  This additional complexity means that maximum likelihood models are much slower than the previous two models discussed.  Maximum likelihood methods make use of substitution models (models of DNA sequence evolution) that describe changes over evolutionary time. Two commonly used substitution models, Jukes-Cantor (JC69; assumes only one mutation rate) and Hasegawa, Kishino and Yano (HKY85; assumes different mutation rates - transitions have different rates) are depicted below:

![Two DNA substitution models](../fig/phylo_max_likelihood.png)

It is also possible to incorporate additional assumptions about your data e.g. assuming that a proportion of the the alignment columns (the invariant or constant sites) cannot mutate or that there is rate variation between the different alignment columns (columns may evolve at different rates).  The choice of which is the best model to use is often a tricky one; generally starting with one of the simpler models e.g. General time reversible (GTR) or HKY is the best way to proceed.  Accounting for rate variation and invariant sites is an important aspect to consider so using models like HKY+G4+I (G4 = four types of rate variation allowed; I = invariant sites don't mutate) should also be considered.

There are a number of different tools for phylogenetic inference via maximum-likelihood and some of the most popular tools used for phylogenetic inference are [`FastTree`](http://www.microbesonline.org/fasttree/), [`IQ-TREE`](http://www.iqtree.org/) and [`RAxML-NG`](https://github.com/amkozlov/raxml-ng). For this lesson, we're going to use `IQ-TREE` as it is fast and has a large number of substitution models to consider.  It also has a model finder option which tells `IQ-TREE` to pick the best fitting model for your dataset, thus removing the decision of which model to pick entirely.

### Tree uncertainty - bootstrap

All the methods for phylogenetic inference that we discussed so far aim at estimating a single realistic tree, but they don't automatically tell us how confident we should be in the tree, or in individual branches of the tree.

One common way to address this limitation is using the phylogenetic bootstrap approach (Felsenstein, 1985).
This consist first in sampling a large number (say, 1000) of bootstrap alignments.
Each of these alignments has the same size as the original alignment, and is obtained by sampling with replacement the columns of the original alignment; in each bootstrap alignment some of the columns of the original alignment will usually be absent, and some other columns would be represented multiple times.
We then infer a bootstrap tree from each bootstrap alignment.
Because the bootstrap alignments differ from each other and from the original alignment, the bootstrap trees might different between each other and from the original tree.
The bootstrap support of a branch in the original tree is then defined as the proportion of times in which this branch is present in the bootstrap trees.