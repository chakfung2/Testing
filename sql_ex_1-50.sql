--http://www.sql-ex.ru/
--Select Ex 1-50
--Oracle
--
--
--
--1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
-- Result set: model, speed, hd.
SELECT
	model,
	speed,
	hd
FROM
	pc
WHERE
	price < 500
;

--2. List all printer makers. Result set: maker.
SELECT DISTINCT
	pro.maker
FROM
	product pro
WHERE
	pro.type = 'Printer'
;

--3. Find the model number, RAM and screen size of the laptops with prices over $1000.
SELECT
	model,
	ram,
	screen
FROM
	laptop
WHERE
	price > 1000
;

--4.Find all records from the Printer table containing data about color printers.
SELECT
	code,
	model,
	color,
	type,
	price
FROM
	printer
WHERE
	color = 'y'
;

--5.Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.
SELECT
	model,
	speed,
	hd
FROM
	pc
WHERE
	price < 600
AND
	(
		cd = '12x'
		OR
		cd = '24x'
	)
;

--6.For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.
SELECT DISTINCT
	pro.maker,
	lap.speed
FROM
	product pro
INNER JOIN
	laptop lap
ON
	pro.model = lap.model
WHERE
	lap.hd >= 10

;

--7.Get the models and prices for all commercially available products (of any type) produced by maker B.
SELECT
	pro.model,
	pprice
FROM
	product pro
INNER JOIN
	(
		SELECT
			model,
			price AS pprice
		FROM
			laptop
		UNION
		SELECT
			model,
			price
		FROM
			pc
		UNION
		SELECT
			model,
			price
		FROM
			printer
		) proo
ON
	pro.model = proo.model
WHERE
	pro.maker = 'B'
;

--8.Find the makers producing PCs but not laptops.
SELECT DISTINCT
	maker
FROM
	product
WHERE
	type = 'PC'
MINUS
SELECT DISTINCT
	maker
FROM
	product
WHERE
	type = 'Laptop'	
;

--9.Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.
SELECT DISTINCT
	pro.maker
FROM
	product pro
INNER JOIN
	pc
ON
	pro.model = pc.model
WHERE
	pc.speed >= 450
;

--10. Find the printer models having the highest price. Result set: model, price.
SELECT
	prin.model,
	prin.price
FROM
	printer prin
WHERE
	prin.price =
	(
		SELECT
			MAX(price)
		FROM
			printer
	)
;

--11.Find out the average speed of PCs.
SELECT
	AVG(speed)
FROM
	pc
;

--12.Find out the average speed of the laptops priced over $1000.
SELECT
	AVG(speed)
FROM
	laptop
WHERE
	price > 1000
;


--13.
SELECT
	AVG(speed)
FROM
	pc
INNER JOIN
	product pro
ON
	pro.model = pc.model
WHERE
	pro.maker = 'A'
;

--14.Get the makers who produce only one product type and more than one model. Output: maker, type.
SELECT DISTINCT
	maker,
	MAX(type) AS type
FROM
	product
HAVING
	COUNT(DISTINCT model) > 1
AND
	COUNT(type) = 1
GROUP BY
	maker
;

--15.Get hard drive capacities that are identical for two or more PCs. 
--Result set: hd.
SELECT
	hd
FROM
	pc
HAVING
	COUNT(model) >= 2
GROUP BY
	hd
;

--16.Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i). 
--Result set: model with the bigger number, model with the smaller number, speed, and RAM.
SELECT DISTINCT
	p.model,
	p2.model,
	p.speed,
	p.ram
FROM
	pc p
INNER JOIN
	pc p2
ON
	p.speed = p2.speed
AND
	p.ram = p2.ram
WHERE
	p.model > p2.model
;

--17.Get the laptop models that have a speed smaller than the speed of any PC. 
--Result set: type, model, speed.

SELECT DISTINCT 
	'Laptop' AS type,
	lap.model,
	lap.speed
FROM
	laptop lap
