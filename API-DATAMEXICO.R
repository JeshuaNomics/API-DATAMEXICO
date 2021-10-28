# API-DATAMEXICO
install.packages("httr")
install.packages("jsonlite")
install.packages("plotly")

library(httr)
library(jsonlite)
library(plotly)

# URL API de DATAMEXICO
# https://api.datamexico.org/ui/?cube=wellness_credits&debug=false&distinct=true&drilldowns[]&measures[0]=Credits&nonempty=true&parents=false&sparse=false0

# Llamando a la API
URL <- "https://api.datamexico.org/tesseract/cubes/inegi_gdp/aggregate.jsonrecords?drilldowns%5B%5D=Date.Date.Quarter&measures%5B%5D=GDP&parents=false&sparse=false"

# Convertir en cadenas
Respuesta <- GET(URL)
Flujo_de_datos <- rawToChar(Respuesta$content)

# Obtención de la lista de observaciones 
Flujo_de_datos <- fromJSON(Flujo_de_datos)
names(Flujo_de_datos)

# Seleccionar solo los datos
Conjunto_de_datos <- Flujo_de_datos$data
names(Conjunto_de_datos)
Conjunto_de_datos <- Conjunto_de_datos[,-c(1)]

# Covertir en un marco de datos
Marco_de_datos <- data.frame(Conjunto_de_datos)
colnames(Marco_de_datos) <- c("Trimestre", "PIB")

# Gráfico del PIB
Grafico_PIB <- plot_ly(Marco_de_datos, 
                       x = ~Trimestre,
                       y = ~PIB,
                       name = 'PIB',
                       type = 'scatter',
                       mode = 'lines+markers')

Grafico_PIB %>% layout(title = "Producto Interno Bruto 1993Q1 al 2021Q1 de México (cifras originales)")

# Cálculo del crecimiento
Crecimiento <- data.frame(diff(log(Marco_de_datos$PIB), lag = 1)*100)
Fechas <- Marco_de_datos$Trimestre[2:114]

Marco_de_datos_crecimiento <- data.frame(cbind(Fechas, Crecimiento))
colnames(Marco_de_datos_crecimiento)<- c("Trimestre", "Crecimiento")

# Gráfico del crecimiento
Grafico_crecimiento <- plot_ly(Marco_de_datos_crecimiento, 
                               x = ~Trimestre,
                               y = ~Crecimiento,
                               name = 'Crecimiento',
                               type = 'scatter',
                               mode = 'lines+markers')

Grafico_crecimiento %>% layout(title="Crecimiento economico (variación porcentual respecto al trimestre anterior)")