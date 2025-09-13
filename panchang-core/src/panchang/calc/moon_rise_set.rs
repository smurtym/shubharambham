use crate::swe_wrapper::wrapper::*;
use crate::panchang::output_structure::*;
use crate::panchang::format_time::*;
use crate::panchang::calc::VedicDay;


use auto_bench_fct::auto_bench_fct;



impl VedicDay {
    #[auto_bench_fct]
    pub fn moon_rise_set(&self, location: &Location) -> (Option<String>, Option<String>) {
        let mr = rise_set(self.sun_rise, SE_MOON, false, location.lat, location.lon);
        let ms = rise_set(self.sun_rise, SE_MOON, true, location.lat, location.lon);

        (
            if mr > self.next_sun_rise { None } else { Some(format_time(self.date, mr)) },
            if ms > self.next_sun_rise { None } else { Some(format_time(self.date, ms)) }
        )
    }
}