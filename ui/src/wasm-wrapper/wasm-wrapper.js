import panchang from '../../wasm/panchang-wasm.js';

var p = await panchang({
    // locateFile: (file) => `wasm/${file}`
    locateFile: function (path) {
        if (path.endsWith('.wasm')) {
          return new URL('../../wasm/panchang-wasm.wasm', import.meta.url).href;
        }
        if (path.endsWith('.data')) {
          return new URL('../../wasm/panchang-wasm.data', import.meta.url).href;
        }
        return path;    
      }
});

// console.log('Loaded panchang');

export const panchang_data_exported = p.cwrap("panchang_data", "number", 
    ["double", "double", "string", "string", "number", "number"]);

function panchang_data(lat, lon, date, tz) {
    let cap = 10240; // Max capacity of the output string, 10KB
    let ptr = p._malloc(cap);
    
    panchang_data_exported(lat, lon, date, tz, ptr, cap);
    const s = p.UTF8ToString(ptr);
    p._free(ptr); // No leak
    return s;
}

// pub extern "C" fn eclipse_data(lat: f64, lon: f64, year: i32, tz_ptr: *const c_char,
// res_ptr: *mut u8, res_cap: usize
// ) -> *mut u8 {

export const eclipse_data_exported = p.cwrap("eclipse_data", "number",
    ["double", "double", "number", "string", "number", "number"]);

function eclipse_data(lat, lon, year, tz) {
    let cap = 10240; // Max capacity of the output string, 10KB
    let ptr = p._malloc(cap);
    
    eclipse_data_exported(lat, lon, year, tz, ptr, cap);
    const s = p.UTF8ToString(ptr);
    p._free(ptr); // No leak
    return s;
}

export { panchang_data, eclipse_data };