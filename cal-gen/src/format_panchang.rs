use panchang_core::PanchangData;
use serde::{Serialize, Deserialize};

// use crate::cal_table::Calendar;

#[derive(Debug)]
#[derive(Serialize, Deserialize)]
pub struct CalendarData {
    pub mm: u8,
    pub dd: u8,
    pub month: String,
    pub yyyymmdd: u32,
    pub header: String,
    pub celldata: String,
}

// Convert PanchangData to string for display
const SAMVATSARA: [&str; 61] = [
    "",
    "ప్రభవ",
    "విభవ",
    "శుక్ల",
    "ప్రమోద్యూత",
    "ప్రజోత్పత్తి",
    "ఆంగీరస",
    "శ్రీముఖ",
    "భావ",
    "యువ",
    "ధాత",
    "ఈశ్వర",
    "బహుధాన్య",
    "ప్రమాధి",
    "విక్రమ",
    "వృష",
    "చిత్రభాను",
    "స్వభాను",
    "తారణ",
    "పార్థివ",
    "వ్యయ",
    "సర్వజిత్తు",
    "సర్వధారి",
    "విరోధి",
    "వికృతి",
    "ఖర",
    "నందన",
    "విజయ",
    "జయ",
    "మన్మధ",
    "దుర్ముఖి",
    "హేవళంబి",
    "విళంబి",
    "వికారి",
    "శార్వరి",
    "ప్లవ",
    "శుభకృతు",
    "శోభకృతు",
    "క్రోధి",
    "విశ్వావసు",
    "పరాభవ",
    "ప్లవంగ",
    "కీలక",
    "సౌమ్య",
    "సాధారణ",
    "విరోధికృతు",
    "పరిధావి",
    "ప్రమాదీచ",
    "ఆనంద",
    "రాక్షస",
    "నల",
    "పింగళ",
    "కాళయుక్తి",
    "సిద్ధార్ది",
    "రౌద్రి",
    "దుర్మతి",
    "దుందుభి",
    "రుధిరోద్గారి",
    "రక్తాక్షి",
    "క్రోధన",
    "అక్షయ"
];

const AYANA: [&str; 3] = [
    "",
    "ఉత్తరాయణం",
    "దక్షిణాయణం"
];

const MASA: [&str; 13] = [
    "",
    "చైత్ర",
    "వైశాఖ",
    "జ్యేష్ఠ",
    "ఆషాఢ",
    "శ్రావణ",
    "భాద్రపద",
    "ఆశ్వయుజ",
    "కార్తీక",
    "మార్గశిర",
    "పుష్య",
    "మాఘ",
    "ఫాల్గుణ"
];

const NAKSHATRA: [&str; 28] = [
    "",
    "అశ్విని",
    "భరణి",
    "కృత్తిక",
    "రోహిణి",
    "మృగశిర",
    "ఆరుద్ర",
    "పునర్వసు",
    "పుష్యమి",
    "ఆశ్లేష",
    "మఖ",
    "పుబ్బ",
    "ఉత్తర",
    "హస్త",
    "చిత్త",
    "స్వాతి",
    "విశాఖ",
    "అనూరాధ",
    "జ్యేష్ఠ",
    "మూల",
    "పూర్వాషాఢ",
    "ఉత్తరాషాఢ",
    "శ్రవణం",
    "ధనిష్ట",
    "శతభిష",
    "పూర్వాభాద్ర",
    "ఉత్తరాభాద్ర",
    "రేవతి"
];

const RITU: [&str; 7] = [
    "",
    "వసంత",
    "గ్రీష్మ",
    "వర్ష",
    "శరద్",
    "హేమంత",
    "శిశిర"
];

// const VARA: [&str; 8] = [
//     "",
//     "ఆది (భాను)",
//     "సోమ (ఇందు)",
//     "మంగళ (భౌమ)",
//     "బుధ (సౌమ్య)",
//     "గురు (బృహస్పతి)",
//     "శుక్ర (భృగు)",
//     "శని (స్థిర)"
// ];

