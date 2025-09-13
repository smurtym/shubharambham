use chrono::DateTime;

use chrono_tz::Tz;
use crate::panchang::output_structure::Location;
use crate::swe_wrapper::*;
use auto_bench_fct::auto_bench_fct;

pub struct VedicDay {
    pub date: DateTime<Tz>,
    pub sun_rise: f64,
    pub sun_set: f64,
    pub next_sun_rise: f64,
}

impl VedicDay {
    #[auto_bench_fct]
    pub fn new(date: DateTime<Tz>, location: &Location) -> Self {

        let timestamp = date.timestamp();

        let lat = location.lat;
        let lon = location.lon;

        let jd = (timestamp as f64) / 86400.0 + 2440587.5; // Convert to Julian Day Number
        let jd = jd - 0.25 ; // Substract 6 hours just incase the sun rises before midnight in polar regions

        set_ephe_path();

        let sun_rise = rise_set(jd, SE_SUN, false, lat, lon);
        let sun_set = rise_set(sun_rise, SE_SUN, true, lat, lon);
        let next_sun_rise = rise_set(sun_set, SE_SUN, false, lat, lon);

        VedicDay {
            date,
            sun_rise,
            sun_set,
            next_sun_rise,
        }
    
    }
 
}