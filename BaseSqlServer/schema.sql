-- Sakila Spatial Sample Database Schema
-- Version 0.9

-- Copyright (c) 2014, Oracle Corporation
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

--  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--  * Neither the name of Oracle Corporation nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- Modified in September 2015 by Giuseppe Maxia
-- The schema and data can now be loaded by any MySQL 5.x version.

--SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
--SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
--SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

--DROP database IF EXISTS sakila;
--CREATE DATABASE sakila;
USE sakila;

--
-- Table structure for table `actor`
--

CREATE TABLE dbo.actor (
  actor_id integer NOT NULL IDENTITY(1,1),
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (actor_id),
  
);

create NONCLUSTERED index idx_actor_last_name on dbo.actor(last_name);

--
-- Table structure for table `country`
--

CREATE TABLE dbo.country (
  country_id integer  NOT NULL IDENTITY(1,1),
  country VARCHAR(50) NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (country_id)
);

--
-- Table structure for table `city`
--

CREATE TABLE dbo.city (
  city_id integer  NOT NULL IDENTITY(1,1),
  city VARCHAR(50) NOT NULL,
  country_id integer  NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (city_id)
);

create NONCLUSTERED index idx_fk_country_id on dbo.city(country_id);


--
-- Table structure for table `address`
--
CREATE TABLE dbo.address (
  address_id integer  NOT NULL IDENTITY(1,1),
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id integer  NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (address_id)
);

create NONCLUSTERED index idx_fk_city_id on dbo.address(city_id);

--
-- Table structure for table `category`
--

CREATE TABLE dbo.category (
  category_id TINYINT  NOT NULL IDENTITY(1,1),
  name VARCHAR(25) NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (category_id)
);

--
-- Table structure for table `staff`
--

CREATE TABLE dbo.staff (
  staff_id TINYINT  NOT NULL IDENTITY(1,1),
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id integer  NOT NULL,
  picture varbinary(MAX) DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  store_id TINYINT  NOT NULL,
  active BIT NOT NULL DEFAULT 'TRUE',
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) DEFAULT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (staff_id)
);

create NONCLUSTERED index idx_fk_store_id on dbo.staff(store_id);
create NONCLUSTERED index idx_fk_address_id on dbo.staff(address_id);

--
-- Table structure for table `store`
--

CREATE TABLE dbo.store (
  store_id TINYINT  NOT NULL IDENTITY(1,1),
  manager_staff_id TINYINT  NOT NULL UNIQUE,
  address_id integer  NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (store_id)
);

create NONCLUSTERED index idx_fk_address_id on dbo.store(address_id);

alter table dbo.staff add  CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES dbo.store (store_id) ON DELETE NO ACTION ON UPDATE NO ACTION

--
-- Table structure for table `customer`
--

CREATE TABLE dbo.customer (
  customer_id integer  NOT NULL IDENTITY(1,1),
  store_id TINYINT  NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id integer  NOT NULL,
  active BIT NOT NULL DEFAULT 'TRUE',
  create_date DATETIME NOT NULL,
  last_update DATETIME DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (customer_id)
);

create NONCLUSTERED index idx_fk_store_id on dbo.customer(store_id);
create nonclustered index idx_fk_address_id on dbo.customer(address_id);
create nonclustered index idx_last_name on dbo.customer(last_name);

--
-- Table structure for table `language`
--

CREATE TABLE language (
  language_id TINYINT  NOT NULL IDENTITY(1,1),
  name CHAR(20) NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (language_id)
);

--
-- Table structure for table `film`
--

CREATE TABLE dbo.film (
  film_id integer  NOT NULL IDENTITY(1,1),
  title VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  release_year NUMERIC DEFAULT NULL,
  language_id TINYINT  NOT NULL,
  original_language_id TINYINT  DEFAULT NULL,
  rental_duration TINYINT  NOT NULL DEFAULT 3,
  rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  length integer  DEFAULT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99,
  rating VARCHAR(255) NOT NULL DEFAULT 'G',
  special_features VARCHAR(255)  DEFAULT NULL ,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (film_id)
);

