-- degrees	is_start
-- 11.11111111	TRUE
-- 18.66666667	TRUE
-- 33.33333333	TRUE
-- 48.88888889	TRUE
-- 56.44444444	TRUE
-- 71.33333333	TRUE
-- 86.66666667	TRUE
-- 97.77777778	TRUE
-- 113.7777778	TRUE
-- 126.6666667	TRUE
-- 137.7777778	TRUE
-- 150.6666667	TRUE
-- 164.6666667	TRUE
-- 177.7777778	TRUE
-- 189.7777778	TRUE
-- 203.1111111	TRUE
-- 215.5555556	TRUE
-- 229.7777778	TRUE
-- 252.4444444	TRUE
-- 258.6666667	TRUE
-- 271.1111111	TRUE
-- 282.2222222	TRUE
-- 295.5555556	TRUE
-- 310.6666667	TRUE
-- 323.5555556	TRUE
-- 338.6666667	TRUE
-- 353.3333333	TRUE
-- 12	FALSE
-- 19.55555556	FALSE
-- 34.22222222	FALSE
-- 49.77777778	FALSE
-- 57.33333333	FALSE
-- 72.22222222	FALSE
-- 87.55555556	FALSE
-- 98.66666667	FALSE
-- 114.6666667	FALSE
-- 127.5555556	FALSE
-- 138.6666667	FALSE
-- 151.5555556	FALSE
-- 165.5555556	FALSE
-- 178.6666667	FALSE
-- 190.6666667	FALSE
-- 204	FALSE
-- 216.4444444	FALSE
-- 230.6666667	FALSE
-- 253.3333333	FALSE
-- 259.5555556	FALSE
-- 272	FALSE
-- 283.1111111	FALSE
-- 296.4444444	FALSE
-- 311.5555556	FALSE
-- 324.4444444	FALSE
-- 339.5555556	FALSE
-- 354.2222222	FALSE

-- Select above data as a table

create or replace view varjya_degrees as
select 11.11111111 as degrees, TRUE as is_start union all
select 18.66666667, TRUE union all
select 33.33333333, TRUE union all
select 48.88888889, TRUE union all
select 56.44444444, TRUE union all
select 71.33333333, TRUE union all
select 86.66666667, TRUE union all
select 97.77777778, TRUE union all
select 113.7777778, TRUE union all
select 126.6666667, TRUE union all
select 137.7777778, TRUE union all
select 150.6666667, TRUE union all
select 164.6666667, TRUE union all
select 177.7777778, TRUE union all
select 189.7777778, TRUE union all
select 203.1111111, TRUE union all
select 215.5555556, TRUE union all
select 229.7777778, TRUE union all
select 252.4444444, TRUE union all
select 258.6666667, TRUE union all
select 271.1111111, TRUE union all
select 282.2222222, TRUE union all
select 295.5555556, TRUE union all
select 310.6666667, TRUE union all
select 323.5555556, TRUE union all
select 338.6666667, TRUE union all
select 353.3333333, TRUE union all
select 12, FALSE union all
select 19.55555556, FALSE union all
select 34.22222222, FALSE union all
select 49.77777778, FALSE union all
select 57.33333333, FALSE union all
select 72.22222222, FALSE union all
select 87.55555556, FALSE union all
select 98.66666667, FALSE union all
select 114.6666667, FALSE union all
select 127.5555556, FALSE union all
select 138.6666667, FALSE union all
select 151.5555556, FALSE union all
select 165.5555556, FALSE union all
select 178.6666667, FALSE union all
select 190.6666667, FALSE union all
select 204, FALSE union all
select 216.4444444, FALSE union all
select 230.6666667, FALSE union all
select 253.3333333, FALSE union all
select 259.5555556, FALSE union all
select 272, FALSE union all
select 283.1111111, FALSE union all
select 296.4444444, FALSE union all
select 311.5555556, FALSE union all
select 324.4444444, FALSE union all
select 339.5555556, FALSE union all
select 354.2222222, FALSE
;

select e.dt, 
convert_timezone('UTC', 'Asia/Kolkata', e.dt) as dt_india,
vd.is_start from varjya_degrees vd
join eph e on
    is_between(vd.degrees, 
                e.moon_before_30s - e.true_chitra,
                e.moon_after_30s - e.true_chitra
                )
where e.dt between '2024-12-01' and '2024-12-31' order by e.dt;

create or replace table varjya as
select e.dt, 
vd.is_start 
from varjya_degrees vd
join eph e on
    is_between(vd.degrees, 
                e.moon_before_30s - e.true_chitra,
                e.moon_after_30s - e.true_chitra
                )
;