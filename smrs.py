import ctypes
import sqlite3 as db

import pandas as pd
import numpy as np
import datetime
import concurrent.futures
from functools import partial

from pandas._libs.tslibs.timestamps import Timestamp

SE_SIDM_TRUE_CITRA = 27
SE_SIDM_LAHIRI = 1
SEFLG_SWIEPH = 2
SEFLG_SIDEREAL = (64*1024)
SEFLG_NONUT = 64
SE_SUN = 0
SE_MOON = 1
SE_CALC_RISE = 1
SE_CALC_SET = 2
SE_BIT_HINDU_RISING = 128 | 256 | 512

libswe = ctypes.CDLL('./swisseph/libswe.so')
libswe.swe_set_ephe_path(str.encode("data/"))
libswe.swe_set_sid_mode(SE_SIDM_LAHIRI, 0, 0)

SE_SIDM_TRUE_CITRA = 27
SE_SIDM_LAHIRI = 1
SEFLG_SWIEPH = 2
SEFLG_SIDEREAL = (64*1024)
SEFLG_NONUT = 64
SE_SUN = 0
SE_MOON = 1
SE_CALC_RISE = 1
SE_CALC_SET = 2
SE_BIT_HINDU_RISING = 128 | 256 | 512

def wrap_function(lib, funcname, restype, argtypes):
    func = lib.__getattr__(funcname)
    func.restype = restype
    func.argtypes = argtypes
    return func


swe_calc_ut_wrapper = wrap_function(libswe, 'swe_calc_ut', ctypes.c_int, [
                                    ctypes.c_double, ctypes.c_int, ctypes.c_int, ctypes.POINTER(ctypes.c_double * 6), ctypes.POINTER(ctypes.c_char * 4000)])

swe_rise_trans_wrapper = wrap_function(libswe, 'swe_rise_trans', None, 
                                       [
                                         ctypes.c_double, 
                                         ctypes.c_int, 
                                         ctypes.POINTER(ctypes.c_char * 4000),
                                         ctypes.c_int, 
                                         ctypes.c_int,
                                         ctypes.POINTER(ctypes.c_double * 3),
                                         ctypes.c_double, 
                                         ctypes.c_double, 
                                         ctypes.POINTER(ctypes.c_double * 1),
                                         ctypes.POINTER(ctypes.c_char * 4000)
                                        ])

def get_rise_set(dt, lat, long):

   # Get approximate 6PM in local time for before day
    dt = dt - (long/360) - (6/24)

    geopos = (ctypes.c_double * 3)()
    geopos[0]= long
    geopos[1]= lat
    res = (ctypes.c_double * 1)()
    star_name = (ctypes.c_char * 4000)()
    err = (ctypes.c_char * 4000)()

    swe_rise_trans_wrapper(dt, SE_SUN, star_name, SEFLG_SWIEPH, SE_CALC_RISE  | SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
    sunrise_dt = res[0]

    swe_rise_trans_wrapper(sunrise_dt, SE_SUN, star_name, SEFLG_SWIEPH, SE_CALC_SET  | SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
    sunset_dt = res[0]

    swe_rise_trans_wrapper(sunrise_dt, SE_MOON, star_name, SEFLG_SWIEPH, SE_CALC_RISE  | SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
    moonrise_dt = res[0]

    swe_rise_trans_wrapper(sunrise_dt, SE_MOON, star_name, SEFLG_SWIEPH, SE_CALC_SET  | SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
    moonset_dt = res[0]

    swe_rise_trans_wrapper(sunset_dt, SE_SUN, star_name, SEFLG_SWIEPH, SE_CALC_RISE  | SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
    nextday_sunrise_dt = res[0]

    if moonrise_dt > nextday_sunrise_dt:
        moonrise_dt = None
    
    if moonset_dt > nextday_sunrise_dt:
        moonset_dt = None

    return [sunrise_dt, sunset_dt, moonrise_dt, moonset_dt, nextday_sunrise_dt]

def calc_rise_set_for_city(lat, long, timezone):
    s = pd.date_range(start='1945-11-01', end='2075-01-01', freq='d', closed='left')
    df = pd.DataFrame(index=s)
    df['dt'] = df.index.to_julian_date()
    df['lat'] = lat
    df['long'] = long

    get_rise_set_city=partial(get_rise_set, lat=lat, long=long)
    with concurrent.futures.ProcessPoolExecutor(8) as pool:
       df['res'] = list(pool.map(get_rise_set_city, df['dt'], chunksize=1000))

    df[['sunrise', 'sunset', 'moonrise', 'moonset', 'next_sunrise']] = pd.DataFrame(df.res.tolist(), index= df.index)
    return df[['dt', 'sunrise', 'sunset', 'moonrise', 'moonset', 'next_sunrise']]

if __name__ == '__main__':
    conn = db.connect('db/e1.db')
    conn.row_factory = db.Row
    c = conn.cursor()
    c.execute('select * from cities')

    result = [dict(row) for row in c.fetchall()]
    for i in result:
        print(i['city_name'])
        df = calc_rise_set_for_city(i['lat'], i['long'], i['tz'])
        df.insert(0, 'city_id', i['city_id'])
        print(df)
        df.to_sql('sun_moon_rise_set', conn, if_exists='append', index = False)
