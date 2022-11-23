Reproducible_Analyses_Ecology_Methods.pdf: Reproducible_Analyses_Ecology_Methods.Rmd plos.csl power_analysis.png
	Rscript -e 'rmarkdown::render("Reproducible_Analyses_Ecology_Methods.Rmd")'

power_analysis.png: power_analysis.R
	Rscript power_analysis.R

plos.csl:
	wget https://raw.githubusercontent.com/citation-style-language/styles/master/plos.csl -O plos.csl

clean:
	rm -f plos.csl *.log *.pdf
