#############################
## Load required libraries ##
#############################

library(tidyverse)
library(janitor) # to clean column names
library(ape)
library(ggtree)
library(ggnewscale)

# working directory
setwd("S_pneumoniae")

#################################
## Assign colours for metadata ##
#################################

# colour blind-friendly palette
colour_list <- RColorBrewer::brewer.pal(8, "Dark2")

##########################
## Read in metadata TSV ##
##########################

# read the metadata table
metadata <- read_tsv("pneumo_metadata.tsv")

############################################
## Create metadata df for ggtree plotting ##
############################################

metadata_ggtree <- metadata %>% 
  # clean the column names
  clean_names() %>% 
  # rename some columns for convenience
  rename(mlst_st = mlst_st_streptococcus_pneumoniae_pub_mlst,
         mlst_profile = mlst_profile_streptococcus_pneumoniae_pub_mlst) %>% 
  # make sure strain type is treated as a categorical for plotting
  mutate(mlst_st = factor(mlst_st)) %>% 
  # move sample names to rownames (for ggtree)
  column_to_rownames("sample")
  

##############################
## Read in IQTREE phylogeny ##
##############################

# read the tree
pneumo_phylogeny <- read.tree("preprocessed/iqtree/sero1.treefile")

#####################################
## Root with reference as outgroup ##
#####################################

pneumo_phylogeny <- root(pneumo_phylogeny, outgroup = "NC_018630.1", resolve.root = TRUE)

############################
## Plot phylogenetic tree ##
############################

pneumo_phylogeny_plot <- ggtree(pneumo_phylogeny) +
  geom_tiplab(align = F, 
              size = 4) +
  xlim_tree(0.002) +
  geom_treescale(x = 0, y = 25) +
  theme_tree()

pneumo_phylogeny_plot

##############################################
## Plot phylogeny with ST as metadata strip ##
##############################################

pneumo_phylogeny_plot_meta <- gheatmap(pneumo_phylogeny_plot, 
                                       metadata_ggtree["mlst_st"],
                                       offset = 0.0005,
                                       width = 0.05,
                                       color = NA,
                                       colnames = T,
                                       colnames_angle=90,
                                       colnames_position = "top",
                                       hjust = 0,
                                       font.size = 4) +
  scale_fill_manual(values = colour_list, name = "MLST ST (PubMLST)") +
  coord_cartesian(clip = "off")

pneumo_phylogeny_plot_meta
