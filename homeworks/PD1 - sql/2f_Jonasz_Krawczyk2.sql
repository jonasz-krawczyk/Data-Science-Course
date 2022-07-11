/*2. DQL – JOIN, UNION, FUNKCJE AGREGUJ¥CE: 
f. Stwórz zestawienie sprzeda¿y dla Klientów najœwie¿szy rok. Wyniki podziel na kwarta³y. 
wyœwietl liczbê zamówieñ, œredni¹, maksymaln¹, minimaln¹ wartoœæ oraz sumê z pól Freight, oraz z kwoty zamówienia. */

-- 1. ca³oœæ ale bez zsumowania wartoœci z kwarta³ów, chocia¿ wyniki s¹ podzielone:
select 
c.company_name,
--o.order_date
count (o.order_id) as order_qty,
round(avg(o.freight) over (partition by o.order_date)) as avg_freight,
round(max(o.freight) over (partition by o.order_date)) as maks_freight,
round(min(o.freight) over (partition by o.order_date)) as min_freight,
round(sum(o.freight) over (partition by o.order_date)) as sum_freight,
round(sum(od.unit_price * od.quantity * (1-od.discount))) as suma_kwoty,
case 
when date_part('month', o.order_date) < 4 then 'I'
when date_part('month', o.order_date) < 7 then 'II'
when date_part('month', o.order_date) < 10 then 'III'
else 'IV'
end as season
from customers c
join orders o 
on c.customer_id = o.customer_id 
join order_details od 
on od.order_id = o.order_id 
group by c.company_name, o.order_date, o.freight, season
having date_part('year', o.order_date) = 1997
order by c.company_name, season

--2. a teraz sumy z kwarta³ów. zrobiê to tak, ¿e wytworzê osobne 4 widoki dla 4 kwarta³ów
--po czym spróbujê je z³¹czyæ i zagregowaæ odpowiednio.

--tworzê widoki kwarta³ów
create view v_q1 as
select 
c.company_name,
--o.order_date,
count (o.order_id) as order_qty,
round(avg(o.freight) over (partition by o.order_date)) as avg_freight,
round(max(o.freight) over (partition by o.order_date)) as maks_freight,
round(min(o.freight) over (partition by o.order_date)) as min_freight,
round(sum(o.freight) over (partition by o.order_date)) as sum_freight,
round(sum(od.unit_price * od.quantity * (1-od.discount))) as suma_kwoty,
1 as season
from customers c
join orders o 
on c.customer_id = o.customer_id 
join order_details od 
on od.order_id = o.order_id 
group by c.company_name, o.order_date, o.freight
having date_part('year', o.order_date) = 1997 and date_part('month', o.order_date) <4
order by c.company_name
--drop view v_q1

create view v_q2 as
select 
c.company_name,
--o.order_date,
count (o.order_id) as order_qty,
round(avg(o.freight) over (partition by o.order_date)) as avg_freight,
round(max(o.freight) over (partition by o.order_date)) as maks_freight,
round(min(o.freight) over (partition by o.order_date)) as min_freight,
round(sum(o.freight) over (partition by o.order_date)) as sum_freight,
round(sum(od.unit_price * od.quantity * (1-od.discount))) as suma_kwoty,
2 as season
from customers c
join orders o 
on c.customer_id = o.customer_id 
join order_details od 
on od.order_id = o.order_id 
group by c.company_name, o.order_date, o.freight
having date_part('year', o.order_date) = 1997 and date_part('month', o.order_date) between 4 and 6
order by c.company_name
--drop view v_q2

create view v_q3 as
select 
c.company_name,
--o.order_date,
count (o.order_id) as order_qty,
round(avg(o.freight) over (partition by o.order_date)) as avg_freight,
round(max(o.freight) over (partition by o.order_date)) as maks_freight,
round(min(o.freight) over (partition by o.order_date)) as min_freight,
round(sum(o.freight) over (partition by o.order_date)) as sum_freight,
round(sum(od.unit_price * od.quantity * (1-od.discount))) as suma_kwoty,
3 as season
from customers c
join orders o 
on c.customer_id = o.customer_id 
join order_details od 
on od.order_id = o.order_id 
group by c.company_name, o.order_date, o.freight
having date_part('year', o.order_date) = 1997 and date_part('month', o.order_date) between 7 and 9
order by c.company_name
--drop view v_q3

create view v_q4 as
select 
c.company_name,
--o.order_date,
count (o.order_id) as order_qty,
round(avg(o.freight) over (partition by o.order_date)) as avg_freight,
round(max(o.freight) over (partition by o.order_date)) as maks_freight,
round(min(o.freight) over (partition by o.order_date)) as min_freight,
round(sum(o.freight) over (partition by o.order_date)) as sum_freight,
round(sum(od.unit_price * od.quantity * (1-od.discount))) as suma_kwoty,
4 as season
from customers c
join orders o 
on c.customer_id = o.customer_id 
join order_details od 
on od.order_id = o.order_id 
group by c.company_name, o.order_date, o.freight
having date_part('year', o.order_date) = 1997 and date_part('month', o.order_date) between 10 and 13
order by c.company_name
--drop view v_q4

--scalam widoki
create view v_qa as
select * from v_q1 
union all
select * from v_q2
union all
select * from v_q3 
union all
select * from v_q4
--drop view v_qa

--agregujê dane z powy¿szego widoku po kombinacji firma-kwarta³
select 
distinct company_name,
season,
sum (order_qty) over (partition by company_name, season) as orders_amount, 
sum (avg_freight) over (partition by company_name, season) as average, 
sum (maks_freight) over (partition by company_name, season) as maksimum,
sum (min_freight) over (partition by company_name, season) as minimum,
sum (sum_freight) over (partition by company_name, season) as total_freight,
sum (suma_kwoty) over (partition by company_name, season) as total_price
from v_qa
/*group by company_name, season, order_qty, avg_freight, maks_freight, min_freight, sum_freight*/
order by company_name, season

