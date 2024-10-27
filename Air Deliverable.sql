/* PROJECT - AIR TRAFFIC DELIVERABLE PART 1 */
/* The purpose of this project is to give the fund managers concise data to help them invest in one of three major airline stocks */

use airtraffic;
-- This query is use to fetch the schema

select * from flights;
select * from airports;
-- These queries are used to chec the data in two tables

-- Question 1
-- Question 1.1
select year(flightdate) as year, count(*) as number_flights 
from flights 
where year(flightdate) in (2018, 2019)
group by
year;

/* According to the query, there were 3,218,653 number of flights in 2018 and 3,302,708 number of flights in 2019. 
Here, I selected the year from year function and counted the number of flights from count function*/

-- Question 1.2
select count(*) as number_of_flights from flights 
where cancelled != 0 or depdelay >= 1 and
year(flightdate) in (2018, 2019);

/* The total number of flights cancelled or departed late in the year 2018 an 2019 are 2,633,237*/

-- Question 1.3
select count(*) from flights 
where cancellationreason is NOT Null;

/* The total number of flights that were cancelled broken down by the reason for cancellation are 92,363. 
It was done using the fields of cancellationreason which are not null */

-- Question 1.4
select
month(flightdate) as months,
count(Tail_Number) as total_flights,
((sum(cancelled) / count(tail_number)) * 100) as percentage_cancelled
from flights
where year(flightdate) = 2019
group by month(flightdate)
order by month(flightdate);

/* To calculate the the total number of flights and percentage of flights cancelled for the year 2019, 
In the above query, I have used aggregate functions like count and to calculate the percentage, 
we did calculations based off of sum and count division */

/* In this diagnosis, while the total flights average remain same throughout the year 2019 but the percentage of cancellation has reduced signifanctly.
This clearly states that due to high cancellations in the earlier months, airline suffered losses but managed to recover the revenue by the end of the year */

-- Question 2
-- Question 2.1
create table Year_2018 as 
(select airlinename, sum(distance) as total_distance, count(Flight_Number_Reporting_Airline) as total_flights
from flights where year(flightdate) = 2018 group by airlinename);

create table Year_2019 as 
(select airlinename, sum(distance) as total_distance, count(Flight_Number_Reporting_Airline) as total_flights 
from flights where year(flightdate) = 2019 group by airlinename);

/* These queries create two new tables, one for each year (2018 and 2019) showing the total miles traveled 
and number of flights broken down by airline. It was done using create table function along with sub queries */

-- Question 2.2
select a.airlinename,
((b.total_flights - a.total_flights) / a.total_flights) * 100 as percent_change_flights,
((b.total_distance - a.total_distance) / a.total_distance) * 100 as percent_change_miles
from year_2018 a
join year_2019 b on a.airlinename = b.airlinename;

/* In this query, we calculate the percentage change from 2018 to 2019 by agggregating the total flights
and the miles travelled by joining the two tables that were created for year 2018 and 2019 
Airline name     % change in flights    % change in miles
Delta Air Lines Inc.	4.4984	5.6
American Airlines Inc.	3.2676	0.6
Southwest Airlines Co.	0.8424	-0.1 */

/* Due to the trend in the percentage change. The fund managers can invest more American airlines with least fluctuations
in both the percentages as the rest two have high risk and volitality. */ 

-- Question 3
-- Question 3.1
select airports.airportname, count(flights.destairportid) as total_flight 
from flights join airports on flights.destairportid = airports.airportid 
group by airports.airportname 
order by total_flight desc limit 10;

/* This query describes the top 10 most popular destination airports by joining two tables, flights and airports. 
This was done using aggregate function and joins along with group by the airport name and setting the limit with the order. */

-- Question 3.2
select airports.airportname, count(*) as total_flight 
from (select destairportid from flights limit 1000) sq 
join airports on sq.destairportid = airports.airportid 
group by airports.airportname 
order by total_flight desc limit 10;

/* Yes, the aggregate and limit function still give the same results but just because of the limited number of count the SQL 
does not need to travel through the whole table and give sufficient results. That's why the latest query is faster
in terms of runtime */

-- Question 4
-- Question 4.1
select airlinename, count(distinct tail_number) as Unique_aircraft_count from flights
where flightdate like '%2018%' or flightdate like '%2019%'
group by airlinename;

/* The Airlines with the unique no. of aircrafts are, 
American Airlines Inc. with 993 aircrafts, 
Delta Air Lines Inc. with 988 aircrafts,
and Southwest Airlines Co. with 754 aircrafts. The results are calcualted on the basis if distinct function for tail_number */

-- Question 4.2
select distinct airlinename, avg(distance) as Average_distance from flights
where flightdate like '%2018%' or flightdate like '%2019%'
group by airlinename;

/* The average distance traveled per aircraft for each of the three airlines is,
Delta Air Lines Inc. with 892.0 miles
American Airlines Inc. with 1004.2 miles
Southwest Airlines Co. with 745.2 miles. The results are calcualted on the basis if distinct function for airlinename*/

/* In terms of finances, Delta airlines contributes to most revenue among the three followed by Southwest Airlines Co. 
and then Amaerican airlines */

-- Question 5
-- Question 5.1
Select avg(crsdeptime) as Average,
CASE
    WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
    WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
    WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
    ELSE "4-night"
END AS "time_of_day" from flights
group by time_of_day
order by time_of_day;

/* The above query shows the average departure time depending on the time of the day with the case function*/

-- Question 5.2
Select airports.airportname as Airportname, avg(flights.crsdeptime) as Average,
CASE
    WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
    WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
    WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
    ELSE "4-night"
END AS "time_of_day" from flights 
join airports on flights.originairportid = airports.airportid
group by Airportname, time_of_day
order by Airportname, time_of_day;

/* The above query shows the average departure time depending on the time of the day along with the airport names by joining two tables*/

-- Question 5.3
select airports.airportname as Airportname, avg(flights.crsdeptime) as Average
from flights 
join airports on flights.originairportid = airports.airportid
where case
when hour(CRSDepTime) between 7 and 11 then "1-morning"
else null end = "1-morning"
group by airportname
having count(*) >= 10000
order by average desc;

/* The above query shows the aiport names aand average departure times of the flights with the morning time of the day
and having at least 10,000 flights. This was done using the aggregate function for departure time and case function for time of the day
along with using having for conditioning group by for at least 10,000 flights */

-- Question 5.4
select airports.airportname as Airportname, avg(flights.crsdeptime) as Average, airports.city as City
from flights 
join airports on flights.originairportid = airports.airportid
where case
when hour(CRSDepTime) between 7 and 11 then "1-morning"
else null end = "1-morning"
group by airportname, City
having count(*) >= 10000
order by average desc;

/* The above query defines the top 10 airports with the highest average morning delay and their corresponding cities */