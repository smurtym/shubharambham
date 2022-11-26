import psycopg2
import psycopg2.extras
from fastapi import APIRouter

router = APIRouter()

def get_panchang(year, city_id):
    conn = psycopg2.connect(database="dbname", user='username', password='passwod', host='127.0.0.1', port= '5432')
    cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor.execute("set search_path=schemaname;")
    sql1 = '''select c.city_name from cities c where c.city_id = %s'''
    cursor.execute(sql1, (city_id,))
    result = [dict(row) for row in cursor.fetchall()][0]
    result['city_id'] = city_id
    result['year'] = year
    sql2 = '''select dt,
      english_date "ఆంగ్ల తేది",
      sunrise "సూర్యోదయం", sunset "సూర్యాస్తమయం", moonrise "చంద్రోదయం", moonset "చంద్రాస్తమయం", 
      year_name "సంవత్సరం", ayana_name "అయనం", ritu_name "దృక్ ఋతువు", old_ritu_name "పూర్వ ఋతువు",  masa_name "మాసం", thithi "తిథి", 
      vara_name "వారం",
      nakshatra "నక్షత్రం", varjyam "వర్జ్యం", durmuhurtham "దుర్ముహుర్తం" 
      from formatted_panchang_mv1 p where year= %s and p.city_id = %s order by dt'''
    #r = cursor.fetchall();
    cursor.execute(sql2, (year, city_id))
    data = [dict(row) for row in cursor.fetchall()]
    data1 = {}
    for i in data:
        data1[i['dt']] = i
        data1[i['dt']].pop('dt')
    result['data'] = data1
    conn.close()
    return result

@router.get("/panchang/")
async def cities(year: int, city_id: int):
    return get_panchang(year, city_id)