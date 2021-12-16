# coding=utf8
import sqlite3 as db
from numpy import NaN, nan
import pandas as pd
import concurrent.futures

conn = db.connect('db/e1.db')

year_names = ['zero','ప్రభవ','విభవ','శుక్ల','ప్రమోద్యూత','ప్రజోత్పత్తి','ఆంగీరస','శ్రీముఖ','భావ','యువ','ధాత','ఈశ్వర','బహుధాన్య','ప్రమాధి','విక్రమ','వృష','చిత్రభాను','స్వభాను','తారణ','పార్థివ','వ్యయ','సర్వజిత్తు','సర్వధారి','విరోధి','వికృతి','ఖర','నందన','విజయ','జయ','మన్మధ','దుర్ముఖి','హేవళంబి','విళంబి','వికారి','శార్వరి','ప్లవ','శుభకృతు','శోభకృతు','క్రోధి','విశ్వావసు','పరాభవ','ప్లవంగ','కీలక','సౌమ్య','సాధారణ','విరోధికృతు','పరిధావి','ప్రమాదీచ','ఆనంద','రాక్షస','నల','పింగళ','కాళయుక్తి','సిద్ధార్ది','రౌద్రి','దుర్మతి','దుందుభి','రుధిరోద్గారి','రక్తాక్షి','క్రోధన','అక్షయ']

ayana_names = ['zero', 'ఉత్తర', 'దక్షిణ']

ritu_names = ['zero', 'వసంత','గ్రీష్మ','వర్ష','శరద్','హేమంత','శిశిర']

masa_names =['zero', 'చైత్ర','వైశాఖ','జ్యేష్ఠ','ఆషాఢ','శ్రావణ','భాద్రపద','ఆశ్వయుజ','కార్తీక','మార్గశిర','పుష్య','మాఘ','ఫాల్గుణ']

paksha_names = ['శుక్ల', 'కృష్ణ']

thithi_names = ['zero', 'పాడ్యమి','విదియ','తదియ','చవితి','పంచమి','షష్ఠి','సప్తమి','అష్టమి','నవమి','దశమి','ఏకాదశి','ద్వాదశి','త్రయోదశి','చతుర్ధశి','పూర్ణిమ','పాడ్యమి','విదియ','తదియ','చవితి','పంచమి','షష్ఠి','సప్తమి','అష్టమి','నవమి','దశమి','ఏకాదశి','ద్వాదశి','త్రయోదశి','చతుర్ధశి','అమావాస్య']

nakshatra_names = ['zero', 'అశ్విని','భరణి','కృత్తిక','రోహిణి','మృగశిర','ఆరుద్ర','పునర్వసు','పుష్యమి','ఆశ్లేష','మఖ','పుబ్బ','ఉత్తర','హస్త','చిత్త','స్వాతి','విశాఖ','అనూరాధ','జ్యేష్ఠ','మూల','పూర్వాషాఢ','ఉత్తరాషాఢ','శ్రవణం','ధనిష్ట','శతభిష','పూర్వాభాద్ర','ఉత్తరాభాద్ర','రేవతి']


