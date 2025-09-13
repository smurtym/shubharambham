use crate::panchang::format_time::*;
use crate::panchang::calc::VedicDay;
use crate::panchang::output_structure::*;
use crate::panchang::util::*;
use crate::swe_wrapper::wrapper::*;
use auto_bench_fct::auto_bench_fct;

impl VedicDay {
    #[auto_bench_fct]
    pub fn varjya(&self) -> Vec<Varjya> {
        
        let varjya_points = get_varjya_points_in_range(
                    get_moon_ephemeris(self.sun_rise), 
                    get_moon_ephemeris(self.next_sun_rise)
                );

        let mut varjya_data: Vec<(f64, bool)> = Vec::new();
        for point in varjya_points {
            // println!("Varjya Point: {:?}", point);
            let solved_value = solve(|x| norm(get_moon_ephemeris(x)), point.0, self.sun_rise, self.next_sun_rise);
            varjya_data.push((solved_value, point.1));
        }

        let date = self.date;
        // Convert varjya_data to Vec<Varjya>
        let varjya = 
        match varjya_data.len() {
            0 => Vec::<Varjya>::new(), // No varjya data on this day
            1 => {
                // If is_start boolean of varjya_data is true,
                if varjya_data[0].1 {
                    vec![Varjya {
                        start_time: Some(format_time(date, varjya_data[0].0)),
                        end_time: None,
                    }]
                } else {
                    vec![Varjya {
                        start_time: None,
                        end_time: Some(format_time(date, varjya_data[0].0)),
                    }]
                } 
            }
            2 => {
                // If is_start boolean of varjya_data is true,
                if varjya_data[0].1 {
                    vec![Varjya {
                        start_time: Some(format_time(date, varjya_data[0].0)),
                        end_time: Some(format_time(date, varjya_data[1].0)),
                    }]
                } else {
                    vec![Varjya {
                        start_time: None,
                        end_time: Some(format_time(date, varjya_data[0].0)),
                    }, Varjya {
                        start_time: Some(format_time(date, varjya_data[1].0)),
                        end_time: None,
                    }]
                }
            }
            3 => {
                // If is_start boolean of varjya_data is true,
                if varjya_data[0].1 {
                    vec![Varjya {
                        start_time: Some(format_time(date, varjya_data[0].0)),
                        end_time: Some(format_time(date, varjya_data[1].0)),
                    }, Varjya {
                        start_time: Some(format_time(date, varjya_data[2].0)),
                        end_time: None,
                    }]
                } else {
                    vec![Varjya {
                        start_time: None,
                        end_time: Some(format_time(date, varjya_data[0].0)),
                    }, Varjya {
                        start_time: Some(format_time(date, varjya_data[1].0)),
                        end_time: Some(format_time(date, varjya_data[2].0)),
                    }]
                }
            }
            4 => {
                // If is_start boolean of varjya_data is true,
                if varjya_data[0].1 {
                    vec![Varjya {
                        start_time: Some(format_time(date, varjya_data[0].0)),
                        end_time: Some(format_time(date, varjya_data[1].0)),
                    }, Varjya {
                        start_time: Some(format_time(date, varjya_data[2].0)),
                        end_time: Some(format_time(date, varjya_data[3].0)),
                    }]
                } else {
                    // This is never possible, panics
                    panic!("Varjya data has 4 elements but first element is not start time");
                }
            }
            _ => {
                // This is never possible, panics
                panic!("Varjya data has more than 4 elements for a day");
            }

        };

        varjya
    }
}