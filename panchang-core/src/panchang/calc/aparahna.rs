
use crate::panchang::format_time::*;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {
    #[auto_bench_fct]
    pub fn aparahna(&self) -> Aparahna {

        let day_5th_part = (self.sun_set - self.sun_rise) / 5.0;
        let aparahna_start = self.sun_rise + (day_5th_part * 3.0);
        let aparahna_end = self.sun_rise + (day_5th_part * 4.0);

        Aparahna {
            start_time: format_time(self.date, aparahna_start),
            end_time: format_time(self.date, aparahna_end),
        }
        
    }
}