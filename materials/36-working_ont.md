---
title: "Working with ONT data"
---

::: {.callout-tip}
#### Learning Objectives

- Understand the advantages of Oxford Nanopore Technologies (ONT) sequencing compared to Illumina.
- Recognise the unique characteristics of ONT data and the alternative pipelines available for its analysis.
:::

## Introduction to Oxford Nanopore Technologies (ONT)

Oxford Nanopore Technologies (ONT) offers a compelling alternative to Illumina’s dominant short-read sequencing platforms, particularly for applications where long-read sequencing provides a critical advantage. ONT’s sequencing technology is based on nanopore sensing, which measures changes in electrical current as DNA or RNA strands pass through protein nanopores, enabling real-time, ultra-long reads (often exceeding 100 kb). This contrasts with Illumina’s short-read (50–300 bp) sequencing-by-synthesis approach. Key advantages of ONT include its portability (with devices ranging from pocket-sized MinIONs to high-throughput PromethION systems), lower upfront costs, and the ability to directly detect base modifications (e.g., methylation) without additional processing. However, ONT has historically had higher error rates (~5–15%) compared to Illumina’s ultra-high accuracy (~99.9%), though improvements in chemistry and basecalling algorithms have narrowed this gap. Additionally, ONT’s real-time data streaming allows for adaptive sequencing, where reads of interest can be selectively targeted during a run.

![Overview of Nanopore sequencing showing the highly-portable MinION device. The device contains thousands of nanopores embedded in a membrane where current is applied. As individual DNA molecules pass through these nanopores they cause changes in this current, which is detected by sensors and read by a dedicated computer program. Each DNA base causes different changes in the current, allowing the software to convert this signal into base calls.](https://media.springernature.com/full/springer-static/image/art%3A10.1038%2Fs41587-021-01108-x/MediaObjects/41587_2021_1108_Fig1_HTML.png?as=webp)

Long-read sequencing excels in applications where resolving complex genomic regions is essential, such as de novo genome assembly, structural variant detection, and resolving repetitive or highly homologous sequences (e.g., telomeres, centromeres, and transposable elements). It is also invaluable for full-length transcriptome sequencing (isoform detection) and metagenomic analyses, where short reads often fail to distinguish closely related species or genes. While Illumina remains the gold standard for high-accuracy, high-throughput applications (e.g., SNP calling, targeted sequencing, and large-scale population studies), ONT’s long reads provide a unique advantage in clinical diagnostics (e.g., identifying large pathogenic deletions or fusion genes) and field-based sequencing (e.g., outbreak surveillance in remote areas). The choice between ONT and Illumina ultimately depends on the trade-offs between read length, accuracy, cost, and the specific biological question at hand.

### Alternative pipelines for ONT data

There are alternative pipelines for analysing ONT data which are designed to handle the unique characteristics of ONT data, including its long reads and higher error rates. These include the following options that can be used instead of the pipelines we have used in this course:

- [`bacQC-ONT`](https://github.com/avantonder/bacQC-ONT): This pipeline is designed for quality control and taxonomic classification of ONT reads. Many of the tools are the same as those used in the `bacQC` pipeline, but it uses the ONT-specific QC tools `nanoplot` and `pycoQC`. 
- [`assembleBAC-ONT`](https://github.com/avantonder/assembleBAC-ONT): This pipeline is designed for *de novo* assembly and annotation of bacterial genomes from ONT reads. 
- [`wf-bacterial-genomes`](https://github.com/epi2me-labs/wf-bacterial-genomes): This pipeline is for mapping and small variant calling of haploid samples. It can be used instead of `bactmap` for ONT data.


## Summary

::: {.callout-tip}
#### Key Points

- Oxford Nanopore Technologies (ONT) offers long-read sequencing capabilities, which are particularly useful for applications requiring resolution of complex genomic regions, such as de novo genome assembly and structural variant detection.
- ONT's sequencing technology is based on nanopore sensing, enabling real-time, ultra-long reads, which contrasts with Illumina's short-read sequencing.
- ONT has advantages such as portability, lower costs, and the ability to directly detect base modifications, but it has historically had higher error rates compared to Illumina.
- There are alternative pipelines for ONT data, such as `bacQC-ONT`, `assembleBAC-ONT`, and `wf-bacterial-genomes`, which are designed to handle the unique characteristics of ONT data.

:::

