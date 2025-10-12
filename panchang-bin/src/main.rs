use chrono::NaiveDate;
use chrono_tz::Tz;

use panchang_core::eclipse::calculate_eclipse;

fn main() {
    let date = "2026-04-17";
    let tz = "Asia/Kolkata";
    let lat = 17.39;
    let lon = 78.47;
    let date = NaiveDate::parse_from_str(&date, "%Y-%m-%d").unwrap();
    let tz = tz.parse::<Tz>().unwrap();

    let panchang_data = panchang_core::calculate_panchang_data(date, lat, lon, tz);
    let panchang_json = serde_json::to_string_pretty(&panchang_data)
        .unwrap();

    //println!("{}", panchang_json);

    // Call the main1 function from the util module
    //panchang_core::main1();
    let eclipse_data = calculate_eclipse(2026, lat, lon, tz);
    let eclipse_json = serde_json::to_string_pretty(&eclipse_data)
        .unwrap();
    println!("{}", eclipse_json);

    // Test cases for get_nakshatra_pada_rasi
    // let test_cases = vec![
    //     (0.1, (1, 1, 1)),

    //     (13.4333333333, (2, 1, 1)),
    //     (26.7666666666, (3, 1, 1)),
    //     (30.1, (3, 2, 2)),
    //     (60.1, (5, 3, 3)),
    //     (120.1, (10, 1, 5)),
    //     (359.1, (27, 4, 12)),
    // ];
    // for (input, expected) in test_cases {
    //     let result = get_nakshatra_pada_rasi(input);
    //     assert_eq!(result, expected, "Failed for input: {}", input);
    // }
    // println!("All test cases passed!");
}

// pub fn get_nakshatra_pada_rasi(moon_ephemeris: f64) -> (i32, i32, i32) {

//     let pada = (moon_ephemeris / (360.0/108.0)).floor() as i32;
//     println!("Pada: {}", pada);
//     let nakshatra = ((moon_ephemeris / (360.0/27.0)).floor() as i32) + 1; // 1 to 27
//     let nakshatra_pada = (pada % 4 ) + 1; // 1 to 4
//     let rasi = ((moon_ephemeris / (360.0/12.0)).floor() as i32) + 1; // 1 to 12

//     (nakshatra, nakshatra_pada, rasi)
// }