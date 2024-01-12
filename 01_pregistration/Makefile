Reproducible_Analyses_Ecology_Pregistration.pdf: Reproducible_Analyses_Ecology_Pregistration.md plos.csl power_analysis.png references.bib
	pandoc --filter pandoc-citeproc -o Reproducible_Analyses_Ecology_Pregistration.pdf Reproducible_Analyses_Ecology_Pregistration.md

power_analysis.png: power_analysis.R
	Rscript power_analysis.R

plos.csl:
	wget https://raw.githubusercontent.com/citation-style-language/styles/master/plos.csl -O plos.csl

clean:
	rm -f plos.csl *.log *.pdf

# May have to run this twice to get the updated PDF
docker: 
	sudo docker image build -t reproducible-analyses-pregistration .
	$(eval ID = $(shell docker create reproducible-analyses-pregistration))
	sudo docker cp $(ID):/reproducible-analyses/Reproducible_Analyses_Ecology_Pregistration.pdf .
	sudo docker rm -v $(ID)