WHERE
	lap.speed < ALL 
	(
		SELECT
			speed
		FROM
			pc
	)
;

--18.Find the makers of the cheapest color printers.
--Result set: maker, price.
SELECT DISTINCT
	pro.maker,
	prin.price
FROM
	product pro
INNER JOIN
	printer prin
ON
	pro.model = prin.model
AND
	prin.color = 'y'
WHERE
	prin.price =
	(
		SELECT
			MIN(price)
		FROM
			printer
		WHERE
			color = 'y'
	)
	
;



-- 19.For each maker having models in the Laptop table, find out the average screen size of the laptops he produces. 
-- Result set: maker, average screen size.
SELECT
	pro.maker,
	AVG(lap.screen)
FROM
	product pro
INNER JOIN
	laptop lap
ON
	pro.model = lap.model
GROUP BY
	pro.maker
;

-- 20.Find the makers producing at least three distinct models of PCs.
-- Result set: maker, number of PC models.
SELECT
	maker,
	COUNT(model)
FROM
	product
WHERE
	type = 'PC'
HAVING
	COUNT(model) >= 3
GROUP BY
	maker
;

-- 21.Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.
SELECT
	pro.maker,
	MAX(pc.price)
FROM
	product pro
INNER JOIN
	pc
ON
	pro.model = pc.model
GROUP BY
	pro.maker
;

-- 22.For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
-- Result set: speed, average price.
SELECT
	speed,
	AVG(price)
FROM
	pc
WHERE
	speed > 600
GROUP BY
	speed
;




-- 23.Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher. 
-- Result set: maker
SELECT DISTINCT
	pro.maker
FROM
	product pro
INNER JOIN
	pc
ON
	pro.model = pc.model
WHERE
	speed >= 750
INTERSECT
SELECT DISTINCT
	pro.maker
FROM
	product pro
INNER JOIN
	laptop lap
ON
	pro.model = lap.model
WHERE
	speed >= 750
;

-- 24.List the models of any type having the highest price of all products present in the database.
SELECT DISTINCT
	comp.allmodel
FROM
	(
		SELECT
			model AS allmodel,
			price AS allprice
		FROM
			laptop
		UNION
		SELECT
			model,
			price
		FROM
			pc
		UNION
		SELECT
			model,
			price
		FROM
			printer
	) comp
WHERE
	comp.allprice = 
	(
		SELECT
			MAX(comm.price)
		FROM
		(
			SELECT
				price
			FROM
				laptop
			UNION
			SELECT
				price
			FROM
				pc
			UNION
			SELECT
				price
			FROM
				printer
		) comm
		
	)
;

-- 25.Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity. 
-- Result set: maker.
SELECT DISTINCT
	pro.maker
FROM
	product pro
WHERE
	pro.type = 'Printer'
AND
	pro.maker IN
		(
			SELECT
				maker
			FROM
				product
			WHERE
				model IN
				(
					SELECT
						model
					FROM
						pc
					WHERE
						speed = 
						(
							SELECT
								MAX(speed)
							FROM
								pc
							WHERE
								ram =
							(
								SELECT
									MIN(ram)
								FROM
									pc
							)
						)
					AND
						ram =
						(
							SELECT
								MIN(ram)
							FROM
								pc
						)
				
				)
		)
;

-- 26.Find out the average price of PCs and laptops produced by maker A.
-- Result set: one overall average price for all items.
SELECT
	AVG(pclap.price)
FROM
	product pro
INNER JOIN
	(
		SELECT
			model,
			price
		FROM
			pc
		UNION ALL
		SELECT
			model,
			price
		FROM
			laptop
	) pclap
ON
	pro.model = pclap.model
WHERE
	pro.maker = 'A'
;

-- 27.Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
-- Result set: maker, average HDD capacity.
SELECT
	pro.maker,
	AVG(pc.hd)
FROM
	pc
INNER JOIN
	product pro
ON
	pc.model = pro.model
