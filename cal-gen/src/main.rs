mod cal_table;
use cal_table::{create_empty_calendar, CellType};
use std::collections::BTreeMap;
use chrono::NaiveDate;

mod format_panchang;
use format_panchang::format_panchang_data;
use format_panchang::CalendarData;
use format_panchang::ENGLISH_MONTH;
use format_panchang::WEEKDAY_NAME;

mod month_headers;
use month_headers::create_month_headers;

use std::fs::File;
use std::io::prelude::*;

use panchang_core::calculate_panchang_data;
// use panchang_core::PanchangData;

fn main() {

    //test_cal_print();
    // calculate_panchang_data for all days in year 2026 for city Hyderabad
    let year = 2026;
    
    // Hyderabad
    // let lat = 17.385044;
    // let lon = 78.486671;
    // let city_name = "హైదరాబాద్";
    // let tz: chrono_tz::Tz = "Asia/Kolkata".parse().unwrap();

    // Penang, Malaysia
    // let lat = 5.41;
    // let lon = 100.32;
    // let city_name = "పెనాంగ్, మలేషియా";
    // let tz: chrono_tz::Tz = "Asia/Kuala_Lumpur".parse().unwrap();

    // Eluru, Andhra Pradesh
    let lat = 16.7100;
    let lon = 81.1100;
    let city_name = "ఏలూరు";
    let tz: chrono_tz::Tz = "Asia/Kolkata".parse().unwrap();

    // loop through all days of the year and get panchang data for each day
    // Store in a key value pair where key is date in YYYYMMDD format and value is PanchangData struct

    // Create a sorted hashmap to store cal data

    let mut cal_data_map: BTreeMap<u32, CalendarData> = BTreeMap::new();
    // Loop through all days of the year using chrono
    let start_date =NaiveDate::from_ymd_opt(year, 1, 1).unwrap();
    let end_date = NaiveDate::from_ymd_opt(year, 12, 31).unwrap();
    let mut current_date = start_date;
    while current_date <= end_date {
        let panchang_data = calculate_panchang_data(current_date, lat, lon, tz);
        let formatted_data = format_panchang_data(&panchang_data);

        cal_data_map.insert(formatted_data.yyyymmdd, formatted_data);
        current_date = current_date.succ_opt().unwrap();
    }

    // Create month headers by grouping calendar data by month and date ranges
    let month_headers = create_month_headers(&cal_data_map);

    // Generate HTML calendar for each month of year
    let mut file = File::create("../ui/calendar.html").unwrap();
    // Add HTML header as utf-8
    writeln!(file, "<!DOCTYPE html>").unwrap();
    writeln!(file, "<html lang=\"en\">").unwrap();
    writeln!(file, "<head>").unwrap();
    writeln!(file, "<meta charset=\"UTF-8\">").unwrap();
    writeln!(file, "
    <style>

    body {{ font-family: Noto Sans Telugu, sans-serif; font-size: 8pt; }}

    table {{ width: 100%; border-collapse: collapse; }}
    th, td {{ border: 1px solid; padding: 6px; }}
  </style>
    </head>").unwrap();
    writeln!(file, "<body>").unwrap();
    for month in 1..=12 {
        // Writing month header year-ENGLISH_MONTH[month]
        
        // Write month header table
        if let Some(headers) = month_headers.get(&month) {
            writeln!(file, "<table border=\"1\">").unwrap();
            writeln!(file, "
            <thead style=\"background-color: bisque\">
            <tr><td colspan=\"6\" align=\"center\"><b>
                <p style=\"text-align: center;\">శుభారంభం</p> 
                <p style=\"text-align: center;\"> {} {} </p>
            </b></td></tr>
            </thead>", year, ENGLISH_MONTH[month as usize]).unwrap();
            for (date_range, header) in headers.iter() {
                writeln!(file, "<tr>").unwrap();
                writeln!(file, "<td colspan=\"1\">{}</td>", date_range).unwrap();
                writeln!(file, "<td colspan=\"5\">{}</td>", header).unwrap();
                writeln!(file, "</tr>").unwrap();
            }
            //writeln!(file, "</table>").unwrap();
        }
        let calendar = create_empty_calendar(year, month);

        // Write calendar table
        let mut weekday_number = 0;
        for week in calendar.iter() {
            writeln!(file, "<tr>").unwrap();
            writeln!(file, "<td>{}</td>", WEEKDAY_NAME[weekday_number]).unwrap();
            weekday_number = weekday_number + 1;
            for cell in week.iter() {
                match cell {
                    CellType::Date(date) => writeln!(file, "<td style=\"vertical-align: top;\">{}</td>",
                     //date
                     cal_data_map.get(date).unwrap().celldata
                    ).unwrap(),
                    CellType::Rowspan(span) => if *span != 0 { writeln!(file, "<td rowspan=\"{}\">&nbsp;&nbsp;&nbsp;&nbsp;</td>", span).unwrap() } ,
                }
            }
            writeln!(file, "</tr>").unwrap();
        }

        // Footer
        writeln!(file, "<tr><td colspan=\"6\">
        <p>సూర్యోదయ, సూర్యాస్తమయ సమయాలు <b> {} </b> ప్రాంతానికి గణించబడినవి. తిథి, నక్షత్రముల సమయములు అంత్య సమయములు. </p>
        <p><b>సూచిక:</b> సూ. ఉ. : సూర్యోదయం; సూ. అ. : సూర్యాస్తమయం; దు. : దుర్ముహూర్తం; ల. : లగాయతు; వ. : వరుకు</p>
        <p> మరిన్ని వివరాలు (యోగం, కరణం, రాహుకాలం, హోరాకాలం, గ్రహణ సమయాలు) శుభారంభం వెబ్‌సైట్ <a href=\"https://www.shubharambham.com/\">https://www.shubharambham.com/</a> లో ఉన్నాయి.</p>    
        </td></tr>", city_name).unwrap();
        writeln!(file, "</table></br><p>&nbsp;</p>").unwrap();
    }
    writeln!(file, "</body>").unwrap();
    writeln!(file, "</html>").unwrap();
    file.flush().unwrap();

}

