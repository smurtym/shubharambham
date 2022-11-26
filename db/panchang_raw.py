from swe_wrapper import *
import datetime
import concurrent.futures
from sqlalchemy import create_engine
import pandas as pd

def remove_minus(x):
    if x > 0:
        return x
    else:
        return x+360

def chec_tran_sun(xmin, xmax):
    if xmin > xmax:         return 1
    if xmin <=  30 <= xmax: return 2
    if xmin <=  60 <= xmax: return 3
    if xmin <=  90 <= xmax: return 4
    if xmin <= 120 <= xmax: return 5
    if xmin <= 150 <= xmax: return 6
    if xmin <= 180 <= xmax: return 7
    if xmin <= 210 <= xmax: return 8
    if xmin <= 240 <= xmax: return 9
    if xmin <= 270 <= xmax: return 10
    if xmin <= 300 <= xmax: return 11
    if xmin <= 330 <= xmax: return 12

def chec_tran_star(xmin, xmax):
    if xmin <= 13.333333333 <= xmax: return 1
    if xmin <= 26.666666667 <= xmax: return 2
    if xmin <= 40.000000000 <= xmax: return 3
    if xmin <= 53.333333333 <= xmax: return 4
    if xmin <= 66.666666667 <= xmax: return 5
    if xmin <= 80.000000000 <= xmax: return 6
    if xmin <= 93.333333333 <= xmax: return 7
    if xmin <= 106.666666667 <= xmax: return 8
    if xmin <= 120.000000000 <= xmax: return 9
    if xmin <= 133.333333333 <= xmax: return 10
    if xmin <= 146.666666667 <= xmax: return 11
    if xmin <= 160.000000000 <= xmax: return 12
    if xmin <= 173.333333333 <= xmax: return 13
    if xmin <= 186.666666667 <= xmax: return 14
    if xmin <= 200.000000000 <= xmax: return 15
    if xmin <= 213.333333333 <= xmax: return 16
    if xmin <= 226.666666667 <= xmax: return 17
    if xmin <= 240.000000000 <= xmax: return 18
    if xmin <= 253.333333333 <= xmax: return 19
    if xmin <= 266.666666667 <= xmax: return 20
    if xmin <= 280.000000000 <= xmax: return 21
    if xmin <= 293.333333333 <= xmax: return 22
    if xmin <= 306.666666667 <= xmax: return 23
    if xmin <= 320.000000000 <= xmax: return 24
    if xmin <= 333.333333333 <= xmax: return 25
    if xmin <= 346.666666667 <= xmax: return 26
    if xmin > xmax:                   return 27

def check_tran_thithi(xmin, xmax):
    if xmin <= 12 <= xmax: return 1
    if xmin <= 24 <= xmax: return 2
    if xmin <= 36 <= xmax: return 3
    if xmin <= 48 <= xmax: return 4
    if xmin <= 60 <= xmax: return 5
    if xmin <= 72 <= xmax: return 6
    if xmin <= 84 <= xmax: return 7
    if xmin <= 96 <= xmax: return 8
    if xmin <= 108 <= xmax: return 9
    if xmin <= 120 <= xmax: return 10
    if xmin <= 132 <= xmax: return 11
    if xmin <= 144 <= xmax: return 12
    if xmin <= 156 <= xmax: return 13
    if xmin <= 168 <= xmax: return 14
    if xmin <= 180 <= xmax: return 15
    if xmin <= 192 <= xmax: return 16
    if xmin <= 204 <= xmax: return 17
    if xmin <= 216 <= xmax: return 18
    if xmin <= 228 <= xmax: return 19
    if xmin <= 240 <= xmax: return 20
    if xmin <= 252 <= xmax: return 21
    if xmin <= 264 <= xmax: return 22
    if xmin <= 276 <= xmax: return 23
    if xmin <= 288 <= xmax: return 24
    if xmin <= 300 <= xmax: return 25
    if xmin <= 312 <= xmax: return 26
    if xmin <= 324 <= xmax: return 27
    if xmin <= 336 <= xmax: return 28
    if xmin <= 348 <= xmax: return 29
    if xmin > xmax:         return 30


