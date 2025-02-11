---
title: Course Software
number-sections: false
---

This page lists the tools used during this course (listed alphabetically). The heading of each file links to a page with more details about each tool. 

### [`Bakta`](https://github.com/oschwengers/bakta) 

`Bakta` is a software tool designed for the rapid and accurate annotation of bacterial genomes. It automates the process of identifying and categorizing genes and other functional elements within bacterial DNA sequences. otation

### [`BCFtools`](http://samtools.github.io/bcftools/bcftools.html)

`BCFtools` is a set of utilities that manipulate variant calls in the Variant Call Format (VCF) and its binary counterpart, BCF. It is widely used for filtering, querying, merging, and annotating genomic variants, making it an essential tool in bioinformatics pipelines for genomic data analysis.

### [`Bracken`](https://ccb.jhu.edu/software/bracken/)

`Bracken` (Bayesian Reestimation of Abundance with KrakEN) is a bioinformatics tool designed to improve the accuracy of species abundance estimation in metagenomic samples. It refines the results from Kraken by using Bayesian statistics to re-estimate the abundance of species, providing more precise and reliable microbial community profiles.

### [`BWA`](https://github.com/lh3/bwa)

`BWA` (Burrows-Wheeler Aligner) is a fast and efficient software tool for aligning short DNA sequences to a reference genome. It supports various alignment algorithms, including BWA-MEM for high-quality alignments of sequences ranging from a few base pairs to hundreds of kilobases, making it a widely used tool in next-generation sequencing analysis.

### [`CheckM2`](https://github.com/chklovski/CheckM2) 

`CheckM2` is an advanced bioinformatics tool used for assessing the quality and completeness of microbial genomes and metagenome-assembled genomes (MAGs). It provides accurate estimates of genome completeness and contamination by leveraging a curated set of marker genes, which helps ensure the reliability of genomic data for downstream analyses.

### [`fastp`](https://github.com/OpenGene/fastp)

`fastp` is a versatile and high-performance tool designed for preprocessing high-throughput sequencing data. It performs quality control, filtering, trimming, and adapter removal with a focus on speed and accuracy, making it an essential component of modern genomic data analysis pipelines.

### [`fastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

`FastQC` is a widely used bioinformatics tool that provides a comprehensive overview of the quality of high-throughput sequencing data. It generates detailed reports on various quality metrics, such as per-base sequence quality, GC content, and sequence duplication levels, helping researchers identify and address potential issues in their sequencing datasets.

### [`fastq-scan`](https://github.com/rpetit3/fastq-scan)

`fastq-scan` is a lightweight and efficient tool designed to quickly summarize basic quality metrics from FASTQ files. It provides essential statistics, such as read length distribution and GC content, without the computational overhead of more comprehensive tools, making it ideal for initial quality assessments of sequencing data.

### [`Gubbins`](https://sanger-pathogens.github.io/gubbins/)

`Gubbins` (Genealogies Unbiased By recomBinations In Nucleotide Sequences) is a bioinformatics tool used to detect and account for recombination in bacterial whole-genome sequence data. By identifying recombinant regions and reconstructing the underlying phylogeny, Gubbins helps ensure accurate evolutionary analyses and inferences.

### [`IQ-TREE`](http://www.iqtree.org/)

`IQ-TREE` is a fast and efficient software tool for constructing phylogenetic trees based on maximum likelihood estimation. It supports a wide range of evolutionary models and provides advanced features such as ultrafast bootstrap approximation and model selection, making it a popular choice for high-quality phylogenetic analysis.

### [`Kraken 2`](https://ccb.jhu.edu/software/kraken2/)

`Kraken 2` is a powerful bioinformatics tool used for taxonomic classification of sequencing reads from metagenomic or genomic datasets. It rapidly assigns taxonomic labels to reads based on k-mer matches to a user-defined reference database, facilitating the characterization of microbial communities and the detection of pathogens in complex samples.

### [`Krona`](https://github.com/marbl/Krona) 

`Krona` is a set of scripts to create Krona charts from several bioinformatics tools as well as from text and XML files.

### [`mash`](https://mash.readthedocs.io/en/latest/index.html) 

`mash` is a computational tool used for fast genome and metagenome distance estimation based on k-mer similarity. It enables rapid comparison of large genomic datasets by compressing sequences into sketch files, allowing efficient retrieval of pairwise distances between genomes or metagenomes.

### [`mlst`](https://github.com/tseemann/mlst) 

`mlst` facilitates the analysis of Multi-Locus Sequence Typing data by automating allele calling and sequence comparison across bacterial isolates. It generates profiles that define the sequence types (STs) of each isolate based on allele variations in designated loci, crucial for studying bacterial population dynamics and genetic diversity.