create NONCLUSTERED index idx_title on dbo.film(title);
create nonclustered index idx_fk_language_id on dbo.film(language_id);
create nonclustered index idx_fk_original_language_id on dbo.film(original_language_id);
--
-- Table structure for table `film_actor`
--

CREATE TABLE dbo.film_actor (
  actor_id integer  NOT NULL,
  film_id integer  NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (actor_id,film_id)
);

create NONCLUSTERED index idx_fk_film_id on dbo.film_actor(film_id);


--
-- Table structure for table `film_category`
--

CREATE TABLE dbo.film_category (
  film_id integer  NOT NULL,
  category_id TINYINT  NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (film_id, category_id)
);


--
-- Table structure for table `film_text`
--

CREATE TABLE dbo.film_text (
  film_id integer NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  PRIMARY KEY  (film_id)
);



-- After MySQL 5.6.10, InnoDB supports fulltext indexes
/*!50610 ALTER TABLE film_text engine=InnoDB */;

--
-- Triggers for loading film_text from film
--

--DELIMITER ;;
Create TRIGGER ins_film ON dbo.film AFTER INSERT  as
  begin
	DECLARE
    @film_id  integer,
    @title   VARCHAR(255),
	@description VARCHAR(8000)

    SELECT @film_id = film_id, @title = title, @description = NULL FROM INSERTED A

    INSERT INTO film_text (film_id, title, description)
        VALUES (@film_id, @title, @description)
  END;
  
  -------------------------------

CREATE TRIGGER upd_film ON dbo.film AFTER UPDATE 
	as
	begin 
		
		UPDATE film_text
            SET title=new.title,
                description=NULL,
                film_id=new.film_id 
		from film_text A 
		inner join INSERTED new on A.film_id = new.film_id
		inner join deleted old 
			on	   old.title <> new.title 
				or old.film_id <> new.film_id

  END;


CREATE TRIGGER del_film ON dbo.film AFTER DELETE 
	as
	begin
		DELETE 
		FROM film_text
		where film_id in (select film_id from INSERTED)
  END;

--
-- Table structure for table `inventory`
--

CREATE TABLE dbo.inventory (
  inventory_id int  NOT NULL IDENTITY(1,1),
  film_id integer  NOT NULL,
  store_id TINYINT  NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (inventory_id)
);

create NONCLUSTERED index idx_fk_film_id on dbo.inventory(film_id);
create NONCLUSTERED index idx_store_id_film_id on dbo.inventory(store_id,film_id);

--
-- Table structure for table `rental`
--

CREATE TABLE dbo.rental (
  rental_id INT NOT NULL IDENTITY(1,1),
  rental_date DATETIME NOT NULL UNIQUE,
  inventory_id INT  NOT NULL,
  customer_id integer  NOT NULL,
  return_date DATETIME DEFAULT NULL,
  staff_id TINYINT  NOT NULL,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (rental_id)
);

create NONCLUSTERED index idx_fk_inventory_id on dbo.rental(inventory_id);
create NONCLUSTERED index idx_fk_customer_id on dbo.rental(customer_id);
create NONCLUSTERED index idx_fk_staff_id on dbo.rental(staff_id);


-- daqui
-- Table structure for table `payment`
--

CREATE TABLE dbo.payment (
  payment_id integer  NOT NULL IDENTITY(1,1),
  customer_id integer  NOT NULL,
  staff_id TINYINT  NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  last_update DATETIME DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (payment_id)
);

create NONCLUSTERED index idx_fk_staff_id on dbo.payment(staff_id);
create NONCLUSTERED index idx_fk_customer_id on dbo.payment(customer_id);




--daqui agr
-- View structure for view `customer_list`
--

