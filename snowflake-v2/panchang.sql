create or replace view panchang as
with smrs as (
select * from smrs_v2 where year(dt) = 2025 and city_id = 5277
),
mms as (
select city_id,
convert_timezone('UTC', c.tz, mms.dt) dt, mms.is_adhika, mms.is_nija, mms.is_kshaya, mms.masa
  from moon_masa_start mms cross join city_v2 c where c.is_active = true
),
ss as (
select city_id,
convert_timezone('UTC', c.tz, ss.dt) dt, ss.samvatsara
  from samvatsara_start ss cross join city_v2 c where c.is_active = true
),
dr as (
select city_id,
convert_timezone('UTC', c.tz, dr.dt) dt, dr.ritu
  from drik_ritu_start dr cross join city_v2 c where c.is_active = true
),
pr as (
select city_id,
convert_timezone('UTC', c.tz, pr.dt) dt, pr.purva_ritu
  from purva_ritu_start pr cross join city_v2 c where c.is_active = true
),
ay as (
select city_id,
convert_timezone('UTC', c.tz, ay.dt) dt, ay.ayana
  from ayana_start ay cross join city_v2 c where c.is_active = true
),
te as(
select  city_id,
convert_timezone('UTC', c.tz, te.dt) dt, te.thithi
  from thithi_end te cross join city_v2 c where c.is_active = true
),
ne as(
select city_id,
convert_timezone('UTC', c.tz, ne.dt) dt, ne.nakshatra
  from nakshatra_end ne cross join city_v2 c where c.is_active = true
),
vj as (
select city_id,
convert_timezone('UTC', c.tz, vj.dt) dt, vj.is_start
  from varjya vj cross join city_v2 c where c.is_active = true
)
select smrs.dt,
       date_part('dow', smrs.dt) as week_of_day,
       smrs.sun_rise,
       smrs.sun_set,
       smrs.moon_rise,
       smrs.moon_set,
       datediff(second, smrs.sun_rise, smrs.sun_set) as day_length_second,
       datediff(second, smrs.sun_set, smrs.next_day_sun_rise) as night_length_second,
       ss.samvatsara,
       ay.ayana,
       dr.ritu,
       pr.purva_ritu,
       mms.is_adhika,
       mms.is_nija,
       mms.is_kshaya,
       mms.masa,
       te1.thithi,
       ne1.nakshatra,
       array_agg(distinct OBJECT_CONSTRUCT('thithi', te2.thithi, 'end', te2.dt)) 
           within group (order by OBJECT_CONSTRUCT('thithi', te2.thithi, 'end', te2.dt):end) as thithi_array,
       array_agg(distinct OBJECT_CONSTRUCT('nakshatra', ne2.nakshatra, 'end', ne2.dt)) 
           within group (order by OBJECT_CONSTRUCT('nakshatra', ne2.nakshatra, 'end', ne2.dt):end) as nakshatra_array,
       array_agg(distinct OBJECT_CONSTRUCT('is_start', vj.is_start, 'dt', vj.dt)) 
           within group (order by OBJECT_CONSTRUCT('is_start', vj.is_start, 'dt', vj.dt):dt) as varjya_array,
       dateadd(second, dp.d1*day_length_second/15, smrs.sun_rise) as durmuhurtham1_start,
       dateadd(second, (dp.d1+1)*day_length_second/15, smrs.sun_rise) as durmuhurtham1_end,
       case 
         when dp.d2 between 0 and 15 then 
              dateadd(second, dp.d2*day_length_second/15, smrs.sun_rise)
         when dp.d2 > 15 then
                dateadd(second, (dp.d2 - 15)*night_length_second/15, smrs.sun_set)
         else null
       end as durmuhurtham2_start,
       case 
            when dp.d2 between 0 and 15 then 
                  dateadd(second, (dp.d2+1)*day_length_second/15, smrs.sun_rise)
            when dp.d2 > 15 then
                 dateadd(second, (dp.d2 - 15 + 1)*night_length_second/15, smrs.sun_set)
            else null
        end as durmuhurtham2_end,
        object_construct('durmuhurtham1_start', durmuhurtham1_start, 
          'durmuhurtham1_end', durmuhurtham1_end, 
          'durmuhurtham2_start', durmuhurtham2_start, 
          'durmuhurtham2_end', durmuhurtham2_end) as durmuhurtham
from smrs asof join mms
match_condition (smrs.sun_rise >= mms.dt) on (smrs.city_id = mms.city_id)
asof join ss
match_condition (smrs.sun_rise >= ss.dt) on (smrs.city_id = ss.city_id)
asof join dr
match_condition (smrs.sun_rise >= dr.dt) on (smrs.city_id = dr.city_id)
asof join pr
match_condition (smrs.sun_rise >= pr.dt) on (smrs.city_id = pr.city_id)
asof join ay
match_condition (smrs.sun_rise >= ay.dt) on (smrs.city_id = ay.city_id)
asof join te te1
match_condition (smrs.sun_rise <= te1.dt) on (smrs.city_id = te1.city_id)
asof join ne ne1
match_condition (smrs.sun_rise <= ne1.dt) on (smrs.city_id = ne1.city_id)
left join te te2
on te2.dt between smrs.sun_rise and smrs.next_day_sun_rise and te2.city_id = smrs.city_id
left join ne ne2
on ne2.dt between smrs.sun_rise and smrs.next_day_sun_rise and ne2.city_id = smrs.city_id
left join vj
on vj.dt between smrs.sun_rise and smrs.next_day_sun_rise and vj.city_id = smrs.city_id
inner join durmuhurtham_parts dp
on date_part('dow', smrs.dt) = dp.week
group by all
order by smrs.dt;

