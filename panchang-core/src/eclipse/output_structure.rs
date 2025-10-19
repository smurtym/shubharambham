// use serde::{Deserialize, Serialize};
// Structures for Eclipse data output

// Use Location from crate::panchang::output_structure::Location;
use crate::panchang::output_structure::Location;

// Structure to hold Eclipse details
#[derive(Debug)]
#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct EclipseDetails {
    pub is_solar: bool,
    pub is_total: bool,
    pub is_annular: Option<bool>, // Only for solar eclipses
    pub is_rahu: bool,
    pub date: String, // YYYY-MM-DD format
    pub yyyy: i32,
    pub mm: i32,
    pub dd: i32,
    pub location: Location,
    pub week_day: i32, // 1=Sunday, 2=Monday, ..., 7=Saturday
    pub is_visible_next_day: bool,
    pub start_time: String, // HH24:MI format
    pub max_time: String,  // HH24:MI format
    pub end_time: String,   // HH24:MI format
    pub is_start_visible: bool,
    pub is_end_visible: bool,
    pub start_nakshatra: i32,
    pub start_nakshatra_pada: i32,
    pub start_rasi: i32,
    pub end_nakshatra: i32,
    pub end_nakshatra_pada: i32,
    pub end_rasi: i32,
    pub rise_in_eclipse_time: Option<String>, // HH24:MI format or None
    pub set_in_eclipse_time: Option<String>,  // HH24:MI format or None
}
