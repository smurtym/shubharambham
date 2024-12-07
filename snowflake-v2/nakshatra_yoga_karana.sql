create or replace table nakshatra_end as
select e.dt, nakshatra.i as nakshatra
from eph e 
join table(generate_end_degrees(27)) nakshatra
on 
    is_between(nakshatra.end_degrees, 
                e.moon_before_30s - e.true_chitra,
                e.moon_after_30s - e.true_chitra
                )
;

create or replace table karana_end as
select e.dt, karana.i as karana
from eph e
join table(generate_end_degrees(60)) karana
on 
    is_between(karana.end_degrees, 
                e.moon_before_30s - e.sun_before_30s,
                e.moon_after_30s - e.sun_after_30s
                );

select * from karana_end where karana = 60;

create or replace table yoga_end as
select e.dt, yoga.i as yoga
from eph e
join table(generate_end_degrees(27)) yoga
on 
    is_between(yoga.end_degrees, 
                normalize_angle(e.sun_before_30s - e.true_chitra) + normalize_angle(e.moon_before_30s - e.true_chitra),
                normalize_angle(e.sun_after_30s - e.true_chitra) + normalize_angle(e.moon_after_30s - e.true_chitra)
                );

select * from yoga_end where yoga = 27;