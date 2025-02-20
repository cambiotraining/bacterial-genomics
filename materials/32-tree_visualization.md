---
title: "Visualising phylogenies with ggtree"
---

::: {.callout-tip}
## Learning Objectives

- Visualise and annotate a _S. pneumoniae_ phylogenetic tree with the R package `ggtree`.

:::

## Plotting phylogenetic trees with R

Plotting phylogenetic trees with `ggtree` in R offers a powerful and flexible approach for visualizing evolutionary relationships. 
The `ggtree` package, built on the ggplot2 framework, enables the creation of complex and highly customizable phylogenetic tree plots. 
With `ggtree`, users can manipulate tree layouts, annotate nodes and branches, and incorporate additional data layers such as heatmaps or bar charts. 
The package supports various tree formats, including Newick, Nexus, and PhyloXML, making it versatile for different datasets. 
Researchers can enhance their plots with a wide array of aesthetic options, such as color coding by clade, adding tip labels, and highlighting specific evolutionary events or traits. 
This flexibility makes `ggtree` an essential tool for evolutionary biologists and bioinformaticians, facilitating the clear and informative presentation of phylogenetic data.

The package developer has written a book - [Data Integration, Manipulation and Visualization of Phylogenetic Trees](https://yulab-smu.top/treedata-book/index.html) -, which goes through the many functions this package offers. 

:::{.callout-exercise}
#### Plot the Pneumococcal tree with `ggtree`

- Open the script `06-plot_phylogeny.R` in the `scripts` directory in RStudio.
- Run the script line-by-line to generate the annotated phylogenetic tree. 

:::{.callout-answer}

The resulting tree should look similar to this:

![Serotype 1 phylogenetic tree generated with ggtree](images/sero1_tree.png)

:::
:::

## Summary

::: {.callout-tip}
#### Key Points

- ggtree is a highly customisable R package for generating publication quality images of phylogenetic trees.
:::