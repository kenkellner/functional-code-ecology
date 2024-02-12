Reproducible_Analyses_Ecology_Results.html: Reproducible_Analyses_Ecology_Results.Rmd 
	Rscript -e "rmarkdown::render('Reproducible_Analyses_Ecology_Results.Rmd')"

clean:
	rm -f *.tiff *.html *.pdf *.docx

# May have to run this twice to get the updated document
docker: 
	sudo docker image build -t reproducible-analyses-results .
	$(eval ID = $(shell docker create reproducible-analyses-results))
	sudo docker cp $(ID):/reproducible-analyses/Reproducible_Analyses_Ecology_Results.html .
	sudo docker cp $(ID):/reproducible-analyses/Figure_1.tiff .
	sudo docker cp $(ID):/reproducible-analyses/Figure_2.tiff .
	sudo docker cp $(ID):/reproducible-analyses/Figure_3.tiff .
	sudo docker cp $(ID):/reproducible-analyses/Table_1.csv .
	sudo docker cp $(ID):/reproducible-analyses/Table_2.csv .
	sudo docker rm -v $(ID)
