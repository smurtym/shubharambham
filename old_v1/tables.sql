drop table  moon_masa_starts;

create table moon_masa_starts as 
with 
amavasya_end_times as 
	(select t from thithi_ends where thithi_num = 30),
month_start_times as (
	select 
		t current_month_start, 
		lag(t) over (order by t) last_month_start ,
		lead(t) over (order by t) next_month_start
	from amavasya_end_times),
amavasya_sankramana_mapping as (
	select *, DATETIME(current_month_start) ,
		(select masa_num from nirayana_surya_starts where t > current_month_start order by t asc limit 1) next_sun_sankaramana,
		(select count(*) from nirayana_surya_starts where t between current_month_start and next_month_start) no_of_sankramana_current_month,
		(select count(*) from nirayana_surya_starts where t between last_month_start and current_month_start) no_of_sankramana_last_month
	from month_start_times
	where last_month_start is not null and next_month_start is not null
)
select 
current_month_start t,
next_sun_sankaramana  masa_num,
case when no_of_sankramana_current_month = 0 then true end is_adhika,
case when no_of_sankramana_last_month =0 then true end is_nija,
case when no_of_sankramana_current_month = 2 then true end is_kshaya
from amavasya_sankramana_mapping;

select * from moon_masa_starts;

drop table year_starts;

create table year_starts as
select
t, ( cast(strftime('%YYYY',t) as integer) - 7 ) % 60 + 1 year_num
from  moon_masa_starts where masa_num = 1 and is_nija is not true;

select * from year_starts;

drop table ayana_starts;
create table ayana_starts as 
select t,
(((masa_num - 4 + 12 ) % 12) / 6 + 1) % 2 + 1  ayana_num
from sayana_surya_starts
where (masa_num + - 4 + 12) % 6 = 0;

select * from ayana_starts;

drop table ritu_starts;
create table ritu_starts as 
select t,
(masa_num %12)/2 + 1 ritu_num 
from sayana_surya_starts  
where masa_num % 2 = 0;

select * from ritu_starts;


------------

drop table cities;
create table cities(city_id int, country_name text, city_name text, lat real, long real, tz text);

insert into cities values(1, 'India', 'హైదరాబాద్', 17.41, 78.47, 'Asia/Kolkata');
insert into cities values(2, 'India', 'విజయవాడ', 16.5, 80.65, 'Asia/Kolkata');
insert into cities values(3, 'India', 'ఏలూరు', 16.71, 81.1, 'Asia/Kolkata');
insert into cities values(4, 'India', 'రాజమండ్రి', 17, 81.8, 'Asia/Kolkata');
insert into cities values(5, 'USA', 'సియాటెల్', 47.7, -122.3, 'US/Pacific');

----------------

drop table durmuhurtham_parts;
create table durmuhurtham_parts(week int, d1 int, d2 int);
insert into durmuhurtham_parts values(0, 13, -1);
insert into durmuhurtham_parts values(1, 8, 11);
insert into durmuhurtham_parts values(2, 3, 21);
insert into durmuhurtham_parts values(3, 7, -1);
insert into durmuhurtham_parts values(4, 5, 11);
insert into durmuhurtham_parts values(5, 3, 8);
insert into durmuhurtham_parts values(6, 0, 1);

drop table daily_durmuhurtham;
create table daily_durmuhurtham as 
with day_with_durmuhurtham_parts as
(select dt, city_id, sunrise, sunset, next_sunrise, strftime('%w', dt) dd,
(select d1 from durmuhurtham_parts where week=strftime('%w', dt)) d1,
(select d2 from durmuhurtham_parts where week=strftime('%w', dt)) d2
from sun_moon_rise_set
),
calc_d as (
select 
dt, city_id,  
 sunrise + (sunset-sunrise)*d1/15 d1_start,
 sunrise + (sunset-sunrise)*(d1+1)/15 d1_end,
case 
 when d2 = -1 then null 
 when d2 > 15 then  sunset + (next_sunrise - sunset)*(d2 - 15)/15
 else  sunrise + (sunset-sunrise)*(d2)/15 
end d2_start,
case 
 when d2 = -1 then null 
 when d2 > 15 then sunset + (next_sunrise - sunset)*(d2+1 - 15)/15
 else sunrise + (sunset-sunrise)*(d2+1)/15 
end d2_end
from day_with_durmuhurtham_parts
)
select * from calc_d;

