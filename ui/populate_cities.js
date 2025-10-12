import { cities, categories } from './city_data.js';



// Uncomment the line below to generate city_data.js from a list of cities
import { gen_cities } from './gen_cities.js';
 gen_cities();

// Below is code to generate city_data.js from a list of cities
// import { encode_city_id, decode_city_id } from './city_helper.js'
// const lat = 5.41;
// const long = 100.32;
// const tz = "Asia/Kuala_Lumpur";
// const city_name = "పెనాంగ్ (మలేషియా)";
// const category_id = 3;
// const city_id = encode_city_id(lat, long, tz);
// console.log(`"${city_id}": { "city_name": "${city_name}", "category_id": ${category_id} }`);


let city_html = document.getElementById("city-list");

// const categories = {
//     "1": "తెలంగాణ",
//     "2": "ఆంధ్రప్రదేశ్",
//     "3": "ఇతర భారత రాష్ట్రాలు",
//     "4": "ఇతర ఆసియా దేశాలు",
//     "5": "ఉత్తర అమెరికా",
//     "6": "యూరోప్",
//     "7": "ఆస్ట్రేలియా/న్యూజిలాండ్",
//     "8": "ఆఫ్రికా",
//     "9": "దక్షిణ అమెరికా"
// };

// const cities = {
//     "736009386268": {
//         "city_name": "ఆదిలాబాద్",
//         "category_id": 1
//     },
//     "727687946524": {
//         "city_name": "కరీంనగర్",
//         "category_id": 1
//     },
//     "719702098204": {
//         "city_name": "ఖమ్మం",
//         "category_id": 1
//     },
// };

// for each category, add a header and then add cities under that header
// sort cities by city_name within each category
let categorized_cities = {};
for (let city_id in cities) {
    let category_id = cities[city_id].category_id;
    if (!(category_id in categorized_cities)) {
        categorized_cities[category_id] = [];
    }
    categorized_cities[category_id].push({ city_id: city_id, city_name: cities[city_id].city_name });
}

// sort cities within each category
for (let category_id in categorized_cities) {
    categorized_cities[category_id].sort((a, b) => a.city_name.localeCompare(b.city_name));
}

// add a table of contents at the top
let toc = document.createElement("div");
for (let category_id in categories) {
    if (category_id in categorized_cities) {
        let link = document.createElement("a");
        link.href = `#category-${category_id}`;
        link.textContent = categories[category_id];
        toc.appendChild(link);
        // add separator as new line
        toc.appendChild(document.createElement("br"));
    }
}

city_html.appendChild(toc);
for (let category_id in categories) {
    if (category_id in categorized_cities) {
        // add an anchor for this category
        let anchor = document.createElement("a");
        anchor.id = `category-${category_id}`;
        city_html.appendChild(anchor);
        let header = document.createElement("h3");
        header.textContent = categories[category_id];
        city_html.appendChild(header);

        for (let city of categorized_cities[category_id]) {
            let link = document.createElement("a");
            link.href = `./panchang.html?city_id=${city.city_id}`;
            link.textContent = city.city_name;
            city_html.appendChild(link);
            // add new line
            city_html.appendChild(document.createElement("br"));
        }
    }
}