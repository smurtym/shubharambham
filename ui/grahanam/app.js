var cached_panchang = {};
var cb_data = " "

$(document).ready(function () {

  $("#cities").selectmenu({
    select: data_changed
  });

  $("#years").selectmenu({
    select: data_changed
  });

  fetchcities();
  fillyears();

})

function data_changed() {

  selected_city = $("#cities")[0].selectedIndex
  selected_year = $("#years")[0].selectedIndex

  // if (selected_city > 0  && selected_year > 0) {
  city_id = $("#cities")[0][selected_city].value
  year = $("#years")[0][selected_year].value
  //console.log("city selected -1: " + city_id)
  show_data(year, city_id);

}

async function show_data(year, city_id) {

  var no_text = " Some error..."
  var cb_data = {}
  var text_to_copy = " "

  data = { data: [] }
  if (year > 0 & city_id > 0) {
    no_text = "గ్రహణ వివరాలకోసం వేచి ఉండండి..."
  } else {
    no_text = "గ్రహణ వివరాలని చూడడానికి పైన ఒక నగరాన్ని మరియు సంవత్సరాన్ని ఎంచుకోండి."
  }

  await $("#results").empty()
  var r = $('<table/>').attr({
    type: "table",
    id: "tab0",
  });

  await $('#tab0').empty();
  $('#results').append(r);
  tRow = $('<tr>').append($('<td>').html(no_text));
  $('#tab0').append(tRow);


  if (year > 0 & city_id > 0) {
    data = await fetchgrahana(year, city_id);

    await $("#results").empty()

    if (Object.keys(data.data).length > 0) {
      $.each(data.data, async function (x, j) {
        //console.log("x: ..." + x)
        var r = $('<table/>').attr({
          type: "table",
          id: "tab" + x,
        });

        await $('#tab' + x).empty();

        $('#results').append(r);

        city_name = $("#cities")[0][selected_city].text
        cb_data[x] = "🕉️ *శుభారంభం* 🕉️\n"
        cb_data[x] = cb_data[x] + "*---------------* \n";
        cb_data[x] = cb_data[x] + "*" + city_name + "* నగరానికి గ్రహణ సమయాలు \n";
        $.each(j.eclipse_data, function (k, v) {
          //console.log(k + " " + v)
          tRow = $('<tr>').append($('<td>').html(k)).append($('<td>').html(v));
          $('#tab' + x).append(tRow);
          cb_data[x] = cb_data[x] + "*" + k.trim() + "* : " + v.trim() + "\n"
        });
        cb_data[x] = cb_data[x] + "( _*సేకరణ*: మునుకుట్ల సత్యనారాయణ మూర్తి నిర్వహిస్తున్న https://shubharambham.com/ వెబ్‌సైట్ నుండి_ )";

        var b = $('<button/>').attr({
          type: "button",
          id: "button" + x,
          class: "ui-button"
        });

        $('#results').append(b);
        $('#results').append("<br/><br/><br/>")

        $('#button' + x).append("పంచడానికి నకలు (Copy to Share)")
        await $('#button' + x).click(async function () {
          //console.log('Clicked : ' + cb_data[x])
          await navigator.clipboard.writeText(cb_data[x]);
        });

      });

    } else {

      var no_text = " Some error..."
      selected_city = $("#cities")[0].selectedIndex
      selected_year = $("#years")[0].selectedIndex

      city_name = $("#cities")[0][selected_city].text
      year = $("#years")[0][selected_year].value
      //console.log("city selected : " + city_name + " " + year)

      no_text = city_name + " నగరంలో " + year + " సంవత్సరంలో ఏ గ్రహణాలు కనిపించవు."

      var r = $('<table/>').attr({
        type: "table",
        id: "tab0",
      });

      await $('#tab0').empty();
      $('#results').append(r);
      tRow = $('<tr>').append($('<td>').html(no_text));
      $('#tab0').append(tRow);

    }
  }

}

async function fetchgrahana(yr, city_id) {
  // cities =  fetch("https://shubharambham.com/api-beta/cities/", {
  //     mode: "no-cors"
  // });
  //return new Promise(async (resolve,reject)=>{
  //here our function should be implemented 

  let return_data = {}
  await $.getJSON("https://shubharambham.com/api-beta/grahana/?city_id=" + city_id + "&year=" + yr, function (data) {

    return_data = data;
    // console.log('Done... fectching for city:' + city_id + " year:" + yr)  

  });

  return return_data

}

async function fillyears() {
  
  $c = $('<option>', {
    text: "సంవత్సరాన్ని ఎంచుకోండి",
    value: "0"
  });
  $c.appendTo('#years');

  $("#years").val("0");
  $("#years").selectmenu("refresh");

  for (let i = 1950; i < 2050; i++) {
    $c = $('<option>', {
      text: i,
      value: i
    });
    $c.appendTo('#years');
  }
  $("#years").selectmenu("refresh");

}

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

  data_changed()

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