def check_varjyam(xmin, xmax):
    if xmin <= 11.111111111 <= xmax: return 0
    if xmin <= 18.666666667 <= xmax: return 0
    if xmin <= 33.333333333 <= xmax: return 0
    if xmin <= 48.888888889 <= xmax: return 0
    if xmin <= 56.444444444 <= xmax: return 0
    if xmin <= 71.333333333 <= xmax: return 0
    if xmin <= 86.666666667 <= xmax: return 0
    if xmin <= 97.777777778 <= xmax: return 0
    if xmin <= 113.777777778 <= xmax: return 0
    if xmin <= 126.666666667 <= xmax: return 0
    if xmin <= 137.777777778 <= xmax: return 0
    if xmin <= 150.666666667 <= xmax: return 0
    if xmin <= 164.666666667 <= xmax: return 0
    if xmin <= 177.777777778 <= xmax: return 0
    if xmin <= 189.777777778 <= xmax: return 0
    if xmin <= 203.111111111 <= xmax: return 0
    if xmin <= 215.555555556 <= xmax: return 0
    if xmin <= 229.777777778 <= xmax: return 0
    if xmin <= 252.444444444 <= xmax: return 0
    if xmin <= 258.666666667 <= xmax: return 0
    if xmin <= 271.111111111 <= xmax: return 0
    if xmin <= 282.222222222 <= xmax: return 0
    if xmin <= 295.555555556 <= xmax: return 0
    if xmin <= 310.666666667 <= xmax: return 0
    if xmin <= 323.555555556 <= xmax: return 0
    if xmin <= 338.666666667 <= xmax: return 0
    if xmin <= 353.333333333 <= xmax: return 0
    
    if xmin <= 12.000000000 <= xmax: return 1
    if xmin <= 19.555555556 <= xmax: return 1
    if xmin <= 34.222222222 <= xmax: return 1
    if xmin <= 49.777777778 <= xmax: return 1
    if xmin <= 57.333333333 <= xmax: return 1
    if xmin <= 72.222222222 <= xmax: return 1
    if xmin <= 87.555555556 <= xmax: return 1
    if xmin <= 98.666666667 <= xmax: return 1
    if xmin <= 114.666666667 <= xmax: return 1
    if xmin <= 127.555555556 <= xmax: return 1
    if xmin <= 138.666666667 <= xmax: return 1
    if xmin <= 151.555555556 <= xmax: return 1
    if xmin <= 165.555555556 <= xmax: return 1
    if xmin <= 178.666666667 <= xmax: return 1
    if xmin <= 190.666666667 <= xmax: return 1
    if xmin <= 204.000000000 <= xmax: return 1
    if xmin <= 216.444444444 <= xmax: return 1
    if xmin <= 230.666666667 <= xmax: return 1
    if xmin <= 253.333333333 <= xmax: return 1
    if xmin <= 259.555555556 <= xmax: return 1
    if xmin <= 272.000000000 <= xmax: return 1
    if xmin <= 283.111111111 <= xmax: return 1
    if xmin <= 296.444444444 <= xmax: return 1
    if xmin <= 311.555555556 <= xmax: return 1
    if xmin <= 324.444444444 <= xmax: return 1
    if xmin <= 339.555555556 <= xmax: return 1
    if xmin <= 354.222222222 <= xmax: return 1


def trans_calc(dt):

    swe1 = SWE()

    min_time = dt - datetime.timedelta(seconds=30)
    max_time = dt + datetime.timedelta(seconds=30)

    tropical_sun_min = swe1.get_eph(min_time, 0, siderial = False) 
    tropical_sun_max = swe1.get_eph(max_time, 0, siderial = False) 

    tropical_sun_transit = chec_tran_sun(tropical_sun_min, tropical_sun_max)

    sidereal_sun_min = swe1.get_eph(min_time, 0, siderial = True)
    sidereal_sun_max = swe1.get_eph(max_time, 0, siderial = True) 

    sidereal_sun_transit = chec_tran_sun(sidereal_sun_min, sidereal_sun_max)

    sidereal_moon_min = swe1.get_eph(min_time, 1, siderial = True)
    sidereal_moon_max = swe1.get_eph(max_time, 1, siderial = True)

    star_transit = chec_tran_star(sidereal_moon_min, sidereal_moon_max)

    moon_sun_diff_min = remove_minus(sidereal_moon_min-sidereal_sun_min)
    moon_sun_diff_max = remove_minus(sidereal_moon_max-sidereal_sun_max)

    thithi_transit = check_tran_thithi(moon_sun_diff_min, moon_sun_diff_max)

    varjyam = check_varjyam(sidereal_moon_min, sidereal_moon_max)

    return [dt, tropical_sun_transit, sidereal_sun_transit, star_transit, thithi_transit, varjyam]

def calc_year(y):
    s = pd.date_range(start=str(y) + '-01-01', end=str(y+1) + '-01-01', freq='min', inclusive='left')
    df = pd.DataFrame(index=s)

    df['dt'] = df.index

    with concurrent.futures.ProcessPoolExecutor(32) as pool:
        df['res'] = list(pool.map(trans_calc, df['dt'], chunksize=1000))

    #df['res'] = df['dt'].apply(trans_calc)

    df[['julian_date', 'sayana_surya', 'nirayana_surya', 'nakshatra', 'thithi', 'varjya']] = pd.DataFrame(df.res.tolist(), index= df.index)

    return df


if __name__ == '__main__':

    years = range(1950, 2051, 1)

    conn_string = 'postgresql://username:passwod@127.0.0.1/dbname'

    db = create_engine(conn_string, connect_args={'options': '-csearch_path=schemaname'})
    conn = db.connect()
    #conn = db.connect('db/e1.db')
    for y in years:
        print(y)

        calc_times = calc_year(y)

        sayana_surya_starts = pd.DataFrame();
        sayana_surya_starts[['t', 'masa_num']] = calc_times[calc_times['sayana_surya'].notnull()][['julian_date', 'sayana_surya']]
        sayana_surya_starts.to_sql('sayana_surya_starts', conn, if_exists='append', index = False)

        nirayana_surya_starts = pd.DataFrame();
        nirayana_surya_starts[['t', 'masa_num']] = calc_times[calc_times['nirayana_surya'].notnull()][['julian_date', 'nirayana_surya']]
        nirayana_surya_starts.to_sql('nirayana_surya_starts', conn, if_exists='append', index = False)

        nakshatra_ends = pd.DataFrame();
        nakshatra_ends[['t', 'nakshatra_num']] = calc_times[calc_times['nakshatra'].notnull()][['julian_date', 'nakshatra']]
        nakshatra_ends.to_sql('nakshatra_ends', conn, if_exists='append', index = False)

        thithi_ends = pd.DataFrame();
        thithi_ends[['t', 'thithi_num']] = calc_times[calc_times['thithi'].notnull()][['julian_date', 'thithi']]
        thithi_ends.to_sql('thithi_ends', conn, if_exists='append', index = False)

        varjyam = pd.DataFrame();
        varjyam[['t', 'is_end']] = calc_times[calc_times['varjya'].notnull()][['julian_date', 'varjya']]
        varjyam.to_sql('varjyam', conn, if_exists='append', index = False)

    conn.close()