

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Location {
    pub lat: f64,
    pub lon: f64,
}

#[derive(Debug)]
#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Masa {
    pub is_adhika: bool,
    pub is_nija: bool,
    pub is_kshaya: bool,
    pub id: i32,
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Tithi {
    pub id: i32,
    pub end_time: Option<String>, // "HH:MM" or null
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Karana {
    pub id: i32,
    pub end_time: String, // "HH:MM"
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Nakshatra {
    pub id: i32,
    pub end_time: Option<String>, // "HH:MM" or null
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Yoga {
    pub id: i32,
    pub end_time: Option<String>, // "HH:MM" or null
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Varjya {
    pub start_time: Option<String>, // "HH:MM" or null
    pub end_time: Option<String>, // "HH:MM" or null
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Durmuhurtha {
    pub start_time: String, // "HH:MM"
    pub end_time: String, // "HH:MM"
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Abhijit {
    pub start_time: String, // "HH:MM"
    pub end_time: String, // "HH:MM"
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Aparahna {
    pub start_time: String, // "HH:MM"
    pub end_time: String, // "HH:MM"
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct RahuKala {
    pub start_time: String, // "HH:MM"
    pub end_time: String, // "HH:MM"
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Hora {
    pub id: i32,
    pub start_time: String, // "HH:MM"
    pub end_time: String, // "HH:MM"
}

#[derive(serde::Serialize)]
#[serde(rename_all = "camelCase")]
pub struct PanchangData {
    pub dt: String, // Date in "YYYY-MM-DD" format
    pub yyyy: String, // Year
    pub mm: String, // Month
    pub dd: String, // Day
    pub tz: String,
    pub location: Location,
    pub week_day: i32,
    pub sun_rise: String,
    pub sun_set: String,
    pub moon_rise: Option<String>,
    pub moon_set: Option<String>,
    pub next_sun_rise: String,
    pub samvatsara: i32,
    pub ayana: i32,
    pub drik_ritu: i32,
    pub purva_ritu: i32,
    pub masa: Masa,
    pub tithi: Vec<Tithi>,
    pub nakshatra: Vec<Nakshatra>,
    pub karana: Vec<Karana>,
    pub yoga: Vec<Yoga>,
    pub varjya: Vec<Varjya>,
    pub durmuhurtha: Vec<Durmuhurtha>,
    pub abhijit: Option<Abhijit>,
    pub aparahna: Aparahna,
    pub rahu_kala: RahuKala,
    pub hora: Vec<Hora>,
}