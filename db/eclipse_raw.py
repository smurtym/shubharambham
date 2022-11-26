from swe_wrapper import *
from datetime import datetime
from datetime import timedelta
import psycopg2
import psycopg2.extras

def dump_city_solar(city_id):
#    year = 2022

    swe1 = SWE()

    conn = psycopg2.connect(database="dbname", user='username', password='passwod', host='127.0.0.1', port= '5432')
    cursor = conn.cursor()
    cursor.execute("set search_path=schemaname;")

    cursor.execute("select lat, long from cities where  city_id=" + str(city_id))
    # To do: Handle when city does not exist
    (lat, long) = cursor.fetchone()

    #print(lat, long);
    dt = datetime.fromisoformat('1950-01-01')

    while (dt.year < 2050):
        (ecl_type_name, start_time, max_time, end_time, is_start_visible, is_end_visible, sunrise_time, sunset_time) = swe1.get_sol_ecl(dt, lat, long)
        #print(ecl_type_name, start_time, max_time, end_time, is_start_visible, is_end_visible, sunrise_time, sunset_time)
        dt = start_time + timedelta(days=10)
        moon_eph_start = swe1.get_eph(start_time, 1, True)
        moon_eph_end = swe1.get_eph(end_time, 1, True)
        rahu_eph = swe1.get_eph(max_time, 11, True)
        cursor.execute('INSERT INTO eclipse_raw VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', (city_id, 'Solar', ecl_type_name, start_time, max_time, end_time, is_start_visible, is_end_visible, sunrise_time, sunset_time, moon_eph_start, moon_eph_end, rahu_eph))


    dt = datetime.fromisoformat('1950-01-01')
    while (dt.year < 2050):
        (ecl_type_name, start_time, max_time, end_time, is_start_visible, is_end_visible, moonrise_time, moonset_time) = swe1.get_lun_ecl(dt, lat, long)
        #print(ecl_type_name, start_time, max_time, end_time, is_start_visible, is_end_visible, moonrise_time, moonset_time)
        dt = max_time + timedelta(days=10)

        if ecl_type_name != 'Penumbral': # We do not need Penumbral eclipses 
            if start_time is None:
                moon_eph_start = swe1.get_eph(moonrise_time, 1, True)
                is_start_visible = False # Some edge cases where moonrise almost equals partial eclipse start
            else:
                moon_eph_start = swe1.get_eph(start_time, 1, True)
                is_start_visible = True # Fix some cases where moonrise happens during Penumbral phase

            if end_time is None:
                moon_eph_end = swe1.get_eph(moonset_time, 1, True)
                is_end_visible = False # Some edge cases where moonset almost equals partial eclipse end
            else:
                moon_eph_end = swe1.get_eph(end_time, 1, True)
                is_end_visible = True # Fix some case where moonset happens during Penumbral phase

            #if 

            rahu_eph = swe1.get_eph(max_time, 11, True)
            cursor.execute('INSERT INTO eclipse_raw VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', (city_id, 'Lunar',    ecl_type_name, start_time, max_time, end_time, is_start_visible, is_end_visible, moonrise_time, moonset_time, moon_eph_start,  moon_eph_end, rahu_eph))


    conn.commit()
    conn.close()


if __name__ == '__main__':

    #dump_city(2)

    conn = psycopg2.connect(database="dbname", user='username', password='passwod', host='127.0.0.1', port= '5432')
    cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor.execute("set search_path=schemaname;")
    cursor.execute("select city_name, city_id from cities")
    #r = cursor.fetchall();
    result = [dict(row) for row in cursor.fetchall()]

    for i in result:
        print(i['city_name'], i['city_id'])
        dump_city_solar(i['city_id'])

