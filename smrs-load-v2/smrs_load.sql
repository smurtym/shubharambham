select * from cities;

create or replace table city_v2 (
  city_id number,
  city_name string,
  country string,
  state string,
  lat double,
  long double,
  tz string,
  is_active boolean
);

-- select 500 random numbers between 2,000,000,000 and 3,000,000,000

insert into city_v2(city_id, is_active)
with radom_numbers as (
select uniform(1000, 9999, random()) as i
from table(generator(rowcount => 1500)))
select distinct i city_id, false from radom_numbers limit 1000;

select * from city_v2;

update city_v2
set 
    city_name = 'Hyderabad',
    country = 'India',
    state = 'Telangana',
    lat = 17.39,
    long = 78.47,
    tz = 'Asia/Kolkata',
    is_active = true
    where city_id = 5277;

update city_v2
set 
    city_name = 'Eluru',
    country = 'India',
    state = 'Andhra Pradesh',
    lat = 16.71,
    long = 81.11,
    tz = 'Asia/Kolkata',
    is_active = true
    where city_id = 8612;

update city_v2
set 
    city_name = 'George Town',
    country = 'Malaysia',
    state = 'Penang',
    lat = 5.41,
    long = 100.32,
    tz = 'Asia/Kuala_Lumpur',
    is_active = true
    where city_id = 7123;

update city_v2
set 
    city_name = 'Kuala Lumpur',
    country = 'Malaysia',
    state = 'Kuala Lumpur',
    lat = 3.16,
    long = 101.69,
    tz = 'Asia/Kuala_Lumpur',
    is_active = true
    where city_id = 2325;

select * from cities;

select * from city_v2 where city_id = 5277;


create or replace table smrs_v2 (
  CITY_ID number,
  DT date,
  SUN_RISE timestamp_ntz,
  SUN_SET timestamp_ntz,
  MOON_RISE timestamp_ntz,
  MOON_SET timestamp_ntz,
  NEXT_DAY_SUN_RISE timestamp_ntz
);

---

-- Create a stage @smrs_stage
create or replace stage smrs_stage;
  file_format = (type = 'CSV' compression = 'GZIP')
;

-- Copy data from local file to stage
put file:///astro/smrs_load_v2/data/5277.txt.gz @smrs_stage;
put file:///astro/smrs_load_v2/data/7123.txt.gz @smrs_stage;

select 
 t.$1 city_id,
 jd_to_date(t.$2) dt,
 convert_timezone('UTC', c.tz, jd_to_date(t.$3))  sun_rise,
 convert_timezone('UTC', c.tz, jd_to_date(t.$4))  sun_set,
 case when t.$5 != -1 then convert_timezone('UTC', c.tz, jd_to_date(t.$5)) else null end  moon_rise,
 case when t.$6 != -1 then convert_timezone('UTC', c.tz, jd_to_date(t.$6)) else null end  moon_set,
 convert_timezone('UTC', c.tz, jd_to_date(t.$7))  next_day_sun_rise
 from @smrs_stage t
 inner join city_v2 c on t.$1 = c.city_id;

-- Merge data from stage to smrs_v2 using city_id and dt as the merge keys 
merge into smrs_v2 t
using (
  select 
    t.$1 city_id,
    jd_to_date(t.$2) dt,
    convert_timezone('UTC', c.tz, jd_to_date(t.$3))  sun_rise,
    convert_timezone('UTC', c.tz, jd_to_date(t.$4))  sun_set,
    case when t.$5 != -1 then convert_timezone('UTC', c.tz, jd_to_date(t.$5)) else null end  moon_rise,
    case when t.$6 != -1 then convert_timezone('UTC', c.tz, jd_to_date(t.$6)) else null end  moon_set,
    convert_timezone('UTC', c.tz, jd_to_date(t.$7))  next_day_sun_rise
    from @smrs_stage t
    inner join city_v2 c on t.$1 = c.city_id
) s
on t.city_id = s.city_id and t.dt = s.dt
when matched then update set
  t.sun_rise = s.sun_rise,
  t.sun_set = s.sun_set,
  t.moon_rise = s.moon_rise,
  t.moon_set = s.moon_set,
  t.next_day_sun_rise = s.next_day_sun_rise
when not matched then insert (
  city_id,
  dt,
  sun_rise,
  sun_set,
  moon_rise,
  moon_set,
  next_day_sun_rise
) values (
  s.city_id,
  s.dt,
  s.sun_rise,
  s.sun_set,
  s.moon_rise,
  s.moon_set,
  s.next_day_sun_rise
);
