#############################
## Load required libraries ##
#############################

library(tidyverse)
library(ggtree)
library(ggnewscale)

#################################
## Assign colours for metadata ##
#################################

colourList <- c("#0000cc","#ff0000","#660000","#9900ff","#ff66cc","#006600","#9999ff","#996600","#663366","#99cc66",
                "#c4dc00","#ff6600","#666600","#cc9933","#99cc00","#cc99ff","#ccccff","#ffcc66","#336666","#000066","#666666","#663300","#1dc39f",
                "#ddff33","#ffd700","#ffac2a","#c4dc00","#8f007f","#444c04","#e8ff2a","#8f0038","#388f00","#dc00c4","#1dc34f","#c34c1d","#ff6666",
                "#ffcccc", "#FFFFD9", "#EDF8B1", "#C7E9B4", "#7FCDBB")

##########################
## Read in metadata TSV ##
##########################

# Update the path
metadata <- read_tsv("pneumo_metadata.tsv")

############################################
## Create metadata df for ggtree plotting ##
############################################

metadataDF <- as.data.frame(metadata[2:10])

metadataDF$`MLST ST (PubMLST)` <- as.factor(metadataDF$`MLST ST (PubMLST)`)

rownames(metadataDF) <- metadata$sample

##############################
## Read in IQTREE phylogeny ##
##############################

# Update the path
pneumo_phylogeny <- read.tree("sero1.treefile")

#####################################
## Root with reference as outgroup ##
#####################################

pneumo_phylogeny <- root(pneumo_phylogeny, outgroup = "NC_018630.1", resolve.root = TRUE)

############################
## Plot phylogenetic tree ##
############################

pneumo_phylogeny_plot <- ggtree(pneumo_phylogeny) +
  geom_tiplab(align = F, 
              size = 2) +
  xlim_tree(0.002) +
  geom_treescale(x = 0, y = 25) +
  theme_tree()

##############################################
## Plot phylogeny with ST as metadata strip ##
##############################################

pneumo_phylogeny_plot_meta <- gheatmap(pneumo_phylogeny_plot, 
                                       metadataDF[9],
                                       offset = 0.0005,
                                       width = 0.05,
                                       color = NA,
                                       colnames = T,
                                       colnames_angle=90,
                                       colnames_position = "top",
                                       hjust = 0,
                                       font.size = 4) +
  scale_fill_manual(values = colourList, name = "MLST ST (PubMLST)") +
  coord_cartesian(clip = "off")
