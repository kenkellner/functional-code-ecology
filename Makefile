# May have to run this twice to get the updated PDF
Reproducible_Analyses_Ecology_Methods: Dockerfile methods/Reproducible_Analyses_Ecology_Methods.md methods/power_analysis.R methods/references.bib
	sudo docker image build -t reproducible-analyses .
	$(eval ID = $(shell docker create reproducible-analyses))
	sudo docker cp $(ID):/reproducible-analyses/methods/Reproducible_Analyses_Ecology_Methods.pdf .
	sudo docker rm -v $(ID)