create or replace table panchang_hyd_2025 as select * from panchang;

select dt, 
sun_rise, format_time(dt, sun_rise) as sun_rise_str,
sun_set, format_time(dt, sun_set) as sun_set_str,
moon_rise, coalesce(format_time(dt, moon_rise), 'అవదు') as moon_rise_str,
moon_set, coalesce(format_time(dt, moon_set), 'అవదు') as moon_set_str,
' సూ.ఉ. ' || sun_rise_str || ' సూ.అ. ' || sun_set_str || 
' చం.ఉ. ' || moon_rise_str || ' చం.అ. ' || moon_set_str || 
' ' || yn.name || ' ' || an.name || ' ' || rn.name || 
' ' || mn.name || ' ' || tn1.paksha || ' ' || tn1.name as panchang,
case
        when thithi_array[0]:thithi is null then 'పూర్తి'
        when ARRAY_SIZE(thithi_array) = 1 then 
           format_time(dt, thithi_array[0]:end::timestamp)
        else 
            format_time(dt, thithi_array[0]:end::timestamp) || 
            ' ' ||
            tn2.name ||
            ' ' || format_time(dt, thithi_array[1]:end::timestamp)
end thithi_time,
nn1.name as nakshatra_name,
case
        when nakshatra_array[0]:nakshatra is null then 'పూర్తి'
        when ARRAY_SIZE(nakshatra_array) = 1 then 
           format_time(dt, nakshatra_array[0]:end::timestamp)
        else 
            format_time(dt, nakshatra_array[0]:end::timestamp) || 
            ' ' ||
            nn2.name ||
            ' ' || format_time(dt, nakshatra_array[1]:end::timestamp)
end nakshatra_time,
format_varjya(dt,varjya_array),
format_durmuhurtham(dt, durmuhurtham),
-- an.name, rn.name, mn.name, tn.paksha, tn.name,
object_construct(p.*)  from panchang_hyd_2025 p
inner join year_names yn on yn.id = samvatsara
inner join ayana_names an on an.id = ayana
inner join ritu_names rn on rn.id = ritu
inner join masa_names mn on mn.id = masa
inner join thithi_names tn1 on tn1.id = thithi
left join thithi_names tn2 on tn2.id = thithi_array[1]:thithi
inner join nakshatra_names nn1 on nn1.id = nakshatra
left join nakshatra_names nn2 on nn2.id = nakshatra_array[1]:nakshatra
order by dt;

select name from year_names where id = 38;

select dt, 
'సూ.ఉ. ' || format_time(dt, sun_rise) || ' సూ.అ. ' || format_time(dt, sun_set) || 
' చం.ఉ. ' || coalesce(format_time(dt, moon_rise), 'అవదు') || ' చం.అ. ' || coalesce(format_time(dt, moon_set), 'అవదు') || 
' ' || yn.name || ' ' || an.name || ' ' || rn.name || 
' ' || mn.name || ' ' || tn1.paksha || ' ' || tn1.name || ' ' ||
case
        when thithi_array[0]:thithi is null then 'పూర్తి'
        when ARRAY_SIZE(thithi_array) = 1 then 
           format_time(dt, thithi_array[0]:end::timestamp)
        else 
            format_time(dt, thithi_array[0]:end::timestamp) || 
            ' ' ||
            tn2.name ||
            ' ' || format_time(dt, thithi_array[1]:end::timestamp)
end || ' ' ||
nn1.name || ' ' ||
case
        when nakshatra_array[0]:nakshatra is null then 'పూర్తి'
        when ARRAY_SIZE(nakshatra_array) = 1 then 
           format_time(dt, nakshatra_array[0]:end::timestamp)
        else 
            format_time(dt, nakshatra_array[0]:end::timestamp) || 
            ' ' ||
            nn2.name ||
            ' ' || format_time(dt, nakshatra_array[1]:end::timestamp)
end || ' ' ||
'వర్జ్యం ' || format_varjya(dt,varjya_array) || ' ' || 
'దు. ' || format_durmuhurtham(dt, durmuhurtham) panchang
  from panchang_hyd_2025 p
inner join year_names yn on yn.id = samvatsara
inner join ayana_names an on an.id = ayana
inner join ritu_names rn on rn.id = ritu
inner join masa_names mn on mn.id = masa
inner join thithi_names tn1 on tn1.id = thithi
left join thithi_names tn2 on tn2.id = thithi_array[1]:thithi
inner join nakshatra_names nn1 on nn1.id = nakshatra
left join nakshatra_names nn2 on nn2.id = nakshatra_array[1]:nakshatra
order by dt;
