#' @title Read data file for seasonal adjustment
#' @description Read a CSV or XLSX file. The file must have 2 or more columns. The first one must contain the sequential date of the time series. Missing values are supported. 
#' @param path path to the csv/xlsx file
#' @param sheetNumber sheet number of xlsx file
#' @return A \code{list} containing the following elements:
#' \item{xts}{time series in the path file.}
#' \item{xtsNA}{a object identifying the missing observations in each series.}
#' \item{deniedNames}{a vector naming the time series that will not be seasonally adjusted (less than three years of observation).}
#' \item{acceptedNames}{a vector naming time series that can be seasonally adjusted.}
#' \item{path}{path to the csv/xlsx file}
#' @importFrom readxl read_excel 
#' @export

readX13 <- function(path = "", sheetNumber = 1){
  
  if(grepl(".xlsx", path)){
    dados <- data.frame(read_excel(path, sheet = sheetNumber))
    inicio <- as.numeric(c(substr(dados[1,1],1,4), substr(dados[1,1],6,7)))
    fim <- as.numeric(c(substr(dados[nrow(dados),1],1,4), substr(dados[nrow(dados),1],6,7)))
  }else if(grepl(".csv", path)){
    dados <- read.csv2(path)
    inicio <- as.numeric(c(substr(dados[1,1],7,10), substr(dados[1,1],4,5)))
    fim <- as.numeric(c(substr(dados[nrow(dados),1],7,10), substr(dados[nrow(dados),1],4,5)))
  }
  colnames(dados)[1] <- "data"
  
  # nome das séries temporais
  nomes <- colnames(dados)[-1]
  
  # renomeando as linhas para as datas
  nomes_linhas <- matrix(substr(dados[,1],1,10))
  
  # criar série temporal com os dados
  xts <- data.frame(dados[,-1], row.names = nomes_linhas)
  colnames(xts) <- nomes
  
  for(nome in nomes){
    xts[,nome] <- ts(dados[,nome], start = inicio, freq = 12)
  } 
  
  # criar série temporal de 1 e 0, onde os 0's são NA 
  xts2 <- (!is.na(xts))*1
  
  # definindo quantas observações têm as séries
  ll <- apply(xts2, MARGIN = 2, FUN = sum)
  message36 <- names(ll[ll < 36])
  if(length(message36) > 0){message("The series ", paste(message36, collapse = ", "), "has/have less than 3 years of observations and cannot be seasonal adjusted!")}
  
  nomes_menosde3anos <- names(which(ll < 36))
  nomes_maisde3anos <- names(which(ll >= 36))
  
  # output da função
  output <- list()
  # séries + identificação se é NA ou não
  output$xts <- xts
  output$xtsNA <- xts2
  # nomes das séries de acordo com os tamanhos
  output$deniedNames <- ifelse(length(nomes_menosde3anos) == 0, "", nomes_menosde3anos)
  output$acceptedNames <- nomes_maisde3anos
  output$path <- path 
  output
} 

