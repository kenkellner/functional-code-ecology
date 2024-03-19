Functional_Reproducible_Code_Ecology.html: Functional_Reproducible_Code_Ecology.Rmd 
	Rscript -e "rmarkdown::render('Functional_Reproducible_Code_Ecology.Rmd')"

clean:
	rm -f *.tiff *.html *.pdf *.docx

# May have to run this twice to get the updated document
docker: 
	sudo docker image build -t reproducible-analyses-results .
	$(eval ID = $(shell docker create reproducible-analyses-results))
	sudo docker cp $(ID):/reproducible-analyses/Functional_Reproducible_Code_Ecology.html .
	sudo docker cp $(ID):/reproducible-analyses/Figure_1.tiff .
	sudo docker cp $(ID):/reproducible-analyses/Figure_2.tiff .
	sudo docker cp $(ID):/reproducible-analyses/Figure_3.tiff .
	sudo docker cp $(ID):/reproducible-analyses/Table_1.csv .
	sudo docker cp $(ID):/reproducible-analyses/Table_2.csv .
	sudo docker rm -v $(ID)
