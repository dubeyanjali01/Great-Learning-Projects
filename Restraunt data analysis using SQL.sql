
CREATE DATABASE mini_project_sales;
USE mini_project_sales;

SHOW TABLES;              
DESC cust_dimen;                            
DESC market_fact;                     
DESC orders_dimen;                  
DESC prod_dimen;                   
DESC shipping_dimen; 

 
-- changing data type for the required columns
ALTER TABLE orders_dimen MODIFY Order_Date DATE;
ALTER TABLE shipping_dimen MODIFY Ship_Date DATE;



-- question 1: Find the top 3 customers who have the maximum number of orders
select * from cust_dimen;
select * from market_fact;
SELECT 
    cd.cust_id,cd.customer_name, COUNT(mf.ord_id) AS number_of_orders
FROM
    cust_dimen cd
        INNER JOIN
    market_fact mf ON cd.cust_id = mf.cust_id
GROUP BY cd.cust_id
ORDER BY number_of_orders DESC
LIMIT 3;

/* This query uses an inner join between the customer dimension table and the market fact table 
on the common field of the customer ID. The COUNT function is used to count the number of order IDs 
in the market_fact table that match each customer ID.
GROUP BY groups the result set by the customer ID to ensure that (COUNT) is applied to each customer separately.
Overall, this SQL query is helpful in providing valuable insights for sales and marketing strategies.
*/

-- ( question2): Create a new column DaysTakenForDelivery that contains the date difference between Order_Date and Ship_Date.
CREATE TABLE Delivery AS (
SELECT od.order_id,od.order_date, od.ord_id, sd.ship_id, sd.ship_date
FROM orders_dimen od INNER JOIN shipping_dimen sd ON od.ORDER_ID=sd.ORDER_ID);

ALTER TABLE Delivery ADD COLUMN DaysTakenForDelivery INT AS (DATEDIFF(ship_date,order_date)) ;
SELECT * FROM delivery;

/*
Here we created new table called Delivery and populated it with data from the orders_dimen and shipping_dimen tables using SELECT 
statement to retrieve columns from both tables and INNER JOIN operator to join the tables based on the order_id column.

The ALTER TABLE statement is used to add a new column to the Delivery table called DaysTakenForDelivery. The data type for 
this column is INT, and the value for each row is calculated using the DATEDIFF function which calculates the number of 
days between the ship_date and order_date columns in each row.
*/

-- Question 3: Find the customer whose order took the maximum time to get delivered.
SELECT c.Cust_id, c.Customer_Name, d.order_id, d.DaysTakenForDelivery 
FROM delivery d INNER JOIN market_fact m ON d.ord_id=m.ord_id
INNER JOIN cust_dimen c ON m.Cust_id = c.Cust_id
ORDER BY DaysTakenForDelivery DESC LIMIT 1;

/*
Here we have used inner join between the delivery table and the market fact table on the common field of the order ID (ord_id). 
It then uses another inner join with the customer dimension table.
The ORDER BY clause sorts the result set in descending order of the number of days taken for delivery. 'LIMIT' clause 
limits the result set to only the first row.

This SQL query is useful for identifying the customer and order that have experienced the longest delay in 
delivery, which can be used for further analysis to identify any issues in the delivery process and improve customer 
satisfaction.  */


-- Question 4: Retrieve total sales made by each product from the data (use Windows function)
select * from market_fact;
select distinct prod_id, 
round(sum(sales) OVER(partition by prod_id ),2) as total_sales
 from market_fact order by total_sales DESC;

/*  Here, DISTINCT keyword is used to retrieve only unique product IDs from the market fact table. 
SUM :- is used to calculate the total sales for each product ID by partitioning the result set by product ID 
using the OVER clause. This creates a separate group of rows for each product ID, and the SUM function is applied to each 
group to calculate the total sales.

This query is helps in analyzing the sales performance of different products and identifying the products 
with the highest total sales. The use of the SUM function with the OVER clause allows for the efficient calculation of 
total sales for each product, making the query faster and more efficient.   */



 -- question 5:  Retrieve the total profit made from each product from the data (use windows function)
SELECT * FROM market_fact;
SELECT DISTINCT prod_id,
 ROUND(SUM(profit) OVER(PARTITION BY prod_id),2) AS total_product_profit
FROM market_fact order by total_product_profit desc;

