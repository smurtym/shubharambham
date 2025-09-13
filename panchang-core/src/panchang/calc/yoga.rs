use crate::panchang::format_time::*;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;
use crate::panchang::util::*;
use crate::swe_wrapper::wrapper::*;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {
    #[auto_bench_fct]
    pub fn yoga(&self) -> Vec<Yoga> {

        let yoga_fn = |tjd_ut| norm(get_moon_ephemeris(tjd_ut) + get_sun_ephemeris(tjd_ut));
        let points = get_points_in_range(yoga_fn(self.sun_rise), yoga_fn(self.next_sun_rise), 27);

        let mut yoga: Vec<Yoga> = Vec::new();
        for point in points {
            if let Some(value) = point.1 {
                let solved_value = solve(|x| yoga_fn(x), value, self.sun_rise, self.next_sun_rise);
                yoga.push(Yoga {
                    id: point.0 as i32,
                    end_time: Some(format_time(self.date, solved_value)),
                });
            } else {
                yoga.push(Yoga {
                    id: point.0 as i32,
                    end_time: None,
                });
            }
        }

        yoga
    }
}