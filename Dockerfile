# Start with R version 4.3.2
FROM rocker/r-ver:4.3.2

# Install some linux libraries that R packages need
RUN apt-get update && apt-get install -y pandoc pandoc-citeproc libxt6

# Create a working directory
WORKDIR /reproducible-analyses

# Install dependencies
RUN Rscript -e 'install.packages("remotes")'
COPY install_dependencies.R install_dependencies.R
RUN Rscript install_dependencies.R 

# Build docx version of methods
COPY methods methods
RUN cd methods; make Reproducible_Analyses_Ecology_Methods.html

# Default to bash terminal when running docker image
CMD ["bash"]
