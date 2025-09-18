				  # PRUEBA SQL - SPRIT 2
                -- ---------- --
-- Curso: Data analytics_2025
-- Alumna: Margot Hilda Arroyo De la Cruz 					Fecha:  18/09/2025
-- -------------------------------------------------------------------------------  
				# Nivel 1
 -- -------------------------------------------------------------------------------                
# I. Ejercicio 1: importación y características de los datos:
	#A. Base de Datos:
		use transactions;
		show tables;
	#B. Columnas de las tablas :
		describe company;
		describe transaction;
	#C. Datos de las tablas :		
		select * from company;
        select * from transaction;
        
# II. Ejercicio 2: Utilizando JOIN realizarás las siguientes consultas:
	#A. Listado de los países que están generando ventas.
		select c.country as Países
        from company c
        join transaction t
        on c.id=t.company_id
        group by c.country;
      
	#B. Desde cuántos países se generan las ventas
		select count(*) as Total_países
        from (  select c.country
				from company c
				join transaction t
				on c.id=t.company_id
                group by c.country )
		as Total;
     
	#C. Identifica a la compañía con la mayor media de ventas.
		select c.company_name as Compañia, avg(t.amount) as venta_promedio
        from company c
        join transaction t
        on c.id=t.company_id
        group by c.company_name
        order by venta_promedio desc
        limit 1;
        
# II. Ejercicio 3. Utilizando sólo subconsultas (sin utilizar JOIN):
	#A. Muestra todas las transacciones realizadas por empresas de Alemania.
		#A1. Empresas de Alemania (subconsulta)
			SELECT id, company_name, country
			FROM company
			where country='Germany';        
        #A2 Respuesta
			select * from transaction
			where company_id in (
				select id 
				from company
					where country="Germany"
			);
	#B. Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
		#B1. La media de todas las transacciones (subconsulta)
			select avg(amount) as Venta_promedio
			from transaction;
        #B2 Respuesta
			select company_name as Empresas
			from company
			where id in (
				select company_id
				from transaction
				where amount > (
					select avg(amount) 
					from transaction)
				);
       #C. Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
		        
			select company_name, country
			from company
			where id not in (
				select company_id
				from transaction
				where company_id is not null
			);

 -- -------------------------------------------------------------------------------  
				# Nivel 2
-- ------------------------------------------------------------------------------- 
# I. Ejercicio 1: #Identifica los cinco días que se generó la mayor cantidad de ingresos
				   -- en la empresa por ventas. Muestra la fecha de cada transacción 
                   -- junto con el total de las ventas.
		select date(timestamp) as Fecha, -- "date" devuelve el día de la transacción -- 
			sum(amount) as Total_ventas
        from transaction
        group by date(timestamp)
        order by Total_ventas desc
        limit 5;

# II. Ejercicio 2: ¿Cuál es la media de ventas por país? Presenta los resultados
					-- ordenados de mayor a menor medio.
		select c.country as País, avg(t.amount) as Venta_promedio
        from company c
        join transaction t
        on c.id=t.company_id
        group by c.country
        order by Venta_promedio desc;
        
# III. Ejercicio 3: En tu empresa, se plantea un nuevo proyecto para lanzar algunas 
					-- campañas publicitarias para hacer competencia a la compañía 
                    -- “Non Institute”. Para ello, te piden la lista de todas las transacciones 
                    -- realizadas por empresas que están ubicadas en el mismo país que esta compañía.
		-- Empresas ubicadas en el mismo pais que “Non Institute”:
				select id, company_name, country
				from company
				where country = (
					select country
					from company
					where company_name = 'Non Institute'
					);
	#A. Muestra el listado aplicando JOIN y subconsultas.
			select t.*, empresas.company_name, empresas.country
			from transaction t
			join (
				select id, company_name, country
				from company 
				where country = (
					select country
					from company
					where company_name = 'Non Institute'
					) 
                ) as empresas
            ON t.company_id = empresas.id;
	#B. Muestra el listado aplicando solo subconsultas.
  		select 
			t.*,
			(select country
			 from company c 
			 where c.id = t.company_id
			) as country,
			(select company_name
			 from company c 
			 where c.id = t.company_id
			) as company_name
		from transaction t
		where company_id in (
			select id
			from company
			where country = (
				select country
				from company
				where company_name = 'Non Institute'
			)
		);   
  
 -- -------------------------------------------------------------------------------  
									#Nivel 3
-- ------------------------------------------------------------------------------- 
# I. Ejercicio 1: Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que 
				-- realizaron transacciones con un valor comprendido entre 350 y 400 euros y
                -- en alguna de estas fechas: 29 de abril de 2015, 20 de julio de 2018 y 13 de 
                -- marzo de 2024. Ordena los resultados de mayor a menor cantidad.
                
			select 
				c.company_name as Nombre,
                c.phone as Telefono,
                c. country as País,
                date(t.timestamp) as Fecha,
                t.amount as Ventas
			from transaction t
            join company c
				on t.company_id=c.id
			where t.amount between 350 and 400
            and date(t.timestamp) in ('2015-04-29', '2018-07-20', '2024-03-13')
			order by t.amount desc;

# II. Ejercicio 2: Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad 
				   -- operativa que se requiera, por lo que te piden la información sobre la cantidad 
                   -- de transacciones que realizan las empresas, pero el departamento de recursos 
                   -- humanos es exigente y quiere un listado de las empresas en las que especifiques 
                   -- si tienen más de 400 transacciones o menos.

			select 
				c.company_name as Nombre,
				c.country as País,
				COUNT(t.id) as Total_transacciones,
				if(COUNT(t.id) > 400, 'Más de 400', 'Menos de 400') as Rango_transacciones
			from company c
			left join transaction t
				on c.id = t.company_id
			group by c.id, c.company_name, c.country
			order by total_transacciones asc;