WHERE
	pc.model IN
		(
			SELECT
				model
			FROM
				product
			WHERE
				maker IN
					(
						SELECT
							maker
						FROM
							product
						WHERE
							type = 'Printer'
					)
		)
GROUP BY
	pro.maker
;

-- 28.Using Product table, find out the number of makers who produce only one model.
SELECT
	COUNT(maker)
FROM
	(
		SELECT
			maker
		FROM
			product
		HAVING
			COUNT(model) = 1
		GROUP BY
			maker
	)
;

-- 29.Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense). 
-- Use Income_o and Outcome_o tables.
SELECT
	COALESCE(i.point, o.point),
	COALESCE(i."date",o."date"),
	i.inc,
	o."out"
FROM
  Income_o i
FULL JOIN 
  Outcome_o o 
ON 
	i.point = o.point 
AND 
	i."date" = o."date"
;

-- 30.Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of times a day for each collection point [i.e. the code column is the primary key], display a table with one corresponding row for each operating date of each collection point.
-- Result set: point, date, total payout per day (out), total money intake per day (inc). 
-- Missing values are considered to be NULL.
SELECT
	uni.point,
	uni."date",
	SUM("out"),
	SUM(inc)
FROM
(
	SELECT
		i.point,
		i."date",
		NULL AS "out",
		SUM(i.inc) AS inc
	FROM
		income i
	GROUP BY
		i.point,
		i."date"
	UNION
	SELECT
		o.point,
		o."date",
		SUM(o."out"),
		NULL AS inc
	FROM
		Outcome o
	GROUP BY
		o.point,
		o."date"
) uni
GROUP BY
	uni.point,
	uni."date"
;

-- 31.For ship classes with a gun caliber of 16 in. or more, display the class and the country.
SELECT
	class,
	country
FROM
	Classes
WHERE
	bore >= 16
;

-- 32.One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw). 
-- Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.
SELECT
	country,
	ROUND(AVG((bore*bore*bore)/2),2)
FROM
(
	SELECT	
		c.country,
		c.bore,
		s.name
	FROM
		classes c
	INNER JOIN
		ships s
	ON
		c.class = s.class
	UNION
	SELECT
		c.country,
		c.bore,
		o.ship
	FROM
		classes c
	INNER JOIN
		outcomes o
	ON
		c.class = o.ship
	WHERE
		o.ship NOT IN 
		(
			SELECT
				name
			FROM
				ships
		)
)
GROUP BY
	country
;
-- 33.Get the ships sunk in the North Atlantic battle. 
-- Result set: ship.
SELECT
	ship
FROM
	outcomes
WHERE
	result = 'sunk'
AND
	battle = 'North Atlantic'
;

-- 34.In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons. 
-- Get the ships violating this treaty (only consider ships for which the year of launch is known). 
-- List the names of the ships.
SELECT
	s.name
FROM
	ships s
INNER JOIN
	classes c
ON
	s.class = c.class
WHERE
	s.launched IS NOT NULL
AND
	s.launched >= 1922
AND
	c.type = 'bb'
AND
	c.displacement > 35000
;

-- 35.Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.
-- Result set: model, type.
SELECT
	model,
	type
FROM
	product
WHERE
	REGEXP_LIKE(model, '^([0-9]+)$')
OR
	REGEXP_LIKE(model, '^([a-z]+)$', 'i')
;

-- 36.List the names of lead ships in the database (including the Outcomes table).
SELECT
	c.class
FROM
	classes c
WHERE
	c.class IN
	(
		SELECT
			name
		FROM
			ships
		UNION
		SELECT
			ship
		FROM
			outcomes
	)
;

-- 37.Find classes for which only one ship exists in the database (including the Outcomes table).
SELECT
	class
FROM
	(
		SELECT
			s.class,
			s.name 
		FROM
			ships s
		INNER JOIN
			classes c
		ON
			s.class = c.class
		UNION
		SELECT
			c2.class,
			o.ship
		FROM
			classes c2
		INNER JOIN
			outcomes o
		ON
			c2.class = o.ship
	) allships
