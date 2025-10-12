import {encode_city_id, decode_city_id, timezones} from './city_helper.js';

const new_cities = [
    "Kozhym (Russia),6,65.7,59.52,Europe/Moscow",
"శాక్రమెంటో (కాలిఫోర్నియా),5,38.58,-121.47,America/Los_Angeles",
"శాన్ డియాగో (కాలిఫోర్నియా),5,32.76,-117.15,America/Los_Angeles",
"పిట్స్‌బర్గ్ (పెన్సెల్‌వేనియా),5,40.44,-80,America/New_York",
"బోస్టన్ (మాసాచుసెట్స్),5,42.36,-71.06,America/New_York",
"శాన్ ఆంటోనియో (టెక్సాస్),5,29.42,-98.49,America/Chicago",
"బాల్టిమోర్ (మేరిలాండ్),5,39.29,-76.61,America/New_York",
"ఫిలడెల్ఫియా (పెన్సెల్‌వేనియా),5,39.95,-75.16,America/New_York",
"ఫీనిక్స్ (అరిజోనా),5,33.45,-112.07,America/Phoenix",
"సిన్‌సినాటి (ఓహైయో),5,39.1,-84.51,America/New_York",
"నాష్‌విల్ (టెన్నెస్సీ),5,36.16,-86.78,America/Chicago",
"సెయింట్ లూయిస్ (మిస్సోరి),5,38.65,-90.3,America/Chicago",
"ఇండియానాపోలిస్ (ఇండియానా),5,39.77,-86.16,America/Indiana/Indianapolis",
"మినియాపోలిస్ (మినెసోటా),5,44.98,-93.27,America/Chicago",
"అట్లాంటా (జార్జియా),5,33.75,-84.39,America/New_York",
"షార్లెట్ (నార్త్ కరోలినా),5,35.23,-80.84,America/New_York",
"టాంపా (ఫ్లోరిడా),5,28,-82.46,America/New_York",
"జాక్సన్‌విల్ (ఫ్లోరిడా),5,30.33,-81.65,America/New_York",
"కొలంబస్ (ఓహైయో),5,39.96,-83,America/New_York",
"ఓక్లహోమా సిటీ (ఓక్లహోమా),5,35.47,-97.52,America/Chicago",
"లూయివిల్ (కెంటకీ),5,38.25,-85.76,America/Kentucky/Louisville",
"డెట్రాయిట్ (మిషిగన్),5,42.4,-83.1,America/Detroit",
"మెక్సికో సిటీ (మెక్సికో),5,19.43,-99.13,America/Mexico_City",
"మాంట్రియల్ (కెనడా),5,45.5,-73.62,America/Toronto",
"ఫ్రాంక్‌ఫర్ట్ (జర్మని),6,50.12,8.68,Europe/Berlin",
"స్టుట్‌గార్ట్ (జర్మని),6,48.78,9.18,Europe/Berlin",
"డబ్లిన్ (ఐర్లాండ్),6,53.35,-6.27,Europe/Dublin",
"రోటర్‌డామ్ (నెదర్లాండ్స్),6,51.92,4.47,Europe/Amsterdam",
"ది హేగ్ (నెదర్లాండ్స్),6,52.07,4.3,Europe/Amsterdam",
"మాంచెస్టర్ (యునైటెడ్ కింగ్‌డమ్),6,53.48,-2.24,Europe/London",
"రెడింగ్ (యునైటెడ్ కింగ్‌డమ్),6,51.45,-0.97,Europe/London",
"వియన్నా (ఆస్ట్రియా),6,48.2,16.37,Europe/Vienna",
"లిస్బన్ (పోర్చుగల్),6,38.72,-9.14,Europe/Lisbon",
"వార్సా (పోలాండ్),6,52.22,21.05,Europe/Warsaw",
"జెడ్డా (సౌదీ అరేబియా),4,21.57,39.17,Asia/Riyadh",
"దమ్మాం (సౌదీ అరేబియా),4,26.43,50.1,Asia/Riyadh",
"మానామా (బహ్రెయిన్),4,26.22,50.59,Asia/Bahrain"
];

function gen_cities() {
// for each value in array new_cities
for (let i = 0; i < new_cities.length; i++) {
    const city = new_cities[i];
    const parts = city.split(",");
    const name = parts[0];
    const category = parseInt(parts[1]);
    const lat = parseFloat(parts[2]);
    const lon = parseFloat(parts[3]);
    const tz = parts[4];
    const city_id = encode_city_id(lat, lon, tz);
    console.log(`"${city_id}": { "city_name": "${name}", "category_id": ${category} }`);
}
}

export { gen_cities };