const TITHI: [(&str, &str); 31] = [
    ("", ""),
    ("శుక్ల", "పాడ్యమి"),
    ("శుక్ల", "విదియ"),
    ("శుక్ల", "తదియ"),
    ("శుక్ల", "చవితి"),
    ("శుక్ల", "పంచమి"),
    ("శుక్ల", "షష్ఠి"),
    ("శుక్ల", "సప్తమి"),
    ("శుక్ల", "అష్టమి"),
    ("శుక్ల", "నవమి"),
    ("శుక్ల", "దశమి"),
    ("శుక్ల", "ఏకాదశి"),
    ("శుక్ల", "ద్వాదశి"),
    ("శుక్ల", "త్రయోదశి"),
    ("శుక్ల", "చతుర్ధశి"),
    ("శుక్ల", "పూర్ణిమ"),
    ("కృష్ణ", "పాడ్యమి"),
    ("కృష్ణ", "విదియ"),
    ("కృష్ణ", "తదియ"),
    ("కృష్ణ", "చవితి"),
    ("కృష్ణ", "పంచమి"),
    ("కృష్ణ", "షష్ఠి"),
    ("కృష్ణ", "సప్తమి"),
    ("కృష్ణ", "అష్టమి"),
    ("కృష్ణ", "నవమి"),
    ("కృష్ణ", "దశమి"),
    ("కృష్ణ", "ఏకాదశి"),
    ("కృష్ణ", "ద్వాదశి"),
    ("కృష్ణ", "త్రయోదశి"),
    ("కృష్ణ", "చతుర్ధశి"),
    ("కృష్ణ", "అమావాస్య")
];

// const YOGA: [&str; 28] = [
//     "",
//     "విష్కంభ",
//     "ప్రీతి",
//     "ఆయుష్మాన్",
//     "సౌభాగ్య",
//     "శోభన",
//     "అతిగండ",
//     "సుకర్మన్",
//     "ధృతి",
//     "శూల",
//     "గండ",
//     "వృద్ధి",
//     "ధ్రువ",
//     "వ్యాఘాత",
//     "హర్షణ",
//     "వజ్ర",
//     "సిద్ధి",
//     "వ్యతీపాత",
//     "వరియన్",
//     "పరిఘ",
//     "శివ",
//     "సిద్ధ",
//     "సాధ్య",
//     "శుభ",
//     "శుక్ల",
//     "బ్రహ్మ",
//     "ఇంద్ర",
//     "వైధృతి"
// ];

// const KARANA: [&str; 61] = [
//     "",
//     "కింస్తుఘ్న",
//     "బవ",
//     "బాలవ",
//     "కౌలవ",
//     "తైతుల",
//     "గరిజ",
//     "వణిజ",
//     "విష్టి(భద్ర)",
//     "బవ",
//     "బాలవ",
//     "కౌలవ",
//     "తైతుల",
//     "గరిజ",
//     "వణిజ",
//     "విష్టి(భద్ర)",
//     "బవ",
//     "బాలవ",
//     "కౌలవ",
//     "తైతుల",
//     "గరిజ",
//     "వణిజ",
//     "విష్టి(భద్ర)",
//     "బవ",
//     "బాలవ",
//     "కౌలవ",
//     "తైతుల",
//     "గరిజ",
//     "వణిజ",
//     "విష్టి(భద్ర)",
//     "బవ",
//     "బాలవ",
//     "కౌలవ",
//     "తైతుల",
//     "గరిజ",
//     "వణిజ",
//     "విష్టి(భద్ర)",
//     "బవ",
//     "బాలవ",
//     "కౌలవ",
//     "తైతుల",
//     "గరిజ",
//     "వణిజ",
//     "విష్టి(భద్ర)",
//     "బవ",
//     "బాలవ",
//     "కౌలవ",
//     "తైతుల",
//     "గరిజ",
//     "వణిజ",
//     "విష్టి(భద్ర)",
//     "బవ",
//     "బాలవ",
//     "కౌలవ",
//     "తైతుల",
//     "గరిజ",
//     "వణిజ",
//     "విష్టి(భద్ర)",
//     "శకున",
//     "చతుష్పాద",
//     "నాగ"
// ];

pub const ENGLISH_MONTH: [&str; 13] = [
    "",
    "జనవరి",
    "ఫిబ్రవరి",
    "మార్చి",
    "ఏప్రిల్",
    "మే",
    "జూన్",
    "జూలై",
    "ఆగస్ట్",
    "సెప్టెంబర్",
    "అక్టోబర్",
    "నవంబర్",
    "డిసెంబర్"
];

