

create or replace table samvatsara_start as
select dt, (year(dt) - 7)%60 + 1 samvatsara from moon_masa_start where masa = 1 and is_nija != true order by dt;

create or replace table sayana_sun_masa_start as 
select e.dt, masa.i as masa
from eph e 
join table(generate_start_degrees(12)) masa
on 
    is_between(masa.start_degrees, 
                e.sun_before_30s,
                e.sun_after_30s
                )
order by e.dt;

create or replace table drik_ritu_start as
select dt, 
case 
  when masa = 12 then 1
  when masa = 2 then 2
  when masa = 4 then 3
  when masa = 6 then 4
  when masa = 8 then 5
  when masa = 10 then 6
end as ritu
 from sayana_sun_masa_start
where masa%2 = 0 order by dt;

create or replace table purva_ritu_start as
select dt,
case 
    when masa in (12, 1) then 1
    when masa in (2, 3) then 2
    when masa in (4, 5) then 3
    when masa in (6, 7) then 4
    when masa in (8, 9) then 5
    when masa in (10, 11) then 6
end as purva_ritu
from moon_masa_start
where 
(masa%2 = 1 and is_nija != true) or (masa%2 = 0 and is_kshaya = true) 
order by dt;

create or replace table ayana_start as
select dt, 
case 
  when masa = 4 then 2
  when masa = 10 then 1
end as ayana
 from sayana_sun_masa_start
where masa in (4, 10) order by dt;