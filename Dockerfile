# docker build . --progress plain -t scviewer-lite:new
FROM rocker/r-ver:4.2.0

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration
RUN apt-get install -y libcurl4-openssl-dev libssl-dev
RUN apt-get install -y xorg libx11-dev mesa-common-dev libglu1-mesa-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libftgl2 freetype2-demos libfreetype6-dev
RUN apt-get install -y libhdf5-dev
# RUN apt-get install -y r-cran-rcppeigen
RUN apt-get install -y libgit2-dev
RUN apt-get install -y libcairo2-dev
RUN apt-get install -y libxt-dev
RUN apt-get install -y libglpk-dev

RUN R -e 'install.packages(c("devtools","shiny","shinydashboard","shinyjs","shinyBS","shinyBS","RColorBrewer","reshape2","ggplot2", "dplyr","tidyr","openssl","httr","plotly","htmlwidgets","DT","shinyRGL","rgl","rglwidget","Seurat","cowplot", "data.table","tibble","network","igraph","visNetwork"))'

#Install packages from bioconductor
RUN R -e 'install.packages("BiocManager")'
RUN R -e 'BiocManager::install(version = "3.15",ask = FALSE)'

RUN R -e 'BiocManager::install(c("biomaRt","Biobase","slingshot","ComplexHeatmap"))'
RUN R -e 'BiocManager::install(c("NMF","broom","gam","parallelDist","scds","ReactomeGSA"))'

RUN R -e 'devtools::install_github("chris-mcginnis-ucsf/DoubletFinder")'
RUN R -e 'devtools::install_github("theislab/destiny")'

RUN R -e 'BiocManager::install(c("slingshot"))'

RUN apt-get install -y libgeos-dev
RUN R -e 'devtools::install_github("Morriseylab/scExtras");'
RUN R -e 'devtools::install_github("Morriseylab/ligrec")'
RUN R -e 'devtools::install_github("mojaveazure/seurat-disk")'

RUN R -e 'install.packages(c("shinyWidgets","shinythemes"))'

RUN R -e 'BiocManager::install(c("NMF","broom","gam","parallelDist","scds","ReactomeGSA"))'
RUN apt-get install -y cmake
RUN R -e 'devtools::install_github("theislab/destiny")'
RUN R -e 'install.packages(c("tidyverse"))'
RUN R -e 'devtools::install_github("Morriseylab/scExtras");'

RUN mkdir /srv/shiny-server
ADD .  /srv/shiny-server
# RUN mv /srv/shiny-server/Example\ data /srv/shiny-server/data
WORKDIR /srv/shiny-server

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp(port=3838,host='0.0.0.0')"]

