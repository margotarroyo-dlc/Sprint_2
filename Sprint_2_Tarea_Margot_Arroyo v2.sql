				  # PRUEBA SQL - SPRIT 2
                -- ---------- --
-- Curso: Data analytics_2025
-- Alumna: Margot Hilda Arroyo De la Cruz 					Fecha:  18/09/2025
-- -------------------------------------------------------------------------------  
				# Nivel 1
 -- -------------------------------------------------------------------------------                
# I. Ejercicio 1: importación y características de los datos:
	#A. Base de Datos:
		USE transactions;
		SHOW TABLES;
	#B. Columnas de las tablas :
		DESCRIBE company;
		DESCRIBE transaction;
	#C. Datos de las tablas :		
		SELECT * FROM company;
        SELECT * FROM transaction;
        
# II. Ejercicio 2: Utilizando JOIN realizarás las siguientes consultas:
	#A. Listado de los países que están generando ventas.
		SELECT c.country AS Países
        FROM company c
        INNER JOIN transaction t
        ON c.id=t.company_id
        GROUP BY c.country;
      
	#B. Desde cuántos países se generan las ventas
		        SELECT count(DISTINCT c.country)
				FROM company c
				JOIN transaction t
				ON c.id=t.company_id;
               
	#C. Identifica a la compañía con la mayor media de ventas.
		SELECT c.company_name AS compañia, ROUND(AVG(t.amount),2) AS venta_promedio
        FROM company c
        JOIN transaction t
        ON c.id=t.company_id
        GROUP BY c.company_name
        ORDER BY venta_promedio DESC
        LIMIT 1;
        
# II. Ejercicio 3. Utilizando sólo subconsultas (sin utilizar JOIN):
	#A. Muestra todas las transacciones realizadas por empresas de Alemania.
		#A1. Empresas de Alemania (subconsulta)
			SELECT id, company_name, country
			FROM company
			WHERE country='Germany';        
        #A2 Respuesta
			SELECT * FROM transaction t
			WHERE EXISTS ( 
				SELECT *
                FROM company c
				WHERE c.id = t.company_id
                AND country="Germany"
			);
	#B. Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
		#B1. La media de todas las transacciones (subconsulta)
			SELECT ROUND(AVG(amount),2) AS venta_promedio
			FROM transaction;
        #B2 Respuesta
        
                SELECT company_name AS Empresas
                FROM company c
				WHERE EXISTS ( 
						SELECT *
						FROM transaction t
						WHERE c.id = t.company_id
						AND amount > (SELECT ROUND(AVG(amount),2)
										FROM transaction)
			     );
       #C. Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
		        
			SELECT company_name, country
			FROM company
			WHERE id NOT IN (
				SELECT company_id
				FROM transaction
				WHERE company_id IS NOT NULL
			);

 -- -------------------------------------------------------------------------------  
				# Nivel 2
-- ------------------------------------------------------------------------------- 
# I. Ejercicio 1: #Identifica los cinco días que se generó la mayor cantidad de ingresos
				   -- en la empresa por ventas. Muestra la fecha de cada transacción 
                   -- junto con el total de las ventas.
		SELECT DATE(timestamp) as fecha, -- "date" devuelve el día de la transacción -- 
			ROUND(SUM(amount),2) AS total_ventas
        FROM transaction
        GROUP BY fecha
        ORDER BY total_ventas DESC
        LIMIT 5;

# II. Ejercicio 2: ¿Cuál es la media de ventas por país? Presenta los resultados
					-- ordenados de mayor a menor medio.
		SELECT c.country AS pais, ROUND(AVG(t.amount),2) AS venta_promedio
        FROM company c
        JOIN transaction t
        ON c.id=t.company_id
        GROUP BY pais
        ORDER BY venta_promedio DESC;
        
# III. Ejercicio 3: En tu empresa, se plantea un nuevo proyecto para lanzar algunas 
					-- campañas publicitarias para hacer competencia a la compañía 
                    -- “Non Institute”. Para ello, te piden la lista de todas las transacciones 
                    -- realizadas por empresas que están ubicadas en el mismo país que esta compañía.
		-- Empresas ubicadas en el mismo pais que “Non Institute”:
				SELECT id, company_name, country
				FROM company
				WHERE country = (
					SELECT country
					FROM company
					WHERE company_name = 'Non Institute'
					);
	#A. Muestra el listado aplicando JOIN y subconsultas.
			SELECT t.*, empresas.company_name, empresas.country
			FROM transaction t
			JOIN company empresas ON t.company_id = empresas.id
            WHERE country = (
					SELECT country
					FROM company
					WHERE company_name = 'Non Institute'
					) ;
	#B. Muestra el listado aplicando solo subconsultas.
  		SELECT 
			t.*,
			(SELECT country
			 FROM company c 
			 WHERE c.id = company_id
			) AS country,
			(SELECT company_name
			 FROM company c 
			 WHERE c.id = company_id
			) AS company_name
		FROM transaction t
		WHERE company_id IN (
			SELECT id
			FROM company
			WHERE country = (
				SELECT country
				FROM company
				WHERE company_name = 'Non Institute'
			)
		);   
  
 -- -------------------------------------------------------------------------------  
									#Nivel 3
-- ------------------------------------------------------------------------------- 
# I. Ejercicio 1: Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que 
				-- realizaron transacciones con un valor comprendido entre 350 y 400 euros y
                -- en alguna de estas fechas: 29 de abril de 2015, 20 de julio de 2018 y 13 de 
                -- marzo de 2024. Ordena los resultados de mayor a menor cantidad.
                
			SELECT 
				c.company_name AS Nombre,
                c.phone AS Telefono,
                c. country as País,
                DATE(t.timestamp) AS Fecha,
                t.amount AS Ventas
			FROM transaction t
            JOIN company c
				ON t.company_id=c.id
			WHERE t.amount BETWEEN 350 AND 400
            AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
			ORDER BY t.amount DESC;

# II. Ejercicio 2: Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad 
				   -- operativa que se requiera, por lo que te piden la información sobre la cantidad 
                   -- de transacciones que realizan las empresas, pero el departamento de recursos 
                   -- humanos es exigente y quiere un listado de las empresas en las que especifiques 
                   -- si tienen más de 400 transacciones o menos.

			SELECT 
				c.company_name AS nombre,
				c.country AS pais,
				COUNT(t.id) AS total_transacciones,
				IF(COUNT(t.id) > 400, 'Más de 400', 'Menos de 400') AS rango_transacciones
			FROM company c
			LEFT JOIN transaction t
				ON c.id = t.company_id
			GROUP BY c.id
			ORDER BY total_transacciones ASC;

