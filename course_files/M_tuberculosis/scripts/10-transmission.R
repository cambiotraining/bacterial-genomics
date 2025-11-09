#############################
## Load required libraries ##
#############################

library(tidyverse)
library(data.table)
library(tidygraph)
library(ggraph)
library(igraph)

# make sure the working directory is set correctly
setwd("M_tuberculosis")

#########################
## Read in pairsnp CSV ##
#########################

# Update the path

snp_matrix <- "preprocessed/transmission/aligned_pseudogenomes_masked_snps.csv"

snp_matrix_df <- read_csv(snp_matrix, col_names = FALSE)

######################
## Read in metadata ##
######################

# Update the path

metadata <- read_tsv("TB_metadata.tsv")

################################
## Add column names to matrix ##
################################

snp_matrix_df <- transpose(snp_matrix_df, make.names = 'X1')

###########################################
## Convert pairsnp output into dataframe ##
###########################################

snp_matrix_df_decon <- data.frame(
  t(combn(names(snp_matrix_df), 2)),
  dist = t(snp_matrix_df)[lower.tri(snp_matrix_df)]
)

colnames(snp_matrix_df_decon) <- c("Taxon1", "Taxon2", "dist")

##############################################
## Plot histogram of pairwise SNP distances ##
##############################################

snp_histogram <- ggplot(data = snp_matrix_df_decon, aes(x = dist)) +
  geom_histogram(bins = 200, alpha = 0.8, position = "identity") +
  theme_bw() +
  xlab("Pairwise SNP distance") +
  ylab("Frequency")

################################################
## Create new df containing nodes for network ##
################################################

metadata_nodes <- metadata %>%
  mutate(id = row_number()) %>%
  select(id, sample, longitude, latitude, Region, Sex, HIV.status, Site.of..TB)

#######################
## Set SNP threshold ##
#######################

threshold <- 15

#######################################
## Extract pairwise SNP comparisons  ##
#######################################

edges <- snp_matrix_df_decon %>%
  filter(dist <= threshold) %>%
  select(Taxon1, Taxon2, dist)

edges <- edges %>%
  left_join(metadata_nodes[, c(1, 2)], by = c("Taxon1" = "sample")) %>%
  rename(from.id = id)

edges <- edges %>%
  left_join(metadata_nodes[, c(1, 2)], by = c("Taxon2" = "sample")) %>%
  select(from.id, to.id = id, dist)

###########################
## Create network object ##
###########################

network <- tbl_graph(nodes = metadata_nodes, edges = edges, directed = TRUE)

network_components <- components(network)

metadata_nodes_networked <- metadata_nodes %>%
  mutate(network_id = network_components$membership)

###################################
## Filter out network singletons ##
###################################

metadata_nodes_networked_filtered <- metadata_nodes_networked %>%
  group_by(network_id) %>%
  filter(n() > 1) %>%
  ungroup() %>%
  mutate(id = row_number()) %>%
  select(id, sample, longitude, latitude, Region, Sex, HIV.status, Site.of..TB)

######################################
## Extract pairwise SNP comparisons ##
######################################

edges_filtered <- snp_matrix_df_decon %>%
  filter(dist <= threshold) %>%
  select(Taxon1, Taxon2, dist)

edges_filtered <- edges_filtered %>%
  left_join(
    metadata_nodes_networked_filtered[, c(1, 2)],
    by = c("Taxon1" = "sample")
  ) %>%
  rename(from.id = id)

edges_filtered <- edges_filtered %>%
  left_join(
    metadata_nodes_networked_filtered[, c(1, 2)],
    by = c("Taxon2" = "sample")
  ) %>%
  select(from.id, to.id = id, dist)

###############################
## Create new network object ##
###############################

network_filtered <- tbl_graph(
  nodes = metadata_nodes_networked_filtered,
  edges = edges_filtered,
  directed = TRUE
)

###################################################
## Plot network without isolates not in networks ##
###################################################

network_filtered_plot <- ggraph(network_filtered, layout = "nicely") +
  geom_edge_link(
    aes(label = dist),
    edge_colour = 'black',
    edge_width = 1,
    angle_calc = "along",
    label_dodge = unit(2.5, 'mm'),
    label_size = 3
  ) +
  geom_node_point(aes(colour = Region, shape = Sex), size = 6) +
  theme_graph() +
  labs(colour = "Region", shape = "Sex")
