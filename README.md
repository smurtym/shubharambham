# This project creates a Telugu panchangam website

* Uses Swiss Ephemeris Library for Ephemeris
** [website](https://www.astro.com/swisseph/swephinfo_e.htm?)
** [github](https://github.com/aloistr/swisseph)
* All panchang calculations are written in Rust and built as wasm
* Tooling for linking: emscripten
* Rust target: wasm32-unknown-emscripten

* UI built using plain JS
* For date component, airdate is used
** [website](https://air-datepicker.com/)
** [github](https://github.com/t1m0n/air-datepicker)
