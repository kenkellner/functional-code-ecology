library(sankey)

incl <- read.csv("included_papers_final.csv")
repr <- read.csv("reproducible_papers_final.csv")

all_papers <- nrow(incl)
all_papers_lab <- paste0("All papers\n(",all_papers,")")

code_and_data <- sum(incl$All_Data & incl$All_Code)
code_and_data_lab <- paste0("\nHas code/\ndata (", code_and_data, ")")
incomplete <- all_papers - code_and_data
inc_lab <- paste0("\nMissing\ncode/data\n(",incomplete,")")

split1 <- data.frame(start_node = rep(all_papers_lab, 2),
                     end_node = c(code_and_data_lab, inc_lab),
                     weight = c(code_and_data, incomplete), 
                     colorstyle="col", col=c("forestgreen", "goldenrod"))

code_runs <- sum(repr$All_Code_Runs, na.rm=TRUE)
code_runs_lab <- paste0("\nCode\nruns (",code_runs,")")
other_issues <- sum(is.na(repr$All_Code_Runs))
other_issues_lab <- paste0("\nOther\nissues (", other_issues, ")")
doesnt_run <- code_and_data - other_issues - code_runs
doesnt_run_lab <- paste0("\nCode\nerrors (",doesnt_run,")") 

split2 <- data.frame(start_node = rep(code_and_data_lab, 3),
                     end_node = c(code_runs_lab, doesnt_run_lab, other_issues_lab),
                     weight = c(code_runs, doesnt_run, other_issues),
                     colorstyle = "col", col=c("forestgreen","goldenrod","gray"))


data_sub_coderuns <- repr[repr$All_Code_Runs==1 & !is.na(repr$All_Code_Runs),]

too_long <- sum(data_sub_coderuns$Runtime_Too_Long)
too_long_lab <- paste0("Runtime\ntoo long\n(", too_long, ")")
reproduces <- sum(!is.na(data_sub_coderuns$Outputs_Match) & data_sub_coderuns$Outputs_Match==1)
repro_lab <- paste0("Reproduces\n(", reproduces, ")")
doesnt_reproduce <- code_runs - too_long - reproduces
doesnt_repro_lab <- paste0("Doesn't\nreproduce\n(", doesnt_reproduce, ")")

split3 <- data.frame(start_node = rep(code_runs_lab, 3),
                     end_node = c(repro_lab, doesnt_repro_lab, too_long_lab),
                     weight = c(reproduces, doesnt_reproduce, too_long),
                     colorstyle = "col", col=c("forestgreen","goldenrod","gray"))

data_sub_norun <- repr[repr$All_Code_Runs==0 & !is.na(repr$All_Code_Runs),]

dep_pkg <- sum(data_sub_norun$Depr_Packages == 1)
dep_pkg_lab <- paste0("Deprecated\npackage\n(", dep_pkg, ")")
miss_file <- sum(data_sub_norun$Miss_File == 1 & data_sub_norun$Depr_Packages == 0)
miss_file_lab <- paste0("File issue\n(", miss_file, ")")
miss_obj <- sum(data_sub_norun$Miss_Object == 1 & data_sub_norun$Depr_Packages == 0)
miss_obj_lab <- paste0("Missing R\nobject (", miss_obj, ")")
other_error <- doesnt_run - dep_pkg - miss_file - miss_obj
other_error_lab <- paste0("Other error\n(", other_error, ")")

split4 <- data.frame(start_node = rep(doesnt_run_lab, 4),
                     end_node = c(dep_pkg_lab, miss_file_lab,
                                  miss_obj_lab, other_error_lab),
                     weight= c(dep_pkg, miss_file, miss_obj, other_error),
                     colorstyle = "col", col="goldenrod")

all_splits <- rbind(split1, split2, split3, split4)

nodes <- data.frame(id = c(all_papers_lab, code_and_data_lab, 
                           inc_lab, code_runs_lab, doesnt_run_lab,
                           other_issues_lab, repro_lab, doesnt_repro_lab,
                           too_long_lab, dep_pkg_lab, miss_file_lab,
                           miss_obj_lab, other_error_lab),
                    col = c("forestgreen", "forestgreen", "goldenrod", 
                            "forestgreen", "goldenrod", "gray",
                            "forestgreen","goldenrod", "gray",
                            "goldenrod","goldenrod","goldenrod","goldenrod"),
                    cex=1.1, adjy=0.9)


plot_input <- make_sankey(nodes = nodes, edges = all_splits)

tiff("sankey.tiff", height=7, width=7, units='in', res=300, compression='lzw')
sankey(plot_input, mar = c(0, 3.2, 0, 4.2))
dev.off()
