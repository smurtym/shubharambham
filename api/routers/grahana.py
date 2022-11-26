import psycopg2
import psycopg2.extras
from fastapi import APIRouter

router = APIRouter()

def get_grahana(year, city_id):
    conn = psycopg2.connect(database="dbname", user='username', password='passwod', host='127.0.0.1', port= '5432')
    cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor.execute("set search_path=schemaname;")
    sql1 = '''select c.city_name from cities c where c.city_id = %s'''
    cursor.execute(sql1, (city_id,))
    result = [dict(row) for row in cursor.fetchall()][0]
    result['city_id'] = city_id
    result['year'] = year
    sql2 = '''
      select eclipse_num, json_data eclipse_data from alpha.json_eclipse_data_mv p where year= %s and p.city_id = %s order by eclipse_num'''
    #r = cursor.fetchall();
    cursor.execute(sql2, (year, city_id))
    data = [dict(row) for row in cursor.fetchall()]
    data1 = {}
    for i in data:
        data1[i['eclipse_num']] = i
        data1[i['eclipse_num']].pop('eclipse_num')
    result['data'] = data1
    conn.close()
    return result

@router.get("/grahana/")
async def cities(year: int, city_id: int):
    return get_grahana(year, city_id)