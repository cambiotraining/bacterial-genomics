---
title: "Run bactmap"
---

::: {.callout-tip}
## Learning Objectives

- Generate consensus genomes for pneumococcus using reference-based aligment. 

:::

:::{.callout-important}
#### Remember to QC your sequencing reads

Remember, the first step of any analysis of a new sequence dataset is to perform Quality Control. For the purposes of time, we've run `bacQC` for you and the results are in `preprocessed/bacqc`.  Before you run `bactmap`, have a look at the read stats and species composition TSV files and make sure that the data looks good before we go ahead and map it. 
:::


:::{.callout-exercise}

#### Running nf-core/bactmap

Your next task is to run the **bactmap** pipeline on the _S. pneumoniae_ data.  In the folder `scripts` (within the `S_pneumoniae` analysis directory) you will find a script named `01-run_bactmap.sh`. This script contains the code to run bactmap. 

- First, create a `samplesheet.csv` file for `bactmap`. Refer back to [The bacQC pipeline](09-bacqc.md#prepare-a-samplesheet) page for how to do this, if you've forgotten.

- Edit the `01-run_bactmap.sh` script, adjusting it to fit your input files and the name and location of the reference you're going to map to (Hint: the reference sequence is located in `resources/reference`).

- Activate the `nextflow` software environment. 

- Run the script using `bash scripts/01-run_bactmap.sh`.
  
- Have a look at the MultiQC report. Do any of the samples look to be poor quality?

:::{.callout-answer}

First, we created our samplesheet using the helper python script, as explained for the bacQC pipeline: 

```bash
python scripts/fastq_dir_to_samplesheet.py data/reads \
    samplesheet.csv \
    -r1 _1.fastq.gz \
    -r2 _2.fastq.gz
```

Next, we fixed the script:

```bash
#!/bin/bash

nextflow run nf-core/bactmap \
  -r "{{< var version.bactmap >}}" \
  -profile singularity \
  --input samplesheet.csv \
  --outdir results/bactmap \
  --reference resources/reference/GCF_000299015.1_ASM29901v1_genomic.fna \
  --genome_size 2.0M
```

Then, we activated the `nextflow` environment:

```bash
mamba activate nextflow
```

Finally, we ran the script as instructed using:

```bash
bash scripts/01-run_bactmap.sh
```

While it was running it printed a message on the screen: 

```bash
N E X T F L O W  ~  version 23.04.1
Launching `https://github.com/nf-core/bactmap` [cranky_swartz] DSL2 - revision: e83f8c5f0e [master]


------------------------------------------------------
                                        ,--./,-.
        ___     __   __   __   ___     /,-._.--~'
  |\ | |__  __ /  ` /  \ |__) |__         }  {
  | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                        `._,._,'
  nf-core/bactmap v1.0.0
------------------------------------------------------
```

The results for all the samples looked really good so we can keep all of them for the next steps of our analyses.

:::
:::

:::{.callout-exercise}
#### How much of the reference was mapped?

- Activate the `seqtk` software environment.
- Run the `02-pseudogenome_check.sh` script we've provided in the `scripts` folder, which calculates how much missing data there is for each sample using `seqtk comp`. 
- Once the analysis finishes, open the `mapping_summary.tsv` file in _Excel_ from your file browser <i class="fa-solid fa-folder"></i>.
- Sort the results by the `%ref mapped` column and identify the sample which has the lowest percentage of the reference mapped.

:::{.callout-answer}
- We activated the software environment: `mamba activate seqtk`
- We then ran the script using `bash scripts/02-pseudogenome_check.sh`. The script prints a message while it's running:

    ```bash
    Processing ERX1265396_ERR1192012.fas
    Processing ERX1265488_ERR1192104.fas
    Processing ERX1501202_ERR1430824.fas
    ...
    ```

We opened the `mapping_summary.tsv` file in _Excel_ and sorted the `%ref mapped` in ascending order to identify which sample had the lowest percentage of the reference mapped. 

```
sample	ref_length	#A	#C	#G	#T	mapped	%ref mapped
ERX1501218_ERR1430840	2064154	593340	394510	390906	593159	1971915	95.53138962
ERX1501224_ERR1430846	2064154	593599	394628	391029	593404	1972660	95.56748188
ERX1501259_ERR1430881	2064154	593659	394622	391027	593434	1972742	95.57145446
ERX1501253_ERR1430875	2064154	593621	394666	391085	593416	1972788	95.57368297
ERX1501207_ERR1430829	2064154	593665	394643	391028	593476	1972812	95.57484568
```

We can see that `ERX1501218_ERR1430840` mapped to 95.5% of the reference which is well above 90% so the mapping worked really well for this set of samples.

:::
:::

## Summary

::: {.callout-tip}
## Key Points

- Obtaining genomes for a species such as pneumococcus can be done using reference-based alignment. 
- We can use the same workflows and scripts covered so far: 
  - `avantonder/bacQC` to perform sequence quality control on the raw sequencing reads. 
  - `nf-core/bactmap` for generating consensus genome sequences based on mapping reads to a reference genome. 
  - Use a custom script to loop through our samples and run `seqtk comp`, which estimates the fraction of missing data in our genomes.

:::