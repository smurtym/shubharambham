// use serde::{Deserialize, Serialize};
// Structures for Eclipse data output

// Use Location from crate::panchang::output_structure::Location;
use crate::panchang::output_structure::Location;

// Enum to define Solar or Lunar Eclipse
#[derive(Debug)]
#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub enum EclipseType {
    Solar,
    Lunar,
}

// Enum to define Eclispe Phases
#[derive(Debug)]
#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub enum EclipsePhase {
    Partial,
    Total,
    Annular,
    TotalAnnular,
}

// Eclispe node Rahu or Ketu
#[derive(Debug)]
#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub enum EclipseNode {
    Rahu,
    Ketu,
}

// Structure to hold Eclipse details
#[derive(Debug)]
#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct EclipseDetails {
    pub eclipse_type: EclipseType,
    pub phase: EclipsePhase,
    pub node: EclipseNode,
    pub date: String, // YYYY-MM-DD format
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
