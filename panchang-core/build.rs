use std::env;

fn main() {
    println!("cargo:rerun-if-changed=vendor/swisseph");
    let target = env::var("TARGET").unwrap();

    let mut b = cc::Build::new();
    b.target(&target)
        .warnings(false)
        .static_flag(true)
        // Add all files as array
        .files([
            "swisseph/sweph.c",
            "swisseph/swephlib.c",
            "swisseph/swedate.c",
            "swisseph/swecl.c",
            "swisseph/swehel.c",
            "swisseph/swehouse.c",
            "swisseph/swejpl.c",
            "swisseph/swemmoon.c",
            "swisseph/swemplan.c",
        ]);

    // Emscripten’s emcc will be used automatically for wasm32-unknown-emscripten.
    b.compile("swe");

}
