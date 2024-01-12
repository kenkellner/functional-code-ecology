# 2. Record Paper Inclusion Data

For each cleaned journal CSV in step 1, skim each paper and add the following information in the relevant columns:

1. Does the paper study plants or animals (`PlantsOrAnimals`)
2. Does the paper implement some kind of hierarchical model for species distribution or abundance (`HierarchModel`)
3. Does the paper use R (`UsesR`)

If all three of these are true (value `1`) for a paper, then mark the paper to be included in the study (`UsePaper` set to 1).
