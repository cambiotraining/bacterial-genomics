---
title: "Introduction to Antimicrobial resistance"
---

::: {.callout-tip}
#### Learning Objectives

- Recognise the threats posed by antimicrobial resistance (AMR) to public health globally.
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

## Summary

::: {.callout-tip}
#### Key Points

- AMR poses significant global public health threats by diminishing the effectiveness of antibiotics, making it challenging to treat infectious diseases effectively.
- AMR software aims to identify specific genes or mutations known to confer resistance to antimicrobial agents. These tools compare input genetic sequences to known resistance genes or patterns in their associated databases.
- AMR prediction can result in false results (either false positives or false negatives). One way to overcome this limitation is to compare the results from multiple tools and, whenever possible, complement it with validation assays in the lab.
:::