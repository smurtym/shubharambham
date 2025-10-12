use chrono::Datelike;
use chrono::{DateTime, NaiveDate, NaiveDateTime, TimeZone};
use chrono_tz::Tz;

use crate::eclipse::output_structure::EclipseDetails;
use crate::panchang::format_time::*;
use crate::panchang::output_structure::Location;
use crate::swe_wrapper::*;

pub fn calculate_eclipse(year: i32, lat: f64, lon: f64, timezone: Tz) -> Vec<EclipseDetails> {

    let mut eclipses: Vec<EclipseDetails> = Vec::new();

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

    let next_year_start: DateTime<Tz> = timezone
        .from_local_datetime(&next_year_start_date_time)
        .unwrap();

    // This failes in very very rare case, that is impossible(?) to happen
    // Just added in comments to explain the scenario
    // Imagine there is a solar eclipse happening on Jan 1st early morning
    // Location of eclipse is in southern hemisphere polar region 
    // Solar eclipse starts before midnight and ends after sunrise
    // This could happen because during Jan 1st, the sun will rise just after midnight in southern hemisphere polar region

    let year_start_jd = datetime_to_jd(year_start);
    let next_year_start_jd = datetime_to_jd(next_year_start);

    let year_start_sunrise_jd = rise_set(year_start_jd, SE_SUN, false, lat, lon);
    let next_year_start_sunrise_jd = rise_set(next_year_start_jd, SE_SUN, false, lat, lon);

    let mut search_from_jd = year_start_jd;

    loop {
        let eclipse_raw = solar_eclipse_when_loc(search_from_jd, lat, lon);

        if eclipse_raw.start_time_jd >= next_year_start_jd {
            break;
        }

        //println!("Eclipse Raw Data: {:?}", eclipse_raw);

        // Update search_from_jd to just after the end of this eclipse to find next eclipse
        search_from_jd = eclipse_raw.max_time_jd + 1.0;

        let eclipse = format_eclipse(eclipse_raw, lat, lon, timezone);
        eclipses.push(eclipse);

    }

    search_from_jd = year_start_sunrise_jd;

    loop {
        let eclipse_raw = lunar_eclipse_when_loc(search_from_jd, lat, lon);

        if eclipse_raw.start_time_jd >= next_year_start_sunrise_jd {
            break;
        }

        search_from_jd = eclipse_raw.max_time_jd + 1.0;

        // Ignore penumbral eclipses and continue
        // is_penumbral could be true only for lunar eclipses and null for solar eclipses
        match eclipse_raw.is_penumbral {
            Some(true) => continue,
            _ => {}
        }

        //println!("Eclipse Raw Data: {:?}", eclipse_raw);
        
        let eclipse = format_eclipse(eclipse_raw, lat, lon, timezone);
        eclipses.push(eclipse);
    }

    // Sort eclipses by date
    eclipses.sort_by_key(|e| e.date.clone());

    eclipses
}

pub fn get_nakshatra_pada_rasi(moon_ephemeris: f64) -> (i32, i32, i32) {
    let pada = (moon_ephemeris / (360.0 / 108.0)).floor() as i32; // 0 to 107
    let nakshatra = ((moon_ephemeris / (360.0 / 27.0)).floor() as i32) + 1; // 1 to 27
    let nakshatra_pada = (pada % 4) + 1; // 1 to 4
    let rasi = ((moon_ephemeris / (360.0 / 12.0)).floor() as i32) + 1; // 1 to 12

    (nakshatra, nakshatra_pada, rasi)
}

pub fn format_eclipse(eclipse_raw: RawEclipseData, lat: f64, lon: f64, timezone: Tz) -> EclipseDetails {

    let eclipse_date: DateTime<Tz>;
    let is_visible_next_day: bool;

    if eclipse_raw.is_solar {

        eclipse_date = jd_to_datetime(eclipse_raw.start_time_jd, timezone);

        // There could some edge cases
        // Imagine there is a solar eclipse starting just before sunset
        // It continuess after sunset, till sunrise next day
        // This could happen in polar regions at the time of solstice where we have very less night time
        // Until we have a proper way to handle this, we will ignore this edge case
        is_visible_next_day = false; 
    } else {
        // This logic is needed for lunar eclipses because the eclipse can start after midnight but still be counted as the previous day

        // Next sunrise after eclipse start time
        let eclipse_next_sunrise_jd = rise_set(eclipse_raw.start_time_jd, SE_SUN, false, lat, lon);
        // Substract 1 day to get the date of eclipse
        let eclipse_date_sunrise = jd_to_datetime(eclipse_next_sunrise_jd - 1.0, timezone);
        // Build eclipse_date from date part of eclipse_date_sunrise and timezone
        eclipse_date = timezone.with_ymd_and_hms(
            eclipse_date_sunrise.year(),
            eclipse_date_sunrise.month(),
            eclipse_date_sunrise.day(),
            0,
            0,
            0,
        ).unwrap();

        let eclipse_end_date = jd_to_datetime(eclipse_raw.end_time_jd, timezone);

        is_visible_next_day = eclipse_end_date.date_naive() != eclipse_date.date_naive();
    }

    let date = eclipse_date.format("%Y-%m-%d").to_string();
    let location = Location { lat: lat, lon: lon };

    let week_day = eclipse_date.weekday().number_from_sunday() as i32;

    let start_time = format_time(eclipse_date, eclipse_raw.start_time_jd);
    let max_time = format_time(eclipse_date, eclipse_raw.max_time_jd);
    let end_time = format_time(eclipse_date, eclipse_raw.end_time_jd);

    let rise_in_eclipse_time = match eclipse_raw.rise_time_jd {
        Some(rise_time_jd) => Some(format_time(eclipse_date, rise_time_jd)),
        None => None,
    };
    let set_in_eclipse_time = match eclipse_raw.set_time_jd {
        Some(set_time_jd) => Some(format_time(eclipse_date, set_time_jd)),
        None => None,
    };

    let moon_ephemeris_start = 
        get_moon_ephemeris(eclipse_raw.rise_time_jd.unwrap_or(eclipse_raw.start_time_jd));
    let moon_ephemeris_end = 
        get_moon_ephemeris(eclipse_raw.set_time_jd.unwrap_or(eclipse_raw.end_time_jd));

    let (start_nakshatra, start_nakshatra_pada, start_rasi) =
        get_nakshatra_pada_rasi(moon_ephemeris_start);
    let (end_nakshatra, end_nakshatra_pada, end_rasi) =
        get_nakshatra_pada_rasi(moon_ephemeris_end);

    let rahu_ephemeris = get_rahu_ephemeris(eclipse_raw.start_time_jd);
    let is_rahu = match (moon_ephemeris_start - rahu_ephemeris).abs() {
        diff if diff >= 90.0 && diff <= 270.0 => false,
        _ => true,
    };

    EclipseDetails {
        is_solar: eclipse_raw.is_solar,
        is_total: eclipse_raw.is_total,
        is_annular: eclipse_raw.is_annular,
        is_rahu,
        date,
        location,
        week_day,
        is_visible_next_day,
        start_time,
        max_time,
        end_time,
        is_start_visible: eclipse_raw.is_start_visible,
        is_end_visible: eclipse_raw.is_end_visible,
        start_nakshatra,
        start_nakshatra_pada,
        start_rasi,
        end_nakshatra,
        end_nakshatra_pada,
        end_rasi,
        rise_in_eclipse_time,
        set_in_eclipse_time,
    }
    
}