HAVING
	COUNT(name) = 1
GROUP BY
	class
;

-- 38.Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’).
SELECT DISTINCT
	country
FROM
	classes
WHERE
	type = 'bb'
INTERSECT
SELECT DISTINCT
	country
FROM
	classes
WHERE
	type = 'bc'
;

-- 39.Find the ships that `survived for future battles`; that is, after being damaged in a battle, they participated in another one, which occurred later.
SELECT DISTINCT
	ob2.ship
FROM
	(
		SELECT
			o.ship,
			o.battle,
			o.result,
			b."date"
		FROM
			outcomes o
		INNER JOIN
			battles b
		ON
			b.name = o.battle
		WHERE
			result = 'damaged'
	) ob1
	INNER JOIN
	(
		SELECT
			o.ship,
			o.battle,
			o.result,
			b."date"
		FROM
			outcomes o
		INNER JOIN
			battles b
		ON
			b.name = o.battle
	) ob2
	ON
	ob1.ship = ob2.ship
WHERE 
		ob1."date" < ob2."date"
;

-- 40.For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
SELECT
	s.class,
	s.name,
	c.country
FROM
	ships s
INNER JOIN
	classes c
ON
	s.class = c.class
WHERE
	c.numGuns >= 10
;

-- 41.For the PC in the PC table with the maximum code value, obtain all its characteristics (except for the code) and display them in two columns:
-- - name of the characteristic (title of the corresponding column in the PC table);
-- - its respective value.
SELECT
	'cd' AS CHR,
	TO_CHAR(cd) AS VALUE
FROM
	pc
WHERE
	code = 
	(
		SELECT
			MAX(code)
		FROM
			pc
	)
UNION
SELECT
	'hd' AS CHR,
	TO_CHAR(hd) AS VALUE
FROM
	pc
WHERE
	code = 
	(
		SELECT
			MAX(code)
		FROM
			pc
	)
UNION
SELECT
	'model' AS CHR,
	TO_CHAR(model) AS VALUE
FROM
	pc
WHERE
	code = 
	(
		SELECT
			MAX(code)
		FROM
			pc
	)
UNION
SELECT
	'price' AS CHR,
	TO_CHAR(price) AS VALUE
FROM
	pc
WHERE
	code = 
	(
		SELECT
			MAX(code)
		FROM
			pc
	)
UNION
SELECT
	'ram' AS CHR,
	TO_CHAR(ram) AS VALUE
FROM
	pc
WHERE
	code = 
	(
		SELECT
			MAX(code)
		FROM
			pc
	)
UNION
SELECT
	'speed' AS CHR,
	TO_CHAR(speed) AS VALUE
FROM
	pc
WHERE
	code = 
	(
		SELECT
			MAX(code)
		FROM
			pc
	)
;

-- 42.Find the names of ships sunk at battles, along with the names of the corresponding battles.
SELECT
	ship,
	battle
FROM
	outcomes
WHERE
	result = 'sunk'
;
--43.Get the battles that occurred in years when no ships were launched into water.
SELECT
	name
FROM
	battles
WHERE
	TO_CHAR("date", 'YYYY') NOT IN
	(
		SELECT
			launched
		FROM
			ships
		WHERE
			launched IS NOT NULL
	)
;

-- 44.Find all ship names beginning with the letter R.
SELECT
	name
FROM
	ships
WHERE
	name LIKE 'R%'
UNION
SELECT
	ship
FROM
	outcomes
WHERE
	ship LIKE 'R%'
;

-- 45.Find all ship names consisting of three or more words (e.g., King George V).
-- Consider the words in ship names to be separated by single spaces, and the ship names to have no leading or trailing spaces.
-- SELECT
	-- name
-- FROM
	-- (
		-- SELECT
			-- name
		-- FROM
			-- ships
		-- UNION
		-- SELECT
			-- ship
		-- FROM
			-- outcomes
	-- )
