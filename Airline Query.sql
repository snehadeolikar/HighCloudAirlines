SET SQL_SAFE_UPDATES = 0;
set sql_mode="NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION";
use airlines;

ALTER TABLE `airlines`.`aircraft types` 
RENAME TO  `airlines`.`aircrafttypes` ;

ALTER TABLE carrieroperatingregion RENAME COLUMN  `%RegionCode` TO RegionCode;
aLTER TABLE carrieroperatingregion RENAME COLUMN  `Carrier'sOperatingRegion` TO CarriersOperatingRegion;
aLTER TABLE maindata_final RENAME COLUMN  `Available Seats` TO Available_Seats;

select * from maindata_final;
select * from aircraftgroups;
select * from carrieroperatingregion;

select* from aircrafttypes;

-- Load Factor
select ifnull((sum(TransportedPassengers)/sum(`Available_Seats`))*100,0) as Loadfactor from maindata_final;



ALTER TABLE maindata_final
ADD OrderDate date;

ALTER TABLE maindata_final
ADD years year;

ALTER TABLE maindata_final
ADD Months date;

Alter Table maindata_final
Add Column Month_Name Char(20);

alter table maindata_final
add column Monthno int;

alter table maindata_final
add column Monthyear char(90);

alter table maindata_final
add column weekDayNo char(90);
alter table maindata_final
add column QuarterName char(90);

alter table maindata_final
add column WeekDayName char(90);
alter table maindata_final
add column WeekDay_weekend char(90);

UPDATE maindata_final SET OrderDate = STR_TO_DATE(CONCAT(Year, '-', Month, '-', Day), '%Y-%m-%d'); 
UPDATE maindata_final SET Years= year(OrderDate);
UPDATE maindata_final SET Month_Name= MonthName(orderDate);
update maindata_final set Monthno=month(orderDate);
update maindata_final set MonthYear=date_format(orderdate,'%Y-%M');

update maindata_final set weekDayNo=weekday(orderDate);
update maindata_final set WeekDayName=dayname(orderDate);
update maindata_final set WeekDay_weekend=
if (WeekDayName='Saturday' or WeekDayName='Sunday',
 'WeekEnd' ,'WeekDay');
 
 update maindata_final set QuarterName= 
 case 
 when Quarter(orderDate)=1 then "Q-1"
 when Quarter(orderDate)=2 then "Q-2"
  when Quarter(orderDate)=3 then "Q-3"
  else
  "Q-4"
  end;
  
  
 -- kpi 1

   create or replace view kpi1 as(
 select 
 str_to_Date(concat(year,'-',Month,'-',Day),'%Y-%m-%d')as OrderDate,
 year(OrderDate)as Years,
 Month(OrderDate) as Months,
 WeekDay(OrderDate) as Days,
 concat("Q-",QUARTER(OrderDate)) as Quarters,
 date_format(OrderDate,'%Y-%M') as Year_Months,
 MonthName(OrderDate) as MonthName,
 DAYOFWEEK(OrderDate) AS `weekday_number`,
        DAYNAME(OrderDate) AS `weekday_name`,
        MONTH((OrderDate + INTERVAL -(3) MONTH)) AS `financial_month`,
        concat("Q-",QUARTER((OrderDate + INTERVAL -(3) MONTH)) ) AS `financial_quarter`,
if ((DAYNAME(OrderDate)='Saturday' or DAYNAME(OrderDate)='Sunday') , "WeekEnd", "WeekDay") as WeekEnd_Weekday 
 from maindata_final
 );
 
 select * from kpi1;

    
  -- Kpi 2

  call kpi2_standby('Yearwise');
  
select years,Month_Name, QuarterName,(sum(TransportedPassengers)/sum(`Available_Seats`))*100 as Loadfactor
from maindata_final
group by years,Month_Name, QuarterName;

-- Procedure
 call kpi2_standby('Quarterwise');

  -- KPI 3
select CarrierName,ifnull((sum(TransportedPassengers)/sum(`Available_Seats`))*100,0) as Loadfactor
from maindata_final
group by CarrierName
order by Loadfactor desc;

-- KPI 4
 SELECT CarrierName ,(sum(TransportedPassengers)/sum(`Available_Seats`))*100 as Loadfactor, rank() 
OVER (order by (sum(TransportedPassengers)/sum(`Available_Seats`))*100  desc ) 
AS 'rank' FROM maindata_final 
group by CarrierName
limit 10 ; 
  
  -- using cte
  with  s as(
   SELECT CarrierName ,ifnull((sum(TransportedPassengers)/sum(`Available_Seats`))*100,0) as Loadfactor, rank() 
OVER (order by (sum(TransportedPassengers)/sum(`Available_Seats`))*100  desc ) 
R FROM maindata_final 
group by CarrierName
) 
select * from s where R between 1 and 10;

-- kpi 5
select count(`%AirlineID`) as FlightNo,FromToCity from  maindata_final
group by FromToCity
order by count(`%AirlineID`) desc;


-- kpi 6
  select WeekDay_weekend , ifnull((sum(TransportedPassengers)/sum(`Available_Seats`))*100,0) as Loadfactor
  from maindata_final
  group by WeekDay_weekend;
  
  
-- kpi 8
select  d.DistanceInterval, count(`DeparturesPerformed`) as Flightno 
from maindata_final m join distancegroups d
on d.`%DistanceGroupID`=m.`%DistanceGroupID`
group by d.DistanceInterval;
  
 -- KPI7
CALL KPI7('Angola','', 'Houston, TX','United States','Texas', 'Houston, Tx');

 -- 'Red Dog, AK',  'United States', 'Kotzebue, AK', 'Alaska', 'United States'
 

 

 






