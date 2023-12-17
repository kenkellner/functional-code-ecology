# Start with R version 4.3.1 (one version behind for fixed package versions)
FROM rocker/r-ver:4.3.1

# Install some linux libraries that R packages need
RUN apt-get update && apt-get install -y pandoc pandoc-citeproc libxt6 \
texlive-latex-base texlive-fonts-recommended texlive-latex-recommended

# Create a working directory
WORKDIR /reproducible-analyses

# Build html version of methods
COPY methods methods
RUN cd methods; make Reproducible_Analyses_Ecology_Methods.pdf

# Default to bash terminal when running docker image
CMD ["bash"]
