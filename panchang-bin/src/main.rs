use chrono::NaiveDate;
use chrono_tz::Tz;

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

    println!("{}", panchang_json);

    // Call the main1 function from the util module
    //panchang_core::main1();
}
