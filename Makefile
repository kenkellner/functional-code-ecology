Reproducible_Analyses_Ecology_Methods.html:
	sudo docker image build -t reproducible-analyses .
	$(eval ID = $(shell docker create reproducible-analyses))
	sudo docker cp $(ID):/reproducible-analyses/methods/Reproducible_Analyses_Ecology_Methods.html .
	sudo docker rm -v $(ID)
