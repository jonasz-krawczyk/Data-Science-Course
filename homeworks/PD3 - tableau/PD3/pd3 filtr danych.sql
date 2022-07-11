---------------- GLOWNY FILTR ----------------
create view v_primary_view_pd3 as
select
i.CountryName,
i.IndicatorName,
i."Year" ,
round(i.Value,3) as wskaznik
from Indicators i
where 
i.CountryName in ('Estonia', 'Latvia', 'Lithuania', 'Poland')
AND
i.IndicatorName in ('Researchers in R&D (per million people)', 'Technicians in R&D (per million people)')
AND
i."Year" > 1992
--drop view v_primary_view

---------------- 1. Researchers in R&D (per million people) ----------------
--ocena danych
--a) przegl¹d:
select *
from v_primary_view_pd3
where IndicatorName = "Researchers in R&D (per million people)" and "year" >= 1998
order by countryname
--danych jest malo; nie brac do funkcji rankujacej.
--b) ilosc wystapien danego panstwa w bazie danych:
SELECT DISTINCT 
CountryName ,
count(CountryName) over (partition by CountryName) as ilosc_powtorzen
from v_primary_view_pd3 as vp
where vp.IndicatorName = "Researchers in R&D (per million people)" 
order by CountryName
--wskazac srednia, maksymalna i minimalna wartosc w ramach ciekawostki
--wsrod grupy
--MAX
SELECT 
CountryName, "Year", max(wskaznik)
from v_primary_view as vp
where vp.IndicatorName = "Researchers in R&D (per million people)" 
--MIN
SELECT 
CountryName, "Year", min(wskaznik)
from v_primary_view as vp
where vp.IndicatorName = "Researchers in R&D (per million people)" 
--AVG (bez Polski)
SELECT 
AVG(wskaznik) as srednia_grupy
from v_primary_view as vp
where vp.IndicatorName = "Researchers in R&D (per million people)" and vp.CountryName is not 'Poland'
--w Polsce
--MAX
SELECT 
CountryName, "Year", max(wskaznik)
from v_primary_view as vp
where vp.IndicatorName = "Researchers in R&D (per million people)" and CountryName = 'Poland'
--MIN
SELECT 
CountryName, "Year", min(wskaznik)
from v_primary_view as vp
where vp.IndicatorName = "Researchers in R&D (per million people)" and CountryName = 'Poland'
--AVG (dla Polski)
SELECT 
AVG(wskaznik) as srednia_polski
from v_primary_view as vp
where vp.IndicatorName = "Researchers in R&D (per million people)" and vp.CountryName = 'Poland'

---------------- 2. Technicians in R&D (per million people) ----------------
--ocena danych
--a) przegl¹d:
select *
from v_primary_view_pd3 
where IndicatorName = "Technicians in R&D (per million people)" and "year" >= 1998
order by countryname
--danych jest malo; nie brac do funkcji rankujacej.
--b) ilosc wystapien danego panstwa w bazie danych:
SELECT DISTINCT 
CountryName ,
count(CountryName) over (partition by CountryName) as ilosc_powtorzen
from v_primary_view as vp
where vp.IndicatorName = "Technicians in R&D (per million people)" 
order by CountryName
--wskazac srednia, maksymalna i minimalna wartosc w ramach ciekawostki
--wsrod grupy
--MAX
SELECT 
CountryName, "Year", max(wskaznik)
from v_primary_view as vp
where vp.IndicatorName = "Technicians in R&D (per million people)" 
--MIN
SELECT 
CountryName, "Year", min(wskaznik)
from v_primary_view as vp
where vp.IndicatorName = "Technicians in R&D (per million people)" 
--AVG (bez Polski)
SELECT 
AVG(wskaznik) as srednia_grupy
from v_primary_view as vp
where vp.IndicatorName = "Technicians in R&D (per million people)" and vp.CountryName is not 'Poland'
--w Polsce
--MAX
SELECT 
CountryName, "Year", max(wskaznik)
from v_primary_view as vp
where vp.IndicatorName = "Technicians in R&D (per million people)" and CountryName = 'Poland'
--MIN
SELECT 
CountryName, "Year", min(wskaznik)
from v_primary_view as vp
where vp.IndicatorName = "Technicians in R&D (per million people)" and CountryName = 'Poland'
--AVG (dla Polski)
SELECT 
AVG(wskaznik) as srednia_polski
from v_primary_view as vp
where vp.IndicatorName = "Technicians in R&D (per million people)" and vp.CountryName = 'Poland'