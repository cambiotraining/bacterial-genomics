---
title: "Introduction to *Streptococcus pneumoniae*"
---

::: {.callout-tip}
## Learning Objectives

- List some of the main features of _Streptococcus pneumoniae_.
- Recognise the role of recombination in the genomic diversity seen in this species.

:::

## _Streptococcus pneumoniae_

_Streptococcus pneumoniae_ (the pneumococcus) is a gram-positive human commensal that also causes a significant disease burden with pneumococcal-related diseases such as pneumonia and meningitis responsible for up 500,000 deaths in children <5 years old each year (Wahl 2018).  The primary pneumococcal virulence factor is the polysaccharide capsule that surrounds the cell.  Over one hundred different polysaccharide capsules (serotypes) have been identified to date and the conjugate vaccines that are routinely administered in vaccination programmes around the world typically target the 10-13 serotypes most prevalent in invasive pneumococcal disease (IPD) (Ganaie 2020).

The Global Pneumococcal Sequencing (GPS) project was set up to help understand the global picture of pneumococcal evolution during vaccine introductions using whole-genome sequencing (Lo 2019).  By the end of 2019, the GPS project had sequenced more than 26,000 pneumococcal genomes from more than 50 countries.  As well as investigating the pre- and post-vaccine pneumococcal population structure, 13,454 GPS genomes were combined with an additional 7,000 published pneumococcal genomes to identify clusters of sequences defined as Global Pneumococcal Sequence Clusters (GPSCs) (Gladstone 2019).  The study identified 621 GPSCs and 35 GPSCs contained more than 100 isolates, accounting for the majority of genomes included in the dataset.  These clusters are increasingly being used as the standard method of lineage assignment in pneumococcus. Tools now exist to allow new genomes to be assigned to existing clusters or else form the basis of novel clusters.

Uptake and incorporation of DNA from the environment into the pneumococcal chromosome via transformation and homologous recombination has been shown to contribute more to nucleotide variation than mutation in this species.  As well as being biologically important, recombination obscures the true phylogenetic signal of vertical descent and needs to be accounted for when inferring pneumococcal phylogenies. 

## Dataset

We have extracted sequence data for 50 pneumococcal genomes from a study that performed the first detailed characterisation of serotype 1 pneumococci collected from disease and carriage in an endemic region in West Africa (Chaguza 2022).

## Reference

For the analysis of our _S. pneumoniae_ dataset, we're going to map the sequence data to the same reference used in the Chaguza paper, [PNI0373 (CP001845)](https://www.ncbi.nlm.nih.gov/nuccore/CP001845.1/). This is a serotype 1 reference and is closely related to the other samples in the dataset.

## Summary

::: {.callout-tip}
## Key Points

- Although being a human commensal, _S. pneumoniae_ is also responsible for significant diseases such as pneumonia. 
- Large genome sequencing projects revealed a high diversity in this species and allowed the classification of isolates into related clusters. 
- A large contributor to the diversity seen in this species is the aquision of new DNA via recombination (horizontal gene transfer). 
- Recombination can distort phylogenetic signals and is therefore crucial to take into account before building a tree. 

:::

#### References

Wahl B, O'Brien KL, Greenbaum A, Majumder A, Liu L, Chu Y, Lukšić I, Nair H, McAllister DA, Campbell H, Rudan I, Black R, Knoll MD. Burden of _Streptococcus pneumoniae_ and _Haemophilus influenzae_ type b disease in children in the era of conjugate vaccines: global, regional, and national estimates for 2000-15. _Lancet Glob Health_. 2018. [DOI](https://doi.org/10.1016/s2214-109x(18)30247-x)

Ganaie F, Saad JS, McGee L, van Tonder AJ, Bentley SD, Lo SW, Gladstone RA, Turner P, Keenan JD, Breiman RF, Nahm MH. A New Pneumococcal Capsule Type, 10D, is the 100th Serotype and Has a Large cps Fragment from an Oral Streptococcus. _mBio_. 2020. [DOI](https://doi.org/10.1128/mbio.00937-20)

Lo SW, Gladstone RA, van Tonder AJ, Lees JA, du Plessis M, Benisty R, Givon-Lavi N, Hawkins PA, Cornick JE, Kwambana-Adams B, Law PY, Ho PL, Antonio M, Everett DB, Dagan R, von Gottberg A, Klugman KP, McGee L, Breiman RF, Bentley SD; Global Pneumococcal Sequencing Consortium. Pneumococcal lineages associated with serotype replacement and antibiotic resistance in childhood invasive pneumococcal disease in the post-PCV13 era: an international whole-genome sequencing study. _Lancet Infect Dis_. 2019. [DOI](https://doi.org/10.1016/s1473-3099(19)30297-x)

Gladstone RA, Lo SW, Lees JA, Croucher NJ, van Tonder AJ, Corander J, Page AJ, Marttinen P, Bentley LJ, Ochoa TJ, Ho PL, du Plessis M, Cornick JE, Kwambana-Adams B, Benisty R, Nzenze SA, Madhi SA, Hawkins PA, Everett DB, Antonio M, Dagan R, Klugman KP, von Gottberg A, McGee L, Breiman RF, Bentley SD; Global Pneumococcal Sequencing Consortium. International genomic definition of pneumococcal lineages, to contextualise disease, antibiotic resistance and vaccine impact. _EBioMedicine_. 2019.[DOI](https://doi.org/10.1016/j.ebiom.2019.04.021)

Chaguza C, Ebruke C, Senghore M, Lo SW, Tientcheu PE, Gladstone RA, Tonkin-Hill G, Cornick JE, Yang M, Worwui A, McGee L, Breiman RF, Klugman KP, Kadioglu A, Everett DB, Mackenzie G, Croucher NJ, Roca A, Kwambana-Adams BA, Antonio M, Bentley SD. Comparative Genomics of Disease and Carriage Serotype 1 Pneumococci. _Genome Biol Evol._ 2022. [DOI](https://doi.org/10.1093/gbe/evac052)