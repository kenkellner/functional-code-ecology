---
title: "How functional and reproducible is code shared by ecology papers? (Pregistration)"
author: |
  | Kenneth F. Kellner and Jerrold L. Belant
  | Michigan State University
date: \today
bibliography: references.bib
csl: plos.csl
css: pandoc.css
header-includes:
    - \usepackage{setspace}\singlespacing
    - \usepackage[left]{lineno}
    - \linenumbers
    - \usepackage[margin=1in]{geometry}
template: default.tex
---

# Introduction

Public archival of analysis code and associated data is increasingly required or encouraged by scientific journals upon paper acceptance.
Making both data and code available has numerous reported benefits, including increased transparency of methods, facilitation of future studies, and enabling complete reproduction of a paper's results [@Mislan_2016; @Culina_2020].
At present, however, there are few standards or checks on publicly available code (hereafter "code"), and in our experience it is rarely examined by reviewers.
This leads to three questions: (1) how common is code sharing in recent papers; (2) how functional is the code, and (3) how reproducible are analyses when both code and data area publicly available?

Researchers in several disciplines have recently attempted to answer one or both of these questions, including psychology [@Obels_2020; @Hardwicke_2021; @Laurinavichyute_2022], neuroscience [@Xiong_2022], pharmacology [@Kirouac_2019], physics [@Stodden_2018], geographic information systems [@Nust_2018], and ecology [@Archmiller_2020; @Culina_2020; @Poongavanan_2021].
Past studies found that the percentage of papers that share code is low on average (range 4-58%), but is increasing over time as more journals require it [@Culina_2020].
In contrast, the proportion of these papers for which available code and data can be said to run and replicate the analysis can be substantially lower, even with aid from the original authors [@Kirouac_2019; @Archmiller_2020; @Poongavanan_2021; @Seibold_2021; @Trisovic_2022; @Xiong_2022].
The value of sharing code is limited when running the code is not possible due to errors or when the code runs but does not reproduce the results in the paper.
Increasing our understanding of the magnitude of this problem and potential explanatory factors could promote reproducibility.

We plan a study to assess code sharing, code functionality, and reproducibility of results in the ecology literature. 
We will limit our study to include only papers estimating species abundance and distribution.
Estimating species abundance and distribution is a key goal of ecology, and a is research focus for the coauthors of this study, which should make running large numbers of analyses more tractable.
Our study will build on previous similar work in ecology (e.g. [@Archmiller_2020; @Poongavanan_2021]) by covering a wider range of journals and using a larger sample size.

## Objectives and hypotheses

Objective 1: Determine the proportion of papers for which it is possible to attempt to reproduce the results. That is, are both data and code for a given paper available?

* Papers in journals with data and code availability policies be **more likely** to have code and data available.
* Awareness of the importance of reproducibility has been increasing [@Hampton_2015; @Fidler_2017; @Powers2019]. Thus, year (2018-2022) will have a **positive effect** on availability of both data and code
* Papers in higher-impact journals (as measured by impact factor) will be **more likely** to have code and data available.

Objective 2: For papers with code and data available, are we able to successfully run the code?

In general we expect that greater code complexity will lead to more problems getting it to run. More specifically:

* We expect that the longer and more complex an analysis (as measured crudely in lines of code), the **less likely** we will be to run the code successfully. The more code you have, the more chances there are to introduce errors.
* Code that is adequately commented should be **more likely** to run successfully, since it may indicate that authors worked through the code carefully line by line and confirmed it did what it said it was doing.
* The more outside libraries the code depends on, the **less likely** the code will be to run.
* Code provided in a format designed for reproducibility, such as `Rmarkdown` [@Allaire_2022], will be **more likely** to run successfully than code in a text file (e.g., .R). Code in text files will be **more likely** to run than code shared in a PDF or Word document.

Objective 3: For papers with running code, do the outputs match the results reported in the paper?

We expect that greater complexity will generally result in lower reproducibility.
Thus, we have the same predictions for code reproducibility as we do for the probability the code runs.

# Methods

## Paper selection

We selected ten journals that publish studies employing hierarchical modeling to estimate species distribution and abundance.
This includes ecology and wildlife-specific journals, and so-called mega journals that publish a wide range of disciplines.
The final set of journals included 
Ecology, 
Journal of Ecology,
Ecology and Evolution,
Methods in Ecology and Evolution,
Biological Conservation,
Journal of Wildlife Management,
Ecosphere,
Scientific Reports,
PLoS ONE,
and Conservation Biology.