-- WHERE
	-- REGEXP_LIKE(name, '^([A-Z]+)[[:space:]]([A-Z]+)[[:space:]]([A-Z]+)$', 'i')
-- ;
SELECT
	name
FROM
	ships
WHERE
	name LIKE '% % %'
UNION
SELECT
	ship
FROM
	outcomes
WHERE
	ship LIKE '% % %'
;

-- 46.For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns.
SELECT
	o.ship,
	c.displacement,
	c.numGuns
FROM
	outcomes o
LEFT OUTER JOIN
	ships s
ON
	o.ship = s.name
LEFT OUTER JOIN
	classes c
ON
	s.class = c.class
OR
	o.ship = c.class 
WHERE 
	O.battle = 'Guadalcanal'
;

-- 47.Number the rows of the Product table as follows: makers in descending order of number of models produced by them (for manufacturers producing an equal number of models, their names are sorted in ascending alphabetical order); model numbers in ascending order.
-- Result set: row number as described above, manufacturer's name (maker), model.
SELECT
	COUNT(*) num,
	mcm.maker,
	mcm.model
FROM
	(	
		SELECT
			mc.maker,
			mc.c,
			p.model
		FROM
		(
			SELECT
				maker,
				COUNT(model) AS c
			FROM
				product
			GROUP BY
				maker
			ORDER BY
				COUNT(model) DESC
		) mc
		INNER JOIN
			product p
		ON
			p.maker = mc.maker
	) mcm
INNER JOIN
	(	
		SELECT
			mc.maker,
			mc.c,
			p.model
		FROM
		(
			SELECT
				maker,
				COUNT(model) AS c
			FROM
				product
			GROUP BY
				maker
			ORDER BY
				COUNT(model) DESC
		) mc
		INNER JOIN
			product p
		ON
			p.maker = mc.maker
	) mcm2
ON
	mcm.c < mcm2.c
OR
	(mcm.c = mcm2.c AND mcm.maker > mcm2.maker)
OR
	(mcm.c = mcm2.c AND mcm.maker = mcm2.maker AND mcm.model >= mcm2.model)
GROUP BY 
	mcm.maker, 
	mcm.model
ORDER BY
	1
;

-- 48.Find the ship classes having at least one ship sunk in battles.

--Lead ship that sunk
SELECT
	c.class
FROM
	outcomes o
INNER JOIN
	classes c
ON
	o.ship = c.class
WHERE
	o.result = 'sunk'
UNION
--ships that sunk
SELECT
	s.class
FROM
	outcomes o
INNER JOIN
	ships s
ON
	o.ship = s.name
WHERE
	o.result = 'sunk'
;


-- 49.Find the names of the ships having a gun caliber of 16 inches (including ships in the Outcomes table).

--Classes that has bore 16
SELECT
	class
FROM
	classes
WHERE
	bore = 16
;

--Lead ships in outcomes with bore 16
SELECT
	o.ship
FROM
	outcomes o
INNER JOIN
	classes c
ON
	o.ship = c.class
WHERE
	bore = 16
;
--ships in outcomes with bore 16
SELECT
	s.name
FROM
	ships s
INNER JOIN
	outcomes o
ON
	s.name = o.ship
WHERE 
	s.class IN
	(
		SELECT
			class
		FROM
			classes
		WHERE
			bore = 16
	)
;
--ships in ships with bore 16
SELECT
	s.name,
	c.bore
FROM
	ships s
INNER JOIN
	classes c
ON
	s.class = c.class
WHERE
	bore = 16
;

--50.Find the battles in which Kongo-class ships from the Ships table were engaged.
SELECT
	o.battle
FROM
	outcomes o
INNER JOIN
	ships s
ON
	o.ship = s.name
AND
	s.class = 'Kongo'
UNION
SELECT
	o.battle
FROM
	outcomes o
INNER JOIN
	ships s
ON
	o.ship = s.class
AND
	s.class = 'Kongo'
;