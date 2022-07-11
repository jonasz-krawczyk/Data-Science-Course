/* ZADANIE DOMOWE NUMER 2
Jonasz Krawczyk

Za pomoc¹ funkcji okna wyznacz dla ka¿dego zamówienia z tabeli orders, 
œredni¹ oraz medianê zamówieñ z bie¿¹cego roku-miesi¹ca. Dodaj do wyników kolumnê z informacj¹ 
czy dane zamówienie ma kwotê wy¿sz¹ czy mniejsz¹ lub równ¹ od œredniej oraz mediany. */

--formula zliczajaca srednia po miesiacach--
create view v1 as
select 
order_id,
order_date,
round(freight::numeric,2) as order_value,
round((avg(freight) over (partition by to_char(order_date, 'yyyy-mm')))::numeric,2) as month_avg
from orders o
--drop view v1

--formula pomocnicza do zliczania mediany: w postgresie, percentile_disc nie operuje na oknach--
create view v2 as
select
*,
dense_rank() over (order by month_avg) as numerek
from v1
--drop view v2

--formula zliczajaca mediane po miesiacach
create view v3 as
select distinct 
numerek,
percentile_disc(0.5) within group (order by order_value) as month_mean
from v2
group by numerek
order by numerek
--drop view v3

--porownanie kwot zamowien do miesiecznej sredniej i miesiecznej mediany
create view v4 as
select
v2.order_id,
v2.order_date,
v2.order_value,
v2.month_avg,
v3.month_mean,
case 
when v2.order_value < v2.month_avg then 'less than avg'
when v2.order_value = v2.month_avg then 'equal to avg'
else 'more than avg'
end as avg_reference,
case 
when v2.order_value < v3.month_mean then 'less than mean'
when v2.order_value = v3.month_mean then 'equal to mean'
else 'more than mean'
end as mean_reference
from v2
join v3
on v2.numerek=v3.numerek
--drop view v4

/* Nastêpne za pomoc¹ funkcji agreguj¹cych stwórz zestawienie wed³ug roku-miesi¹ca 
z liczb¹ zamówieñ powy¿ej/poni¿ej œredniej /mediany. */

--a) zapytanie:
select 
to_char(order_date, 'yyyy-mm') as "period",
sum(case when avg_reference = 'less than avg' then 1 end) as less_avg_total,
sum(case when avg_reference = 'equal to avg' then 1 end) as equal_avg_total,
sum(case when avg_reference = 'more than avg' then 1 end) as more_avg_total,
sum(case when mean_reference = 'less than mean' then 1 end) as less_mean_total,
sum(case when mean_reference = 'equal to mean' then 1 end) as equal_mean_total,
sum(case when mean_reference = 'more than mean' then 1 end) as more_mean_total
from v4
group by to_char(order_date, 'yyyy-mm')
order by to_char(order_date, 'yyyy-mm')

--b) sprawdzenie czy ilosc sie sumuje poprawnie:
--tabela pomocnicza--
create view v5 as
select *,
count(*) over (partition by to_char(order_date, 'yyyy-mm')) as total_monthly,
case when avg_reference = 'less than avg' then 1 end as less_avg_counter,
case when avg_reference = 'equal to avg' then 1 end as equal_avg_counter,
case when avg_reference = 'more than avg' then 1 end as more_avg_counter,
case when mean_reference = 'less than mean' then 1 end as less_mean_counter,
case when mean_reference = 'equal to mean' then 1 end as equal_mean_counter,
case when mean_reference = 'more than mean' then 1 end as more_mean_counter
from v4
--drop view v5

--formula sprawdzajaca. patrz 2 ostatnie kolumny--
select distinct
to_char(order_date, 'yyyy-mm') as "period",
total_monthly,
sum(less_avg_counter) as less_avg_total,
sum(equal_avg_counter) as equal_avg_total,
sum(more_avg_counter) as more_avg_total,
sum(less_mean_counter) as less_mean_total,
sum(equal_mean_counter) as equal_mean_total,
sum(more_mean_counter) as more_mean_total,
case when total_monthly = (sum(less_avg_counter) + sum(more_avg_counter)) then 'ok' else 'error' end as avg_counter_check,
case when total_monthly = (sum(less_mean_counter) + sum(equal_mean_counter) + sum(more_mean_counter)) then 'ok' else 'error' end as mean_counter_check
from v5
group by v5.total_monthly, to_char(order_date, 'yyyy-mm')
order by to_char(order_date, 'yyyy-mm')


----------


