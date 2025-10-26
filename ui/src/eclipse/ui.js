import { get_eclipse_data } from './data.js';

import { cities } from '../city/data.js';
import { decode_city_id } from '../city/helper.js';

// let data = get_eclipse_data(1976, 13.0827, 80.2707, "Asia/Kolkata");
// data.then(data => {
    
//    // Convert to string and log
//    console.log(JSON.stringify(data, null, 2));
// });
console.log("Version: 2.0.2");
let dp =   new AirDatepicker('#datepicker', {
        inline: true,
        minDate: new Date(1951, 0, 1),
        maxDate: new Date(2100, 11, 31),
        dateFormat: 'yyyy-MM-dd',
        view: 'years',
        minView: 'years',
        firstDay: 0,
        toggleSelected: false,
        onSelect: ({date, formattedDate, datepicker}) =>  { onSelectTrigger({date, formattedDate, datepicker}) },
        onChangeViewDate: ({month, year, decade}) => { onChangeViewDateTrigger({month, year, decade}) }

    });
//});

dp.selectDate(new Date(), {silent: false});
// dp.setCurrentView("years", {});


const params = new URLSearchParams(document.location.search);
const city_id = params.get("city_id");

// Add a label to display the selected city
const cityLabel = document.getElementById("city");
if (city_id && cities[city_id]) {
    cityLabel.textContent = `నగరం/ప్రాంతం: ${cities[city_id].city_name}`;
    document.title = `గ్రహణ సమయాలు - ${cities[city_id].city_name}`;
} else {
    cityLabel.textContent = 'నగరం/ప్రాంతం: Not specified';
    document.title = 'గ్రహణ సమయాలు';
}

cityLabel.innerHTML += `<br><a href="../city/index.html?page=eclipse">(మార్చడానికి ఇక్కడ క్లిక్ చేయండి)</a>`;

const decoded_data = decode_city_id(city_id);
const lat = decoded_data.lat;
const long = decoded_data.lon;
const tz = decoded_data.tz;

//console.log(`City ID: ${city_id}, Lat: ${lat}, Long: ${long}, TZ: ${tz}`);

// class RenderQueue {
//   constructor() {
//     this.chain = Promise.resolve();
//   }

//   add(dt) {
//     this.chain = this.chain.then(() => renderPanchangam(dt));
//     return this.chain;
//   }

// }

// Create an instance of the RenderQueue
// const renderQueue = new RenderQueue();

const table = document.getElementById('eclipse');

// Store the last selected decade to detect navigation
// Make default value as start year of current decade
let lastSelectedDecade = new Date().getFullYear() - (new Date().getFullYear() % 10);

async function onChangeViewDateTrigger({month, year, decade}) {
      // console.log(`View changed to Month: ${month}, Year: ${year}, Decade: ${decade}`);
      
      // Get the start year (first element of decade array)
      const startYear = decade[0];
      
      // Check if decade has changed
      if (lastSelectedDecade !== startYear) {
          lastSelectedDecade = startYear;
          await dp.selectDate(new Date(startYear, 0, 1), {silent: false});
      }
}

async function onSelectTrigger({date, formattedDate, datepicker}) {
    //console.log selected year
    const selectedYear = date.getFullYear();
    renderEclipse(selectedYear);
}

async function renderEclipse(year) {
    // Clear existing table content
    table.innerHTML = '';

    // Fetch eclipse data for the selected year
    const eclipseData = await get_eclipse_data(year, lat, long, tz);
    //console.log(`Eclipse data for year ${year}:`, eclipseData);

    //console.log(eclipseData);

    // If there are no eclipses, show a message like above
    if (eclipseData.length === 0) {
        const row = document.createElement('tr');
        const cell = document.createElement('td');
        cell.textContent = `${cities[city_id].city_name} నగరంలో ${year} సంవత్సరంలో ఏ గ్రహణాలు కనిపించవు.`;
        row.appendChild(cell);
        table.appendChild(row);
        return;
    }

    // For each eclipse, create a table row
    // In each table row, create a nested table for the eclipse details
    // Nested table will have two columns: key and value

    eclipseData.forEach(eclipse => {
        const row = document.createElement('tr');
        const nestedTable = document.createElement('table');
        // eclipse contains an array of key-value pairs
        eclipse.forEach(detail => {
            const detailRow = document.createElement('tr');
            const keyCell = document.createElement('td');
            keyCell.textContent = detail.key;
            const valueCell = document.createElement('td');
            valueCell.textContent = detail.value;
            detailRow.appendChild(keyCell);
            detailRow.appendChild(valueCell);
            nestedTable.appendChild(detailRow);
        } );

        // const copyButton = document.createElement('button');
        // copyButton.textContent = 'పంచడానికి నకలు (Copy to Share)';
        // copyButton.addEventListener('click', async () => {
        //     let cb_data = "🕉️ *శుభారంభం* 🕉️\n";
        //     cb_data += "*---------------* \n";
        //     cb_data += `*${cities[city_id].city_name}* నగరానికి గ్రహణ సమయాలు \n`;
        //     eclipse.forEach(detail => {
        //         cb_data += `*${detail.key.trim()}* : ${detail.value.trim()}\n`;
        //     });
        //     cb_data += "( _*సేకరణ*: మునుకుట్ల సత్యనారాయణ మూర్తి నిర్వహిస్తున్న https://shubharambham.com/ వెబ్‌సైట్ నుండి_ )";
        //     await navigator.clipboard.writeText(cb_data);
        // });
        // const buttonRow = document.createElement('tr');
        // const buttonCell = document.createElement('td');
        // buttonCell.colSpan = 2; // Span across both columns

        // buttonCell.appendChild(copyButton);
        // buttonRow.appendChild(buttonCell);
        // nestedTable.appendChild(buttonRow);

        row.appendChild(nestedTable);
        table.appendChild(row);
    });

}