// pub const WEEKDAY_NAME: [&str; 7] =    [
// "ఆది </br> (భాను) </br> Sun",
// "సోమ </br> (ఇందు) </br> Mon",
// "మంగళ </br> (భౌమ) </br> Tue",
// "బుధ </br> (సౌమ్య) </br> Wed",
// "గురు </br> (బృహస్పతి) </br> Thu",
// "శుక్ర </br> (భృగు) </br> Fri",
// "శని </br> (స్థిర) </br> Sat"
//                      ];
                    
pub const WEEKDAY_NAME: [&str; 7] =    [
"<p>ఆది </p> <p> (భాను) </p> <p> Sun</p>",
"<p>సోమ </p> <p> (ఇందు) </p> <p> Mon</p>",
"<p>మంగళ </p> <p> (భౌమ) </p> <p> Tue</p>",
"<p>బుధ </p> <p> (సౌమ్య) </p> <p> Wed</p>",
"<p>గురు </p> <p> (బృహస్పతి) </p> <p> Thu</p>",
"<p>శుక్ర </p> <p> (భృగు) </p> <p> Fri</p>",
"<p>శని </p> <p> (స్థిర) </p> <p> Sat</p>"
                     ];

// const HORA_LORD: [&str; 8] = [
//     "",
//     "రవి",
//     "చంద్ర",
//     "కుజ",
//     "బుధ",
//     "గురు",
//     "శుక్ర",
//     "శని"
// ];

// const VARA_1: [&str; 8] = [
//     "",
//     "ఆది",
//     "సోమ",
//     "మంగళ",
//     "బుధ",
//     "గురు",
//     "శుక్ర",
//     "శని"
// ];

// const RASI: [&str; 13] = [
//     "",
//     "మేష",
//     "వృషభ",
//     "మిథున",
//     "కర్కాటక",
//     "సింహ",
//     "కన్య",
//     "తుల",
//     "వృశ్చిక",
//     "ధనుస్సు",
//     "మకర",
//     "కుంభ",
//     "మీన"
// ];

fn format_time(time: &str) -> String {
    let parts: Vec<&str> = time.split(':').collect();
    let hours: u32 = parts.get(0).and_then(|s| s.parse().ok()).unwrap_or(0);
    let minutes: u32 = parts.get(1).and_then(|s| s.parse().ok()).unwrap_or(0);
    
    let mut formatted_time = String::new();
    
    if hours < 12 {
        formatted_time.push_str("ఉ. ");
    } else if hours >= 12 && hours < 16 {
        formatted_time.push_str("మ. ");
    } else if hours >= 16 && hours < 20 {
        formatted_time.push_str("సా. ");
    } else if hours >= 20 && hours < 24 {
        formatted_time.push_str("రా. ");
    } else if hours >= 24 {
        formatted_time.push_str("తె. ");
    }
    
    let display_hours = if hours <= 12 {
        hours
    } else if hours > 12 && hours <= 24 {
        hours - 12
    } else {
        hours - 24
    };
    
    formatted_time.push_str(&format!("{:02}:{:02}", display_hours, minutes));
    
    formatted_time
}

