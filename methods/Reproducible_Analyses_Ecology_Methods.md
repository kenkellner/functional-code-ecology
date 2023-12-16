---
title: "Reproducibility of hierarchical modeling analyses in ecology: pregistration"
author: Kenneth F. Kellner and Jerrold L. Belant
date: 16 December 2022
bibliography: references.bib
csl: plos.csl
css: pandoc.css
---

# Introduction

Public archival of analysis code, in addition to associated data, is increasingly required or encouraged by scientific journals upon paper acceptance.
Code sharing has numerous benefits, including increased transparency of methods, facilitation of future studies, and enabling complete reproduction of a paper's results [@Mislan_2016; @Culina_2020].
At present, however, there are few standards or checks on shared code, and in our experience it is rarely examined by reviewers.
This leads to two questions: how common is code sharing in recent papers, and how accurate, functional, and reproducible are public code archives when they do exist?

Researchers in several disciplines have recently attempted to answer one or both of these questions, including psychology [@Obels_2020; @Hardwicke_2021; @Laurinavichyute_2022], neuroscience [@Xiong_2022], pharmacology [@Kirouac_2019], physics [@Stodden_2018], geographic information systems [@Nust_2018], and ecology [@Archmiller_2020; @Culina_2020; @Poongavanan_2021].
In general, past studies found that the percentage of papers that share code are low on average (range 4-58%), but this number is increasing over time as more journals require it [@Culina_2020].
On the other hand, the proportion of these papers for which the shared code and data can be said to replicate the analysis can be significantly lower, even with aid from the original authors [@Kirouac_2019; @Archmiller_2020; @Poongavanan_2021; @Seibold_2021; @Trisovic_2022; @Xiong_2022].
The value of sharing code is questionable when running the code is not possible due to errors or when the code runs but does not reproduce the results in the paper.
Increasing our understanding of the scope of this problem, as well as potential explanatory factors, would promote reproducibility.

We plan a similar study of the ecology and wildlife conservation literature, specifically focusing on papers that estimate species distribution or abundance via hierarchical modeling (for an overview see @Kery_2016).
We chose to constrain our study in this way for two reasons: first, estimation of these parameters is a key goal of many ecological studies; and second, limiting the included papers to a common set of objectives and analyses should make the process of testing shared code more tractable and consistent.
Our study will build on previous similar work in ecology (e.g. [@Archmiller_2020; @Poongavanan_2021]) by covering a wider range of journals and with a larger sample size.

## Objectives and hypotheses

Objective 1: Determine the proportion of papers for which it is possible attempt to reproduce the results. That is, are both data and code for a given paper available?

* Journals are increasingly requiring authors to share data and code. Thus, year (2018-2022) will have a **positive effect** on availability of both data and code
* Articles in more selective/higher impact journals (as measured by impact factor) will be **more likely** to have code and data available.
* Open access papers should be **more likely** to have code and data available.
* Papers that use a Bayesian approach typically need to code custom models; there is a historical norm of sharing the model code in these cases. Thus we expect papers that use Bayesian modeling tools such as BUGS, Nimble, and Stan to be **more likely** to make both code and data available.

Objective 2: For papers with both code and data available, are we able to reproduce the results (yes/partially/no)?

* We expect that the longer and more complex an analysis (as measured crudely in lines of code), the **less likely** we will be to successfully reproduce it. The more code you have, the more chances there are to introduce errors.
* We predict that we will be **less likely** to reproduce results from code shared in the form of PDFs/Word documents than shared as appropriate text files (.R, etc.). Changing the format or copying and pasting code is likely to introduce errors. Articles that use a specific tool designed for reproducibility, such as {Rmarkdown} [@Allaire_2022], should be the most likely to be run successfully.
* Code that is adequately commented should be **more likely** to run successfully, since it may indicate that authors worked through the code carefully line by line and confirmed it did what it said it was doing.

# Methods

## Article selection

We selected ten journals which we know from experience publish studies employing hierarchical modeling to estimate distribution and abundance.
This included both ecology/wildlife-specific journals and so-called mega journals that publish across a wide range of disciplines.
The final set of journals included 
Ecology, 
Journal of Ecology,
Ecology and Evolution,
Methods in Ecology and Evolution,
Ecological Applications,
Journal of Wildlife Management,
Ecosphere,
Scientific Reports,
PLoS ONE,
and Conservation Biology.

