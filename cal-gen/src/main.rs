mod cal_table;
use cal_table::{create_empty_calendar, CellType};
use std::collections::BTreeMap;
use chrono::NaiveDate;

mod format_panchang;
use format_panchang::format_panchang_data;
use format_panchang::CalendarData;
use format_panchang::ENGLISH_MONTH;
use format_panchang::WEEKDAY_NAME;

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
    let lat = 5.41;
    let lon = 100.32;
    let city_name = "పెనాంగ్, మలేషియా";
    let tz: chrono_tz::Tz = "Asia/Kuala_Lumpur".parse().unwrap();

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

    // Create a btree map to store monthly header
    // Key: integer mm
    // Value: Vector of strings

    //let mut month_headers: BTreeMap<u8, Vec<String>> = BTreeMap::new();
    let mut month_headers: BTreeMap<u8, BTreeMap<String, String>> = BTreeMap::new();


    // Loop through cal data map
    // Observe change in month and cal_data.header
    // Add to header map only when the value of cal_data.header changes
    // Key to the header_map is first date of the same header value and last date of the same header value separated by hyphen
    // When month changes, add header_map to month_headers map and start a new map
    let mut current_month: u8 = 1;
    let mut header_map: BTreeMap<String, String> = BTreeMap::new();
    let mut current_header: Option<String> = None;
    let mut header_start_date: u8 = 0;
    let mut last_date: u8 = 0;

    for cal_data in cal_data_map.values() {
        // Check if month changed
        if cal_data.mm != current_month {
            // Finalize current header range before changing month
            if let Some(header) = current_header.take() {
                let key = if header_start_date == last_date {
                    format!("{:02}", header_start_date)
                } else {
                    format!("{:02}-{:02}", header_start_date, last_date)
                };
                header_map.insert(key, header);
            }
            
            // Save current month's header_map
            month_headers.insert(current_month, header_map);
            
            // Reset for new month
            header_map = BTreeMap::new();
            current_month = cal_data.mm;
            current_header = Some(cal_data.header.clone());
            header_start_date = cal_data.dd;
        } else {
            // Same month - check if header changed
            match &current_header {
                None => {
                    // First entry
                    current_header = Some(cal_data.header.clone());
                    header_start_date = cal_data.dd;
                }
                Some(header) => {
                    if header != &cal_data.header {
                        // Header changed - save previous range
                        let key = if header_start_date == last_date {
                            format!("{:02}", header_start_date)
                        } else {
                            format!("{:02}-{:02}", header_start_date, last_date)
                        };
                        header_map.insert(key, header.clone());
                        
                        // Start new header range
                        current_header = Some(cal_data.header.clone());
                        header_start_date = cal_data.dd;
                    }
                    // If header is same, just continue (extending the range)
                }
            }
        }
        last_date = cal_data.dd;
    }
    
    // Add the last header range of the last month
    if let Some(header) = current_header {
        let key = if header_start_date == last_date {
            format!("{:02}", header_start_date)
        } else {
            format!("{:02}-{:02}", header_start_date, last_date)
        };
        header_map.insert(key, header);
    }
    month_headers.insert(current_month, header_map);


    // Loop through cal data array and print results to file output.txt

    // let mut file = File::create("output.txt").unwrap();
    // for cal_data in cal_data_map.values() {
    //     //println!("{:?}",cal_data);
    //     // Convert cal_data to JSON in a single line
    //     let json_data = serde_json::to_string(cal_data).unwrap();
    //     writeln!(file, "{}", json_data).unwrap();
    // }

    // file.flush().unwrap();

    // // Write month headers to file month_headers.txt in JSON format
    // let mut file = File::create("month_headers.txt").unwrap();
    // for (mm, headers) in month_headers.iter() {
    //     let json_data = serde_json::to_string(headers).unwrap();
    //     writeln!(file, "{}: {}", mm, json_data).unwrap();
    // }

    

    // file.flush().unwrap();

    // Generate HTML calendar for each month of year
    let mut file = File::create("../ui/calendar.html").unwrap();
    // Add HTML header as utf-8
    writeln!(file, "<!DOCTYPE html>").unwrap();
    writeln!(file, "<html lang=\"en\">").unwrap();
    writeln!(file, "<head>").unwrap();
    writeln!(file, "<meta charset=\"UTF-8\">").unwrap();
    writeln!(file, "
    
    
<style>
    @page {{ size: A4; margin: 20mm; }}

    body {{ font-family: Noto Sans Telugu, sans-serif; font-size: 8pt; }}

    .page-break {{
      break-before: page;           /* modern */
      page-break-before: always;    /* legacy */
}}

    @media print {{
      thead {{ display: table-header-group; }}
      tfoot {{ display: table-footer-group; }}
      tr, td, th {{ break-inside: avoid; page-break-inside: avoid; }}
}}

    table {{ width: 100%; border-collapse: collapse; }}
    th, td {{ border: 1px solid #ccc; padding: 6px; }}
  </style>

    </head>").unwrap();
    writeln!(file, "<body>").unwrap();
    for month in 1..=12 {
        // Writing month header year-ENGLISH_MONTH[month]
        
        // Write month header table
        if let Some(headers) = month_headers.get(&month) {
            writeln!(file, "<table border=\"1\">
            
  <colgroup>
    <col style=\"width: 5%\"> 
    <col style=\"width: 19%\"> 
    <col style=\"width: 19%\">  
    <col style=\"width: 19%\">  
    <col style=\"width: 19%\">  
    <col style=\"width: 19%\">  
  </colgroup>

            ").unwrap();
            writeln!(file, "
            <thead style=\"background-color: bisque\">
            <tr><td colspan=\"6\" align=\"center\"><b><p style=\"text-align: center;\">శుభారంభం</p> <p style=\"text-align: center;\"> {} {} </p></b></td></tr>
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
        //writeln!(file, "<table border=\"1\">").unwrap();
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
        writeln!(file, "<tr><td colspan=\"6\">
        <p>సూర్యోదయ, సూర్యాస్తమయ సమయాలు <b> {} </b> ప్రాంతానికి గణించబడినవి. తిథి, నక్షత్రముల సమయములు అంత్య సమయములు. </p>
        <p><b>సూచిక:</b> సూ. ఉ. : సూర్యోదయం; సూ. అ. : సూర్యాస్తమయం; దు. : దుర్ముహూర్తం; ల. : లగాయతు; వ. : వరుకు</p>
        </td></tr>", city_name).unwrap();
        writeln!(file, "</table></br><p>&nbsp;</p>").unwrap();
        writeln!(file, "<br clear=all
style='mso-special-character:line-break;page-break-before:always'>").unwrap();
        //writeln!(file, "<div class=\"page-break\"></div>").unwrap();
    }
    writeln!(file, "</body>").unwrap();
    writeln!(file, "</html>").unwrap();
    file.flush().unwrap();

}

// fn test_cal_print() {

//         // print an empty calendar for 2026 
//     let calendar = create_empty_calendar(2026, 6);
//     for week in calendar.iter() {
//         for cell in week.iter() {
//             match cell {
//                 CellType::Date(date) => print!("Date: {} ", date),
//                 CellType::Rowspan(span) => print!("Rowspan: {} ", span),
//             }
//         }
//         println!();
//     }   

//     // print calendar for all months of 2026
//     for month in 1..=12 {
//         println!("Calendar for 2026-{:02}:", month);
//         let calendar = create_empty_calendar(2026, month);
//         for week in calendar.iter() {
//             for cell in week.iter() {
//                 match cell {
//                     CellType::Date(date) => print!("Date: {} ", date),
//                     CellType::Rowspan(span) => print!("Rowspan: {} ", span),    
//                 }
//             }
//             println!();
//         }
//     }

// }