pub fn format_panchang_data(panchang: &PanchangData) -> CalendarData {

    let mut celldata = String::new();

    if (panchang.tithi[0].id == 15 && panchang.tithi[0].end_time.is_some())
    || (panchang.tithi.len() > 1 && panchang.tithi[1].id == 15)
     {
        celldata.push_str(&format!("<b>{} Ｏ</b> <br>", &panchang.dd));
      
    } 
    else if (panchang.tithi[0].id == 30 && panchang.tithi[0].end_time.is_some())
        || (panchang.tithi.len() > 1 && panchang.tithi[1].id == 30)
     {
        celldata.push_str(&format!("<b>{} ⬤</b> <br>", &panchang.dd));
      
    } else {
        celldata.push_str(&format!("<b>{}</b> <br>", &panchang.dd));

    }

    



    celldata.push_str(TITHI[panchang.tithi[0].id as usize].1);
    if let Some(end_time) = &panchang.tithi[0].end_time {
        celldata.push_str(" ");
        celldata.push_str(&format_time(end_time));
    } else {
        celldata.push_str(" పూర్తి");
    }
    if panchang.tithi.len() > 1 {
        celldata.push_str("  ");
        celldata.push_str(TITHI[panchang.tithi[1].id as usize].1);
        if let Some(end_time) = &panchang.tithi[1].end_time {
            celldata.push_str(" ");
            celldata.push_str(&format_time(end_time));
        }
    }

    celldata.push_str(&format!(" {}", NAKSHATRA[panchang.nakshatra[0].id as usize]));
    if let Some(end_time) = &panchang.nakshatra[0].end_time {
        celldata.push_str(" ");
        celldata.push_str(&format_time(end_time));
    } else {
        celldata.push_str(" పూర్తి");
    }
    if panchang.nakshatra.len() > 1 {
        celldata.push_str("  ");
        celldata.push_str(NAKSHATRA[panchang.nakshatra[1].id as usize]);
        if let Some(end_time) = &panchang.nakshatra[1].end_time {
            celldata.push_str(" ");
            celldata.push_str(&format_time(end_time));
        }
    }

    // Varjya handling
    celldata.push_str(" ");
    if panchang.varjya.is_empty() {
        celldata.push_str("వర్జ్యం లేదు");
    } else {
        if let Some(first) = panchang.varjya.get(0) {
            match (&first.start_time, &first.end_time) {
                (Some(start), Some(end)) => {
                    celldata.push_str(&format!("వర్జ్యం {} ల. {} వ.", format_time(start), format_time(end)));
                }
                (Some(start), None) => {
                    celldata.push_str(&format!("వర్జ్యం {} ల. ", format_time(start)));
                }
                (None, Some(end)) => {
                    celldata.push_str(&format!("శేష వర్జ్యం {} వ.", format_time(end)));
                }
                (None, None) => {}
            }
        }
        
        if panchang.varjya.len() > 1 {
            if let Some(second) = panchang.varjya.get(1) {
                celldata.push_str(",  ");
                if let (Some(start), Some(end)) = (&second.start_time, &second.end_time) {
                    celldata.push_str(&format!("{} ల. {} వ.", format_time(start), format_time(end)));
                } else if let Some(start) = &second.start_time {
                    celldata.push_str(&format!("{} ల. ", format_time(start)));
                }
            }
        }
    }

    // Durmuhurtha handling
    celldata.push_str(" దు. ");
    let durmuhurtha_parts: Vec<String> = panchang.durmuhurtha.iter()
        .map(|d| format!("{} ల. {} వ.", format_time(&d.start_time), format_time(&d.end_time)))
        .collect();
    celldata.push_str(&durmuhurtha_parts.join(", "));

    let suryodaya = format_time(&panchang.sun_rise);
    celldata.push_str(&format!(" సూ. ఉ. {} ", suryodaya));

    let suryastama = format_time(&panchang.sun_set);
    celldata.push_str(&format!("సూ. అ. {}\n", suryastama));

    let header = 
        SAMVATSARA[panchang.samvatsara as usize].to_string() + " నామ సంవత్సరం " +
        AYANA[panchang.ayana as usize].to_string().as_str() + " " +
        RITU[panchang.drik_ritu as usize].to_string().as_str() + " ఋతువు " +
        if panchang.masa.is_adhika { "అధిక " } else if panchang.masa.is_nija { "నిజ " } else { "" }.to_string().as_str() +
        MASA[panchang.masa.id as usize].to_string().as_str() + " మాసం " +
        if panchang.tithi[0].id <= 15 { "శుక్ల" } else { "కృష్ణ" }.to_string().as_str() +
        " పక్షం";

    //println!("Formatted Panchang Data: Header: {}, Cell Data: {}", header, celldata);

    let output = CalendarData {
        mm: panchang.mm.parse().unwrap_or(0),
        dd: panchang.dd.parse().unwrap_or(0),
        month: ENGLISH_MONTH[panchang.mm.parse().unwrap_or(0) as usize].to_string(),
        yyyymmdd: panchang.dt.clone().replace("-","").to_string().parse().unwrap(),
        header,
        celldata,
    };

    output
}