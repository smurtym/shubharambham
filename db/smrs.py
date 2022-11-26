import psycopg2
import psycopg2.extras

import pandas as pd
import numpy as np
from swe_wrapper import *
import datetime
import concurrent.futures
from functools import partial
import cProfile
from sqlalchemy import create_engine
import json

def get_rise_set_wrapper(nj_dt, lat, long):
    swe1 = SWE()
    return swe1.get_rise_set(nj_dt, lat, long)

def calc_rise_set_for_city(y, lat, long):
    s = pd.date_range(start=str(y) + '-01-01', end=str(y+1) + '-01-01', freq='d', inclusive='left')
    df = pd.DataFrame(index=s)
    df['dt'] = df.index
    df['lat'] = lat
    df['long'] = long

    get_rise_set_city=partial(get_rise_set_wrapper, lat=lat, long=long) 
    with concurrent.futures.ProcessPoolExecutor(4) as pool:
       df['res'] = list(pool.map(get_rise_set_city, df['dt'], chunksize=1000))

    df[['sunrise', 'sunset', 'moonrise', 'moonset', 'next_sunrise']] = pd.DataFrame(df.res.tolist(), index= df.index)
    return df[['dt', 'sunrise', 'sunset', 'moonrise', 'moonset', 'next_sunrise']]

def dump_city(city_id):
#    year = 2022

    conn = psycopg2.connect(database="dbname", user='username', password='passwod', host='127.0.0.1', port= '5432')
    cursor = conn.cursor()
    cursor.execute("set search_path=schemaname;")

    # To do: Avoid SQL injection attack
    cursor.execute("delete from smrs where city_id=" + str(city_id))
    conn.commit()
    cursor.execute("select lat, long from cities where  city_id=" + str(city_id))
    # To do: Handle when city does not exist
    (lat, long) = cursor.fetchone()
    conn.close()

    years = range(1950, 2051, 1)
    for year in years:
        print(city_id,year)
        conn_string = 'postgresql://username:passwod@127.0.0.1/dbname'
        db = create_engine(conn_string, connect_args={'options': '-csearch_path=schemaname'})
        conn_sa = db.connect()
        df = calc_rise_set_for_city(year, lat, long)
        df['city_id'] = city_id
        df['year'] = year
        df.to_sql('smrs', conn_sa, if_exists='append', index = False)
        conn_sa.close()


if __name__ == '__main__':

    #dump_city(2)

    conn = psycopg2.connect(database="dbname", user='username', password='passwod', host='127.0.0.1', port= '5432')
    cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor.execute("set search_path=schemaname;")
    cursor.execute("select city_name, city_id from cities ")
    #r = cursor.fetchall();
    result = [dict(row) for row in cursor.fetchall()]

    for i in result:
        print(i['city_name'], i['city_id'])
        dump_city(i['city_id'])



