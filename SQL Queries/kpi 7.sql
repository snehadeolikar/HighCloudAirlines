CREATE DEFINER=`root`@`localhost` PROCEDURE `KPI7`(in origincon text,in originsta text,in origincity text, in destcon text, in deststa text,in destcity text)
BEGIN
select `%AirlineID`, DeparturesScheduled,Available_Seats,CarrierName,OriginCity,`OriginState`,`OriginCountry`
,DestinationCity,DestinationState,DestinationCountry from maindata_final
where OriginCountry=origincon
or OriginState=originsta
and OriginCity =origincity
and DestinationCountry=destcon
and DestinationState=deststa
or DestinationCity=destcity;
END