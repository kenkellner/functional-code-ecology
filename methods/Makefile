Reproducible_Analyses_Ecology_Methods.pdf: Reproducible_Analyses_Ecology_Methods.Rmd plos.csl
	Rscript -e 'rmarkdown::render("Reproducible_Analyses_Ecology_Methods.Rmd")'

plos.csl:
	wget https://raw.githubusercontent.com/citation-style-language/styles/master/plos.csl -O plos.csl

clean:
	rm -f plos.csl *.log *.pdf
