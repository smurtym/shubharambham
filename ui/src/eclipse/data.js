
import { eclipse_data } from '../wasm-wrapper/wasm-wrapper.js';
import { english_month, vara_1, rasi, nakshatra } from '../locale/telugu.js';

async function get_eclipse_data(year, lat, long, tz) {
    //console.log(`Fetching eclipse data for year: ${year}, lat: ${lat}, long: ${long}, tz: ${tz}`);

    try {

        const data_str = await eclipse_data(lat, long, year, tz);
        //console.log('Data fetched successfully:', data_str);
        const data = JSON.parse(data_str);

        // for element in data, format it, and add to formattedData array
        let formattedData = [];
        data.forEach(eclipse => {
            let formattedEclipse = formatEclipseData(eclipse);
            formattedData.push(formattedEclipse);
        });

        return formattedData;
    } catch (error) {
        console.error('Error:', error);
    }
}

function formatEclipseData(eclipse) {

    //console.log(eclipse);
    // Format the eclipse data as needed
    let formattedEclipse = [];

    let english_date = eclipse.yyyy + " " + english_month[parseInt(eclipse.mm)] + " " + eclipse.dd + " "
         + vara_1[eclipse.weekDay] + "వారం";

    if (eclipse.isVisibleNextDay) {
        english_date += " (తెల్లవారితే " + vara_1[(eclipse.weekDay % 7) + 1] + "వారం)";
    }

    formattedEclipse.push({
        "key": "ఆంగ్ల తేది",
        "value": english_date
    })

    let eclipse_type = "";
    if (eclipse.isRahu) {
        eclipse_type += "రాహుగ్రస్త ";
    } else {
        eclipse_type += "కేతుగ్రస్త ";
    }

    if (eclipse.riseInEclipseTime != null) {
        eclipse_type += "గ్రస్తోదయ ";
    } 
    if (eclipse.setInEclipseTime != null) {
        eclipse_type += "గ్రస్తాస్తమయ ";
    }

    if (eclipse.isAnnular) {
        eclipse_type += "కంకణాకార ";
    }

    if (eclipse.isTotal) {
        eclipse_type += "సంపూర్ణ ";
    } else if (!eclipse.isAnnular) {
        eclipse_type += "పాక్షిక ";
    }

    if (eclipse.isSolar) {
        eclipse_type += "సూర్య గ్రహణం";
    } else {
        eclipse_type += "చంద్ర గ్రహణం";
    }

    formattedEclipse.push({
        "key": "గ్రహణ వివరణ",
        "value": eclipse_type
    })

    let nakshatra_info = "";
    if (eclipse.startNakshatra == eclipse.endNakshatra && eclipse.startRasi == eclipse.endRasi) {
        if (eclipse.startNakshatraPada == eclipse.endNakshatraPada) {
            nakshatra_info = nakshatra[eclipse.startNakshatra] + " " + eclipse.startNakshatraPada + "వ పాదం (" +
                rasi[eclipse.startRasi] + "రాశి)";
        } else {
            nakshatra_info = nakshatra[eclipse.startNakshatra] + " " + eclipse.startNakshatraPada + "," + eclipse.endNakshatraPada + "వ పాదాలు (" +
                rasi[eclipse.startRasi] + "రాశి)";
        }
    } else {
        nakshatra_info = nakshatra[eclipse.startNakshatra] + " " + eclipse.startNakshatraPada + "వ పాదం (" +
            rasi[eclipse.startRasi] + "రాశి), " +
            nakshatra[eclipse.endNakshatra] + " " + eclipse.endNakshatraPada + "వ పాదం (" +
            rasi[eclipse.endRasi] + "రాశి)";
    }

    formattedEclipse.push({
        "key": "నక్షత్రం - రాశి",
        "value": nakshatra_info
    })

    let touch_time = "";
    // We will have touch time always in case of solar eclipse
    // For lunar eclipse, we may not have touch time only if isStartVisible is false
    if (eclipse.isSolar == true || eclipse.isStartVisible == true) {
        touch_time = formatTime(eclipse.startTime);
    } else {
        touch_time = "కనిపించదు";
    }

    formattedEclipse.push({
        "key": "స్పర్శకాలం",
        "value": touch_time
    })

    let rise_time = "";
    if (eclipse.riseInEclipseTime != null) {
        rise_time = formatTime(eclipse.riseInEclipseTime);
        if (eclipse.isSolar) {
            formattedEclipse.push({
                "key": "సూర్యోదయం",
                "value": rise_time
            })
        } else {
            formattedEclipse.push({
                "key": "చంద్రోదయం",
                "value": rise_time
            })
        }
    }

    let start_time = "";

    if (eclipse.isSolar && eclipse.riseInEclipseTime != null) {
        start_time = rise_time + " (సూర్యోదయం) నుండి";
    } else if (eclipse.isSolar == false && eclipse.riseInEclipseTime != null) {
        start_time = rise_time + " (చంద్రోదయం) నుండి";
    } else {
        start_time = touch_time + " (స్పర్శకాలం) నుండి";
    }

    formattedEclipse.push({
        "key": "గ్రహణం కనిపించడం మొదలు",
        "value": start_time
    })

    let max_time = "";
    if (eclipse.maxTime != null) {
        max_time = formatTime(eclipse.maxTime);
    } else {
        max_time = "కనిపించదు";
    }

    formattedEclipse.push({
        "key": "మధ్యకాలం",
        "value": max_time
    })
    
    let set_time = "";
    if (eclipse.setInEclipseTime != null) {
        set_time = formatTime(eclipse.setInEclipseTime);
        if (eclipse.isSolar) {
            formattedEclipse.push({
                "key": "సూర్యాస్తమయం",
                "value": set_time
            })
        } else {
            formattedEclipse.push({
                "key": "చంద్రాస్తమయం",
                "value": set_time
            })
        }
    }

    let end_time = "";
    if (eclipse.isSolar && eclipse.setInEclipseTime != null) {
        end_time = set_time + " (సూర్యాస్తమయం) వరకు";
    } else if (eclipse.isSolar == false && eclipse.setInEclipseTime != null) {
        end_time = set_time + " (చంద్రాస్తమయం) వరకు";
    } else {
        end_time = formatTime(eclipse.endTime) + " (ఉన్మీలనకాలం) వరకు";
    }

    formattedEclipse.push({
        "key": "గ్రహణం కనిపించడం ముగింపు",
        "value": end_time
    })

    if (eclipse.isSolar == true || eclipse.isEndVisible == true) {
        end_time = formatTime(eclipse.endTime);
    } else {
        end_time = "కనిపించదు";
    }

    formattedEclipse.push({
        "key": "ఉన్మీలనకాలం",
        "value": end_time
    })


// Output: Sample

// ఆంగ్ల తేది	1976 మే 13 గురువారం (తెల్లవారితే శుక్రవారం)
// గ్రహణ వివరణ 	రాహుగ్రస్త పాక్షిక చంద్ర గ్రహణం
// నక్షత్రం - రాశి 	విశాఖ 3వ పాదం (తులరాశి)
// స్పర్శకాలం 	తె.12:46
// గ్రహణం కనిపించడం మొదలు 	తె.12:46 (స్పర్శకాలం) నుండి
// మధ్యకాలం 	తె.01:24
// గ్రహణం కనిపించడం ముగింపు 	తె.02:02 (ఉన్మీలనకాలం) వరకు
// ఉన్మీలనకాలం 	తె.02:02 
    // Input:
// {
//     "isSolar": true,
//     "isTotal": false,
//     "isAnnular": false,
//     "isRahu": false,
//     "date": "2022-10-25",
//     "year": 2022,
//     "month": 10,
//     "day": 25,
//     "location": {
//       "lat": 13.0827,
//       "lon": 80.2707
//     },
//     "weekDay": 3,
//     "isVisibleNextDay": false,
//     "startTime": "17:14",
//     "maxTime": "17:43",
//     "endTime": "18:25",
//     "isStartVisible": true,
//     "isEndVisible": false,
//     "startNakshatra": 15,
//     "startNakshatraPada": 1,
//     "startRasi": 7,
//     "endNakshatra": 15,
//     "endNakshatraPada": 1,
//     "endRasi": 7,
//     "riseInEclipseTime": null,
//     "setInEclipseTime": "17:43"
//   }
    return formattedEclipse;
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

export { get_eclipse_data };