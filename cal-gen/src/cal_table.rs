use chrono::{Datelike, NaiveDate};

// Enum containing 2 variants
// 1. Date (String with format YYYYMMDD)
// 2. Rowspan (integer) (number from 0 to 7)
#[derive(Clone, Copy)]
pub enum CellType {
    Date(u32),
    Rowspan(u8),
}

pub type Calendar = [[CellType; 5]; 7];

// Function to create an empty calendar
// Input: Year and Month as integers
// Output: Calendar
// If there are 6 weeks in the month, the last week will wrap around to the first week of same month
// Rowspan: where there are no dates, the CellType will be Rowspan 
// Value of Rowspan will be number of empty cells in that week
// If the cell is already part of a Rowspan, it will not be counted again, i.e., Rowspan will only count consecutive empty cells
// In that case the CellType will be Rowspan(0)
// fn is_leap_year(year: i32) -> bool {
//     (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
// }

fn get_days_of_month(year: i32, month: u8) -> u8 {
    // Use chrono crate to get number of days in the month
    let first_day = NaiveDate::from_ymd_opt(year, month as u32, 1).unwrap();
    let next_month = if month == 12 { 1 } else { month + 1 };
    let next_month_year = if month == 12 { year + 1 } else { year };
    let first_day_next_month = NaiveDate::from_ymd_opt(next_month_year, next_month as u32, 1).unwrap();
    (first_day_next_month - first_day).num_days() as u8
}
    
fn get_first_weekday(year: i32, month: u8) -> u8 {
    // Use chrono crate to get the first weekday of the month
    let first_day = NaiveDate::from_ymd_opt(year, month as u32, 1).unwrap();
    // First weekday: 0 = Sunday, 1 = Monday, ..., 6 = Saturday
    first_day.weekday().num_days_from_sunday() as u8
}

fn get_day_panchang(yyyy: i32, mm: u8, dd: u8) -> u32 {
    // Return day of month till implementation is done
    yyyy as u32 * 10000 + mm as u32 * 100 + dd as u32
}

pub fn create_empty_calendar(year: i32, month: u8) -> Calendar {
    let mut calendar: Calendar = [[CellType::Rowspan(0); 5]; 7];
    // 1-D Array of CellType of 35
    let mut cells = [CellType::Rowspan(0); 35];

    // Get number of days in the month
    let days_in_month = get_days_of_month(year, month);
    // Get first weekday of the month
    let first_weekday = get_first_weekday(year, month);
    // Fill the cells array with dates and rowspans
    let mut day_counter = 1;
    for i in 0..35 {
        if i as u8 >= first_weekday && day_counter <= days_in_month {
            let date_value = get_day_panchang(year, month, day_counter);
            cells[i] = CellType::Date(date_value);
            day_counter += 1;
        } else {
            cells[i] = CellType::Rowspan(0);
        }
    }
    // If days exceed 35, wrap around to the beginning

    // Fill remaining days (they can be only 1 or 2 days)
    if day_counter <= days_in_month {
                let date_value = get_day_panchang(year, month, day_counter);
                cells[0] = CellType::Date(date_value);
                day_counter += 1;
    }

    if day_counter <= days_in_month {
                let date_value = get_day_panchang(year, month, day_counter);
                cells[1] = CellType::Date(date_value);
    }

    // Update rowspans
    // Loop through cells array
    // find out consecutive Rowspan(0) and update the first one with the count
    let mut i = 0;
    while i < 35 {
        if let CellType::Rowspan(0) = cells[i] {
            let mut count = 0;
            let start_index = i;
            while i < 35 {
                if let CellType::Rowspan(0) = cells[i] {
                    count += 1;
                    i += 1;
                } else {
                    break;
                }
            }
            if count > 0 {
                cells[start_index] = CellType::Rowspan(count);
                // Default value of 0 for the rest of the rowspans
                // for j in start_index + 1..start_index + count {
                //     cells[j] = CellType::Rowspan(0);
                // }
            }
        } else {
            i += 1;
        }
    }

    // Prepare the 2-D calendar array from 1-D cells array
    for week in 0 .. 5 {
        for day in 0 .. 7 {
            calendar[day][week] = cells[week * 7 + day];
        }
    }

    calendar
}