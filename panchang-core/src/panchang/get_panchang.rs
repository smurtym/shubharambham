
use chrono::Datelike;
use crate::panchang::output_structure::*;
use chrono::NaiveDate;
use chrono_tz::Tz;

use crate::panchang::calc::VedicDay;
use auto_bench_fct::auto_bench_fct;


// It returns a PanchangData struct
#[auto_bench_fct]
pub fn calculate_panchang_data(plain_dt: NaiveDate, lat: f64, lon: f64, tz: Tz) -> PanchangData {

    let location = Location {
        lat: lat,
        lon: lon,
    };

    let date = plain_dt.and_hms_opt(0, 0, 0)
                            .unwrap()
                            .and_local_timezone(tz)
                            .unwrap();

    // Simple calculations first
    let dt = date.format("%Y-%m-%d").to_string();
    let yyyy = date.year().to_string();
    let mm = format!("{:02}", date.month());
    let dd = format!("{:02}", date.day());
    let week_day = date.weekday().number_from_sunday() as i32;
    let tz = date.timezone().name().to_string();

    let vedic_day = VedicDay::new(date, &location);

    let (sun_rise, sun_set, next_sun_rise) = vedic_day.sun_rise_set();
    let (moon_rise, moon_set) = vedic_day.moon_rise_set(&location);

    let (samvatsara, purva_ritu, masa) = vedic_day.masa();
    let (drik_ritu, ayana) = vedic_day.drik_ritu();

    let (tithi, karana) = vedic_day.tithi_karana();
    let nakshatra = vedic_day.nakshatra();
    let yoga = vedic_day.yoga();

    let varjya = vedic_day.varjya();
    let durmuhurtha = vedic_day.durmuhurtha();

    let abhijit = vedic_day.abhijit();
    let aparahna = vedic_day.aparahna();
    let rahukala = vedic_day.rahu_kala();
    let hora = vedic_day.hora();

    PanchangData {
        dt: dt,
        yyyy: yyyy,
        mm: mm,
        dd: dd, 
        tz: tz, 
        location: location,
        week_day: week_day, 
        sun_rise: sun_rise, 
        sun_set: sun_set, 
        moon_rise: moon_rise,
        moon_set: moon_set,
        next_sun_rise: next_sun_rise,
        samvatsara: samvatsara,
        ayana: ayana,
        drik_ritu: drik_ritu,
        purva_ritu: purva_ritu,
        masa: masa,
        tithi: tithi,
        nakshatra: nakshatra,
        karana: karana,
        yoga: yoga,
        varjya: varjya,
        durmuhurtha: durmuhurtha,
        abhijit: abhijit, 
        aparahna: aparahna, 
        rahu_kala: rahukala, 
        hora: hora 
    }
}

