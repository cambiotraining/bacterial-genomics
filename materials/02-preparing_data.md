---
title: "Preparing data"
---

::: {.callout-tip}
## Learning Objectives

- Recognise the importance of organising your files and folders when starting a bioinformatic analysis.
- Investigate the content of sequencing FASTQ files.
- Recognise the importance of metadata for data interpretation and discuss its relevance for pathogen surveillance.

:::

## Preparing Files

On our computers, for each of the three species we will be working with on the course, we have a directory in `~/Course_Materials` for each species where we will do all our analysis. We already included the following in each species directory: 
 
- `data/` - contains the sequencing files we will be working with.
- `preprocessed/` - contains the results for all the analysis we'll be running during the course (see box below). 
- `resources/` - where we include other files we will be using such as reference genomes.
- `databases/` - where we include public databases needed by some tools.
- `scripts/` - where we include some scripts that we will use during the course. You will have to edit some of these scripts as part of the exercises. 
- `sample_info.csv` - a table with some metadata for our samples.

:::{.callout-warning}

We have a lot to fit in this week, and during testing, we found that running all the pipelines and tools on even the genomes we selected from larger datasets was going to take too long. So, what we decided, was to only analyse five samples during the exercises you'll be doing this week.  This will allow you to set up and run the various scripts, see the pipelines and tools running and see the outputs in the time we've set aside for each section.  The outputs will always be sent to a `results` directory.  However, we've provided the results you would have obtained if you'd run the scripts on all of the data in a `preprocessed` directory.  For some of the exercises, you'll be making use of the outputs in this directory instead of what you create yourselves as this will hopefully give you a more realistic set of results like the ones you may eventually generate when working with larger datasets. We will make it clear in the course materials and exercises when you should be working with the results in the `preprocessed` directory instead of the `results` directory.
:::

### Data

Your analysis starts with FASTQ files (if you need a reminder of what a FASTQ file is, look at the [Intro to NGS > FASTQ](03-intro_ngs.html#FASTQ_Files) section of the materials). The Illumina files come as compressed FASTQ files (`.fastq.gz` format) and there's two files per sample, corresponding to read 1 and read 2. 
This is indicated by the file name suffix: 

- `*_1.fastq.gz` for read 1
- `*_2.fastq.gz` for read 2

You can look at the files you have available in any of the species directories from the command line using: 

```bash
ls data/reads
```

### Metadata

A critical step in any analysis is to make sure that our samples have all the relevant metadata associated with them. This is important to make sense of our results and produce informative reports at the end. There are many types of information that can be collected from each sample and for effective genomic surveillance, we need at the very minimum three pieces of information:

- **When**: date when the sample was collected (not when it was sequenced!).
- **Where**: the location where the sample was collected (not where it was sequenced!).
- **Source**: the source of the the sample e.g. host, environment.

Of course, this is the **minimum** metadata we need for a useful analysis. The more information you collect about each sample, the more questions you can ask from your data -- so always remember to record as much information as possible for each sample. 

:::{.callout-warning}
#### Dates in Spreadsheet Programs

Note that programs such as _Excel_ often convert date columns to their own format, and this can cause problems when analysing data later on. 
The ISO standard for dates is YYYY-MM-DD and this is how we recommend you store your dates. However, by default _Excel_ displays dates as DD/MM/YYYY.  
You can change how _Excel_ displays dates by highlighting the date column, right-clicking and selecting <kbd>Format cells</kbd>, then select "Date" and pick the format that matches YYYY-MM-DD. 
However, every time you open the CSV file, _Excel_ annoyingly converts it back to its default format!

To make sure no date information is lost due to _Excel_'s behaviour, it's a good idea to **store information about year, month and day in separate columns** (stored just as regular numbers).

:::

## Summary

::: {.callout-tip}
## Key Points

- Proper file and folder organization ensures clarity, reproducibility, and efficiency throughout your bioinformatic analysis.
- Organising files by project, and creating directories for data, scripts and results helps prevent data mix-ups and confusion.
- FASTQ files containing the raw sequencing data, can be quickly investigated using standard command line tools, for example to count how many reads are available.
- Metadata provides context to biological data, including sample information, experimental conditions, and data sources.
- In pathogen surveillance, metadata helps trace the origin and characteristics of samples, aiding outbreak investigation.
:::