---
title: "Working with Bacterial Genomes"
author: "Andries van Tonder; Hugo Tavares; Bajuna Salehe"
date: today
number-sections: false
---

## Overview 

This comprehensive course equips you with essential skills and knowledge in bacterial genomics analysis, primarily using Illumina-sequenced samples. You'll gain an understanding of how to select the most appropriate analysis workflow, tailored to the genome diversity of a given bacterial species. Through hands-on training, you'll apply both _de novo_ assembly and reference-based mapping approaches to obtain bacterial genomes for your isolates. You will apply standardised workflows for genome assembly and annotation, including quality assessment criteria to ensure the reliability of your results. Furthermore, you'll learn how to construct phylogenetic trees using whole genome and core genome alignments, enabling you to explore the evolutionary relationships among bacterial isolates. Lastly, you'll apply methods to detect antimicrobial resistance genes. As examples we will use _Mycobacterium tuberculosis_, _Staphylococcus aureus_ and _Streptococcus pneumoniae_, allowing you to become well-equipped to conduct bacterial genomics analyses on a range of species. 

::: {.callout-tip}
### Learning Objectives

By the end of this course, you will be able to:

- Choose the most suitable analysis workflow based on the genome diversity of a given bacterial species.
- Differentiate between "_de novo_ assembly" and "reference-based mapping" approaches for reconstructing bacterial genomes.
- Apply standardised workflows to assemble and annotate genomes using both approaches.
- Evaluate the quality of assembled genomes and determine their suitability for downstream analysis.
- Detect and remove recombinant regions.
- Construct phylogenetic trees using both whole genome and core genome alignments.
- Detect the presence of antimicrobial resistance genes in your isolates.
:::


### Target Audience

The course is aimed at biologists interested in microbiology, prokaryotic genomics and antimicrobial resistance.


### Prerequisites

#### Essential

- Basic understanding of high-throughput sequencing technologies.
  - Watch this iBiology video for an excellent overview.
- A working knowledge of the UNIX command line (course registration page).
  - If you are not able to attend this prerequisite course, please work through our Unix command line materials ahead of the course (up to section 7).
- A working knowledge of R (course registration page).
  - If you are not able to attend this prerequisite course, please work through our R materials ahead of the course.

#### Desirable

- A basic knowledge of phylogenetics inference methods (course registration page).
- A working knowledge of running analysis on High Performance Computing (HPC) clusters (course registration page).


## Authors
<!-- 
The listing below shows an example of how you can give more details about yourself.
These examples include icons with links to GitHub and Orcid. 
-->

About the authors:

- **Andries van Tonder**
  <a href="https://orcid.org/0000-0002-4380-5250" target="_blank"><i class="fa-brands fa-orcid" style="color:#a6ce39"></i></a> 
  <a href="https://github.com/avantonder" target="_blank"><i class="fa-brands fa-github" style="color:#4078c0"></i></a>  
  _Affiliation_: Department of Veterinary Medicine, University of Cambridge  
  _Roles_: writing - original draft; conceptualisation; coding
- **Hugo Tavares**
  <a href="https://orcid.org/0000-0001-9373-2726" target="_blank"><i class="fa-brands fa-orcid" style="color:#a6ce39"></i></a> 
  <a href="https://github.com/tavareshugo" target="_blank"><i class="fa-brands fa-github" style="color:#4078c0"></i></a>  
  _Affiliation_: Bioinformatics Training Facility, University of Cambridge  
  _Roles_: writing - review & editing
- **Bajuna Salehe**
  <a href="https://github.com/bsalehe" target="_blank"><i class="fa-brands fa-github" style="color:#4078c0"></i></a>  
  _Affiliation_: Bioinformatics Training Facility, University of Cambridge  
  _Roles_: writing - original content; conceptualisation; coding; data curation


## Citation

<!-- We can do this at the end -->

Please cite these materials if:

- You adapted or used any of them in your own teaching.
- These materials were useful for your research work. For example, you can cite us in the methods section of your paper: "We carried our analyses based on the recommendations in _TODO_.".

You can cite these materials as:

> TODO

Or in BibTeX format:

```
@Misc{,
  author = {},
  title = {},
  month = {},
  year = {},
  url = {},
  doi = {}
}
```


## Acknowledgements

<!-- if there are no acknowledgements we can delete this section -->

- List any other sources of materials that were used.
- Or other people that may have advised during the material development (but are not authors).
