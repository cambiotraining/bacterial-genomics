---
title: "Introduction to Antimicrobial resistance"
---

::: {.callout-tip}
#### Learning Objectives

- Recognise the threats posed by antimicrobial resistance (AMR) to public health globally.
- Apply both command line and web applications to find potential AMR genes in a set of genomes.
- Recognise the limitations of computational AMR prediction and the importance of comparing results across multiple tools.

:::

## Antimicrobial Resistance (AMR) analysis

Antimicrobial resistance (AMR) is a phenomenon where microorganisms, such as bacteria, evolve in a way that reduces the effectiveness of antimicrobial drugs, including antibiotics.
This occurs due to the overuse and misuse of these drugs, which exerts selective pressure on the microorganisms. 
As a result, bacteria may develop or acquire genetic changes that enable them to **survive exposure to antimicrobial agents**, making the drugs less effective or entirely ineffective. 
AMR poses a significant **global health threat**, as it can lead to infections that are challenging to treat, potentially causing increased morbidity and mortality. 
Efforts to combat AMR include responsible antibiotic use, developing new drugs, and enhancing infection prevention and control measures.

According to the [WHO](https://www.who.int/publications/i/item/9789241564748), antimicrobial resistance (AMR) has evolved into a global concern for public health. 
This stems from various harmful bacterial strains developing resistance to antimicrobial medications, including antibiotics. 
As part of our analysis, we will now focus on identifying AMR patterns connected to our _S. pneumoniae_ isolates.

Numerous software tools have been created to predict the presence of genes linked to AMR in genome sequences. 
Estimating the function of a gene or protein solely from its sequence is complex, leading to varying outcomes across different software tools. 
It is advisable to employ multiple tools and compare their findings, thus increasing our confidence in identifying which antimicrobial drugs might be more effective for treating patients infected with the strains we're studying.

In this section we will introduce a workflow aimed at combining the results from various AMR tools into a unified analysis.
We will compare its results with AMR analysis performed by _Pathogenwatch_.

## AMR with _Pathogenwatch_

_Pathogenwatch_ also performs AMR prediction using its own [algorithm and curated gene sequences](https://cgps.gitbook.io/pathogenwatch/technical-descriptions/antimicrobial-resistance-prediction/pw-amr). 
The results from this analysis can be seen from the individual sample report, or summarised in the collection view.

![AMR analysis from _Pathogenwatch_. The summary table (top) can be accessed from the sample collections view, by selecting "Antibiotics" from the drop-down on the top-left. The table summarises resistance to a range of antibiotics (red = resistant; yellow = intermediate). More detailed results can be viewed for each individual sample by clicking on its name and opening the sample report (bottom).](images/amr_pathogenwatch.png){#fig-amr_pathogenwatch}


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
#### Key Points

- AMR poses significant global public health threats by diminishing the effectiveness of antibiotics, making it challenging to treat infectious diseases effectively.
- AMR software aims to identify specific genes or mutations known to confer resistance to antimicrobial agents. These tools compare input genetic sequences to known resistance genes or patterns in their associated databases.
- The `nf-core/funcscan` workflow performs AMR analysis using several software tools and producing a summary of their results as a CSV file.
- _Pathogenwatch_ is a more user-friendly application, which performs AMR using its own curated database. 
- AMR prediction can result in false results (either false positives or false negatives). One way to overcome this limitation is to compare the results from multiple tools and, whenever possible, complement it with validation assays in the lab.
:::