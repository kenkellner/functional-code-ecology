Reproducible_Analyses_Ecology_Methods.pdf: Reproducible_Analyses_Ecology_Methods.md plos.csl power_analysis.png
	pandoc --filter pandoc-citeproc -o Reproducible_Analyses_Ecology_Methods.pdf Reproducible_Analyses_Ecology_Methods.md

Reproducible_Analyses_Ecology_Methods.html: Reproducible_Analyses_Ecology_Methods.md plos.csl power_analysis.png
	pandoc --filter pandoc-citeproc --self-contained -o Reproducible_Analyses_Ecology_Methods.html Reproducible_Analyses_Ecology_Methods.md

power_analysis.png: power_analysis.R
	Rscript power_analysis.R

plos.csl:
	wget https://raw.githubusercontent.com/citation-style-language/styles/master/plos.csl -O plos.csl

clean:
	rm -f plos.csl *.log *.pdf
