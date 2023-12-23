CREATE DEFINER=`root`@`localhost` PROCEDURE `kpi2_standby`(in selection text)
BEGIN
-- declare selection text;

if selection = 'Yearwise' THEN 
(select years,(sum(TransportedPassengers)/sum(`Available_Seats`))*100 as Loadfactor
from maindata_final
group by years);
elseif selection = 'Monthwise' then 
(select Month_Name,(sum(TransportedPassengers)/sum(`Available_Seats`))*100 as Loadfactor
from maindata_final
group by Month_Name);
ELSEIF selection = 'Quarterwise' THEN
        (SELECT QuarterName, (SUM(TransportedPassengers) / SUM(`Available_Seats`)) * 100 AS Loadfactor
        FROM maindata_final
        GROUP BY QuarterName);
        
    ELSE
        -- If an invalid selection is passed
        SELECT 'Invalid Selection,Please pass mentioned keyword:(Yearwise,Monthwise and Quarterwise)' AS Result;
        
-- end case;
end if;
end