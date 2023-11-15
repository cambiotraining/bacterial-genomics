---
title: "Run bactmap"
---

::: {.callout-tip}
## Learning Objectives

- Run bactmap on pneumo dataset.

:::

:::{.callout-warning}

**Remember to QC your data!**

Remember, the first step of any analysis of a new sequence dataset is to perform Quality Control. For the purposes of time, we've run bacQC for you and the results are in `results/bacqc`.  Before you run assembleBAC, have a look at the read stats and species composition TSV files and make sure that the data looks good before we go ahead and assemble it. 

:::

:::{.callout-exercise}

#### Running nf-core/bactmap

Your next task is to run the **bactmap** pipeline on your data.  In the folder `scripts` (within your analysis directory) you will find a script named `01-run_bactmap.sh`. This script contains the code to run bactmap. Edit this script, adjusting it to fit your input files and the name and location of the reference you're going to map to (Hint: the reference sequence is located in `resources/reference`).

Now, run the script using `bash scripts/01-run_bactmap.sh`.
  
If the script is running successfully it should start printing the progress of each job in the bactmap pipeline. The pipeline will take a while to run so we'll have a look at the results after lunch.

:::{.callout-answer}

We ran the script as instructed using:

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

:::
:::

## Summary

::: {.callout-tip}
## Key Points

:::