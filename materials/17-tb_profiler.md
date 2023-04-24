---
title: "TB-profiler"
---

::: {.callout-tip}
#### Learning Objectives

- Understand what TB-profiler does

:::

[tb-profiler](https://github.com/jodyphelan/TBProfiler) is a tool used to detect resistance and lineages of *M. tuberculosis* genomes.

It is made up of a pipeline which by default uses trimmomatic to trim reads, aligns the reads to the H37Rv reference using bowtie2, BWA or minimap2 and then calls variants using bcftools. These variants are then compared to a drug-resistance database. The tool also predicts the number of reads supporting drug resistance variants as an insight into hetero-resistance (not applicable for minION data).

![TB-profiler pipeline](../fig/tb-profiler_pipeline.png)

:::{.callout-important}
### Keeping up to date

Note that, like many other database-based tools TBProfiler is under constant rapid development. If you plan to use the program in your work please make sure you are using the most up to date version! 
Similarly, the database is not static and is continuously being improved so make sure you are using the most latest version. If you use TBProfiler in your work please state the version of both the tool and the database as they are developed independently from each other.
:::


There is an online version of the tool which is very useful for analysing few genomes. You can try it out later at your free time by following this [link](https://tbdr.lshtm.ac.uk/). 

![tb-profiler online tool](../fig/tb-profiler_online.png)