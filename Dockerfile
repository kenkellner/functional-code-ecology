# Start with R version 4.2.2
FROM rocker/r-ver:4.2.2

# Install some linux libraries that R packages need
RUN apt-get update && apt-get install -y cmake libxt6 pandoc pandoc-citeproc

# Set renv version 0.15.5
ENV RENV_VERSION 0.15.5

# Install renv
RUN Rscript -e "install.packages('http://cran.r-project.org/src/contrib/Archive/renv/renv_${RENV_VERSION}.tar.gz', repos=NULL, type='source')"

# Create a working directory
WORKDIR /reproducible-analyses

# Install all R packages specified in renv.lock
COPY renv.lock renv.lock
RUN Rscript -e 'renv::restore()'

# Copy necessary files
COPY README.md README.md
COPY methods methods

# Build docx version of methods
RUN cd methods; make Reproducible_Analyses_Ecology_Methods.docx

# Default to bash terminal when running docker image
CMD ["bash"]
