use crate::panchang::format_time::*;
use crate::panchang::util::*;
use crate::swe_wrapper::wrapper::*;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;
use auto_bench_fct::auto_bench_fct;


impl VedicDay {
    #[auto_bench_fct]
    pub fn nakshatra(&self) -> Vec<Nakshatra> {

        let nakshatra_fn = |tjd_ut| get_moon_ephemeris(tjd_ut);
        let points = get_points_in_range(nakshatra_fn(self.sun_rise), nakshatra_fn(self.next_sun_rise), 27);

        let mut nakshatra: Vec<Nakshatra> = Vec::new();
        for point in points {
            if let Some(value) = point.1 {
                let solved_value = solve(|x| nakshatra_fn(x), value, self.sun_rise, self.next_sun_rise);
                nakshatra.push(Nakshatra {
                    id: point.0 as i32,
                    end_time: Some(format_time(self.date, solved_value)),
                });
            } else {
                nakshatra.push(Nakshatra {
                    id: point.0 as i32,
                    end_time: None,
                });
            }
        }

        nakshatra
    }
}