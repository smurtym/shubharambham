import numpy as np
import datetime





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



# f = open("html/cal1.html", "w") 
# f.write('<html> <body> ')
# f.write('<b>')
# f.write('aaa')
# f.write('</b>')
# f.write(' </body> </html>')
# f.close()

f = open("html/cal1.html", "w") 

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
              <td colspan="5" align="center">Heading
              </br>
              2022
              </td>
            </tr>
          </thead>
          <tbody>
    """ )

    cal_format = get_calformat(2022, m)

    #print(cal_format)

    month_table = ''
    for row in cal_format:
        month_table = month_table + "<tr> \n"

        for cell in row:
            if cell['rowspan'] > 0:
                month_table = month_table + "<td rowspan=" + str(cell['rowspan']) + ">&nbsp;</td> \n"
            if cell['rowspan'] == 0 and cell['val'] != 'nocell':
                month_table = month_table + "<td>" + str(cell['val']) + "</td> \n"

        month_table = month_table + "</tr> \n"

    f.write(month_table)

    f.write("""
            <tr>
              <td colspan="5">Footer</td>
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

