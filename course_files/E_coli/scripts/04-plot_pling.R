#############################
## Load required libraries ##
#############################

library(tidyverse)
library(ggtree)
library(ggnewscale)

#################################
## Assign colours for metadata ##
#################################

# colour blind-friendly palette
colour_list <- RColorBrewer::brewer.pal(8, "Dark2")

#########################
## Parse pling results ##
#########################

# Read the TSV file
pling_results <- read_tsv("results/pling/dcj_thresh_4_graph/objects/typing.tsv")

# Split the 'plasmid' column into 'sample' and 'plasmid'
pling_results <- pling_results %>%
  separate(
    col = plasmid,
    into = c("sample", "plasmid"),
    sep = "_",
    extra = "merge"  # Handles cases with multiple underscores
  )

# Filter rows where 'type' contains "community_0"
filtered_pling_results <- pling_results %>%
  filter(str_detect(type, "community_0_"))

# Select most common plasmid for each sample
filtered_pling_results <- filtered_pling_results %>%
  group_by(sample) %>%
  add_count(plasmid) %>%  # Count occurrences of each plasmid per sample
  arrange(desc(n)) %>%    # Sort by count descending
  slice(1) %>%            # Take the first (most common) plasmid
  select(-n) %>%          # Remove the count column
  ungroup()

# Create dataframe for plotting with ggtree
filtered_pling_results_df <- as.data.frame(filtered_pling_results[2:3])
rownames(filtered_pling_results_df) <- filtered_pling_results$sample

#######################################
## Read in E.coli mashtree phylogeny ##
#######################################

phylogeny <- read.tree("results/mashtree/tree.nwk")

###################
## Midpoint root ##
###################

phylogeny_rooted <- midpoint.root(phylogeny)

############################
## Plot phylogenetic tree ##
############################

phylogeny_plot <- ggtree(phylogeny_rooted) +
  geom_tiplab(align = F, 
              size = 3) +
  xlim_tree(0.001) +
  geom_treescale(x = 0, y = 5) +
  theme_tree()

##################################
## Plot phylogeny with metadata ##
##################################

phylogeny_plot_meta <- gheatmap(phylogeny_plot, 
                                        filtered_pling_results_df[1],
                                        offset = 0.002,
                                        width = 0.05,
                                        color = NA,
                                        colnames = T,
                                        colnames_angle=90,
                                        colnames_position = "top",
                                        hjust = 0,
                                        font.size = 4) +
  scale_fill_manual(values = colour_list, name = "Plasmid") +
  coord_cartesian(clip = "off")

phylogeny_plot_meta_2 <- phylogeny_plot_meta + new_scale_fill()

phylogeny_plot_meta_3 <- gheatmap(phylogeny_plot_meta_2, 
                                        filtered_pling_results_df[2],
                                        offset = 0.003,
                                        width = 0.05,
                                        color = NA,
                                        colnames = T,
                                        colnames_angle=90,
                                        colnames_position = "top",
                                        hjust = 0,
                                        font.size = 4) +
  scale_fill_manual(values = colour_list, name = "Cluster") +
  coord_cartesian(clip = "off")