### [`MultiQC`](https://multiqc.info/)

`MultiQC` is a versatile tool used for aggregating and visualizing quality control metrics from multiple bioinformatics analyses in a single comprehensive report. It simplifies the assessment of data quality across diverse sequencing experiments and facilitates rapid identification of potential issues or trends in large datasets.

### [`Nextflow`](https://www.nextflow.io/)

`Nextflow` is a data-driven workflow management system designed for scalable and reproducible scientific workflows. It simplifies the deployment and execution of complex computational pipelines across different computing environments, enhancing collaboration and facilitating the integration of diverse bioinformatics tools and data sources.

### [pairsnp](https://github.com/gtonkinhill/pairsnp)

`pairsnp` is a bioinformatics tool used for comparing whole-genome sequences and identifying single nucleotide polymorphisms (SNPs) between pairs of genomes. It provides a rapid and efficient method for genome-wide SNP detection, aiding in the study of genetic variation and evolutionary relationships among bacterial or viral isolates.

### [`Panaroo`](https://gtonkinhill.github.io/panaroo/)

`Panaroo` is a bioinformatics tool used for pan-genome analysis, which identifies core and accessory genes across multiple genomes of related organisms. It efficiently clusters and annotates genes to reveal the genomic diversity within a species or strain collection, aiding in understanding evolutionary dynamics and functional differences among microbial populations.

### [`QUAST`](https://quast.sourceforge.net/)

`QUAST` (Quality Assessment Tool for Genome Assemblies) is a software tool used for evaluating the quality of genome assemblies. It provides comprehensive metrics and graphical reports to assess key aspects such as contiguity, accuracy, and completeness, aiding researchers in optimizing genome assembly strategies and comparing different assembly methods.

### [`Rasusa`](https://github.com/mbhall88/rasusa) 

`Rasusa` is a bioinformatics tool used for simulating sequencing reads from reference genomes with specified sequencing error profiles and sequencing depths. It enables researchers to evaluate and benchmark bioinformatics pipelines by generating synthetic datasets that mimic real-world sequencing data characteristics.

### [`remove_blocks_from_aln.py`](https://github.com/sanger-pathogens/remove_blocks_from_aln)

`remove_blocks_from_aln.py` is a Python script used for removing blocks of sequences from a multiple sequence alignment (MSA) based on specified criteria such as sequence identity or gap content. It facilitates the preprocessing of alignments to focus on conserved regions or to remove poorly aligned or ambiguous sequences, improving downstream phylogenetic or evolutionary analyses.

### [`SAMtools`](https://sourceforge.net/projects/samtools/files/samtools/)

`SAMtools` is a widely used software suite for manipulating sequencing alignment files in the SAM/BAM format. It provides essential functions such as file format conversion, sorting, indexing, and variant calling, making it indispensable in genomics research and variant analysis workflows. 

### [`seqtk`](https://github.com/lh3/seqtk)

`seqtk` is a versatile toolkit for processing sequences in FASTA and FASTQ formats. It includes tools for subsetting sequences, extracting specific regions, filtering by quality, and converting between different sequence formats, facilitating various bioinformatics analyses and preprocessing tasks.

### [`Shovill`](https://github.com/tseemann/shovill) 

`Shovill` is a bioinformatics tool designed for fast and accurate _de novo_ assembly of microbial genomes from Illumina sequencing data. It automates the assembly process, including read trimming, error correction, and scaffolding, providing comprehensive genome assemblies suitable for downstream genomic analysis and comparative genomics studies.

### [`SNP-sites`](https://github.com/sanger-pathogens/snp-sites)

`SNP-sites` is a software tool used for identifying and extracting variable sites (SNPs) from a multiple sequence alignment (MSA). It efficiently detects polymorphic positions across aligned sequences, essential for population genetics, phylogenetics, and evolutionary studies based on genomic data.

### [`TB-Profiler`](https://github.com/jodyphelan/TBProfiler)

`TB-Profiler` is a bioinformatics tool used for analyzing _Mycobacterium tuberculosis_ genomes to detect mutations associated with drug resistance and lineage classification. It provides a comprehensive analysis of resistance profiles and strain lineages based on genomic data, aiding in clinical diagnostics and epidemiological surveillance of tuberculosis.

### [`TreeTime`](https://treetime.readthedocs.io/en/latest/index.html)

`TreeTime` is a tool used for molecular clock phylogenetic analysis, which estimates the evolutionary timescale of genetic sequences by integrating sequence data with a phylogenetic tree. It performs ancestral reconstruction and divergence dating, providing insights into the timing of evolutionary events within microbial populations or viral lineages.