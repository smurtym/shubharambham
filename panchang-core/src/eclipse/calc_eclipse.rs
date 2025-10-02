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

    let eclipses: Vec<EclipseDetails> = Vec::new();

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

    loop {
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

        if start_time >= next_year_start_jd {
            break;
        }

//         pub struct EclipseDetails {
//     pub is_solar: bool,
//     pub is_total: bool,
//     pub is_annular: bool,
//     pub is_rahu: bool,
//     pub date: String, // YYYY-MM-DD format
//     pub location: Location,
//     pub week_day: i32, // 1=Sunday, 2=Monday, ..., 7=Saturday
//     pub is_visible_next_day: bool,
//     pub start_time: String, // HH24:MI format
//     pub max_time: String,  // HH24:MI format
//     pub end_time: String,   // HH24:MI format
//     pub is_start_visible: bool,
//     pub is_end_visible: bool,
//     pub start_nakshatra: i32,
//     pub start_nakshatra_pada: i32,
//     pub start_rasi: i32,
//     pub end_nakshatra: i32,
//     pub end_nakshatra_pada: i32,
//     pub end_rasi: i32,
//     pub rise_in_eclipse_time: Option<String>, // HH24:MI format or None
//     pub set_in_eclipse_time: Option<String>,  // HH24:MI format or None
// }
        let is_solar = true;
        let start_date = DateTime::from_timestamp(
                ((start_time - 2440587.5) * 86400.0).round() as i64, 
                0
            )
        .unwrap()
        .with_timezone(&timezone);

        let date = start_date.format("%Y-%m-%d").to_string();


    }
    

    // print the results
    // println!("Is Total: {}, Is Annular: {}, Start Time: {}, Max Time: {}, End Time: {}, Is Start Visible: {}, Is End Visible: {}, Sunrise Time: {:?}, Sunset Time: {:?}", 
    //     is_total, is_annular, start_time, max_time, end_time, is_start_visible, is_end_visible, sunrise_time, sunset_time);

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