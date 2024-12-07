-- thithi calculations

select e.dt,
e.moon_before_30s, e.sun_before_30s, e.moon_after_30s , e.sun_after_30s,
e.moon_before_30s - e.sun_before_30s, e.moon_after_30s - e.sun_after_30s,
CONVERT_TIMEZONE('UTC','Asia/Kolkata', e.dt) as dt_india,
 thithi.i from eph e 
join table(generate_end_degrees(30)) thithi
on 
    is_between(thithi.end_degrees, 
                e.moon_before_30s - e.sun_before_30s,
                e.moon_after_30s - e.sun_after_30s
                )
where e.dt between '2024-11-01' and '2024-11-30';


create or replace table thithi_end as 
select e.dt, thithi.i as thithi
from eph e 
join table(generate_end_degrees(30)) thithi
on 
    is_between(thithi.end_degrees, 
                e.moon_before_30s - e.sun_before_30s,
                e.moon_after_30s - e.sun_after_30s
                )
;

select * from thithi_end where thithi = 30;

create or replace table nirayana_sun_masa_start as 
select e.dt, masa.i as masa
from eph e 
join table(generate_start_degrees(12)) masa
on 
    is_between(masa.start_degrees, 
                e.sun_before_30s - e.true_lahiri,
                e.sun_after_30s - e.true_lahiri
                )
order by e.dt;

create or replace table moon_masa_start as 
with amavasya as (
    select dt masa_start,
    lead(dt) over (order by dt) as masa_end
from thithi_end where thithi = 30
),
moon_masa_numbers as (
    select 
        array_agg(ns.masa) masa_numbers, 
        masa_start, 
        count(ns.masa) 
    from amavasya mm
    left join nirayana_sun_masa_start ns 
        on ns.dt between mm.masa_start and mm.masa_end
    group by  masa_start
),
moon_masa_numbers_with_masa_type as (
select 
    masa_numbers,
    masa_start,
    lead(masa_numbers) over (order by masa_start) as next_masa_numbers,
    lag(masa_numbers) over (order by masa_start) as prev_masa_numbers,
    case 
        when array_size(masa_numbers) > 0 then masa_numbers[0] 
        else next_masa_numbers[0] -- adhika masa number 
    end as moon_masa_number,
    (array_size(masa_numbers) = 0) as is_adhika,
    (array_size(prev_masa_numbers) = 0) as is_nija,
    (array_size(masa_numbers) = 2) as is_kshaya
 from moon_masa_numbers
  -- qualify is_adhika = true or is_nija = true or is_kshaya = true
 )
 select 
    masa_start dt, 
    moon_masa_number masa,
    is_adhika,
    is_nija,
    is_kshaya
 from moon_masa_numbers_with_masa_type
 order by masa_start;

select * from moon_masa_start;