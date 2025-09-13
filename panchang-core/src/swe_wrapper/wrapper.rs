
use auto_bench_fct::auto_bench_fct;
pub type Int32 = ::std::os::raw::c_int;
pub type CChar = ::std::os::raw::c_char;

// SWE Constants in Rust
pub const SE_SUN: Int32 = 0;
pub const SE_MOON: Int32 = 1;
pub const SE_CALC_RISE: Int32 = 1;
pub const SE_CALC_SET: Int32 = 2;
pub const SE_BIT_HINDU_RISING: Int32 = 128 | 256 | 512;
pub const SEFLG_SW: Int32 = 256;

//pub const SEFLG_MOSEPH: Int32 = 4; // Use Moshier Ephemeris
pub const SEFLG_SWIEPH: Int32 = 2; // Use Swiss Ephemeris
//pub const SEFLG_JPLEPH: Int32 = 1; // Use JPL Ephemeris

pub const SEFLG_SIDEREAL: Int32 = 64 * 1024; // Use Sidereal Ephemeris

pub const SE_SIDM_TRUE_CITRA: Int32 = 27; // True Citra Sidereal Zodiac
// pub const SE_SIDM_TRUE_REVATI: Int32 = 28; // True Revati Sidereal Zodiac
// pub const SE_SIDM_TRUE_PUSHYA: Int32 = 29; // True Pushya Sidereal Zodiac
// pub const SE_SIDM_GALCENT_MULA_WILHELM: Int32 = 36; // GalCent Mula Wilhem Sidereal Zodiac

//SEFLG_NONUT = 64
pub const SEFLG_NONUT: Int32 = 64; // No nutation

unsafe extern "C" {
    pub fn swe_set_ephe_path(path: *const CChar);
}

unsafe extern "C" {
    pub fn swe_set_sid_mode(sid_mode: Int32, 
                            ayan_t0: f64, 
                            ayan_t0_prec: f64);
}

#[auto_bench_fct]
pub fn set_ephe_path() {
    let path = std::ffi::CString::new("data").unwrap();
    //print!("Setting ephemeris path to: {:?}", path);
    unsafe {
        swe_set_ephe_path(path.as_ptr());
        // Setting ayanamsa
        swe_set_sid_mode(SE_SIDM_TRUE_CITRA, 0.0, 0.0);
    }
}

unsafe extern "C" {
    pub fn swe_rise_trans(
        tjd_ut: f64,
        ipl: Int32,
        starname: *mut CChar,
        epheflag: Int32,
        rsmi: Int32,
        geopos: *mut f64,
        atpress: f64,
        attemp: f64,
        tret: *mut f64,
        serr: *mut CChar,
    ) -> Int32;
}

#[auto_bench_fct]
pub fn rise_set(
    tjd_ut: f64,
    ipl: Int32,
    is_set: bool,
    lat: f64,
    lon: f64
) -> f64 {
    let mut geopos: [f64; 3] = [0.0; 3];
    geopos[0] = lon;
    geopos[1] = lat;
    geopos[2] = 0.0;
    let mut tret: [f64; 1] = [0.0; 1];
    let mut serr: [CChar; 4000] = [0; 4000];
    let mut star_name: [CChar; 4000] = [0; 4000];
    let err;
    let event: Int32 = if is_set { SE_CALC_SET } else { SE_CALC_RISE };

    unsafe {
        swe_rise_trans(tjd_ut, ipl, star_name.as_mut_ptr(), 
            SEFLG_SW, 
            event  | SE_BIT_HINDU_RISING, 
            geopos.as_mut_ptr(), 0.0, 0.0, tret.as_mut_ptr(), serr.as_mut_ptr());
        err = std::ffi::CStr::from_ptr(serr.as_mut_ptr()).to_str().unwrap();
    }

    if err != "" {
        //println!("Error: {}", err);
        panic!("Error in rise_set: {}", err);
    }
    // return the time of the event
    tret[0]
}

unsafe extern "C" {
    pub fn swe_calc_ut(
        tjd_ut: f64,
        ipl: Int32,
        iflag: Int32,
        xx: *mut f64,
        serr: *mut CChar,
    ) -> Int32;
}

pub fn calc_ut(tjd_ut: f64, ipl: Int32, iflag: Int32) -> f64 {
    let mut xx: [f64; 6] = [0.0; 6];
    let mut serr: [CChar; 256] = [0; 256];
    let err;
    unsafe {
        swe_calc_ut(tjd_ut, ipl, iflag, xx.as_mut_ptr(), serr.as_mut_ptr());
        err = std::ffi::CStr::from_ptr(serr.as_mut_ptr()).to_str().unwrap();
    }
    // convert serr only if it's not empty
    if err != "" {
        println!("Error: {}", err);
    }

    xx[0]
}

pub fn get_sun_ephemeris(tjd_ut: f64) -> f64 {
    let ipl = SE_SUN; // Sun's planet number in Swiss Ephemeris
    let iflag = SEFLG_SWIEPH | SEFLG_SIDEREAL | SEFLG_NONUT; 
    calc_ut(tjd_ut, ipl, iflag)
}

pub fn get_moon_ephemeris(tjd_ut: f64) -> f64 {
    let ipl = SE_MOON; // Moon's planet number in Swiss Ephemeris
    let iflag = SEFLG_SWIEPH | SEFLG_SIDEREAL | SEFLG_NONUT; 
    calc_ut(tjd_ut, ipl, iflag)
}

pub fn get_tropical_sun_ephemeris(tjd_ut: f64) -> f64 {
    let ipl = SE_SUN; // Sun's planet number in Swiss Ephemeris
    let iflag = SEFLG_SWIEPH | SEFLG_NONUT; 
    calc_ut(tjd_ut, ipl, iflag)
}