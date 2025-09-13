
use crate::swe_wrapper::*;

pub fn main1() {

   set_ephe_path();
   let julian_date = 2460895.5;
   let ephemeris = get_sun_ephemeris(julian_date);
   println!("Ephemeris for the Sun on Julian date {}: {:?}", julian_date, ephemeris);

   //println!("x = {} ", (0.0-111.5)%360.0);

   let a = solve(|x| norm(get_moon_ephemeris(x) - get_sun_ephemeris(x)), 192.0, 2460894.5, 2460899.5);

    println!("Solved value for 192.0: {}", a);

    // Solving for karana ends between 2460895.5 2460896.5
    let start_jd = 2460895.5;
    let end_jd = 2460896.6;

    // Create function that calculates the ephemeris difference
    let ephemeris_diff = |tjd_ut| norm(get_moon_ephemeris(tjd_ut) - get_sun_ephemeris(tjd_ut));

    let start_eph = ephemeris_diff(start_jd);
    let end_eph = ephemeris_diff(end_jd);

    let points = get_points_in_range(start_eph, end_eph, 60);
    // print points
    for point in &points {
        println!("Point: {:?}", point);
    }

    // for each point in points do this
    // take second value in point 
    // and if that is not None then solve for it between start_jd and end_jd 
    // get an array of tuples of (solved_value, point.1)
    // results is vector of f64, Option<f64>
    let mut results: Vec<(f64, Option<f64>)> = Vec::new();
    for point in points {
        if let Some(value) = point.1 {
            let solved_value = solve(|x| ephemeris_diff(x), value, start_jd, end_jd);
            results.push((point.0, Some(solved_value)));
        } else {
            results.push((point.0, None));
        }
    }

    // print results
    for (point_value, solved_value) in results {
        println!("Point: {:?}, Solved value: {:?}", point_value, solved_value);
    }

}


pub fn solve<F>(f: F, val: f64, min: f64, max: f64) -> f64
where
    F: Fn(f64) -> f64,
{
    let val = val % 360.0; // Normalize value to be within 0 to 360
    // println!("Solving for value: {}, min: {}, max: {}, max - min: {}", val, min, max, max - min);

    if (min * 86400.0).round() == (max * 86400.0).round() {
        return min;
    }

    let min_result = f(min);
    let max_result = f(max);
    // println!("val: {}, Min result: {}, Max result: {}", val, min_result, max_result);

    if !is_between(val, min_result, max_result) {
        panic!("Invalid Inputs.. Failing..");
    }

    

    let cut_factor = norm(val - min_result) / norm(max_result - min_result);

    // For bisection method, we can use a fixed cut factor of 0.5
    // let cut_factor = 0.5;
    // println!("Cut factor: {}", cut_factor);

    // let cut_factor = if cut_factor <= 0.000001 {
    //     0.000001
    // } else if cut_factor >= 0.999999 {
    //     0.999999
    // } else {
    //     cut_factor
    // };

    // let cut_factor = if cut_factor <= 0.001 {
    //     0.001
    // } else if cut_factor >= 0.99 {
    //     0.99
    // } else {
    //     cut_factor
    // };

    // let cut_factor = if cut_factor <= 0.01 {
    //     0.01
    // } else if cut_factor >= 0.99 {
    //     0.99
    // } else {
    //     cut_factor
    // };

        let cut_factor = if cut_factor <= 0.1 {
        0.1
    } else if cut_factor >= 0.9 {
        0.9
    } else {
        cut_factor
    };
    

    let middle = min + ((max - min) * cut_factor);
    let middle_result = f(middle);

    let half = min + ((max - min) * 0.5);
    let half_result = f(half);

    let (m1, m1_result) = if middle_result < half_result { (middle, middle_result) } else { (half, half_result) };
    let (m2, m2_result) = if middle_result < half_result { (half, half_result) } else { (middle, middle_result) };

    // let m1_result = f(m1);
    // let m2_result = f(m2);

    // println!("Middle: {}, Middle Result: {}, Half: {}, Half Result: {}", middle, middle_result, half, half_result);

    if is_between(val, min_result, m1_result) {
        solve(f, val, min, m1)
    } else if is_between(val, m1_result, m2_result) {
        solve(f, val, m1, m2)
    } else {
        solve(f, val, m2, max)
    } 
    

    // if is_between(val, min_result, middle_result) {
    //     solve(f, val, min, middle)
    // } else {
    //     solve(f, val, middle, max)
    // }
}

