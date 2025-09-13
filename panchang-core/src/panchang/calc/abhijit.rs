
use chrono::Datelike;
use auto_bench_fct::auto_bench_fct;

use crate::panchang::format_time::*;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;

impl VedicDay {

    #[auto_bench_fct]
    pub fn abhijit(&self) -> Option<Abhijit> {

        let day_15th_part = (self.sun_set - self.sun_rise) / 15.0;
        let week_day = self.date.weekday().number_from_sunday() as i32;

        let abhijit = if week_day != 4 { // If not Wednesday
            let start_time = self.sun_rise + (day_15th_part * 7.0);
            let end_time = self.sun_rise + (day_15th_part * 8.0);
            Some(Abhijit {
                start_time: format_time(self.date, start_time),
                end_time: format_time(self.date, end_time),
            })
        } else { // If it is Wednesday, no Abhijit time 
            None
        };

        abhijit

    }
}