Using Web of Science ([https://webofknowledge.com](https://webofknowledge.com)), we will search each journal with the following search string: "occupancy OR n-mixture OR capture recapture OR 'distance sampling' OR 'removal sampling'", and constrain the results to years 2018-2022.
We will export all found records to spreadsheets.
For each journal, we will then randomly sort the results and review the abstracts and main text of each paper.
We will retain the first 50 entries for each journal that fit our inclusion criteria, which are: (1) research on plants or animals; (2) applies one of the hierarchical modeling approaches from our search criteria to estimate distribution or abundance for simulated or empirical data; (3) has an analysis conducted at least partially using R [@R_2022].
We expect that the vast majority of papers will use R, or R plus auxiliary software such as JAGS [@Plummer_2003].

As our study will focus on recent years (2018-2022) and on journals which now encourage or require sharing of data and code, we expect the proportion of studies in our study with both code and data available to be approximately 30% [@Archmiller_2020; @Culina_2020; @Obels_2020; @Hardwicke_2021; @Poongavanan_2021].
Thus we anticipate a sample size of at least 150 (50 * 10 * 0.3) studies which we can attempt to reproduce.
A power analysis indicated that a sample size of 150 studies with both code and data available should be adequate to detect a change in probability a paper's code runs of 0.2 (e.g. from 0.2 to 0.4) with power 0.8 (Figure 1).

![](power_analysis.png)

## Code and data availability

We will examine each selected paper, along with associated online materials, and collect several data points.
First, we will record basic information: the journal and year.
Second, we will determine if the authors have made the dataset, code, or both available online.
We will record where the data and analysis code were located (appendix, database, etc.)
We will not contact authors to obtain missing data or code, or for help with the analyses; our study is focused just on information that is already available publicly.
At this stage we will not assess whether data and/or code are complete, just that they are at least present.

## Running paper code

For each paper, we will download code and data that is directly cited or linked to by the paper and associated online supplements.
We will not contact the authors for missing data or try to identify other sources (e.g. unlinked Git repositories).
We will proceed through the papers in a random order, attempting to run the code under the following conditions:

* We will use the latest version of R packages unless a certain version is specified by the authors.
* Code that uses software that is no longer available (e.g. R packages removed from CRAN) will be marked as failing to run, unless the authors accounted for this somehow.
* Papers that use proprietary software will not be tested.
* We will not make any adjustments to code, even to fix minor issues, *except* to correctly specify file paths of downloaded data.
* We will ignore data and analyses not related to estimation of species distribution or abundance, or that do not use R.

For each paper we will record:

* Information about the code, such as the number of lines, the number of R packages used, the file format, and if it includes comments.
* If the code runs as written.
* The reasons the code failed to run, if applicable, to the best of our knowledge.

We expect some analyses will take a very long time to run on an average laptop computer, for example simulation studies or Bayesian models with many slow MCMC iterations.
In these cases, we will attempt to run an abbreviated version if possible (e.g., fewer simulations) to confirm the code runs and produces output.
Since the results from such an abbreviated analysis would not be a fair assessment of reproducibility, these studies will be excluded from further analysis.
This may introduce some bias against Bayesian analyses or big simulation studies.

## Reproducibility

If we are able to run the code, we will record if the results we obtain match the results reported in the paper, within reasonable rounding error.
Note that we do not plan to try to determine if the code is implemented *correctly*, just if it runs and produces the results seen in the paper.

# Analysis

We will report summary statistics, including overall proportion of papers that have code and data available, proportion of papers with running code, and proportion of papers with reproducible analyses.
We will also report a breakdown by year, the frequency of different software packages used, etc.

## Objective 1

The response variable will be binary: 1 if a paper had both code and data available, and 0 if it did not.
We will model the proportion of papers with both code and data available using a generalized linear mixed model (GLMM) with a logit link function.
We will fit a single model with covariates for year, journal impact factor, and code and data availability policy of the journal, corresponding to our hypotheses.

## Objective 2

The response variable will be binary: 1 if the code from a paper runs, 0 if not.
We will fit a GLMM with a logit link to this response variable.
Covariates will include total lines of code, number of libraries used, code format (PDF/Word, text file, or Rmarkdown and similar), and whether the code is adequately commented (yes/no), corresponding to our hypotheses.

## Objective 3

The response variable will be binary: 1 if the code reproduces the results of the paper, 0 if not.
We will fit a GLMM with a logit link, and the same covariates as in objective 2.

## All objectives

All models will include random intercepts by journal.
All continuous covariates will be standardized to have a mean of 0 and a standard deviation of 1 prior to analysis.
We will test for correlation between covariates before running models and if two covariates have a correlation coefficient > |0.7|, we will retain only one in the model.
We plan to conduct all analyses using the `glmmPQL` function in the `MASS` package.
We will assess model diagnostics and goodness-of-fit using the `DHARMa` package [@Hartig_2022].
We will assess support for our hypotheses based on effect sizes (i.e., estimated slopes) and associated 95% confidence intervals.

# References
