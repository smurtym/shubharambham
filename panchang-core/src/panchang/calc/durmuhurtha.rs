
use std::collections::HashMap;
use chrono::Datelike;

use crate::panchang::format_time::*;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {
    #[auto_bench_fct]
    pub fn durmuhurtha(&self) -> Vec<Durmuhurtha> {
            
        let week_day = self.date.weekday().number_from_sunday() as i32;

        let durmuhurtham_parts: HashMap<i32, Vec<i32>> = 
           // Initialize the map with the values
           [
               (1, vec![13]),
               (2, vec![8, 11]),
               (3, vec![3, 21]),
               (4, vec![7]),
               (5, vec![5, 11]),
               (6, vec![3, 8]),
               (7, vec![0, 1]),
            ].iter().cloned().collect();

        let mut durmuhurtha = Vec::<Durmuhurtha>::new();

        let sun_rise = self.sun_rise;
        let sun_set = self.sun_set;
        let next_sun_rise = self.next_sun_rise;

        let day_15th_part = (sun_set - sun_rise) / 15.0;
        let night_15th_part = (next_sun_rise - sun_set) / 15.0;

        // Fetch Durmuhurtha parts for a weekday as a vector
        for i in durmuhurtham_parts.get(&week_day).unwrap() {
            // print!("Durmuhurtham parts for weekday {}: {:?}\n", week_day, i);
            let start_time;
            let end_time;
            // If i is less than 15, then it is day time, else it is night time
            if *i < 15 {
                start_time = sun_rise + (day_15th_part * (*i as f64));
                end_time = start_time + day_15th_part;
            } else {
                start_time = sun_set + (night_15th_part * ((*i - 15) as f64));
                end_time = start_time + night_15th_part;
            }
            durmuhurtha.push(Durmuhurtha {
                    start_time: format_time(self.date, start_time),
                    end_time: format_time(self.date, end_time),
                });
        }

        durmuhurtha
  
    }
}