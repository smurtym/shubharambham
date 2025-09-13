use crate::panchang::format_time::*;
use crate::panchang::calc::VedicDay;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {
    #[auto_bench_fct]
    pub fn sun_rise_set(&self) -> (String, String, String) {
        (
            format_time(self.date, self.sun_rise),
            format_time(self.date, self.sun_set),
            format_time(self.date, self.next_sun_rise)
        )
    }
}