select prod_id,sum(shipping_cost) from market_fact group by prod_id  order by sum(shipping_cost) desc;

/* Here we use SUM with the OVER clause to calculate the total profit for each product ID by partitioning the result set 
by product ID. This creates a separate group of rows for each product ID, and the SUM function is applied to each group to 
calculate the total profit.

This query is helps in analyzing the profit performance of different products and identifying the products 
with the highest total profit. The use of the SUM function with the OVER clause allows for the efficient calculation of 
total profit for each product, making the query faster and more efficient. 
*/

-- Question 6: Count the total number of unique customers in January 
-- and how many of them came back every month over the entire year in 2011

CREATE VIEW combined_table as(
SELECT  cd.customer_name,cd.cust_id,mf.ord_id,od.order_date
 FROM
     cust_dimen cd
        INNER JOIN
     market_fact mf ON cd.cust_id = mf.cust_id
         INNER JOIN
     orders_dimen od ON mf.ord_id = od.ord_id);

SELECT distinct Year(order_date), Month(order_date), 
count(cust_id) OVER(PARTITION BY month(order_date) order by month(order_date)) AS Total_Unique_Customers
FROM combined_table
WHERE year(order_date)=2011 AND cust_id
IN (SELECT DISTINCT cust_id
FROM combined_table
WHERE month(order_date)=1
AND year(order_date)=2011);

/* The first query creates a view called combined_table which combines data from three tables: cust_dimen, market_fact, and 
orders_dimen. It joins cust_dimen and market_fact on the cust_id column and market_fact and orders_dimen on the ord_id column.
The result is a combined view of the relevant data from these three tables, which is used in subsequent queries.    */

/* The second query retrieves the total number of unique customers for each month in the year 2011, using a window function 
and a subquery.
The SELECT statement selects distinct Year and Month values from the order_date column of the combined_table, and 
calculates the Total_Unique_Customers for each month.
The count(cust_id) OVER(PARTITION BY month(order_date) order by month(order_date)) calculates the count of unique cust_id 
values for each month using a window function, and assigns the result to the Total_Unique_Customers column.
The WHERE clause filters the result to only include records from the year 2011 and where the cust_id values are present in
the subquery. The subquery selects distinct cust_id values from the combined_table where the month is January and the year
is 2011. */

	-- -----------------------------------------------------------------------------------------------------------------------------
    
   --  Part 2 – Restaurant:
CREATE DATABASE mini_project_restaurant;
USE mini_project_restaurant;
drop DATABASE mini_project_restaurant;
   
SHOW TABLES;
DESC chefmozaccepts; 
DESC chefmozhours4;      
DESC chefmozcuisine;    
DESC chefmozparking;   
DESC geoplaces2;         
DESC rating_final;       
DESC usercuisine;       
DESC userpayment;        
DESC userprofile;         
   
  --  Question 1: - We need to find out the total visits to all restaurants under all alcohol categories available.
SELECT a.placeID,a.name, a.alcohol, COUNT(b.userid) AS total_visits
FROM geoplaces2 a JOIN rating_final b 
ON a.placeID = b.placeID
where a.alcohol not like "%NO_Alcohol%"
GROUP BY alcohol, a.placeID, a.name
ORDER BY total_visits DESC;                         

/*   Here we use inner join between the geoplaces2 table and the rating_final table on the common field of the place ID. 
WHERE clause filters the result set to only include places that serve alcohol.
GROUP BY groups the result set by the alcohol availability status, place ID, and name to ensure that the 
aggregate function (COUNT) is applied to each group separately.

This query helps in analyzing the popularity of places that serve alcohol and identifying the number of users who have 
rated those places.               */

  
-- Question 2: -find out the average rating according to alcohol and price so that we can understand the rating in 
-- respective price categories as well.
 
SELECT distinct b.placeID,b.name, b.alcohol, b.price,
 AVG(a.rating) OVER(PARTITION BY b.alcohol) as `rating according to alcohol`,
AVG(a.rating) OVER(PARTITION BY b.price) as `rating according to price`
FROM rating_final a JOIN geoplaces2 b
ON a.placeID = b.placeID 
WHERE b.alcohol NOT LIKE "%NO_Alcohol%"                                
ORDER BY AVG(a.rating) OVER(PARTITION BY b.alcohol) DESC,
AVG(a.rating) OVER(PARTITION BY b.price) DESC;

