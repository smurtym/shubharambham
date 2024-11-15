select DATE_PART(epoch_second, '1900-01-01 12:00:00'::timestamp) - 2415021.0 * 86400;

create or replace function jd_to_date(jd double)
returns TIMESTAMP_NTZ(0)
as
$$
 TO_TIMESTAMP(round(jd * 86400)::integer - 210866760000)
$$;

select jd_to_date(2488799.49930556);

select * from eph_raw order by jd desc limit 10;


create or replace function normalize_angle(angle float)
returns float
as 
$$
   case 
      when angle < 0 then angle + 360
      when angle >= 360 then angle - 360
      else angle
   end
$$;

select normalize_angle(-90.12), normalize_angle(450.12), normalize_angle(0.0), normalize_angle(360.0), normalize_angle(359.99),
normalize_angle(360.01), normalize_angle(72.54), normalize_angle(0.01), normalize_angle(-359.99);

create or replace function is_between(angle float, start_angle float, end_angle float)
returns boolean
as
$$
   case
      when normalize_angle(start_angle) > normalize_angle(end_angle) then
         (normalize_angle(angle) >= normalize_angle(start_angle) or normalize_angle(angle) <= normalize_angle(end_angle))
      else
         (normalize_angle(angle) >= normalize_angle(start_angle) and normalize_angle(angle) <= normalize_angle(end_angle))
   end
$$;

select 
    is_between(17.1, 11.1, 20.1),
    is_between(17.1, 20.1, 11.1),
    is_between(17.1, 20.1, 17.1),
    is_between(17.1, 17.1, 20.1),
    is_between(17.1, 17.1, 17.1),
    is_between(17.1, 17.01, 360.1),
    is_between(17.1, 27.2, 20.5),
    is_between(17.1, -17.5, 17.2);
