use chrono_tz::Tz;
use chrono::{DateTime, NaiveDate, NaiveDateTime, TimeZone};

use crate::eclipse::output_structure::EclipseDetails;
use crate::swe_wrapper::*;

pub fn calc_eclipse(
    year: i32,
    lat: f64,
    lon: f64,
    timezone: Tz,
) -> Vec<EclipseDetails> {
    // Placeholder implementation
    // Convert year to Julian Day as of January 1st of that year in local time
    let year_start_date_time: NaiveDateTime = NaiveDate::from_ymd_opt(year, 1, 1)
        .unwrap()
        .and_hms_opt(0, 0, 0)
        .unwrap();

    let year_start: DateTime<Tz> = timezone.from_local_datetime(&year_start_date_time).unwrap();
    //add 1 year to get to next year
    let next_year_start_date_time: NaiveDateTime = NaiveDate::from_ymd_opt(year + 1, 1, 1)
       .unwrap()
       .and_hms_opt(0, 0, 0)
       .unwrap();
    let next_year_start: DateTime<Tz> = timezone.from_local_datetime(&next_year_start_date_time).unwrap();

    let year_start_jd = (year_start.timestamp() as f64) / 86400.0 + 2440587.5;
    let next_year_start_jd = (next_year_start.timestamp() as f64) / 86400.0 + 2440587.5;

    let year_start_sunrise_jd = rise_set(year_start_jd, SE_SUN, false, lat, lon);
    let next_year_start_sunrise_jd = rise_set(next_year_start_jd, SE_SUN, false, lat, lon);

    let (
        is_total, 
        is_annular, 
        start_time, 
        max_time, 
        end_time, 
        is_start_visible,
        is_end_visible, 
        sunrise_time, 
        sunset_time,
    ) = solar_eclipse_when_loc(year_start_jd, lat, lon);

    // print the results
    println!("Is Total: {}, Is Annular: {}, Start Time: {}, Max Time: {}, End Time: {}, Is Start Visible: {}, Is End Visible: {}, Sunrise Time: {:?}, Sunset Time: {:?}", 
        is_total, is_annular, start_time, max_time, end_time, is_start_visible, is_end_visible, sunrise_time, sunset_time);

    // Lunar eclipse test

    let (
        is_total,
        is_penumbral,
        start_time,
        max_time,
        end_time,
        is_start_visible,
        is_end_visible,
        moon_rise,
        moon_set,
    ) = lunar_eclipse_when_loc(year_start_sunrise_jd, lat, lon);

    // print the results
    println!("Is Total: {}, Is Penumbral: {}, Start Time: {}, Max Time: {}, End Time: {}, Is Start Visible: {}, Is End Visible: {}, Moon Rise: {:?}, Moon Set: {:?}", 
        is_total, is_penumbral, start_time, max_time, end_time, is_start_visible, is_end_visible, moon_rise, moon_set);

    vec![]

}