CREATE VIEW dbo.customer_list
AS
	SELECT	cu.customer_id AS ID, 
			CONCAT(cu.first_name, concat(' ', cu.last_name)) AS name, 
			a.address AS address, 
			a.postal_code AS [zip code],
			a.phone AS phone, 
			city.city AS city, 
			country.country AS country, 
			case when cu.active = 'TRUE' then 'active' else '' end AS notes, 
			cu.store_id AS SID
	FROM customer AS cu 
	inner JOIN address AS a ON cu.address_id = a.address_id 
	inner JOIN city ON a.city_id = city.city_id
	inner JOIN country ON city.country_id = country.country_id

--
-- View structure for view `film_list`
--

CREATE VIEW film_list
AS
	SELECT	film.film_id AS FID, 
			film.title AS title, 
			film.description AS description, 
			category.name AS category, 
			film.rental_rate AS price,
			film.length AS length, 
			film.rating AS rating, 
			CONCAT(CONCAT(actor.first_name, ' , '), actor.last_name) AS actors
	FROM category 
	LEFT JOIN film_category ON category.category_id = film_category.category_id 
	LEFT JOIN film ON film_category.film_id = film.film_id
	INNER JOIN film_actor  ON film.film_id = film_actor.film_id
		JOIN actor ON film_actor.actor_id = actor.actor_id

--
-- View structure for view `nicer_but_slower_film_list`
--

CREATE VIEW nicer_but_slower_film_list
AS
	SELECT	film.film_id AS FID, 
			film.title AS title, 
			film.description AS description, 
			category.name AS category, 
			film.rental_rate AS price,
			film.length AS length, 
			film.rating AS rating, 
			null AS actors
	FROM category LEFT JOIN film_category ON category.category_id = film_category.category_id LEFT JOIN film ON film_category.film_id = film.film_id
			JOIN film_actor ON film.film_id = film_actor.film_id
		JOIN actor ON film_actor.actor_id = actor.actor_id

--
-- View structure for view `staff_list`
--

CREATE VIEW staff_list
AS
SELECT s.staff_id AS ID, CONCAT(s.first_name, s.last_name) AS name, a.address AS address, a.postal_code AS [zip code], a.phone AS phone,
	city.city AS city, country.country AS country, s.store_id AS SID
FROM staff AS s JOIN address AS a ON s.address_id = a.address_id JOIN city ON a.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id;

--
-- View structure for view `sales_by_store`
--

CREATE VIEW sales_by_store
AS
SELECT
CONCAT(c.city, cy.country) AS store
, CONCAT(m.first_name,  m.last_name) AS manager
, SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN store AS s ON i.store_id = s.store_id
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS c ON a.city_id = c.city_id
INNER JOIN country AS cy ON c.country_id = cy.country_id
INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY CONCAT(m.first_name,  m.last_name),CONCAT(c.city, cy.country);

--
-- View structure for view `sales_by_film_category`
--
-- Note that total sales will add up to >100% because
-- some titles belong to more than 1 category
--

CREATE VIEW sales_by_film_category
AS
SELECT
c.name AS category
, SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name;

--
-- View structure for view `actor_info`
--

--
-- Procedure structure for procedure `rewards_report`
--
CREATE TRIGGER customer_create_date ON dbo.customer AFTER INSERT as
	begin 
		declare @customer_id integer 

		select @customer_id = customer_id from INSERTED
		
		update A
		set create_date = getdate()
		from customer A
		where A.customer_id = @customer_id
	end

	
CREATE TRIGGER payment_date ON payment after INSERT as
	begin 
		declare @payment_id integer 

		select @payment_id = payment_id from INSERTED
		
		update A
		set payment_date = getdate()
		from payment A
		where A.payment_id = @payment_id
	end


CREATE TRIGGER rental_date ON dbo.rental after INSERT as
	begin 
		declare @rental_id integer 

		select @rental_id = rental_id from INSERTED
		
		update A
		set rental_date = getdate()
		from dbo.rental A
		where A.rental_id = @rental_id
	end

