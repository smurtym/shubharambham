-- create a function that takes 2 parameters 
-- 1. date 2. timestamp
-- returns a string
-- language sql

create or replace function format_time(d date, t timestamp)
returns string
language sql
as
$$
select prefix || hh_str || ':' || mm_str from (
select 
    case 
        when t is null 
          then null
        else 
          datediff('second', d, t)
    end s,
    round(s/60.0) as m,
    trunc(m/60.0) as hh,
    m - hh*60 as mm,
    case 
      when hh < 12 then 'ఉ. '
      when hh >= 12 and hh < 16 then 'మ. '
      when hh >= 16 and hh < 20 then 'సా. '
      when hh >= 20 and hh < 24 then 'రా. '
      else 'తె. '
    end prefix,
    to_char((hh-1)%12+1, 'fm00') as hh_str,
    to_char(mm, 'fm00') as mm_str
    )
$$;
 
select format_time('2025-01-01', '2025-01-02 02:21:00');

-- varjya formatter
create or replace function format_varjya(d date, v array)
returns string
language sql
as
$$
select
    case 
        when v[0]:dt is null then 'లేదు' 
        else ''
    end ||
    case
        when v[0]:is_start = false then 'శేషవర్జ్యం ' || format_time(d, v[0]:dt::timestamp) || ' వ.'
        else ''
    end ||
    case
        when v[0]:is_start = true then format_time(d, v[0]:dt::timestamp) || ' ల.'
        else ''
    end ||
    case
        when array_size(v) >= 1 and v[1]:is_start = false then ' ' || format_time(d, v[1]:dt::timestamp) || ' వ.'
        else ''
    end ||
    case
        when array_size(v) >= 1 and v[1]:is_start = true then ' ' || format_time(d, v[1]:dt::timestamp) || ' ల.'
        else ''
    end ||
    case
        when array_size(v) >= 2 and v[2]:is_start = false then ' ' || format_time(d, v[2]:dt::timestamp) || ' వ.'
        else ''
    end ||
    case
        when array_size(v) >= 2 and v[2]:is_start = true then ' ' || format_time(d, v[2]:dt::timestamp) || ' ల.'
        else ''
    end ||
    case
        when array_size(v) >= 3 and v[3]:is_start = false then ' ' || format_time(d, v[3]:dt::timestamp) || ' వ.'
        else ''
    end ||
    case
        when array_size(v) >= 3 and v[3]:is_start = true then ' ' || format_time(d, v[3]:dt::timestamp) || ' ల.'
        else ''
    end 
        
    
$$;


select dt, varjya_array, format_varjya(dt,varjya_array) from panchang_hyd_2025 order by dt;

create or replace function format_durmuhurtham(d date, durmuhurtham variant)
returns string
language sql
as
$$
select 
    format_time(d, durmuhurtham:durmuhrtham1_start) || ' ల.' || ' ' ||
    format_time(d, durmuhurtham:durmuhurtham1_end) || ' వ.' || 
    case
        when durmuhurtham:durmuhurtham2_start is not null then 
            ' ' || format_time(d, durmuhurtham:durmuhurtham2_start) || ' ల.' || ' ' ||
            format_time(d, durmuhurtham:durmuhurtham2_end) || ' వ.'
        else ''
    end
$$;

select dt, durmuhurtham, format_durmuhurtham(dt, durmuhurtham) from panchang_hyd_2025 order by dt;