use crate::panchang::format_time::*;
use crate::swe_wrapper::wrapper::*;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;
use crate::panchang::util::*;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {
    #[auto_bench_fct]
    pub fn tithi_karana(&self) -> (Vec<Tithi>, Vec<Karana>) {
           
        let karana_fn = |tjd_ut| norm(get_moon_ephemeris(tjd_ut) - get_sun_ephemeris(tjd_ut));

        let points = get_points_in_range(karana_fn(self.sun_rise), karana_fn(self.next_sun_rise), 60);

        let mut karana: Vec<Karana> = Vec::new();
        for point in points {
            if let Some(value) = point.1 {
                let solved_value = solve(|x| karana_fn(x), value, self.sun_rise, self.next_sun_rise);
                karana.push(Karana {
                    id: point.0 as i32,
                    end_time: format_time(self.date, solved_value),
                });
            }
            // Not needed because there will be atleast one karana end in a day
            //  else {
            //     karana2.push(Karana {
            //         id: point.0 as i32,
            //         end_time: None,
            //     });
            // }
        }

        // Loop through the Karana vector, if id is even number then insert into thiti vector
        // But while inserting, if half the id.
        let tithi: Vec<Tithi> = karana.iter()
            .filter(|k| k.id % 2 == 0)
            .map(|k| Tithi {
                id: k.id / 2,
                end_time: Some(k.end_time.clone()),
            })
            .collect();
        
        // If there are no tithis, then insert first id of Karana vector/2 + 1 and None as end_time
        let tithi = if tithi.is_empty() {
            vec![Tithi {
                id: (karana[0].id / 2) + 1,
                end_time: None,
            }]
        } else {
            tithi
        };
    
        (tithi, karana)
    }
}