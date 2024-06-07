# TFM
Repositorio con los archivos y códigos relativos al TFM de Miguel Caballero Rodríguez.

Por limitación de tamaño en los archivos de GitHub, hay que descargar un archivo adicional llamado `gadm36_IDN_gpkg.zip`, que se puede encontrar en la referencia https://geodata.ucdavis.edu/gadm/gadm3.6/gpkg/, que nos servirá para graficar los mapas de Indonesia.

Para proceder con la ejecución de los programas habrá que hacerlo de la siguiente manera:
1. Ejecutar el archivo `TFM_Miguel_Caballero.ipynb`, hasta la sección de resultados del modelo. En esta ejecución, se llevará a cabo todo el análisis estadístico de los datos, creación del modelo, y generación de escenarios. Se crearán los archivos `demandas.txt`, `vehiculos.txt` y `distancias.txt`, los cuales nos servirán de datos de entrada al modelo matemático.
2. A continuación, ejecutar el programa de GAMS `TFM.gms`, el cual resuelve el modelo matemático, y guarda la solución en el archivo `output.xlsx`.
3. Finalmente, ejecutar la parte final del archivo `TFM_Miguel_Caballero.ipynb`, de resultados del modelo, en la que se obtienen las gráficas de las soluciones y el análisis de sensibilidad. 
