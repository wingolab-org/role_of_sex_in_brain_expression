# Code sharing for Wingo et al., _The Role of Sex in Brain Protein Expression and Disease_

This repository contains scripts and commands used to perform most analyses for _The Role of Sex in Brain Protein Expression and Disease_.

The goal of the repository is to provide transparency for critical analysis details of the manuscript.
It is not the intention for the commands and scripts in the repository to be directly used to recapitulate the analyses of the manuscript since they were written for the specific computing infrastructure that existed at the time of the analysis.
Rather, the code, commands, and notes in this repository are intended to be a guide for the approaches to the analyses performed in the manuscript.

Yue Liu in the Wingo Lab wrote the notes, scripts, and comments in this repository and performed the majority of the analyses for the manuscript. Yue's records were collated with minimal editing to provide details of the analysis: [`sex_specific_brain_protein_expression_project_analysis_notes.txt`](sex_specific_brain_protein_expression_project_analysis_notes.txt).
The analysis used either a local environment or a high performance computing cluster with a job queue system.
Scripts are divided into either `cluster` or `local` directories depending on the context of the analysis.
Within the notes, scripts are prefixed with the appropriate directory (i.e., `cluster/` or `local/`) within this repository.
Scripts were tidied to improve readability using [perltidy](https://metacpan.org/pod/Code::TidyAll::Plugin::PerlTidy) and [tidyall](https://metacpan.org/pod/tidyall) for perl using settings in [`.perltidyrc`](.perltidyrc), [shfmt](https://github.com/mvdan/sh) for shell using default settings, and [vscode-R](https://github.com/REditorSupport/vscode-R) and [format-files](https://github.com/jbockle/format-files) for R using default settings.

The analysis shared in the manuscript and code both depend on external software that include:

- [Bystro b10](https://github.com/akotlar/bystro/blob/b10/INSTALL.md).
- [COLOC v5.0.0.9002](https://chr1swallace.github.io/coloc/)
- [DEeq2 version v.1.26.0](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)
- [EIGENSTRAT 6.1.4](https://github.com/DReichLab/EIG/tree/master/EIGENSTRAT)
- [FUSION](http://gusevlab.org/projects/fusion)
- [GO-Elite version 1.2.5](http://www.genmapp.org/go_elite/)
- [KING version 2.2.2](https://www.kingrelatedness.com/history.shtml).
- [MASHR v0.2.38](https://github.com/stephenslab/mashr)
- [Plink version v1.90 beta](https://www.cog-genomics.org/plink/1.9/).
- [Proteome Discoverer suite v2.4.1](https://www.thermofisher.com/order/catalog/product/OPTON-31099)
- [qvalue version 2.22.0](https://www.bioconductor.org/packages/release/bioc/html/qvalue.html)
- [R version 3.5.1](https://www.r-project.org/)
- [SEURAT version v3.1.2](https://github.com/satijalab/seurat/)
- [SMR software](https://cnsgenomics.com/software/smr)
- [STAR v2.4](https://github.com/alexdobin/STAR)
- [Surrogate variable analysis v3.20.0](https://www.rdocumentation.org/packages/sva/versions/3.20.0).
- [SusieR](https://stephenslab.github.io/susieR/index.html)
