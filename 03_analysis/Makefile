Reproducible_Analyses_Ecology_Results.pdf: Reproducible_Analyses_Ecology_Results.Rmd 
	Rscript -e "rmarkdown::render('Reproducible_Analyses_Ecology_Results.Rmd')"

clean:
	rm -f *.tiff *.pdf

# May have to run this twice to get the updated PDF
docker: 
	sudo docker image build -t reproducible-analyses-results .
	$(eval ID = $(shell docker create reproducible-analyses-results))
	sudo docker cp $(ID):/reproducible-analyses/Reproducible_Analyses_Ecology_Results.pdf .
	sudo docker cp $(ID):/reproducible-analyses/Figure_1.tiff .
	sudo docker cp $(ID):/reproducible-analyses/Figure_2.tiff .
	sudo docker cp $(ID):/reproducible-analyses/Figure_3.tiff .
	sudo docker rm -v $(ID)
