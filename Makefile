docker:
	mkdir -p docker-output
	docker image build -t reproducible-analyses .
	$(eval ID = $(shell docker create reproducible-analyses))
	docker cp $(ID):/reproducible-analyses/methods/Reproducible_Analyses_Ecology_Methods.html docker-output/
	docker cp $(ID):/reproducible-analyses/methods/Reproducible_Analyses_Ecology_Methods.html docker-output/
	docker rm -v $(ID)