select * from daily_durmuhurtham;

 create index t1 on thithi_ends(t, thithi_num);
 create index n1 on nakshatra_ends(t, nakshatra_num);
 create index m1 on moon_masa_starts(t desc, is_adhika, is_nija, is_kshaya, masa_num);
 create index y1 on year_starts(t desc, year_num);
 create index a1 on ayana_starts(t desc, ayana_num);
 create index r1 on ritu_starts(t desc, ritu_num);
create index v1 on varjyam(t, is_end);


drop table daily_thithi;

create table daily_thithi as 
select city_id, dt,
(select year_num from year_starts where t < sunrise order by t desc limit 1) year_num,
(select ayana_num from ayana_starts where t < sunrise order by t desc limit 1) ayana_num,
(select ritu_num from ritu_starts where t < sunrise order by t desc limit 1) ritu_num,
(select is_adhika from moon_masa_starts where t < sunrise order by t desc limit 1) is_adhika,
(select is_nija from moon_masa_starts where t < sunrise order by t desc limit 1) is_nija,
(select is_kshaya from moon_masa_starts where t < sunrise order by t desc limit 1) is_kshaya,
(select masa_num from moon_masa_starts where t < sunrise order by t desc limit 1) masa_num,
(select thithi_num from thithi_ends where t > sunrise order by t asc limit 1) thithi1,
(select t from thithi_ends where t > sunrise and t < next_sunrise order by t asc limit 1) thithi1_end,
(select thithi_num from thithi_ends where t > sunrise and t < next_sunrise order by t asc limit 2 offset 1) thithi2,
(select t  from thithi_ends where t > sunrise and t < next_sunrise order by t asc limit 2 offset 1) thithi2_end,
(select nakshatra_num from nakshatra_ends where t > sunrise order by t asc limit 1) nakshatra1,
(select t from nakshatra_ends where t > sunrise and t < next_sunrise order by t asc limit 1) nakshatra1_end,
(select nakshatra_num from nakshatra_ends where t > sunrise and t < next_sunrise order by t asc limit 2 offset 1) nakshatra2,
(select t  from nakshatra_ends where t > sunrise and t < next_sunrise order by t asc limit 2 offset 1) nakshatra2_end
from sun_moon_rise_set;

drop table daily_varjyam;

create table daily_varjyam as 
with v1_unordered as (
select DATETIME(dt),  dt, city_id,
(select t from varjyam  where t > sunrise and t < next_sunrise and is_end = 0 order by t asc limit 1) v1_start,
(select t from varjyam  where t > sunrise and t < next_sunrise and is_end = 1 order by t asc limit 1) v1_end,
(select t from varjyam  where t > sunrise and t < next_sunrise and is_end = 0 order by t asc limit 2 offset 1) v2_start,
(select t from varjyam  where t > sunrise and t < next_sunrise and is_end = 1 order by t asc limit 2 offset 1) v2_end
from sun_moon_rise_set )
select city_id, dt, 
case when v1_start > v1_end then null else v1_start end v1_start,
v1_end,
case when v1_start > v1_end then v1_start else v2_start end v2_start,
v2_end
from v1_unordered;

select * from daily_varjyam;

drop table daily_panchang_utc;

create table daily_panchang_utc as 
select m.dt, m.city_id, c.tz, 
m.sunrise , m.sunset , m.moonrise , m.moonset, 
year_num, ayana_num, ritu_num, 
is_adhika, is_nija, is_kshaya, masa_num,
thithi1, thithi1_end, thithi2, thithi2_end, 
nakshatra1, nakshatra1_end, nakshatra2, nakshatra2_end,
v1_start, v1_end, v2_start, v2_end,
d1_start, d1_end, d2_start, d2_end
from sun_moon_rise_set m 
join cities c on m.city_id = c.city_id 
join daily_thithi on daily_thithi.dt = m.dt and daily_thithi.city_id = m.city_id 
join daily_durmuhurtham on daily_durmuhurtham.dt = m.dt and daily_durmuhurtham.city_id = m.city_id
join daily_varjyam on daily_varjyam.dt = m.dt and daily_varjyam.city_id = m.city_id;

