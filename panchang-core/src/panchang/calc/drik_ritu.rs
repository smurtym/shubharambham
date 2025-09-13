use crate::panchang::calc::VedicDay;
use crate::swe_wrapper::wrapper::*;
use crate::panchang::util::*;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {

    #[auto_bench_fct]
    pub fn drik_ritu(&self) -> (i32, i32) {

        let tropical_sun_eph = get_tropical_sun_ephemeris(self.sun_rise);

        let drik_ritu = (norm(tropical_sun_eph + 30.0) / 60.0).ceil() as i32;

        let ayana = if drik_ritu == 1 || drik_ritu == 2 || drik_ritu == 6 {
            1 // Uttarayana
        } else {
            2 // Dakshinayana
        };

        (drik_ritu, ayana)
        
    }
}