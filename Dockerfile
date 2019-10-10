FROM rocker/verse:latest

RUN R -e "install.packages(c('forecast', 'plotly', 'ggplot2', 'dplyr', 'UKgrid', 'fpp2', 'shiny', 'tsibble', 'dygraphs', 'devtools'))"

# installing dev version packages
CMD ["R", "-e", "devtools::install_github("RamiKrispin/TSstudio")"]
CMD ["R", "-e", "devtools::install_github("RamiKrispin/forecastML")"]


