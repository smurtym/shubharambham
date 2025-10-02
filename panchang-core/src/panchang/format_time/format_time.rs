
use chrono::DateTime;
use chrono::Timelike;
use chrono_tz::Tz;

use auto_bench_fct::auto_bench_fct;

// Inputs: DateTime<Tz>, Julian Day as f64
// Returns: Formatted time string of the Julian Day in the format "HH:MM"
// We need date with timezone because
// 1. Julian Day is not timezone aware, so we need to convert it to the timezone of the date
// 2. We need date value to ensure additional/missing hour is accounted on the days of DST change
#[auto_bench_fct]
pub fn format_time(date: DateTime<Tz>, jd: f64) ->String {

    let dt2 = jd_to_datetime(jd, date.timezone());

    // round to nearest minute based on seconds
    let dt2 = if dt2.second() >= 30 {
        dt2 + chrono::Duration::minutes(1)
    } else {
        dt2
    };

    // Actual formatting
    format!("{:02}:{:02}", 
            (dt2.hour() as i64)+(dt2.signed_duration_since(date).num_days()*24), 
            dt2.minute()
           )

}

// Utility function to convert to DateTime<Tz> from Julian Day
pub fn jd_to_datetime(jd: f64, tz: Tz) -> DateTime<Tz> {
    let timestamp = ((jd - 2440587.5) * 86400.0).round() as i64;
    DateTime::from_timestamp(timestamp, 0).unwrap().with_timezone(&tz)
}

// Utility function to convert to Julian Day from DateTime<Tz>
pub fn datetime_to_jd(date: DateTime<Tz>) -> f64 {
    (date.timestamp() as f64) / 86400.0 + 2440587.5
}


