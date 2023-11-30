---
title: "funcscan versus Pathogenwatch"
---

::: {.callout-tip}
## Learning Objectives

- Apply both command line and web applications to find potential AMR genes in a set of genomes.
:::

## AMR with `Pathogenwatch`

`Pathogenwatch` also performs AMR prediction using its own [algorithm and curated gene sequences](https://cgps.gitbook.io/pathogenwatch/technical-descriptions/antimicrobial-resistance-prediction/pw-amr). 
The results from this analysis can be seen from the individual sample report, or summarised in the collection view.


## Which AMR do my isolates have?

At this stage you may notice that different tools will give you a different answer to this question and it is therefore recommended to **compare the results across multiple tools**.
For example, _Pathogenwatch_ generally detects AMR for comparatively more antimicrobial drugs compared to the `funcscan` analysis. 
However, some of the drugs detected by `funcscan` were either not reported by _Pathogenwatch_ (possibly because they are not part of its database) or have a disagreeing result. 

Let's take a specific example. 
_Pathogenwatch_ determined that none of our isolates were resistant to Streptomycin. 
However, in the _hAMRonization_ summary table (output by `funcscan`) we can see that this drug was reported for several of our samples. 
Upon closer inspection, however, we can see that we only had partial matches to the reference NCBI sequence ([WP_001206356.1](https://www.ncbi.nlm.nih.gov/protein/WP_001206356.1)), or in the case of one sample with a higher match the sequence identity was less than 100% (table below, showing some of the columns from the _hAMRonization_ table).

```
input_file_name               gene_symbol   reference_accession   antimicrobial_agent   coverage_percentage   sequence_identity  
isolate01.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate02.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate02.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate04.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate05.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate06.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate07.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate08.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate09.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          68.44                 100                
isolate10.tsv.amrfinderplus   aadA2         WP_001206356.1        STREPTOMYCIN          100                   92.05              
```

It is also important to take into consideration our earlier [assembly quality assessments](../02-assembly/04-assembly_quality.md) as they may result in **false negative results**.
For example, we can see that "isolate05" has the lowest AMR detection of all samples. 
However, this was the sample with the lowest genome coverage (only 21x) and with a resulting highly fragmented genome (229 fragments). 
Therefore, it is very possible that we missed parts of its genome during assembly, and that some of those contained AMR genes or plasmids. 

In conclusion, always be critical of the analysis of your results at this stage, comparing the output from different tools as well as considering the quality of your assemblies. 
Ultimately, the safest way to assess AMR is with **experimental validation**, by testing those strains against the relevant antimicrobial agents in the lab. 
However, computational analysis such as what we did can help inform these experiments and treatment decisions.


## Exercises

<i class="fa-solid fa-triangle-exclamation" style="color: #1e3050;"></i> 
For these exercises, you can either use the dataset we provide in [**Data & Setup**](../../setup.md), or your own data. 
You also need to have completed the genome assembly exercise in @sec-ex-assembly.



:::{.callout-exercise}
#### AMR with _Pathogenwatch_

Following from the _Pathogenwatch_ exercise in @sec-ex-pathogenwatch, open the "Ambroise 2023" collection that you created and answer the following questions:

- Open the antibiotics summary table.
- Do all your samples have evidence for antibiotic resistance?
- If any samples have resistance to much fewer antibiotics compared to the others, do you think this could be related to assembly quality?
- How do the results from _Pathogenwatch_ compare to those from `nf-core/funcscan`?

How do the results compare with Pathogenwatch?

:::{.callout-answer}

We can open the "Antibiotics" table from the top-left dropdown menu, as shown in the image below. 

![](images/pathogenwatch-ambroise04.png)

We can see that _Pathogenwatch_ identified resistance to several antibiotics. 
All samples are similar, except "1432" doesn't have resistance to furazolidone and nitrofurantoin. 
This sample had high completeness, according to _CheckM2_. 
However, it was also the sample with the lowest sequencing coverage (from our analysis during the genome assembly in @sec-ex-assembly), so this could be a "false negative" result due to the inability to cover some of the genes that confer AMR.

All of the drugs identified by _funcscan_ were also identified by _Pathogenwatch_ (note that sulfamethoxazole and sulfisoxazole identified by _Pathogenwatch_ are both sulfonamide-derived drugs, reported by funcscan). 
However, _Pathogenwatch_ identified resistance to several other drugs: ampicilin, ceftazidime, cephalosporins, ceftriazone, cefepime, furazolidone and nitrofurantoin. 
:::
:::

## Summary

::: {.callout-tip}
## Key Points

:::