/*   Here we partition the result set by the alcohol availability and price using the OVER clause. Also, the result set is 
sorted by the average rating for each alcohol availability and by the average rating for each price group in descending 
order allowing the user to identify the places with the best ratings for each group.

The AVG function is used with the OVER clause to calculate the average rating for each alcohol availability group and each 
price group. This creates a separate group of rows for each group, and the AVG function is applied to each group to 
calculate the average rating.

Overall, this query is helpful in analyzing the relationship between the rating score, alcohol availability, and price
 of the places. The use of the AVG function allows for the efficient calculation of the average rating for each group, 
 making the query faster and more efficient.                */


-- Question 3:Let’s write a query to quantify that what are the parking availability as well in different alcohol 
-- categories along with the total number of restaurants.


SELECT a.alcohol AS alcohol_type, b.parking_lot,
       COUNT(DISTINCT a.placeID) AS total_restaurants, 
       SUM(b.parking_lot IN 
       ('public', 'yes', 'valet parking', 'fee', 'street','validated parking')) AS ParkingAvailable_count, 
       SUM(b.parking_lot = 'none') AS NoParking_count
FROM geoplaces2 a LEFT JOIN chefmozparking b
ON a.placeID = b.placeID
 WHERE a.alcohol NOT LIKE '%NO_Alcohol%'
GROUP BY a.alcohol, b.parking_lot;


/*
This SQL query retrieves the total number of restaurants for each alcohol availability and parking lot combination, 
and the count of restaurants that have parking available or no parking at all.

The query achieves this by using a LEFT JOIN between the geoplaces2 table (a) and the chefmozparking table (b) on the 
common field of the place ID (placeID). The WHERE clause filters the result set to only include places that serve alcohol,
 as indicated by the "NO_Alcohol" flag in the alcohol column.

The SELECT clause specifies the columns to be retrieved from the tables: the alcohol availability status, parking lot type,
 total number of restaurants, the count of restaurants that have parking available, and the count of restaurants that have
 no parking.               */

-- Question 4: -Also take out the percentage of different cuisine in each alcohol type.
SELECT 
  a.alcohol AS alcohol_type, 
  b.rcuisine AS cuisine_type, 
  COUNT(DISTINCT a.placeid) AS total_restaurants,
  SUM(p.parking_lot
  IN ('public', 'yes', 'valet parking', 'fee', 'street','validated parking')) AS parking_available_count,
  SUM(p.parking_lot = 'none') AS no_parking_count,
  ROUND(COUNT(DISTINCT a.placeid) / SUM(COUNT(DISTINCT a.placeid)) OVER (PARTITION BY a.alcohol) * 100, 2) AS cuisine_percentage
FROM geoplaces2 a 
JOIN chefmozCuisine b ON a.placeid = b.placeid 
JOIN chefmozparking p ON a.placeid = p.placeid
WHERE a.alcohol NOT LIKE '%NO_Alcohol%' AND a.country <> '?'
GROUP BY a.alcohol, b.rcuisine
ORDER BY a.alcohol, cuisine_percentage DESC;

-- Questions 5: - let’s take out the average rating of each state.
update geoplaces2 set state= replace(state,"san luis potos","San Luis Potosi");
update geoplaces2 set state= replace(state,"San Luis Potosii","San Luis Potosi");

SELECT 
    a.state, ROUND(AVG(b.rating), 2) AS average_rating
FROM 
    geoplaces2 a
        INNER JOIN
    rating_final b ON a.placeid = b.placeid where a.state <> "?" 
GROUP BY state order by average_rating desc;

/* 
This query performs two operations. The first operation updates the "state" column in the "geoplaces2" table by replacing any 
instances of "san luis potos" and "San Luis Potosii" with "San Luis Potosi". The second operation retrieves data from two tables,
 "geoplaces2" and "rating_final", and calculates the average rating of restaurants in each state,
 rounding the result to two decimal places.
It joins the two tables using the placeid column, and then groups the results by state.
 The result set is sorted in descending order by the average rating, which is rounded to two decimal places using the 
 ROUND function.

The use of the GROUP BY clause and the AVG function allow for the aggregation and averaging of data across multiple rows. 
The sorting of the results by average rating provides additional insights into which states have the highest-rated places 
according to the data.
*/


