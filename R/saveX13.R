#' @title Save seasonal adjustment results in multiple files
#' @description Save CSV files for seasonally adjusted data, seasonal factors, calendar factors, total factors (seasonal & calendar factors) and model specification for each series.
#' @param output output from seasX13 function
#' @param file a character string naming the file
#' @importFrom zoo as.Date
#' @export
 
saveX13 <- function(output, file = ""){
  
  if(file == ""){ stop("Insert the file name. No extensions are required.")}

  ajustadas <- data.frame(date = as.Date(output$xSA), output$xSA)
  fatores_totais <- data.frame(date = as.Date(output$totalFactors), output$totalFactors)
  fatores_sazonais <- data.frame(date = as.Date(output$seasonalFactors), output$seasonalFactors)
  fatores_calendario <- data.frame(date = as.Date(output$calendarFactors), output$calendarFactors)
  
  # salvar serie com ajuste sazonal
  write.csv2(ajustadas, file = paste0(file,"_seasonallyAdjusted.csv"), row.names = F, na = "", fileEncoding = "utf-8")
  write.csv2(fatores_totais, file = paste0(file,"_totalFactors.csv"), row.names = F, na = "", fileEncoding = "utf-8")
  write.csv2(fatores_calendario, file = paste0(file,"_calendarFactors.csv"), row.names = F, na = "", fileEncoding = "utf-8")
  write.csv2(fatores_sazonais, file = paste0(file,"_seasonalFactors.csv"), row.names = F, na = "", fileEncoding = "utf-8")
  write.csv2(output$espec, file = paste0(file,"_especifications.csv"), row.names = F, na = "", fileEncoding = "utf-8")
  
}