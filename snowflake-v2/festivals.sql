select * from panchang;

select dt,
convert_timezone('UTC','Asia/Kolkata', dt) as dt_india,
convert_timezone('UTC','Asia/Kuala_Lumpur', dt) as dt_malaysia,
convert_timezone('UTC','US/Central', dt) as dt_central,
convert_timezone('UTC','US/Pacific', dt) as dt_pacific
 from nirayana_sun_masa_start where year(dt) = 2025 and masa = 10 order by dt;

 select * from city_v2 where is_active = true;
