use std::collections::BTreeMap;
use crate::format_panchang::CalendarData;

/// Creates a map of monthly headers with date ranges
/// 
/// Takes calendar data and groups headers by month, tracking when headers change
/// and creating date ranges for each unique header value within a month.
/// 
/// Returns: BTreeMap<month, BTreeMap<date_range, header_text>>
pub fn create_month_headers(cal_data_map: &BTreeMap<u32, CalendarData>) -> BTreeMap<u8, BTreeMap<String, String>> {
    let mut month_headers: BTreeMap<u8, BTreeMap<String, String>> = BTreeMap::new();
    
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
    
    month_headers
}
