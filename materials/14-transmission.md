---
title: "Building transmission networks"
---

::: {.callout-tip}
## Learning Objectives

- Understand how to predict putative transmission events using genomic data.
- Understand TB transmission.
- Use networks to display putative transmission events.


:::

## Transmission networks in bacteria

Genomic data can be utilized to identify and understand the transmission of bacterial pathogens. In particular, SNP thresholds can be used to infer bacterial transmission networks by analyzing the genetic similarity between bacterial isolates from different individuals or sources. The underlying principle is that closely related bacterial strains will share a higher number of SNPs due to their recent common ancestry, while more distantly related strains will have accumulated more genetic differences over time. Putative transmission can be inferred by establishing a threshold for the number of SNPs that can be considered to indicate a transmission link. This threshold can be based on epidemiological data, previous studies, or statistical models.  These links can then be used to identify clusters and potential transmission network.  It's worth remembering that the actual SNP threshold for inferring transmission will vary depending on the organism, the population structure, and the specific context of the study. It is often determined empirically by analyzing the distribution of pairwise SNP differences among strains and identifying a natural cutoff point or through simulation studies that may incorporate information about the mutation rate of the organism and likely routes of transmission.

### Identifying transmission networks in TB

The actual SNP threshold used to define a cluster can vary depending on the study and the population being analyzed and in TB there have been a number of different thresholds applied when trying to identify putative transmission clusters,  with the most commonly applied thresholds being 5, 10 and 12 SNPs.  For example the 12 SNP threshold is used for inferring likely transmission between a pair of TB cases by UKHSA and is the threshold applied in the paper describing the data we've been analysing (Walker 2014, Claasens 2022).  Given the slow mutation of _M. tuberculosis_, a stricter threshold of 5 SNPs is usually used to infer recent transmission.  In the exercise to follow, we will use both thresholds to examine the effect they have on the transmission networks we infer.

## Generating a pairwise SNP distance matrix

The first step in building putative transmission networks is to calculate the pairwise SNP distances between all the samples in our dataset and we can do this by running a tool call `pairsnp` on the SNP alignment we used to build our phylogenetic tree.

We'll start by activating the `pairsnp` software environment:

```bash
mamba activate pairsnp
```

To run `pairsnp` on `aligned_pseudogenomes_masked_snps.fas`, the following commands can be used:

```bash
# create output directory
mkdir -p results/transmission/

# run pairsnp
pairsnp preprocessed/snp-sites/aligned_pseudogenomes_masked_snps.fas -c > results/transmission/aligned_pseudogenomes_masked_snps.csv
```
The option we used is:

- `-c` - saves the `pairsnp` output in CSV format.

The pairwise SNP matrix will be saved to the `results/transmission/` directory.  

Alternatively we've provided a script, `07-run_pairsnp.sh` in the `scripts` directory which could be used instead with `bash`:

```bash
bash scripts/07-run_pairsnp.sh
```

## Calculating and plotting transmission networks in R

Now that we've generated a pairwise SNP distance matrix, we can use **R** to calculate and plot our transmission network using a pre-determined threshold of **5** SNPs to identify putative transmission events. Open RStudio then open the script `08-transmission.R` in the `scripts` directory. Run the code in the script, going line by line (remember in RStudio you can run code from the script panel using <kbd>Ctrl</kbd> + <kbd>Enter</kbd>). As you run the code check the tables that are created (in your "Environment" panel on the top-right) and see if the SNP matrix was correctly imported.  Once you reach the end of the script, you should have created a plot showing the putative transmission networks identified in the data with the nodes coloured by Sex and the pairwise SNP distances shown along the edges:

![Putative transmission networks generated using a 5 SNP threshold](images/5_snp_network.png)

:::{.callout-exercise}
#### Adjust the pairwise SNP threshold
As discussed in the introduction above, various SNP thresholds are used when inferring putative transmission networks in TB.  We used the most conservative threshold of 5 SNPs.  For this exercise:

- Change the SNP threshold to 12 SNPs and recalculate the transmission networks
- Change the colour of the nodes to show Region instead of Sex 
- How many additional networks did we infer compared to using a threshold of 12 SNPs?

:::{.callout-answer}
- We changed the variable `threshold` to `12` then re-ran the subsequent code to generate new networks.  
- In the command to generate the final plot, we changed `geom_node_point(aes(colour = Sex), size = 6)` to `geom_node_point(aes(colour = Region), size = 6)` and changed `labs(colour = "Sex")` to `labs(colour = "Region")`.
- We generated one additional network but identified a much more complex network comprised of 13 isolates when using the higher SNP threshold of 12.

![Putative transmission networks generated using a 12 SNP threshold](images/12_snp_network.png)

:::
:::


## Summary

::: {.callout-tip}
## Key Points

:::

#### References

Walker TM, Lalor MK, Broda A, Ortega LS, Morgan M, Parker L, Churchill S, Bennett K, Golubchik T, Giess AP, Del Ojo Elias C, Jeffery KJ, Bowler ICJW, Laurenson IF, Barrett A, Drobniewski F, McCarthy ND, Anderson LF, Abubakar I, Thomas HL, Monk P, Smith EG, Walker AS, Crook DW, Peto TEA, Conlon CP. Assessment of _Mycobacterium tuberculosis_ transmission in Oxfordshire, UK, 2007-12, with whole pathogen genome sequences: an observational study. _Lancet Respir Med_. 2014. [DOI](https://doi.org/10.1016/s2213-2600(14)70027-x)

Claasens M, _et al._ Whole-Genome Sequencing for Resistance Prediction and Transmission Analysis of _Mycobacterium tuberculosis_ Complex Strains from Namibia. _Microbiology Spectrum_. 2022. [DOI](https://doi.org/10.1128/spectrum.01586-22)