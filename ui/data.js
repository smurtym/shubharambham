import { samvatsara, ayana, masa, nakshatra, ritu, vara, tithi, yoga, karana, hora_lord, english_month } from './telugu_names.js';

import panchang from './wasm/panchang-wasm.js';

var p = await panchang({
    // locateFile: (file) => `wasm/${file}`
    locateFile: function (path) {
        if (path.endsWith('.wasm')) {
          return new URL('./wasm/panchang-wasm.wasm', import.meta.url).href;
        }
        if (path.endsWith('.data')) {
          return new URL('./wasm/panchang-wasm.data', import.meta.url).href;
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

async function get_data(date, lat, long, tz) {

     try {

        const data_str = await panchang_data(lat, long, date, tz);
        // console.log('Data fetched successfully:', data_str);
        const data = JSON.parse(data_str);

        return formatData(data);
    } catch (error) {
        console.error('Error:', error);
    }
}

function formatData(data) {
    // Return array of objects with keys: date, sunrise, sunset, moonrise, moonset
    
    let formattedData = [];
    formattedData.push({
        "key": "ఆంగ్ల తేది",
        "value": data.yyyy + " " + english_month[parseInt(data.mm)] + " " + data.dd
    });

    // Suryodayam
    formattedData.push({
        "key": "సూర్యోదయం",
        "value": formatTime(data.sunRise)
    });
    // Suryasastam
    formattedData.push({
        "key": "సూర్యాస్తమయం",
        "value": formatTime(data.sunSet)
    });

    // Chandrodayam
    let chandrodaya_data = "";
    
    if(data.moonRise) {
        chandrodaya_data = formatTime(data.moonRise);
    } else {
        chandrodaya_data = "అవదు";
    }
    
    formattedData.push({
        "key": "చంద్రోదయం",
        "value": chandrodaya_data
    });

    // Chandrasastam
    let chandrasastam_data = "";
    if(data.moonSet) {
        chandrasastam_data = formatTime(data.moonSet);
    } else {
        chandrasastam_data = "అవదు";
    }

    formattedData.push({
        "key": "చంద్రాస్తమయం",
        "value": chandrasastam_data
    });

    formattedData.push({
        "key": "సంవత్సరం",
        "value": samvatsara[data.samvatsara]
    })
    formattedData.push({
        "key": "అయనం",
        "value": ayana[data.ayana]
    });
    formattedData.push({
        "key": "దృక్ ఋతువు",
        "value": ritu[data.drikRitu]
    });
    formattedData.push({
        "key": "పూర్వ ఋతువు",
        "value": ritu[data.purvaRitu]
    });
    formattedData.push({
        "key": "మాసం",
        "value": 
            (data.masa.isAdhika ? "అధిక " : data.masa.isKshaya ? "క్షయ " : data.masa.isNija ? "నిజ " : "") 
            + masa[data.masa.id] 
    });

    let tithi_data = tithi[data.tithi[0].id][0] + " " + tithi[data.tithi[0].id][1];

    if (data.tithi[0].endTime) {
        tithi_data = tithi_data + " " + formatTime(data.tithi[0].endTime);
    } else {
        tithi_data = tithi_data + " పూర్తి";
    }

    // there is another tithi in data.tithi, so we will add it to the formattedData
    if (data.tithi.length > 1) {
        tithi_data += "<br>  " + tithi[data.tithi[1].id][1];
        tithi_data += " " + formatTime(data.tithi[1].endTime);
    }

    formattedData.push({
        "key": "తిథి",
        "value": tithi_data
    });

    formattedData.push({
        "key": "వారం",
        "value": vara[data.weekDay]
    });

    let nakshatra_data = nakshatra[data.nakshatra[0].id];
    if (data.nakshatra[0].endTime) {
        nakshatra_data = nakshatra_data + " " + formatTime(data.nakshatra[0].endTime);
    } else {
        nakshatra_data = nakshatra_data + " పూర్తి";
    }

    if (data.nakshatra.length > 1) {
        nakshatra_data += "<br>  " + nakshatra[data.nakshatra[1].id];
        nakshatra_data += " " + formatTime(data.nakshatra[1].endTime);
    }

    formattedData.push({
        "key": "నక్షత్రం",
        "value": nakshatra_data
    });

    let yoga_data = yoga[data.yoga[0].id];
    
    if (data.yoga[0].endTime) {
        yoga_data = yoga_data + " " + formatTime(data.yoga[0].endTime);
    } else {
        yoga_data = yoga_data + " పూర్తి";
    }
    
    if (data.yoga.length > 1) {
        yoga_data += "<br>  " + yoga[data.yoga[1].id];
        yoga_data += " " + formatTime(data.yoga[1].endTime);
    }

    formattedData.push({
        "key": "యోగం",
        "value": yoga_data
    });

    let karana_data = data.karana.map(k => {
        let karana_name = karana[k.id] + " " + formatTime(k.endTime);
        return karana_name;
    });

    formattedData.push({
        "key": "కరణం",
        "value": karana_data.join("<br>")
    });

    let varjya_data = "";
    if (data.varjya.length === 0) {
        varjya_data = "లేదు";
    } 

    if (data.varjya.length > 0) {
        if (data.varjya[0].startTime && data.varjya[0].endTime) {
            varjya_data = formatTime(data.varjya[0].startTime) + " ల. " + formatTime(data.varjya[0].endTime) + " వ.";
        } else if (data.varjya[0].startTime) {
            varjya_data = formatTime(data.varjya[0].startTime) + " ల. ";
        } else if (data.varjya[0].endTime) {
            varjya_data = "శేష వర్జ్యం " + formatTime(data.varjya[0].endTime) + " వ.";
        } 
    }

    if (data.varjya.length > 1) {
        varjya_data += "<br>  "
        if (data.varjya[1].startTime && data.varjya[1].endTime) {
            varjya_data += formatTime(data.varjya[1].startTime) + " ల. " + formatTime(data.varjya[1].endTime) + " వ.";
        }
        else {
            varjya_data += formatTime(data.varjya[1].startTime) + " ల. ";
        }
    }

    formattedData.push({
        "key": "వర్జ్యం",
        "value": varjya_data
    });

    let durmuhurtha_data = data.durmuhurtha.map(d => {
        let startTime = formatTime(d.startTime);
        let endTime = formatTime(d.endTime);
        return startTime + " ల. " + endTime + " వ.";
    });

    formattedData.push({
        "key": "దుర్ముహూర్తం",
        "value": durmuhurtha_data.join("<br>")
    });

    let abhijit_data = "";
    if (data.abhijit) {
        abhijit_data = formatTime(data.abhijit.startTime) + " ల. " + formatTime(data.abhijit.endTime) + " వ.";
    } else {
        abhijit_data = "లేదు";
    }

    formattedData.push({
        "key": "అభిజిత్",
        "value": abhijit_data
    });


    let aparahna_data = formatTime(data.aparahna.startTime) + " ల. " + formatTime(data.aparahna.endTime) + " వ.";
  
    formattedData.push({
        "key": "అపరాహ్నం",
        "value": aparahna_data
    });

    let rahuKala_data = formatTime(data.rahuKala.startTime) + " ల. " + formatTime(data.rahuKala.endTime) + " వ.";

    formattedData.push({
        "key": "రాహు కాలం",
        "value": rahuKala_data
    });

    // Dina Hora: Slice first 12 elements of data.hora
    let dina_hora_data = data.hora.slice(0, 12).map(h => {
        let startTime = formatTime(h.startTime);
        let endTime = formatTime(h.endTime);
        return hora_lord[h.id] + " " + startTime + " ల. " + endTime + " వ.";
    });

    formattedData.push({
        "key": "పగటి హోరలు",
        "value": dina_hora_data.join("<br>")
    });

    // Raatri Hora: Slice last 12 elements of data.hora
    let raatri_hora_data = data.hora.slice(12).map(h => {
        let startTime = formatTime(h.startTime);
        let endTime = formatTime(h.endTime);
        return hora_lord[h.id] + " " + startTime + " ల. " + endTime + " వ.";
    });

    formattedData.push({
        "key": "రాత్రి హోరలు",
        "value": raatri_hora_data.join("<br>")
    });

    return formattedData;
}

function formatTime(time) {

    const [hours, minutes] = time.split(':').map(Number);

    let formattedTime = '';

    if (hours < 12) {
        formattedTime += 'ఉ. ';
    } else if (hours >= 12 && hours < 16) {
        formattedTime += 'మ. ';
    } else if (hours >= 16 && hours < 20) {
        formattedTime += 'సా. ';
    } else if (hours >= 20 && hours < 24) {
        formattedTime += 'రా. ';
    } else if (hours >= 24) {
        formattedTime += 'తె. ';
    }

    if (hours <= 12) {
        formattedTime += hours.toString().padStart(2, '0') + ':' + minutes.toString().padStart(2, '0');
    } else if (hours > 12 && hours <= 24) {
        formattedTime += (hours - 12).toString().padStart(2, '0') + ':' + minutes.toString().padStart(2, '0');
    } else if (hours > 24) {
        formattedTime += (hours - 24).toString().padStart(2, '0') + ':' + minutes.toString().padStart(2, '0');
    } 

    return formattedTime;
}

export { get_data };

// Sample data structure for formattedData
// {
//   "dt": "2025-08-12",
//   "yyyy": "2025",
//   "mm": "08",
//   "dd": "12",
//   "tz": "Asia/Kolkata",
//   "location": {
//     "lat": 17.39,
//     "lon": 78.47
//   },
//   "weekDay": 3,
//   "sunRise": "06:02",
//   "sunSet": "18:40",
//   "moonRise": "21:00",
//   "moonSet": "08:35",
//   "nextSunRise": "30:02",
//   "samvatsara": 39,
//   "ayana": 2,
//   "drikRitu": 3,
//   "purvaRitu": 3,
//   "masa": {
//     "isAdhika": false,
//     "isNija": false,
//     "isKshaya": false,
//     "id": 5
//   },
//   "tithi": [
//     {
//       "id": 18,
//       "endTime": "08:41"
//     }
//   ],
//   "nakshatra": [
//     {
//       "id": 25,
//       "endTime": "11:50"
//     }
//   ],
//   "karana": [
//     {
//       "id": 36,
//       "endTime": "08:41"
//     },
//     {
//       "id": 37,
//       "endTime": "19:40"
//     }
//   ],
//   "yoga": [
//     {
//       "id": 7,
//       "endTime": "18:50"
//     }
//   ],
//   "varjya": [
//     {
//       "startTime": "20:56",
//       "endTime": "22:26"
//     }
//   ],
//   "durmuhurtha": [
//     {
//       "startTime": "08:34",
//       "endTime": "09:24"
//     },
//     {
//       "startTime": "23:13",
//       "endTime": "23:58"
//     }
//   ],
//   "abhijit": {
//     "startTime": "11:56",
//     "endTime": "12:46"
//   },
//   "aparahna": {
//     "startTime": "13:37",
//     "endTime": "16:08"
//   },
//   "rahuKala": {
//     "startTime": "15:31",
//     "endTime": "17:05"
//   },
//   "hora": [
//     {
//       "id": 3,
//       "startTime": "06:02",
//       "endTime": "07:05"
//     },
//     {
//       "id": 1,
//       "startTime": "07:05",
//       "endTime": "08:08"
//     },
//     {
//       "id": 6,
//       "startTime": "08:08",
//       "endTime": "09:12"
//     },
//     {
//       "id": 4,
//       "startTime": "09:12",
//       "endTime": "10:15"
//     },
//     {
//       "id": 2,
//       "startTime": "10:15",
//       "endTime": "11:18"
//     },
//     {
//       "id": 7,
//       "startTime": "11:18",
//       "endTime": "12:21"
//     },
//     {
//       "id": 5,
//       "startTime": "12:21",
//       "endTime": "13:24"
//     },
//     {
//       "id": 3,
//       "startTime": "13:24",
//       "endTime": "14:27"
//     },
//     {
//       "id": 1,
//       "startTime": "14:27",
//       "endTime": "15:31"
//     },
//     {
//       "id": 6,
//       "startTime": "15:31",
//       "endTime": "16:34"
//     },
//     {
//       "id": 4,
//       "startTime": "16:34",
//       "endTime": "17:37"
//     },
//     {
//       "id": 2,
//       "startTime": "17:37",
//       "endTime": "18:40"
//     },
//     {
//       "id": 7,
//       "startTime": "18:40",
//       "endTime": "19:37"
//     },
//     {
//       "id": 5,
//       "startTime": "19:37",
//       "endTime": "20:34"
//     },
//     {
//       "id": 3,
//       "startTime": "20:34",
//       "endTime": "21:31"
//     },
//     {
//       "id": 1,
//       "startTime": "21:31",
//       "endTime": "22:27"
//     },
//     {
//       "id": 6,
//       "startTime": "22:27",
//       "endTime": "23:24"
//     },
//     {
//       "id": 4,
//       "startTime": "23:24",
//       "endTime": "24:21"
//     },
//     {
//       "id": 2,
//       "startTime": "24:21",
//       "endTime": "25:18"
//     },
//     {
//       "id": 7,
//       "startTime": "25:18",
//       "endTime": "26:15"
//     },
//     {
//       "id": 5,
//       "startTime": "26:15",
//       "endTime": "27:12"
//     },
//     {
//       "id": 3,
//       "startTime": "27:12",
//       "endTime": "28:09"
//     },
//     {
//       "id": 1,
//       "startTime": "28:09",
//       "endTime": "29:05"
//     },
//     {
//       "id": 6,
//       "startTime": "29:05",
//       "endTime": "30:02"
//     }
//   ]
// }