pub fn is_between(value: f64, start: f64, end: f64) -> bool {
    // case where start is less than end
    let value = value % 360.0; // Normalize value to be within 0 to 360
    let start = start % 360.0; // Normalize start to be within 0 to 360
    let end = end % 360.0; // Normalize end to be within 0 to 360
    if start < end {
        return value > start && value < end;
    }
    // case where start is greater than end where value between end and 360, or 0 and start
    else {
        //start >= end
        return value > start || value < end;
    }
}

pub fn norm(x: f64) -> f64 {
    let mut x = x % 360.0;
    if x < 0.0 {
        x += 360.0;
    }
    x
}

pub fn get_points_in_range(start_val: f64, end_val: f64, n: usize) -> Vec<(f64, Option<f64>)> {
    (1..=n)
        .map(|x| (x as f64, (360.0 * (x as f64) / (n as f64))))
        .cycle()
        .skip_while(|&(_, v)| v < start_val)
        .take(n)
        .enumerate()
        .take_while(|&(i, (_, v))| {
            // take either first one or any subsequent ones that are between the start and end values
            i == 0 || is_between(v, start_val, end_val)
        })
        .map(|(_, (k, v))| {
            if is_between(v, start_val, end_val) {
                (k, Some(v))
            } else {
                (k, None)
            }
        })
        .collect::<Vec<_>>()
}

pub fn get_varjya_points_in_range(start_val: f64, end_val: f64) -> Vec<(f64, bool)> {

    let varjya_degrees = [
        ( 100.0/9.0, true), ( 108.0/9.0, false), ( 168.0/9.0, true), ( 176.0/9.0, false), ( 300.0/9.0, true), ( 308.0/9.0, false), 
        ( 440.0/9.0, true), ( 448.0/9.0, false), ( 508.0/9.0, true), ( 516.0/9.0, false), ( 642.0/9.0, true), ( 650.0/9.0, false), 
        ( 780.0/9.0, true), ( 788.0/9.0, false), ( 880.0/9.0, true), ( 888.0/9.0, false), (1024.0/9.0, true), (1032.0/9.0, false), 
        (1140.0/9.0, true), (1148.0/9.0, false), (1240.0/9.0, true), (1248.0/9.0, false), (1356.0/9.0, true), (1364.0/9.0, false), 
        (1482.0/9.0, true), (1490.0/9.0, false), (1600.0/9.0, true), (1608.0/9.0, false), (1708.0/9.0, true), (1716.0/9.0, false), 
        (1828.0/9.0, true), (1836.0/9.0, false), (1940.0/9.0, true), (1948.0/9.0, false), (2068.0/9.0, true), (2076.0/9.0, false), 
        (2272.0/9.0, true), (2280.0/9.0, false), (2328.0/9.0, true), (2336.0/9.0, false), (2440.0/9.0, true), (2448.0/9.0, false), 
        (2540.0/9.0, true), (2548.0/9.0, false), (2660.0/9.0, true), (2668.0/9.0, false), (2796.0/9.0, true), (2804.0/9.0, false), 
        (2912.0/9.0, true), (2920.0/9.0, false), (3048.0/9.0, true), (3056.0/9.0, false), (3180.0/9.0, true), (3188.0/9.0, false),
        // Cycle through start but adding 360
        ( (100.0/9.0)+360.0, true), ( (108.0/9.0)+360.0, false), ( (168.0/9.0)+360.0, true), ( (176.0/9.0)+360.0, false)
    ];

    let varjya_points = varjya_degrees.into_iter()
        .skip_while(|&x| x.0 < start_val)
        .take_while(|&x| is_between(x.0, start_val, end_val))
        .collect::<Vec<(f64, bool)>>();

    varjya_points

}