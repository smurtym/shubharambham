import numpy as np
import datetime

import sqlite3 as db

def get_calformat(y, m):
    cal2 = np.zeros(35, dtype=int)

    dt = datetime.date(y, m, 1);
    days = (dt.replace(month = dt.month % 12 +1, day = 1)-datetime.timedelta(days=1)).day
    start_day = (dt.weekday() + 1) % 7

    #print(days, start_day)

    for i in range(days, 0, -1):
        cal2[35-i-start_day] = i

    zerocount = 0
    for i in range(35):
        if cal2[i] == 0:
            zerocount = zerocount + 1
        if i == 34:
            cal2[i] = cal2[i] + zerocount * 100
            break
        if cal2[i+1] != 0:
            cal2[i] = cal2[i] + zerocount * 100
            zerocount = 0


    cal4 = np.flipud(cal2)
    cal5 = cal4.reshape(5,7).transpose()

    #print(cal5)

    cal6 = np.zeros((7, 5), dtype=int).tolist()

    for i in range(len(cal6)):
        for j in range(len(cal6[i])):
            x = cal5[i][j]
            rowspan = x // 100
            val = (x % 100).item()
            if val != 0:
                val = str(dt + datetime.timedelta(days=val-1))
            else:
                val = 'nocell'
            cal6[i][j] = { 'rowspan': rowspan, 'val': val}

    return cal6

city_id = 2
year = 2022

conn = db.connect('db/e1.db')
conn.row_factory = db.Row
c = conn.cursor()

stmt = """
select dt, SUBSTRING(dt, 9 , 2) || '</br>' || 
' సూ.ఉ. ' || sunrise || ' సూ.అ. ' || sunset ||  '</br>' ||
' చం.ఉ. ' || moonrise || ' చం.అ. ' || moonset ||  '</br>' ||
samvatsara || ' ' || ayana  || ' ' || ritu || ' '|| masa || ' '  ||  '</br>' ||
thithi_details || ' ' || nakshatra_details   ||  '</br>' ||
' వర్జ్యం ' || varjyam ||  ' దు. ' || durmuhurtham  ||  '</br>' day_data
 from result where city_id = """ + str(city_id) + """ and dt like '""" + str(year) + """%' """
c.execute(stmt)
cal_content = {}
for row in c.fetchall():
    cal_content [dict(row)['dt']] = dict(row)['day_data'] 
#print(cal_content)

stmt = "select city_name from cities where city_id = " + str(city_id)
c.execute(stmt)
city_name = c.fetchall()[0][0]
print(city_name)

week_daynames =    ['ఆది </br> (భాను) </br> Sun',
 'సోమ </br> (ఇందు) </br> Mon',
 'మంగళ </br> (భౌమ) </br> Tue',
 'బుధ </br> (సౌమ్య) </br> Wed',
 'గురు </br> (బృహస్పతి) </br> Thu',
 'శుక్ర </br> (భృగు) </br> Fri',
 'శని </br> (స్థిర) </br> Sat'
                     ]

month_names = ['zero', 'జనవరి', 'ఫిబ్రవరి', 'మార్చి', 'ఏప్రిల్', 'మే', 'జూన్',
                'జూలై', 'ఆగస్ట్', 'సెప్టెంబర్', 'అక్టోబర్', 'నవంబర్', 'డిసెంబర్']

f = open("html/cal2.html", "w") 

f.write("""
<html>
  <body>
 <br/>
""" )

for m in range(1, 13, 1):
    f.write("""
        <table style="border-collapse: collapse; width: 100%" border="1">
          <thead style="background-color: bisque">
            <tr>
              <td colspan="6" align="center">శుభారంభం
              </br> """ +
              str(year) + ' '  +  month_names[m]
              + """
              </td>

            </tr>
          </thead>
          <tbody>
    """ )

    cal_format = get_calformat(year, m)

    #print(cal_format)

    month_table = ''
    wd = 0
    for row in cal_format:
        month_table = month_table + "<tr> \n"
        month_table = month_table + "<td>" + week_daynames[wd] + "</td> \n"
        wd = wd + 1

        for cell in row:
            if cell['rowspan'] > 0:
                month_table = month_table + "<td rowspan=" + str(cell['rowspan']) + ">&nbsp;</td> \n"
            if cell['rowspan'] == 0 and cell['val'] != 'nocell':
                month_table = month_table + "<td>" + cal_content[cell['val']] + "</td> \n"

        month_table = month_table + "</tr> \n"

    f.write(month_table)

    f.write("""
            <tr>
              <td colspan="6">
              సూర్యోదయ, సూర్యాస్తమయ, చంద్రోదయ, చంద్రాస్తమయ సమయాలు <b>""" + city_name + """</b> నగరానికి గణించబడినవి. తిథి, నక్షత్రముల సమయములు అంత్య సమయములు. </br>
              <b>సూచిక:</b> సూ. ఉ. : సూర్యోదయం; సూ. అ. : సూర్యాస్తమయం; చ. ఉ. : చంద్రోదయం; చ. అ. : చంద్రాస్తమయం; దు. : దుర్ముహూర్తం; ల. : లగాయతు; వ. : వరుకు
              </td>
            </tr>
          </tbody>
        </table>
     <br/>
    """)

f.write("""
  </body>
</html>
""")
f.close()

