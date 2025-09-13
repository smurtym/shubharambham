use std::ptr;
use chrono::NaiveDate;
use chrono_tz::Tz;

use panchang_core::calculate_panchang_data;
use core::ffi::{c_char, CStr};

#[unsafe(no_mangle)]
pub extern "C" fn panchang_data(lat: f64, lon: f64, date_ptr: *const c_char, tz_ptr: *const c_char,
res_ptr: *mut u8, res_cap: usize
) -> *mut u8 {

    // Convert date and tz to strings
    let date = unsafe { CStr::from_ptr(date_ptr).to_string_lossy().into_owned() };
    let tz = unsafe { CStr::from_ptr(tz_ptr).to_string_lossy().into_owned() };

    let date = NaiveDate::parse_from_str(&date, "%Y-%m-%d").unwrap();
    let tz = tz.parse::<Tz>().unwrap();

    let panchang_data = calculate_panchang_data(date, lat, lon, tz);
    let panchang_json = serde_json::to_string_pretty(&panchang_data)
        .unwrap();

    let panchang_bytes = panchang_json.as_bytes();

    // NULL terminate 

    // If the provided buffer is too small, return a null pointer.
    if res_cap < panchang_bytes.len() {
        return std::ptr::null_mut();
    }

    unsafe {
        // Copy the bytes into the provided buffer.
        std::ptr::copy_nonoverlapping(panchang_bytes.as_ptr(), res_ptr, panchang_bytes.len());
        // NUL-terminate
        *res_ptr.add(panchang_bytes.len()) = 0;
    }

    res_ptr

}

pub fn get_result1_interal() -> String {
    "Hello from Rust!".to_string()
}

#[unsafe(no_mangle)]
pub extern "C" fn get_result1(out_ptr: *mut u8, out_cap: usize) -> usize {
    let msg = get_result1_interal();
    let bytes = msg.as_bytes();

    // bytes needed including the NUL terminator
    let needed = bytes.len() + 1;

    // If the caller’s buffer is too small, return the required size.
    if out_cap < needed {
        return needed;
    }

    unsafe {
        // Copy the bytes
        ptr::copy_nonoverlapping(bytes.as_ptr(), out_ptr, bytes.len());
        // NUL-terminate
        *out_ptr.add(bytes.len()) = 0;
    }

    // Return the number of bytes written (not counting the NUL)
    bytes.len()
}
