drop table  if exists moon_masa_starts;

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
	select * ,
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

drop table if exists year_starts;

create table year_starts as
select
t, ( extract (year from t) - 7 ) % 60 + 1 year_num
from  moon_masa_starts where masa_num = 1 and is_nija is not true;

drop table if exists ayana_starts;

create table ayana_starts as 
select t,
(((masa_num::int - 4 + 12 ) % 12) / 6 + 1) % 2 + 1  ayana_num
from sayana_surya_starts
where (masa_num::int + - 4 + 12) % 6 = 0;

drop table if exists ritu_starts;

create table ritu_starts as 
select t,
(masa_num::int %12)/2 + 1 ritu_num 
from sayana_surya_starts  
where masa_num::int % 2 = 0;

create index t1 on thithi_ends(t, thithi_num);
create index n1 on nakshatra_ends(t, nakshatra_num);
create index m1 on moon_masa_starts(t desc, is_adhika, is_nija, is_kshaya, masa_num);
create index y1 on year_starts(t desc, year_num);
create index a1 on ayana_starts(t desc, ayana_num);
create index r1 on ritu_starts(t desc, ritu_num);
create index v1 on varjyam(t, is_end);



CREATE OR REPLACE VIEW daily_panchang
AS WITH daily_thithi AS (
         SELECT smrs.city_id,
            smrs.dt,
            ( SELECT year_starts.year_num
                   FROM year_starts
                  WHERE year_starts.t < smrs.sunrise
                  ORDER BY year_starts.t DESC
                 LIMIT 1) AS year_num,
            ( SELECT ayana_starts.ayana_num
                   FROM ayana_starts
                  WHERE ayana_starts.t < smrs.sunrise
                  ORDER BY ayana_starts.t DESC
                 LIMIT 1) AS ayana_num,
            ( SELECT ritu_starts.ritu_num
                   FROM ritu_starts
                  WHERE ritu_starts.t < smrs.sunrise
                  ORDER BY ritu_starts.t DESC
                 LIMIT 1) AS ritu_num,
            ( SELECT moon_masa_starts.is_adhika
                   FROM moon_masa_starts
                  WHERE moon_masa_starts.t < smrs.sunrise
                  ORDER BY moon_masa_starts.t DESC
                 LIMIT 1) AS is_adhika,
            ( SELECT moon_masa_starts.is_nija
                   FROM moon_masa_starts
                  WHERE moon_masa_starts.t < smrs.sunrise
                  ORDER BY moon_masa_starts.t DESC
                 LIMIT 1) AS is_nija,
            ( SELECT moon_masa_starts.is_kshaya
                   FROM moon_masa_starts
                  WHERE moon_masa_starts.t < smrs.sunrise
                  ORDER BY moon_masa_starts.t DESC
                 LIMIT 1) AS is_kshaya,
            ( SELECT moon_masa_starts.masa_num
                   FROM moon_masa_starts
                  WHERE moon_masa_starts.t < smrs.sunrise
                  ORDER BY moon_masa_starts.t DESC
                 LIMIT 1) AS masa_num,
            ( SELECT thithi_ends.thithi_num
                   FROM thithi_ends
                  WHERE thithi_ends.t > smrs.sunrise
                  ORDER BY thithi_ends.t
                 LIMIT 1) AS thithi1,
            ( SELECT thithi_ends.t
                   FROM thithi_ends
                  WHERE thithi_ends.t > smrs.sunrise AND thithi_ends.t < smrs.next_sunrise
                  ORDER BY thithi_ends.t
                 LIMIT 1) AS thithi1_end,
            ( SELECT thithi_ends.thithi_num
                   FROM thithi_ends
                  WHERE thithi_ends.t > smrs.sunrise AND thithi_ends.t < smrs.next_sunrise
                  ORDER BY thithi_ends.t
                 OFFSET 1
                 LIMIT 2) AS thithi2,
            ( SELECT thithi_ends.t
                   FROM thithi_ends
                  WHERE thithi_ends.t > smrs.sunrise AND thithi_ends.t < smrs.next_sunrise
                  ORDER BY thithi_ends.t
                 OFFSET 1
                 LIMIT 2) AS thithi2_end,
            ( SELECT nakshatra_ends.nakshatra_num
                   FROM nakshatra_ends
                  WHERE nakshatra_ends.t > smrs.sunrise
                  ORDER BY nakshatra_ends.t
                 LIMIT 1) AS nakshatra1,
            ( SELECT nakshatra_ends.t
                   FROM nakshatra_ends
                  WHERE nakshatra_ends.t > smrs.sunrise AND nakshatra_ends.t < smrs.next_sunrise
                  ORDER BY nakshatra_ends.t
                 LIMIT 1) AS nakshatra1_end,
            ( SELECT nakshatra_ends.nakshatra_num
                   FROM nakshatra_ends
                  WHERE nakshatra_ends.t > smrs.sunrise AND nakshatra_ends.t < smrs.next_sunrise
                  ORDER BY nakshatra_ends.t
                 OFFSET 1
                 LIMIT 2) AS nakshatra2,
            ( SELECT nakshatra_ends.t
                   FROM nakshatra_ends
                  WHERE nakshatra_ends.t > smrs.sunrise AND nakshatra_ends.t < smrs.next_sunrise
                  ORDER BY nakshatra_ends.t
                 OFFSET 1
                 LIMIT 2) AS nakshatra2_end
           FROM smrs
        ), day_with_durmuhurtham_parts AS (
         SELECT smrs.dt,
            smrs.city_id,
            smrs.sunrise,
            smrs.sunset,
            smrs.next_sunrise,
            EXTRACT(dow FROM smrs.dt) AS dd,
            ( SELECT durmuhurtham_parts.d1
                   FROM durmuhurtham_parts
                  WHERE durmuhurtham_parts.week::numeric = EXTRACT(dow FROM smrs.dt)) AS d1,
            ( SELECT durmuhurtham_parts.d2
                   FROM durmuhurtham_parts
                  WHERE durmuhurtham_parts.week::numeric = EXTRACT(dow FROM smrs.dt)) AS d2
           FROM smrs
        ), daily_durmuhurtham AS (
         SELECT day_with_durmuhurtham_parts.dt,
            day_with_durmuhurtham_parts.city_id,
            day_with_durmuhurtham_parts.sunrise + (day_with_durmuhurtham_parts.sunset - day_with_durmuhurtham_parts.sunrise) * day_with_durmuhurtham_parts.d1::double precision / 15::double precision AS d1_start,
            day_with_durmuhurtham_parts.sunrise + (day_with_durmuhurtham_parts.sunset - day_with_durmuhurtham_parts.sunrise) * (day_with_durmuhurtham_parts.d1 + 1)::double precision / 15::double precision AS d1_end,
                CASE
                    WHEN day_with_durmuhurtham_parts.d2 = '-1'::integer THEN NULL::timestamp without time zone
                    WHEN day_with_durmuhurtham_parts.d2 > 15 THEN day_with_durmuhurtham_parts.sunset + (day_with_durmuhurtham_parts.next_sunrise - day_with_durmuhurtham_parts.sunset) * (day_with_durmuhurtham_parts.d2 - 15)::double precision / 15::double precision
                    ELSE day_with_durmuhurtham_parts.sunrise + (day_with_durmuhurtham_parts.sunset - day_with_durmuhurtham_parts.sunrise) * day_with_durmuhurtham_parts.d2::double precision / 15::double precision
                END AS d2_start,
                CASE
                    WHEN day_with_durmuhurtham_parts.d2 = '-1'::integer THEN NULL::timestamp without time zone
                    WHEN day_with_durmuhurtham_parts.d2 > 15 THEN day_with_durmuhurtham_parts.sunset + (day_with_durmuhurtham_parts.next_sunrise - day_with_durmuhurtham_parts.sunset) * (day_with_durmuhurtham_parts.d2 + 1 - 15)::double precision / 15::double precision
                    ELSE day_with_durmuhurtham_parts.sunrise + (day_with_durmuhurtham_parts.sunset - day_with_durmuhurtham_parts.sunrise) * (day_with_durmuhurtham_parts.d2 + 1)::double precision / 15::double precision
                END AS d2_end
           FROM day_with_durmuhurtham_parts
        ), daily_varjyam AS (
         WITH v1_unordered AS (
                 SELECT smrs.dt,
                    smrs.city_id,
                    ( SELECT varjyam.t
                           FROM varjyam
                          WHERE varjyam.t > smrs.sunrise AND varjyam.t < smrs.next_sunrise AND varjyam.is_end = 0::double precision
                          ORDER BY varjyam.t
                         LIMIT 1) AS v1_start,
                    ( SELECT varjyam.t
                           FROM varjyam
                          WHERE varjyam.t > smrs.sunrise AND varjyam.t < smrs.next_sunrise AND varjyam.is_end = 1::double precision
                          ORDER BY varjyam.t
                         LIMIT 1) AS v1_end,
                    ( SELECT varjyam.t
                           FROM varjyam
                          WHERE varjyam.t > smrs.sunrise AND varjyam.t < smrs.next_sunrise AND varjyam.is_end = 0::double precision
                          ORDER BY varjyam.t
                         OFFSET 1
                         LIMIT 2) AS v2_start,
                    ( SELECT varjyam.t
                           FROM varjyam
                          WHERE varjyam.t > smrs.sunrise AND varjyam.t < smrs.next_sunrise AND varjyam.is_end = 1::double precision
                          ORDER BY varjyam.t
                         OFFSET 1
                         LIMIT 2) AS v2_end
                   FROM smrs
                )
         SELECT v1_unordered.city_id,
            v1_unordered.dt,
                CASE
                    WHEN v1_unordered.v1_start > v1_unordered.v1_end THEN NULL::timestamp without time zone
                    ELSE v1_unordered.v1_start
                END AS v1_start,
            v1_unordered.v1_end,
                CASE
                    WHEN v1_unordered.v1_start > v1_unordered.v1_end THEN v1_unordered.v1_start
                    ELSE v1_unordered.v2_start
                END AS v2_start,
            v1_unordered.v2_end
           FROM v1_unordered
        ), daily_panchang AS (
         SELECT m.dt,
            m.city_id,
            m.year,
            c.tz,
            (m.dt AT TIME ZONE c.tz) AS dt_local,
            ((date_trunc('minute'::text, m.sunrise + '00:00:30'::interval) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS sunrise,
            ((date_trunc('minute'::text, m.sunset + '00:00:30'::interval) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS sunset,
            ((date_trunc('minute'::text, m.moonrise + '00:00:30'::interval) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS moonrise,
            ((date_trunc('minute'::text, m.moonset + '00:00:30'::interval) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS moonset,
            daily_thithi.year_num,
            daily_thithi.ayana_num,
            daily_thithi.ritu_num,
            daily_thithi.is_adhika,
            daily_thithi.is_nija,
            daily_thithi.is_kshaya,
            daily_thithi.masa_num,
            daily_thithi.thithi1,
            ((daily_thithi.thithi1_end AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS thithi1_end,
            daily_thithi.thithi2,
            ((daily_thithi.thithi2_end AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS thithi2_end,
            daily_thithi.nakshatra1,
            ((daily_thithi.nakshatra1_end AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS nakshatra1_end,
            daily_thithi.nakshatra2,
            ((daily_thithi.nakshatra2_end AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS nakshatra2_end,
            ((daily_varjyam.v1_start AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS v1_start,
            ((daily_varjyam.v1_end AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS v1_end,
            ((daily_varjyam.v2_start AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS v2_start,
            ((daily_varjyam.v2_end AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS v2_end,
            ((date_trunc('minute'::text, daily_durmuhurtham.d1_start + '00:00:30'::interval) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS d1_start,
            ((date_trunc('minute'::text, daily_durmuhurtham.d1_end + '00:00:30'::interval) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS d1_end,
            ((date_trunc('minute'::text, daily_durmuhurtham.d2_start + '00:00:30'::interval) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS d2_start,
            ((date_trunc('minute'::text, daily_durmuhurtham.d2_end + '00:00:30'::interval) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS d2_end
           FROM smrs m
             JOIN cities c ON m.city_id = c.city_id
             JOIN daily_thithi ON daily_thithi.dt = m.dt AND daily_thithi.city_id = m.city_id
             JOIN daily_durmuhurtham ON daily_durmuhurtham.dt = m.dt AND daily_durmuhurtham.city_id = m.city_id
             JOIN daily_varjyam ON daily_varjyam.dt = m.dt AND daily_varjyam.city_id = m.city_id
        )
 SELECT daily_panchang.dt,
    daily_panchang.city_id,
    daily_panchang.year,
    daily_panchang.tz,
    daily_panchang.dt_local,
    daily_panchang.sunrise,
    daily_panchang.sunset,
    daily_panchang.moonrise,
    daily_panchang.moonset,
    daily_panchang.year_num,
    daily_panchang.ayana_num,
    daily_panchang.ritu_num,
    daily_panchang.is_adhika,
    daily_panchang.is_nija,
    daily_panchang.is_kshaya,
    daily_panchang.masa_num,
    daily_panchang.thithi1,
    daily_panchang.thithi1_end,
    daily_panchang.thithi2,
    daily_panchang.thithi2_end,
    daily_panchang.nakshatra1,
    daily_panchang.nakshatra1_end,
    daily_panchang.nakshatra2,
    daily_panchang.nakshatra2_end,
    daily_panchang.v1_start,
    daily_panchang.v1_end,
    daily_panchang.v2_start,
    daily_panchang.v2_end,
    daily_panchang.d1_start,
    daily_panchang.d1_end,
    daily_panchang.d2_start,
    daily_panchang.d2_end
   FROM daily_panchang;


CREATE OR REPLACE VIEW formatted_panchang
AS SELECT daily_panchang.dt::date::text AS dt,
    ( SELECT (((EXTRACT(YEAR FROM daily_panchang.dt) || ' '::text) || emn.name::text) || ' '::text) || EXTRACT(DAY FROM daily_panchang.dt)
           FROM english_month_names emn
          WHERE emn.id::numeric = EXTRACT(MONTH FROM daily_panchang.dt)) AS english_date,
    daily_panchang.city_id,
    daily_panchang.year,
    time_formatter(daily_panchang.sunrise - daily_panchang.dt) AS sunrise,
    time_formatter(daily_panchang.sunset - daily_panchang.dt) AS sunset,
    COALESCE(time_formatter(daily_panchang.moonrise - daily_panchang.dt), 'అవదు'::character varying) AS moonrise,
    COALESCE(time_formatter(daily_panchang.moonset - daily_panchang.dt), 'అవదు'::character varying) AS moonset,
    ( SELECT year_names.name
           FROM year_names
          WHERE year_names.id::numeric = daily_panchang.year_num) AS year_name,
    ( SELECT ayana_names.name
           FROM ayana_names
          WHERE ayana_names.id = daily_panchang.ayana_num) AS ayana_name,
    ( SELECT ritu_names.name
           FROM ritu_names
          WHERE ritu_names.id = daily_panchang.ritu_num) AS ritu_name,
    ( SELECT ritu_names.name
           FROM ritu_names
          WHERE ritu_names.id::double precision = ceil(daily_panchang.masa_num / 2::double precision)) AS old_ritu_name,
    ((
        CASE
            WHEN daily_panchang.is_adhika THEN 'అధిక '::text
            ELSE ''::text
        END ||
        CASE
            WHEN daily_panchang.is_nija THEN 'నిజ '::text
            ELSE ''::text
        END) || ((( SELECT masa_names.name
           FROM masa_names
          WHERE masa_names.id::double precision = daily_panchang.masa_num))::text)) ||
        CASE
            WHEN daily_panchang.is_kshaya THEN ' క్షయ '::text || ((( SELECT masa_names.name
               FROM masa_names
              WHERE masa_names.id::double precision = (daily_panchang.masa_num + 1::double precision)))::text)
            ELSE ''::text
        END AS masa_name,
    (((( SELECT (thithi_names.paksha::text || ' '::text) || thithi_names.name::text
           FROM thithi_names
          WHERE thithi_names.id::double precision = daily_panchang.thithi1)) || ' '::text) || COALESCE(time_formatter(daily_panchang.thithi1_end - daily_panchang.dt), 'పూర్తి'::character varying)::text) ||
        CASE
            WHEN daily_panchang.thithi2 IS NOT NULL THEN (( SELECT (' '::text || thithi_names.name::text) || ' '::text
               FROM thithi_names
              WHERE thithi_names.id::double precision = daily_panchang.thithi2)) || time_formatter(daily_panchang.thithi2_end - daily_panchang.dt)::text
            ELSE ''::text
        END AS thithi,
    ((((( SELECT nakshatra_names.name
           FROM nakshatra_names
          WHERE nakshatra_names.id::double precision = daily_panchang.nakshatra1))::text) || ' '::text) || COALESCE(time_formatter(daily_panchang.nakshatra1_end - daily_panchang.dt), 'పూర్తి'::character varying)::text) ||
        CASE
            WHEN daily_panchang.nakshatra2 IS NOT NULL THEN (( SELECT (' '::text || nakshatra_names.name::text) || ' '::text
               FROM nakshatra_names
              WHERE nakshatra_names.id::double precision = daily_panchang.nakshatra2)) || time_formatter(daily_panchang.nakshatra2_end - daily_panchang.dt)::text
            ELSE ''::text
        END AS nakshatra,
    ( SELECT dn.name
           FROM day_names dn
          WHERE dn.id::numeric = (EXTRACT(DOW FROM daily_panchang.dt) + 1::numeric)) AS vara_name,
    ((((
        CASE
            WHEN daily_panchang.v1_start IS NULL AND daily_panchang.v1_end IS NULL THEN 'లేదు'::text
            ELSE ''::text
        END ||
        CASE
            WHEN daily_panchang.v1_start IS NULL AND daily_panchang.v1_end IS NOT NULL THEN 'శేషవర్జ్యం'::text
            ELSE ''::text
        END) ||
        CASE
            WHEN daily_panchang.v1_start IS NOT NULL THEN time_formatter(daily_panchang.v1_start - daily_panchang.dt)::text || ' ల.'::text
            ELSE ''::text
        END) ||
        CASE
            WHEN daily_panchang.v1_end IS NOT NULL THEN (' '::text || time_formatter(daily_panchang.v1_end - daily_panchang.dt)::text) || ' వ.'::text
            ELSE ''::text
        END) ||
        CASE
            WHEN daily_panchang.v2_start IS NOT NULL THEN (' '::text || time_formatter(daily_panchang.v2_start - daily_panchang.dt)::text) || ' ల.'::text
            ELSE ''::text
        END) ||
        CASE
            WHEN daily_panchang.v2_end IS NOT NULL THEN (' '::text || time_formatter(daily_panchang.v2_end - daily_panchang.dt)::text) || ' వ.'::text
            ELSE ''::text
        END AS varjyam,
    (((time_formatter(daily_panchang.d1_start - daily_panchang.dt)::text || ' ల. '::text) || time_formatter(daily_panchang.d1_end - daily_panchang.dt)::text) || ' వ.'::text) ||
        CASE
            WHEN daily_panchang.d2_start IS NOT NULL THEN (((' '::text || time_formatter(daily_panchang.d2_start - daily_panchang.dt)::text) || ' ల. '::text) || time_formatter(daily_panchang.d2_end - daily_panchang.dt)::text) || ' వ.'::text
            ELSE ''::text
        END AS durmuhurtham
   FROM daily_panchang;

-- formatted_eclipse source

CREATE OR REPLACE VIEW formatted_eclipse
AS WITH eclipse_list AS (
         SELECT c.city_id,
            c.category_id,
            c.category_name,
            er.moon_eph_start,
            er.moon_eph_end,
            er.eclipse_category,
            er.eclipse_type,
            c.tz,
            ((COALESCE(er.start_time_utc, er.rise_time_during_eclipse_utc) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS start_time,
            ((er.max_time_utc AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS max_time,
            ((COALESCE(er.end_time_utc, er.set_time_during_eclipse_utc) AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS end_time,
            er.is_start_visible,
            er.is_end_visible,
            ((er.rise_time_during_eclipse_utc AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS rise_time,
            ((er.set_time_during_eclipse_utc AT TIME ZONE 'utc'::text) AT TIME ZONE c.tz) AS set_time,
                CASE
                    WHEN abs(er.moon_eph_start - er.rahu_eph) >= 90::double precision AND abs(er.moon_eph_start - er.rahu_eph) <= 270::double precision THEN false
                    ELSE true
                END AS rahu
           FROM eclipse_raw er
             JOIN cities c ON er.city_id = c.city_id
        ), eclipse_list_with_start_dates AS (
         SELECT eclipse_list.start_time - eclipse_list.start_time::date::timestamp without time zone AS datepart,
            COALESCE(
                CASE
                    WHEN (eclipse_list.start_time - eclipse_list.start_time::date::timestamp without time zone) < '12:00:00'::interval AND eclipse_list.eclipse_category::text = 'Lunar'::text THEN eclipse_list.start_time::date - '1 day'::interval
                    ELSE eclipse_list.start_time::date::timestamp without time zone
                END, eclipse_list.max_time::date::timestamp without time zone) AS eclipse_date1,
            COALESCE(eclipse_list.start_time::date, eclipse_list.max_time::date) AS eclipse_date2,
            eclipse_list.city_id,
            eclipse_list.category_id,
            eclipse_list.category_name,
            eclipse_list.moon_eph_start,
            eclipse_list.moon_eph_end,
            eclipse_list.eclipse_category,
            eclipse_list.eclipse_type,
            eclipse_list.tz,
            eclipse_list.start_time,
            eclipse_list.max_time,
            eclipse_list.end_time,
            eclipse_list.is_start_visible,
            eclipse_list.is_end_visible,
            eclipse_list.rise_time,
            eclipse_list.set_time,
            eclipse_list.rahu
           FROM eclipse_list
        )
 SELECT eclipse_list_with_start_dates.city_id,
    EXTRACT(year FROM eclipse_list_with_start_dates.eclipse_date1) AS year,
    eclipse_list_with_start_dates.eclipse_date1,
    eclipse_list_with_start_dates.eclipse_date2,
    eclipse_list_with_start_dates.rahu,
    ((((((EXTRACT(year FROM eclipse_list_with_start_dates.eclipse_date1) || ' '::text) || ((( SELECT english_month_names.name
           FROM english_month_names
          WHERE english_month_names.id::numeric = EXTRACT(month FROM eclipse_list_with_start_dates.eclipse_date1)))::text)) || ' '::text) || EXTRACT(day FROM eclipse_list_with_start_dates.eclipse_date1)) || ' '::text) || (( SELECT day_names.telugu_name::text || 'వారం'::text
           FROM day_names
          WHERE day_names.id::numeric = (EXTRACT(dow FROM eclipse_list_with_start_dates.eclipse_date1) + 1::numeric)))) ||
        CASE
            WHEN eclipse_list_with_start_dates.eclipse_date1 <> eclipse_list_with_start_dates.eclipse_date2 THEN ( SELECT (' (తెల్లవారితే '::text || day_names.telugu_name::text) || 'వారం)'::text
               FROM day_names
              WHERE day_names.id::numeric = (EXTRACT(dow FROM eclipse_list_with_start_dates.eclipse_date2) + 1::numeric))
            ELSE ' '::text
        END AS eclipse_telugu_day,
    eclipse_list_with_start_dates.eclipse_category,
    eclipse_list_with_start_dates.eclipse_type,
    ((((
        CASE
            WHEN eclipse_list_with_start_dates.rahu THEN 'రాహుగ్రస్త '::text
            ELSE 'కేతుగ్రస్త '::text
        END ||
        CASE
            WHEN NOT eclipse_list_with_start_dates.is_start_visible THEN 'గ్రస్తోదయ '::text
            ELSE ''::text
        END) ||
        CASE
            WHEN NOT eclipse_list_with_start_dates.is_end_visible THEN 'గ్రస్తాస్తమయ '::text
            ELSE ''::text
        END) ||
        CASE eclipse_list_with_start_dates.eclipse_type
            WHEN 'Partial'::text THEN 'పాక్షిక '::text
            WHEN 'Total'::text THEN 'సంపూర్ణ '::text
            WHEN 'Annular'::text THEN 'కంకణాకార '::text
            ELSE NULL::text
        END) ||
        CASE eclipse_list_with_start_dates.eclipse_category
            WHEN 'Solar'::text THEN 'సూర్య'::text
            WHEN 'Lunar'::text THEN 'చంద్ర'::text
            ELSE NULL::text
        END) || ' గ్రహణం'::text AS eclipse_desc,
    format_eclipse_nakshatra_pada(eclipse_list_with_start_dates.moon_eph_start, eclipse_list_with_start_dates.moon_eph_end) AS nakshatra_details,
        CASE
            WHEN eclipse_list_with_start_dates.eclipse_category::text = 'Solar'::text OR eclipse_list_with_start_dates.eclipse_category::text = 'Lunar'::text AND eclipse_list_with_start_dates.is_start_visible THEN time_formatter(eclipse_list_with_start_dates.start_time - eclipse_list_with_start_dates.eclipse_date1)::text || ' '::text
            ELSE ''::text
        END ||
        CASE
            WHEN NOT eclipse_list_with_start_dates.is_start_visible THEN 'కనిపించదు'::text
            ELSE ''::text
        END AS sparsha_kala,
    eclipse_list_with_start_dates.is_start_visible,
    time_formatter(
        CASE
            WHEN eclipse_list_with_start_dates.is_start_visible THEN eclipse_list_with_start_dates.start_time
            ELSE eclipse_list_with_start_dates.rise_time
        END - eclipse_list_with_start_dates.eclipse_date1)::text ||
        CASE
            WHEN eclipse_list_with_start_dates.is_start_visible THEN ' (స్పర్శకాలం) నుండి'::text
            ELSE
            CASE eclipse_list_with_start_dates.eclipse_category
                WHEN 'Solar'::text THEN ' (సూర్యోదయం) నుండి'::text
                WHEN 'Lunar'::text THEN ' (చంద్రోదయం) నుండి'::text
                ELSE NULL::text
            END
        END AS visible_start,
    time_formatter(
        CASE
            WHEN eclipse_list_with_start_dates.is_end_visible THEN eclipse_list_with_start_dates.end_time
            ELSE eclipse_list_with_start_dates.set_time
        END - eclipse_list_with_start_dates.eclipse_date1)::text ||
        CASE
            WHEN eclipse_list_with_start_dates.is_end_visible THEN ' (ఉన్మీలనకాలం) వరకు'::text
            ELSE
            CASE eclipse_list_with_start_dates.eclipse_category
                WHEN 'Solar'::text THEN ' (సూర్యాస్తమయం) వరకు'::text
                WHEN 'Lunar'::text THEN ' (చంద్రాస్తమయం) వరకు'::text
                ELSE NULL::text
            END
        END AS visible_end,
    time_formatter(eclipse_list_with_start_dates.max_time - eclipse_list_with_start_dates.eclipse_date1) AS madhya_kala,
    eclipse_list_with_start_dates.is_end_visible,
        CASE
            WHEN eclipse_list_with_start_dates.eclipse_category::text = 'Solar'::text OR eclipse_list_with_start_dates.eclipse_category::text = 'Lunar'::text AND eclipse_list_with_start_dates.is_end_visible THEN time_formatter(eclipse_list_with_start_dates.end_time - eclipse_list_with_start_dates.eclipse_date1)::text || ' '::text
            ELSE ''::text
        END ||
        CASE
            WHEN NOT eclipse_list_with_start_dates.is_end_visible THEN 'కనిపించదు'::text
            ELSE ''::text
        END AS unmeelana_kala,
    time_formatter(eclipse_list_with_start_dates.rise_time - eclipse_list_with_start_dates.eclipse_date1) AS formatted_rise_time,
    time_formatter(eclipse_list_with_start_dates.set_time - eclipse_list_with_start_dates.eclipse_date1) AS formatted_set_time,
    eclipse_list_with_start_dates.start_time,
    eclipse_list_with_start_dates.end_time,
    eclipse_list_with_start_dates.max_time,
    eclipse_list_with_start_dates.rise_time,
    eclipse_list_with_start_dates.set_time
   FROM eclipse_list_with_start_dates;

CREATE OR REPLACE VIEW json_eclipse_data
AS SELECT formatted_eclipse.city_id,
    formatted_eclipse.year,
    row_number() OVER (PARTITION BY formatted_eclipse.city_id, formatted_eclipse.year ORDER BY formatted_eclipse.eclipse_date1) AS eclipse_num,
    json_strip_nulls(json_build_object('ఆంగ్ల తేది', formatted_eclipse.eclipse_telugu_day, 'గ్రహణ వివరణ ', formatted_eclipse.eclipse_desc, 'నక్షత్రం - రాశి ', formatted_eclipse.nakshatra_details, 'స్పర్శకాలం ', formatted_eclipse.sparsha_kala,
        CASE formatted_eclipse.eclipse_category
            WHEN 'Solar'::text THEN 'సూర్యోదయం'::text
            WHEN 'Lunar'::text THEN 'చంద్రోదయం'::text
            ELSE NULL::text
        END, formatted_eclipse.formatted_rise_time, 'గ్రహణం కనిపించడం మొదలు ', formatted_eclipse.visible_start, 'మధ్యకాలం ', formatted_eclipse.madhya_kala,
        CASE formatted_eclipse.eclipse_category
            WHEN 'Solar'::text THEN 'సూర్యాస్తమయం'::text
            WHEN 'Lunar'::text THEN 'చంద్రాస్తమయం'::text
            ELSE NULL::text
        END, formatted_eclipse.formatted_set_time, 'గ్రహణం కనిపించడం ముగింపు ', formatted_eclipse.visible_end, 'ఉన్మీలనకాలం ', formatted_eclipse.unmeelana_kala)) AS json_data
   FROM formatted_eclipse;

-- Now the actual tables needed for API service are getting created. 

drop table if exists formatted_panchang_mv1;
create table formatted_panchang_mv1 as select * from formatted_panchang;

drop table  if exists json_eclipse_data_mv;
create table json_eclipse_data_mv as select * from json_eclipse_data;
