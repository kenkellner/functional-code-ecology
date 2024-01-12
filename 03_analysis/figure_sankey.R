library(sankey)

incl <- read.csv("included_papers_final.csv")
repr <- read.csv("reproducible_papers_final.csv")

all_papers <- nrow(incl)

code_and_data <- sum(incl$All_Data & incl$All_Code)
incomplete <- all_papers - code_and_data

split1 <- data.frame(start_node = c("All papers", "All papers"),
                     end_node = c("Both\ncode/data", "Incomplete\ncode/data"),
                     weight = c(code_and_data, incomplete), 
                     colorstyle="col", col=c("forestgreen", "goldenrod"))

code_runs <- sum(repr$All_Code_Runs, na.rm=TRUE)
other_issues <- sum(is.na(repr$All_Code_Runs))
doesnt_run <- code_and_data - other_issues - code_runs

split2 <- data.frame(start_node = rep("Both\ncode/data", 3),
                     end_node = c("Code\nruns", "Doesn't\nrun", "Other\nissues"),
                     weight = c(code_runs, doesnt_run, other_issues),
                     colorstyle = "col", col=c("forestgreen","goldenrod","gray"))


data_sub_coderuns <- repr[repr$All_Code_Runs==1 & !is.na(repr$All_Code_Runs),]

too_long <- sum(data_sub_coderuns$Runtime_Too_Long)
reproduces <- sum(!is.na(data_sub_coderuns$Outputs_Match) & data_sub_coderuns$Outputs_Match==1)
doesnt_reproduce <- code_runs - too_long - reproduces

split3 <- data.frame(start_node = rep("Code\nruns", 3),
                     end_node = c("Reproduces", "Doesn't\nreproduce", "Took\ntoo long"),
                     weight = c(reproduces, doesnt_reproduce, too_long),
                     colorstyle = "col", col=c("forestgreen","goldenrod","gray"))

data_sub_norun <- repr[repr$All_Code_Runs==0 & !is.na(repr$All_Code_Runs),]

dep_pkg <- sum(data_sub_norun$Depr_Packages == 1)
miss_file <- sum(data_sub_norun$Miss_File == 1 & data_sub_norun$Depr_Packages == 0)
miss_obj <- sum(data_sub_norun$Miss_Object == 1 & data_sub_norun$Depr_Packages == 0)
other_error <- doesnt_run - dep_pkg - miss_file - miss_obj

split4 <- data.frame(start_node = rep("Doesn't\nrun", 4),
                     end_node = c("Deprecated\npackage", "File\nissue",
                                  "Missing\nR object", "Other\nerror"),
                     weight= c(dep_pkg, miss_file, miss_obj, other_error),
                     colorstyle = "col", col="goldenrod")

all_splits <- rbind(split1, split2, split3, split4)

nodes <- data.frame(id = c("All papers", "Both\ncode/data", 
                           "Incomplete\ncode/data", "Code\nruns", "Doesn't\nrun",
                           "Other\nissues", "Reproduces","Doesn't\nreproduce",
                           "Took\ntoo long", "Deprecated\npackage", "File\nissue",
                           "Missing\nR object", "Other\nerror"),
                    col = c("forestgreen", "forestgreen", "goldenrod", 
                            "forestgreen", "goldenrod", "gray",
                            "forestgreen","goldenrod", "gray",
                            "goldenrod","goldenrod","goldenrod","goldenrod"),
                    cex=1.2, adjy=0.9)


plot_input <- make_sankey(nodes = nodes, edges = all_splits)

tiff("sankey.tiff", height=7, width=7, units='in', res=300, compression='lzw')
sankey(plot_input)
dev.off()