Using Web of Science ([https://webofknowledge.com](https://webofknowledge.com)), we will search each journal with the following search string: "occupancy OR n-mixture OR capture recapture OR 'distance sampling' OR 'removal sampling'", and constrain the results to years 2018-2022.
We will export all found records to spreadsheets.
For each journal, we will then randomly sort the results and began reading the abstracts and skimming the text of each paper.
We will retain the first 50 entries for each journal that fit our detailed inclusion criteria.
Our inclusion criteria for an article are: (1) research on plants or animals; (2) applies one of the hierarchical modeling approaches from our search string to estimate distribution or abundance for either simulated or real data; (3) has an analysis conducted at least partially using R [@R_2022].
We expect that the vast majority of papers will use R, or R plus auxiliary software such as JAGS [@Plummer_2003].

A survey of the literature (across multiple disciplines) found a range of 4% - 58% of studies made both data and analysis code available [@Archmiller_2020; @Culina_2020; @Obels_2020; @Hardwicke_2021; @Poongavanan_2021].
As our study will focus on recent years (2018-2022) and on mainly journals which now strongly encourage or require sharing of data and code, we expect the proportion of studies in our study with both code and data available to fall at least in the middle of this range (~30%).
Thus we anticipate a sample size of at least 150 (50 * 10 * 0.3) studies which we can attempt to reproduce.
A power analysis indicated that a sample size of 150 studies with both code and data available should be adequate to detect a change in probability of reproducibility of 0.1 (e.g. from 0.2 to 0.3) with power 0.8 (Figure 1). However, we will aim for a sample size of 200.

![](power_analysis.png)

## Article assessment

We will examine each selected article, along with associated online materials, and collect several data points.
First, we will record basic information: the journal, year, and taxonomic group(s) studied.
Second, we will record information about the analysis; specifically, the model applied, and if available the software used.
Finally, we will determine if the authors have made the dataset, code, or both available online.
We do not plan to contact authors to obtain missing data or code, or to ask for help with the analyses; our study is focused just on information that is already available publicly.
At this stage we will not attempt to determine if the data and/or code are complete, just that they are at least present.

## Reproducing analyses

Code and data will be downloaded from all papers that made it available.
Only code and data which are directly cited or linked by the paper and associated online supplements will be used.
We will not reach out to the authors for missing data or try to identify other sources (e.g. unlinked Git repositories).
Papers with available code and data will be randomly ordered.
The primary author (KFK) will proceed through the papers in this order one by one, attempting to replicate each analysis, under the following conditions.
We will use the latest version of software packages unless a certain version is specified by the authors.
Papers that use proprietary software or software that is no longer available to download will not be tested.
We will not make any adjustments to code, even to fix minor issues, except to correctly specify file paths of downloaded data.

For each analysis we will record (1) information about the code, such as the file format and if it is well-commented; (2) if the code runs as written; (3) if the code appears to cover all, or only some, of the results presented in the paper; (4) if the numerical results we obtain match or partially match (within rounding error) the results reported in the paper; (5) if figure code is available and resulting figures are similar to the figures in the paper; and (6) if the general conclusions (significance, direction of effect, etc.) are similar between our results and the results reported in the paper.
Note that we do not plan to try to determine if the code is implemented *correctly*, just if it runs and produces the results seen in the paper.
In the final dataset we will share with the paper, we plan on anonymizing the author lists and titles of the papers.

## Excluding data and stopping rules

We expect some analyses will take a very long time to run on an average laptop computer, for example simulation studies or Bayesian models with many slow MCMC iterations.
In these cases, we will attempt to run an abbreviated version (e.g., fewer MCMC iterations) to confirm the code runs and produces output.
Since the results from such an abbreviated analysis would not be a fair assessment of reproducibility, these studies will be excluded from further analysis.
This may introduce some bias against Bayesian analyses or big simulation studies, but we simply don't have unlimited run time.

After reaching a maximum sample size of 200 analyses from papers with both code and data available, we will stop.
We may adjust this sample size if the process of running analyses takes more or less time than expected, but we will not examine the data in any way before making this determination.

If we are unable to find a minimum of 150 papers with both code and data available, we will randomly add additional papers from journals that had > 50 relevant papers available until we reach this threshold.

# Analysis

We will report summary statistics, including overall proportion of articles that have code and data available, and proportion of these with analyses that reproduce partially and fully.
We will also report a breakdown by year, the frequency of different software packages used, etc.

## Objective 1

The response variable will be binary: 1 if a paper had both code and data available, and 0 if it did not.
We will model the proportion of papers with both code and data available using a generalized linear mixed model (GLMM) with a logit link function.
We will fit a single model with covariates for year, journal impact factor, open access status, and if the paper uses a Bayesian framework, corresponding to our hypotheses.

## Objective 2

The response variable will also be binary: 1 if we determined a paper to be fully reproducible, 0 if not or only partially reproducible.
We will fit a similar GLMM with a logit link to this response variable.
Covariates will include total lines of code, code format (PDF/Word, text file, or Rmarkdown and similar), and whether the code is adequately commented (yes/no), again corresponding to our hypotheses.

## Both objectives

Both models will include random intercepts by journal, and we will conclude that a given covariate has a significant effect on the response if the 95% credible interval around the corresponding slope parameter does not contain 0.
All continuous covariates will be standardized to have a mean of 0 and a standard deviation of 1 prior to analysis.
We do not expect correlation in our covariates, but we will test for this before running models and if two covariates have a correlation coefficient > 0.7, we will retain only one in the model.
We plan to conduct all analyses in a Bayesian framework using the {rstanarm} R package [@Goodrich_2020].
Model fit will be assessed using posterior predictive checks, and model predictive accuracy using the receiver operating characteristic (ROC) curve.

# References