-- Questions 6: -' Tamaulipas' Is the lowest average rated state. Quantify the reason why it is the lowest rated by providing the
--  summary on the basis of State, alcohol, and Cuisine.
SELECT 
    COUNT(gp.placeid) AS number_of_restaurants,
    Rcuisine,
    alcohol
FROM
    geoplaces2 gp
        INNER JOIN
    chefmozcuisine cc ON gp.placeid = cc.placeid
WHERE
    gp.state LIKE '%Tamaulipas%'
GROUP BY Rcuisine , alcohol;

/* Here we filter the results by selecting only those restaurants that are located in Tamaulipas state using the WHERE 
clause and the LIKE operator.We also group the results by the type of cuisine and alcohol availability, and then count the 
number of restaurants in each group using the COUNT function. */


/*Inference
there are only 6 type of cuisines there in tamaulipas and non of them serve alcohol
 where as the highest rated place ie san luis potos have restaurants with 11 different quisines along with 6 restaurants 
 serving alcohol.*/

 
 /*Question 7:  - Find the average weight, food rating, and service rating of the customers who have visited KFC and
 tried Mexican or Italian types of cuisine, and also their budget level is low.We encourage you to give it a try by not using joins.*/
 
select b.userid,avg(b.weight) as avg_weight , a.food_rating,a.service_rating from userprofile b,
(SELECT 
    placeid, userid, food_rating, service_rating
FROM
    rating_final
WHERE
    placeid IN (SELECT 
            placeid
        FROM
            geoplaces2
        WHERE
            placeid IN (SELECT 
                    placeid
                FROM
                    chefmozcuisine
                WHERE
                    Rcuisine LIKE '%mexican%'
                        OR Rcuisine LIKE '%italian%') 
                AND price LIKE '%low%'))a where a.userid=b.userid group by b.userid ,food_rating,service_rating 
                order by avg_weight desc;
select * from rating_final;
select * from chefmozcuisine;
select * from geoplaces2 where name like "%kfc%";
SELECT 
    up.userid, jp.name,jp.placeid
FROM
    geoplaces2 jp
        INNER JOIN
    rating_final rf ON jp.placeid = rf.placeid
        INNER JOIN
    userprofile up ON rf.userid = up.userid
    where name like "%kfc%";
-- -----------------------------------------------------------------------------------------------------------------------------------                
drop database mini_project_created_tables;

create database mini_project_created_tables;
use mini_project_created_tables;
create table student_details
(student_id int(3) not null,
student_name varchar(30) not null,
mail_id varchar(35) not null,
mobile_number int(12) not null,primary key(student_id) 
);
create table student_details_backup
(student_id int(3) not null,
student_name varchar(30) not null,
mail_id varchar(35) not null,
mobile_number int(12), primary key(student_id),foreign key (student_id) references student_details(student_id));

insert into student_details values(1,"jenny","anjenny@gmail.com",945215635);
insert into student_details values(2,"tessa","attessa@gmail.com",956248521);
insert into student_details values(3,"terence","teterence@gmail.com",958452156);
insert into student_details values(4,"jasmine","jasmine@gmail.com",985214578);
select * from student_details;

select * from student_details_backup;


delimiter //
create trigger stud_det_backup
before delete
on student_details
for each row
begin
insert into student_details_backup(student_id,student_name,mail_id,mobile_number)
values (old.student_id,old.student_name,old.mail_id,old.mobile_number);
end;
// 
delimiter ;

set foreign_key_checks=0;
select * from student_details;
delete from student_details where student_id=4;
select * from student_details_backup;
select * from student_details;

/* Here we create a trigger called "stud_det_backup" that is triggered before a record is deleted from the 
"student_details" table.

For each deleted row, the trigger will execute an "INSERT" statement that copies the data from the deleted row and inserts 
it into the "student_details_backup" table. The "student_details_backup" table will store the student_id, student_name, 
mail_id, and mobile_number columns for the deleted record.

The "delimiter" command is used to change the delimiter used in the query from the default semicolon to "//" to allow for 
the use of semicolons within the trigger definition. After the trigger definition is complete, the delimiter is set back
 to the default semicolon using the "delimiter ;" command.

Overall, this query sets up a trigger that creates a backup copy of any deleted records in the "student_details" 
table, which can be useful for auditing purposes or for restoring data in the future.
*/