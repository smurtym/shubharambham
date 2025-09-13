use std::collections::HashMap;
use chrono::Datelike;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;

use crate::panchang::format_time::*;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {
    #[auto_bench_fct]
    pub fn rahu_kala(&self) -> RahuKala {

        let week_day = self.date.weekday().number_from_sunday() as i32;
        
        let day_8th_part = (self.sun_set - self.sun_rise) / 8.0;
        let rahukala_parts: HashMap<i32, i32> = 
           [
               (1, 7),
               (2, 1),
               (3, 6),
               (4, 4),
               (5, 5),
               (6, 3),
               (7, 2),
            ].iter().cloned().collect(); 
        
        let rahukala_start = self.sun_rise + (day_8th_part * ((rahukala_parts.get(&week_day).unwrap() + 0) as f64));
        let rahukala_end   = self.sun_rise + (day_8th_part * ((rahukala_parts.get(&week_day).unwrap() + 1) as f64)); 
        
        RahuKala {
            start_time: format_time(self.date, rahukala_start),
            end_time: format_time(self.date, rahukala_end),
        }
        
    }
}