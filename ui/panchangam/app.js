var cached_panchang = {};
var cb_data = " "

$(document).ready(function () {

  $("#datepicker").datepicker({
    dayNamesMin: ["ఆ", "సో", "మం", "బు", "గు", "శు", "శ"],
    monthNames: ["జనవరి", "ఫిబ్రవరి", "మార్చి", "ఏప్రిల్", "మే", "జూన్", "జూలై", "ఆగస్ట్", "సెప్టెంబర్", "అక్టోబర్", "నవంబర్", "డిసెంబర్"],
    monthNamesShort: ["జనవరి", "ఫిబ్రవరి", "మార్చి", "ఏప్రిల్", "మే", "జూన్", "జూలై", "ఆగస్ట్", "సెప్టెంబర్", "అక్టోబర్", "నవంబర్", "డిసెంబర్"],
    //showOtherMonths:true,
    //selectOtherMonths:true,
    //showButtonPanel: true,
    changeYear: false,
    changeMonth: false,
    showMonthAfterYear: true,
    yearRange: "1951:2049",
    onSelect: updateText,
    onChangeMonthYear: setToFirstDate,
  });

  $("#datepicker").datepicker("option", "disabled", true);

  $("#b2").click(setToday);
  $("#cb").click(copytoCB);

  $("#cities").selectmenu({
    select: city_changed
  });

  fetchcities();
  setToday();

})


async function fetchcities() {
  // cities =  fetch("https://shubharambham.com/api-beta/cities/", {
  //     mode: "no-cors"
  // });

  await $.getJSON("https://shubharambham.com/api-beta/cities/", function (data1) {
    var data = groupByCatategory(data1)
    //console.log(data);

    $c = $('<option>', {
      text: "నగరాన్ని ఎంచుకోండి",
      value: "0"
    });
    $c.appendTo('#cities');


    $("#cities").val("0");
    $("#cities").selectmenu("refresh");

    $.each(data, function (groupName, options) {
      var $optgroup = $("<optgroup>", {
        label: groupName
      });
      $optgroup.appendTo('#cities');
      $.each(options, function (j, option) {
        var $option = $("<option>", {
          text: option.city_name,
          value: option.city_id
        });
        $option.appendTo($optgroup);
      });
    });
    $("#cities").selectmenu("refresh");

  });

}

const groupByCatategory = (arr = []) => {
  let result = [];
  result = arr.reduce((r, a) => {
    r[a.category_name] = r[a.category_name] || [];
    r[a.category_name].push(a);
    return r;
  }, Object.create(null));
  return result;
};


async function fetchpanchang(yr, city_id) {
  // cities =  fetch("https://shubharambham.com/api-beta/cities/", {
  //     mode: "no-cors"
  // });
  //return new Promise(async (resolve,reject)=>{
  //here our function should be implemented 

  if (cached_panchang.city_id != city_id || cached_panchang.year != yr) {
    await $.getJSON("https://shubharambham.com/api-beta/panchang/?city_id=" + city_id + "&year=" + yr, function (data) {

      cached_panchang = data;
      // console.log('Done... fectching for city:' + city_id + " year:" + yr)  
    });
  }

}

function city_changed(event, ui) {
  $("#datepicker").datepicker("option", "disabled", false);
  $("#datepicker").datepicker("option", "changeYear", true);
  $("#datepicker").datepicker("option", "changeMonth", true);
  //console.log("City_changed")
  myrefresh();

}


async function setToday() {
  //console.log("clicked today");

  selected_city = $("#cities")[0].selectedIndex
  //console.log("refresh city selected -1: " + selected_city)
  if (selected_city > 0) {


    $("#datepicker").datepicker("setDate", "+0 day");
    await myrefresh();
    // During the first call it could change month
    // Then it will make date to 1st of current month
    // call it again to set current date
    $("#datepicker").datepicker("setDate", "+0 day");
    await myrefresh();
  }
}

function updateText(dateText, inst) {
  selected_city = $("#cities")[0].selectedIndex
  //console.log("updateText city selected -1: " + selected_city)
  myrefresh();

}

function setToFirstDate(y, m, inst) {
  $("#datepicker").datepicker("setDate", m + "/01/" + y);
  myrefresh();
}

async function myrefresh() {

  $("#datepicker").datepicker("refresh");

  await $('#tab1').empty();
  $('#tab1').append("పంచాంగం డౌన్‌లోడ్ అవుతోంది, వేచిఉండండి....")

  dt1 = $("#datepicker").datepicker("getDate");

  dt = dt1.getFullYear() + "-" + ("00" + (dt1.getMonth() + 1)).slice(-2) + "-" + ("00" + (dt1.getDate())).slice(-2)
  //console.log("refresh called " + dt);

  city_id = "Not Selected"

  selected_city = $("#cities")[0].selectedIndex
  //console.log("refresh city selected -1: " + selected_city)

  if (selected_city > 0) {
    city_id = $("#cities")[0][selected_city].value
    //console.log("city selected -1: " + city_id)
    await fetchpanchang(dt1.getFullYear(), city_id);
  }

  if (selected_city > 0) {
    dt_p = cached_panchang.data[dt];
    var transData = $.map(dt_p, function (value, key) {
      return [[key, value]];
    });

    await $('#tab1').empty();
    cb_data = ""
    $.each(transData, function (i) {
      tRow = $('<tr>').append($('<td>').html(transData[i][0])).append($('<td>').html(transData[i][1]));

      $('#tab1').append(tRow);
      cb_data = cb_data + "*" + transData[i][0] + "* : " + transData[i][1] + "\n";
    });

    //console.log("Text area:" + JSON.stringify(cached_panchang.data[dt]));
  } else {
    //console.log("Please select city") ;
    await $('#tab1').empty();
    $('#tab1').append("పంచాంగం చూడడానికి పైన ఒక నగరాన్ని ఎంచుకోండి.")
  }

}

async function copytoCB() {
  if (selected_city > 0) {
    city_name = $("#cities")[0][selected_city].text
    text_to_copy = "🕉️ *శుభారంభం* 🕉️\n";
    text_to_copy = text_to_copy + "*---------------* \n";
    text_to_copy = text_to_copy + "*" + city_name + "* నగరానికి పంచాంగం \n";
    text_to_copy = text_to_copy + cb_data;
    text_to_copy = text_to_copy + "( _*సేకరణ*: మునుకుట్ల సత్యనారాయణ మూర్తి నిర్వహిస్తున్న https://shubharambham.com/ వెబ్‌సైట్ నుండి_ )";
    await navigator.clipboard.writeText(text_to_copy);
  }
}