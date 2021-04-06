# Resultados Elecciones Ecuador 2021 # 

**[EN CONSTRUCCIÓN: Repositorio de resultados electorales de Ecuador desde 2002 hasta 2021]** Este es un repositorio de datos de los resultados electorales de la elecciones generales de Ecuador de febrero de 2021. También es el primer aporte de un proyecto más amplio que llevamos a cabo con [Diana Dávila Gordillo](https://twitter.com/DiDavilaG), en el cual queremos crear un repositorio de resultados electorales de Ecuador desde 2002 hasta 2021. A medidad que vayamos limpiando y organizando la data, la iremos subiendo. También esperamos darle un mejor formato a este GitHub, como para que no se vea tan feo. 

## Data: ##
Por el momento, están disponibles los siguientes datos (con un pequeña descripción):

1. results_final_clean.Rdata : votos por partido para asambleísta provincial a nivel de junta (mesa electoral). Toda la información fue bajada de la página oficial del [Consejo Nacional Electoral](https://resultados.cne.gob.ec/). Nota: la junta 1F se refiere a la primera mesa de mujeres, así como la junta 4M se refiere a la cuarta mesa de hombres. 
2. presi_data_clean.Rdata : votos por candidato presidencial a nivel de junta (mesa electoral). Esta información es cortesía de [Ricardo Baquero](https://twitter.com/RocordoB) quien ha creado un [Mapa Estadístico](https://github.com/RickyTB/elecciones-2021) con los resultado. Toda la información fue bajada de la página oficial del [Consejo Nacional Electoral](https://resultados.cne.gob.ec/).
3. candidatos_2021_nocel.csv : lista de todos los candidatos a asambleísta (tanto provinciales como nacionales). Incluye dignidad, partido, provincia y circunscripción (para asambleístas provinciales), y posición en la lista. 

## Código ##
Adicionalmente, y para los más curioso, está disponible el siguiente código:

1. selenium_scrape_results2021.R : código de R para bajarse la información de la página del CNE de asambleístas provinciales para provincias con circunscripciones. Como paquete principal, utiliza [RSelenium](https://cran.r-project.org/web/packages/RSelenium/index.html) y debe estar asociado a [Docker](https://www.docker.com/).
2. selenium_scrape_results2021_sincircuns.R : código de R para bajarse la información de la página del CNE de asambleístas provinciales para provincias sin circunscripciones. Como paquete principal, utiliza [RSelenium](https://cran.r-project.org/web/packages/RSelenium/index.html) y debe estar asociado a [Docker](https://www.docker.com/). 
3. data_clean_results.R : código de R para limpiar la data de asambleístas provinciales. 
 
