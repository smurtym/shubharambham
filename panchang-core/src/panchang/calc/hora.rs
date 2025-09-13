use chrono::Datelike;

use crate::panchang::format_time::*;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {
    #[auto_bench_fct]
    pub fn hora(&self) -> Vec<Hora> {
            
    let week_day = self.date.weekday().number_from_sunday() as i32;

    let mut hora_lord = week_day;
    let mut hora = Vec::<Hora>::new();

    let day_12th_part = (self.sun_set - self.sun_rise) / 12.0;
    let night_12th_part = (self.next_sun_rise - self.sun_set) / 12.0;

    for hora_num in 0 .. 24 {

        let start_time;
        let end_time;

        if hora_num < 12 {
            start_time = self.sun_rise + (day_12th_part * (hora_num as f64));
            end_time = start_time + day_12th_part;
        } else {
            start_time = self.sun_set + (night_12th_part * ((hora_num - 12) as f64));
            end_time = start_time + night_12th_part;
        }

        hora.push(Hora {
            id: hora_lord,
            start_time: format_time(self.date, start_time),
            end_time: format_time(self.date, end_time),
        });
        
        // Formula for next hora lord
        hora_lord = (hora_lord + 4)%7 + 1;
    }

    hora
        
    }
}