def time_formatter(t_j, d_j, tz):
    dt = pd.to_datetime(d_j, unit='D', origin='julian').tz_localize(tz=tz)
    t = pd.to_datetime(t_j, unit='D', origin='julian').tz_localize(tz='UTC').tz_convert(tz)
    diff_days = pd.Timedelta(t - dt).round('min').days
    diff = pd.Timedelta(t - dt).round('min').seconds
    diff_hours = diff//3600
    diff_mins = (diff//60)%60

    prefix = 'x. '
    if (diff_hours < 12 and diff_days == 0): prefix = 'ఉ.'
    if (12 <= diff_hours < 16): prefix = 'మ.'
    if (16 <= diff_hours < 20): prefix = 'సా.'
    if (20 <= diff_hours < 24): prefix = 'రా.'
    if (diff_hours < 12 and diff_days == 1): prefix = 'తె.'

    diff_hours = ((diff_hours - 1) % 12 ) + 1
    formatted_time = prefix + str(diff_hours).zfill(2) + ':' + str(diff_mins).zfill(2)
    return formatted_time


def formatter(x):
    #print('x: ' + x)
    dt = pd.to_datetime(x['dt'], unit='D', origin='julian').strftime('%Y-%m-%d')

    sunrise = time_formatter(x['sunrise'], x['dt'], x['tz'])
    sunset = time_formatter(x['sunset'], x['dt'], x['tz'])

    if pd.isna(x['moonrise']) :
        moonrise = 'అవదు'
    else:
        moonrise = time_formatter(x['moonrise'], x['dt'], x['tz'])

    if pd.isna(x['moonset']):
        moonset = 'అవదు'
    else:
        moonset = time_formatter(x['moonset'], x['dt'], x['tz'])

    samvatsara = ''
    if not pd.isna(x['year_num']): samvatsara = year_names[int(x['year_num'])]

    ayana = ''
    if not pd.isna(x['ayana_num']): ayana = ayana_names[int(x['ayana_num'])]

    ritu = ''
    if not pd.isna(x['ritu_num']): ritu = ritu_names[int(x['ritu_num'])]

    masa = ''
    if x['is_adhika'] == 1:  masa = masa + 'అధిక '
    if x['is_nija'] == 1:  masa = masa + 'నిజ '
    if not pd.isna(x['masa_num']): masa = masa + masa_names[int(x['masa_num'])]
    # To fix: Kshaya Chitra may not work, will it happen astrologically?
    if x['is_kshaya'] == 1:  masa = masa + ' క్షయ ' + masa_names[int(x['masa_num'])+1]

    thithi_details = ''
    if x['thithi1'] <= 15: thithi_details = thithi_details + paksha_names[0]
    if x['thithi1'] > 15:  thithi_details = thithi_details + paksha_names[1]
    if not pd.isna(x['thithi1']): thithi_details = thithi_details + ' ' + thithi_names[int(x['thithi1'])]
    if pd.isna(x['thithi1_end']): 
        thithi_details = thithi_details + ' పూర్తి'
    else:
        thithi_details = thithi_details + ' ' + time_formatter(x['thithi1_end'], x['dt'], x['tz'])
    if not pd.isna(x['thithi2']): 
        thithi_details = thithi_details + ' ' + thithi_names[int(x['thithi2'])]
    if not pd.isna(x['thithi2_end']): 
        thithi_details = thithi_details + ' ' + time_formatter(x['thithi1_end'], x['dt'], x['tz'])

    nakshatra_details = ''
    if not pd.isna(x['nakshatra1']): nakshatra_details = nakshatra_details + ' ' + nakshatra_names[int(x['nakshatra1'])]
    if pd.isna(x['nakshatra1_end']): 
        nakshatra_details = nakshatra_details + ' పూర్తి'
    else:
        nakshatra_details = nakshatra_details + ' ' + time_formatter(x['nakshatra1_end'], x['dt'], x['tz'])
    if not pd.isna(x['nakshatra2']): 
        nakshatra_details = nakshatra_details + ' ' + nakshatra_names[int(x['nakshatra2'])]
    if not pd.isna(x['nakshatra2_end']): 
        nakshatra_details = nakshatra_details + ' ' + time_formatter(x['nakshatra1_end'], x['dt'], x['tz'])

    varjyam = ''
    if pd.isna(x['v1_start']) and pd.isna(x['v1_end']):
        varjyam = 'లేదు' 
    if pd.isna(x['v1_start']) and not pd.isna(x['v1_end']):
        varjyam = 'శేషవర్జ్యం '
    if not pd.isna(x['v1_start']):
        varjyam = varjyam + time_formatter(x['v1_start'], x['dt'], x['tz']) + ' ల.'
    if not pd.isna(x['v1_end']) :
        varjyam = varjyam + ' ' + time_formatter(x['v1_end'], x['dt'], x['tz']) + ' వ.'
    if not pd.isna(x['v2_start']):
        varjyam = varjyam + ' ' + time_formatter(x['v2_start'], x['dt'], x['tz']) + ' ల.'
    if not pd.isna(x['v2_end']) :
        varjyam = varjyam + ' ' + time_formatter(x['v2_end'], x['dt'], x['tz']) + ' వ.'

    durmuhurtham = ''
    durmuhurtham = durmuhurtham + time_formatter(x['d1_start'], x['dt'], x['tz']) + ' ల.'
    durmuhurtham = durmuhurtham + ' ' + time_formatter(x['d1_end'], x['dt'], x['tz']) + ' వ.'
    if not pd.isna(x['d2_start']):
        durmuhurtham = durmuhurtham + ' ' + time_formatter(x['d2_start'], x['dt'], x['tz']) + ' ల.'
    if not pd.isna(x['d2_end']) :
        durmuhurtham = durmuhurtham + ' ' + time_formatter(x['d2_end'], x['dt'], x['tz']) + ' వ.'

    return [dt, x['city_id'], sunrise, sunset, moonrise, moonset, samvatsara, ayana, ritu, masa, thithi_details, nakshatra_details, varjyam, durmuhurtham]

if __name__ == '__main__':
    dp_utc = pd.read_sql_query("select * from daily_panchang_utc", conn)
    #dp_utc = pd.read_sql_query("select * from daily_panchang_utc where dt=2445375.5", conn)

    #df = dp_utc.loc[:, ['dt', 'city_id', 'tz', 'd1_start']]
    #df['ts'] = pd.to_datetime(df['d1_start'], unit='D', origin='julian')
    #print(df)

    #df['ts_local'] = df.apply (lambda x: x['ts'].tz_localize(tz='UTC').tz_convert(x['tz']), axis=1)
    #df2 = pd.DataFrame(df.apply (formatter, axis=1));
    with concurrent.futures.ProcessPoolExecutor(4) as pool:
       res = list(pool.map(formatter, dp_utc.to_dict('records'), chunksize=1000))
    df2 = pd.DataFrame(res, columns=['dt', 'city_id', 'sunrise', 'sunset', 'moonrise', 'moonset', 'samvatsara', 'ayana', 'ritu', 'masa', 'thithi_details', 'nakshatra_details', 'varjyam', 'durmuhurtham'])
    #df['ts_local'] = df['ts'].dt.tz_localize('UTC')

    #df2 = pd.DataFrame(df.apply (formatter, axis=1));
    #print(df2[['d1', 'diff']].aggregate(lambda x: x.tolist(),axis=1))

    #print(df2.groupby(['d1']))

    print(df2)
    df2.to_sql('result', conn, if_exists='replace', index = False)