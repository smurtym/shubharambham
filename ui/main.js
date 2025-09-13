import { cities } from './city_data.js';
import { get_data } from './data.js';
import { decode_city_id } from './city_helper.js'

//document.addEventListener('DOMContentLoaded', function () {
let dp =   new AirDatepicker('#datepicker', {
        inline: true,
        locale: {
            daysMin: ['ఆది', 'సోమ', 'మంగళ', 'బుధ', 'గురు', 'శుక్ర', 'శని'],
            months: ['జనవరి', 'ఫిబ్రవరి', 'మార్చి', 'ఏప్రిల్', 'మే', 'జూన్', 'జూలై', 'ఆగస్ట్', 'సెప్టెంబర్', 'అక్టోబర్', 'నవంబర్', 'డిసెంబర్'],
            monthsShort: ['జనవరి', 'ఫిబ్రవరి', 'మార్చి', 'ఏప్రిల్', 'మే', 'జూన్', 'జూలై', 'ఆగస్ట్', 'సెప్టెంబర్', 'అక్టోబర్', 'నవంబర్', 'డిసెంబర్'],
        },
        //fixedHeight: true,
        // selectOtherMonths: false,
        // showOtherMonths: false,
        minDate: new Date(1951, 0, 1),
        maxDate: new Date(2100, 11, 31),
        dateFormat: 'yyyy-MM-dd',
        firstDay: 0,
        //buttons: [button],
        toggleSelected: false,
        onSelect: ({date, formattedDate, datepicker}) =>  { onSelectTrigger({date, formattedDate, datepicker}) },
        onChangeViewDate: ({month, year, decade}) => { onChangeViewDateTrigger({month, year, decade}) }

    });
//});

dp.selectDate(new Date(), {silent: false});

const params = new URLSearchParams(document.location.search);
const city_id = params.get("city_id");

// Add a label to display the selected city
const cityLabel = document.getElementById("city");
if (city_id && cities[city_id]) {
    cityLabel.textContent = `నగరం/ప్రాంతం: ${cities[city_id].city_name}`;
} else {
    cityLabel.textContent = 'నగరం/ప్రాంతం: Not specified';
}

cityLabel.innerHTML += `<br><a href="index.html">(మార్చడానికి ఇక్కడ క్లిక్ చేయండి)</a>`;

const decoded_data = decode_city_id(city_id);
const lat = decoded_data.lat;
const long = decoded_data.lon;
const tz = decoded_data.tz;
//console.log(`City ID: ${city_id}, Lat: ${lat}, Long: ${long}, TZ: ${tz}`);

class RenderQueue {
  constructor() {
    this.chain = Promise.resolve();
  }

  add(dt) {
    this.chain = this.chain.then(() => renderPanchangam(dt));
    return this.chain;
  }

}

// Create an instance of the RenderQueue
const renderQueue = new RenderQueue();

// Swipe functionality for mobile devices
const table = document.getElementById('panchangam');
let startX = 0;
let endX = 0;
table.addEventListener('touchstart', function(e) {
  startX = e.touches[0].clientX;
});
table.addEventListener('touchmove', function(e) {
  endX = e.touches[0].clientX;
});
table.addEventListener('touchend', function() {
  const diffX = endX - startX;
  if (Math.abs(diffX) > 100) { // threshold for swipe
    if (diffX > 0) {
    //   console.log('Swiped Right');
      let selectedDate = new Date(dp.selectedDates[0]);
      selectedDate.setDate(selectedDate.getDate() - 1);
      dp.setFocusDate(selectedDate);
    //   console.log(selectedDate);
      dp.selectDate(selectedDate, {silent: false});
    } else {
    //   console.log('Swiped Left');
      let selectedDate = new Date(dp.selectedDates[0]);
      selectedDate.setDate(selectedDate.getDate() + 1);
      dp.setFocusDate(selectedDate);
    //   console.log(selectedDate);
      dp.selectDate(selectedDate, {silent: false});
    }
  }
});


//Function that will be called when date is selected
async function onSelectTrigger({date, formattedDate, datepicker}) {
    renderQueue.add(formattedDate);
}

async function renderPanchangam(date) {

    let table = document.getElementById("panchangam");
    table.innerHTML = "Loading..."; // Clear previous content

    await get_data(date, lat, long, tz).then(data => {
        //console.log(data);

        // let table = document.getElementById("panchangam");
        table.innerHTML = ""; // Clear previous content

        data.forEach(item => {
            let row = document.createElement("tr");
            row.innerHTML = `
                <td>${item.key}</td>
                <td>${item.value}</td>
        `   ;
        table.appendChild(row);
    });
    }).catch(error => {
        console.error('Error fetching data:', error);
    });

}

// Function that will be called when month is changed
async function onChangeViewDateTrigger({month, year, decade}) {
    await dp.selectDate(new Date(year, month, 1), {silent: false});
}