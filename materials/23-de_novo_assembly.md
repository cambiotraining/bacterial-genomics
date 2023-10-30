---
title: "de novo Assembly"
---

::: {.callout-tip}
## Learning Objectives

- Understand what *de novo* genome assembly is and how it differs from reference-based assembly.
- Assemble sequence data with `assembleBAC`

:::

## Introduction

There are two approaches for genome assembly: reference-based (or comparative)  or *de novo*.  In a reference-based assembly, we use a reference genome as a guide to map our sequence data to and thus reassemble our sequence this way (this is what we did in the previous module).  Alternatively, we can create a 'new' (*de novo*) assembly that does not rely on a map or reference and more closely reflects the actual genome structure of the isolate that was sequenced.

![Genome assembly](../fig/genome-assembly.jpeg)

## Genome assemblers

Several tools are available for *de novo* genome assembly depending on whether you're trying to assemble short-read sequence data, long reads or else a combination of both.  Two of the most commonly used assemblers for short-read Illumina data are `Velvet` and `SPAdes`.  SPAdes has become the *de facto* standard de novo genome assembler for Illumina whole genome sequencing data of bacteria and is a major improvement over previous assemblers like Velvet. However, some of its components can be slow and it traditionally did not handle overlapping paired-end reads well.  `Shovill` is a pipeline which uses `SPAdes` at its core, but alters the steps before and after the primary assembly step to get similar results in less time. Shovill also supports other assemblers like `SKESA`, `Velvet` and `Megahit`.

## Summary

::: {.callout-tip}
## Key Points

:::