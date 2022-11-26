import ctypes
from datetime import datetime
import julian

class SWE:

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
    SEFLG_SPEED = 256

    SE_ECL_CENTRAL		 = 1
    SE_ECL_NONCENTRAL	 = 2
    SE_ECL_TOTAL		 = 4
    SE_ECL_ANNULAR		 = 8
    SE_ECL_PARTIAL		 = 16
    SE_ECL_ANNULAR_TOTAL = 32
    SE_ECL_PENUMBRAL	 = 64
    SE_ECL_PARTBEG_VISIBLE		= 512	#/* begin of partial eclipse */
    SE_ECL_TOTBEG_VISIBLE		= 1024	#/* begin of total eclipse */
    SE_ECL_TOTEND_VISIBLE		= 2048  #  /* end of total eclipse */
    SE_ECL_PARTEND_VISIBLE		= 4096  #  /* end of partial eclipse */

    def __init__(self):
        self.libswe = ctypes.CDLL('./swisseph/libswe.so')
        self.libswe.swe_set_ephe_path(str.encode("data"))
        self.libswe.swe_set_sid_mode(SWE.SE_SIDM_TRUE_CITRA, 0, 0)

        self.swe_calc_ut_wrapper = self.libswe.swe_calc_ut
        self.swe_calc_ut_wrapper.restype = ctypes.c_int
        self.swe_calc_ut_wrapper.argtypes = [
                                ctypes.c_double, ctypes.c_int, ctypes.c_int, 
                                ctypes.POINTER(ctypes.c_double * 6), ctypes.POINTER(ctypes.c_char * 4000)]

        self.swe_rise_trans_wrapper = self.libswe.swe_rise_trans
        self.swe_rise_trans_wrapper.restype = None
        self.swe_rise_trans_wrapper.argtypes = [
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
                                        ]

        self.swe_houses_ex_wrapper = self.libswe.swe_houses_ex
        self.swe_houses_ex_wrapper.restype = ctypes.c_int
        self.swe_houses_ex_wrapper.argtypes = [
            ctypes.c_double,
            ctypes.c_int,
            ctypes.c_double,
            ctypes.c_double,
            ctypes.c_int,
            ctypes.POINTER(ctypes.c_double * 13),
            ctypes.POINTER(ctypes.c_double * 10)
        ]

        self.swe_sol_eclipse_when_loc_wrapper = self.libswe.swe_sol_eclipse_when_loc
        self.swe_sol_eclipse_when_loc_wrapper.restype = ctypes.c_int
        self.swe_sol_eclipse_when_loc_wrapper.argtypes = [
            ctypes.c_double,
            ctypes.c_int,
            ctypes.POINTER(ctypes.c_double * 3),
            ctypes.POINTER(ctypes.c_double * 10),
            ctypes.POINTER(ctypes.c_double * 20),
            ctypes.c_int,
            ctypes.POINTER(ctypes.c_char * 4000)
        ]

        self.swe_lun_eclipse_when_loc_wrapper = self.libswe.swe_lun_eclipse_when_loc
        self.swe_lun_eclipse_when_loc_wrapper.restype = ctypes.c_int
        self.swe_lun_eclipse_when_loc_wrapper.argtypes = [
            ctypes.c_double,
            ctypes.c_int,
            ctypes.POINTER(ctypes.c_double * 3),
            ctypes.POINTER(ctypes.c_double * 10),
            ctypes.POINTER(ctypes.c_double * 20),
            ctypes.c_int,
            ctypes.POINTER(ctypes.c_char * 4000)
        ]


    def get_lun_ecl(self, dt, lat, long):

        j_date = julian.to_jd(dt)
        geopos = (ctypes.c_double * 3)()
        geopos[0]= long
        geopos[1]= lat
        geopos[2]= 0

        err = (ctypes.c_char * 4000)()

        result1 = (ctypes.c_double * 10)()
        result2 = (ctypes.c_double * 20)()

        ecl_type = self.swe_lun_eclipse_when_loc_wrapper(j_date, 0, geopos, result1, result2, 0, err)

        #print("ecl ret:", ecl_type);

        ecl_type_name = ""
        if (ecl_type & SWE.SE_ECL_PARTIAL):
            ecl_type_name = "Partial"
        if (ecl_type & SWE.SE_ECL_TOTAL):
            ecl_type_name = "Total"
        if (ecl_type & SWE.SE_ECL_PENUMBRAL):
            ecl_type_name = "Penumbral"


        max_time_njdt = julian.from_jd(result1[0])
        #print("Ecl max time: " + str(max_time_njdt))
        start_time_njdt = None
        if (result1[2] != 0):
            start_time_njdt = julian.from_jd(result1[2])
        #print("Ecl start time: " + str(start_time_njdt))
        end_time_njdt = None
        if (result1[3] != 0):
            end_time_njdt = julian.from_jd(result1[3])

        # print("Ecl start time: " + str(start_time_njdt))
        # print("Ecl max time: " + str(max_time_njdt))
        # print("Ecl end time: " + str(end_time_njdt))

        is_start_visible = bool(ecl_type & SWE.SE_ECL_PARTBEG_VISIBLE)
        #print ("Is start visible: " + str(is_start_visible))
        is_end_visible = bool(ecl_type & SWE.SE_ECL_PARTEND_VISIBLE)
        #print ("Is end visible: " + str(is_end_visible))

        moonrise_time = None
        moonset_time = None

        if (result1[8] != 0):
            moonrise_time = julian.from_jd(result1[8])
            #print("Sunrise time: " + str(julian.from_jd(result1[5])))
        if (result1[9] != 0):
            moonset_time = julian.from_jd(result1[9])
            #print("Sunset time: " + str(julian.from_jd(result1[6])))

        return (ecl_type_name, start_time_njdt, max_time_njdt, end_time_njdt, is_start_visible, is_end_visible, moonrise_time, moonset_time)

    def get_sol_ecl(self, dt, lat, long):

        j_date = julian.to_jd(dt)
        geopos = (ctypes.c_double * 3)()
        geopos[0]= long
        geopos[1]= lat
        geopos[2]= 0

        err = (ctypes.c_char * 4000)()

        result1 = (ctypes.c_double * 10)()
        result2 = (ctypes.c_double * 20)()

        ecl_type = self.swe_sol_eclipse_when_loc_wrapper(j_date, 0, geopos, result1, result2, 0, err)

        ecl_type_name = ""
        if (ecl_type & SWE.SE_ECL_PARTIAL):
            ecl_type_name = "Partial"
        if (ecl_type & SWE.SE_ECL_TOTAL):
            ecl_type_name = "Total"
        if (ecl_type & SWE.SE_ECL_ANNULAR):
            ecl_type_name = "Annular"
        if (ecl_type & SWE.SE_ECL_ANNULAR_TOTAL):
            ecl_type_name = "Annular Total"


        max_time_njdt = julian.from_jd(result1[0])
        start_time_njdt = julian.from_jd(result1[1])
        end_time_njdt = julian.from_jd(result1[4])

        # print("Ecl start time: " + str(start_time_njdt))
        # print("Ecl max time: " + str(max_time_njdt))
        # print("Ecl end time: " + str(end_time_njdt))

        is_start_visible = bool(ecl_type & SWE.SE_ECL_PARTBEG_VISIBLE)
        #print ("Is start visible: " + str(is_start_visible))
        is_end_visible = bool(ecl_type & SWE.SE_ECL_PARTEND_VISIBLE)
        #print ("Is end visible: " + str(is_end_visible))

        sunrise_time = None
        sunset_time = None

        if (not is_start_visible):
            sunrise_time = julian.from_jd(result1[5])
            #print("Sunrise time: " + str(julian.from_jd(result1[5])))
        if (not is_end_visible):
            sunset_time = julian.from_jd(result1[6])
            #print("Sunset time: " + str(julian.from_jd(result1[6])))

        return (ecl_type_name, start_time_njdt, max_time_njdt, end_time_njdt, is_start_visible, is_end_visible, sunrise_time, sunset_time)




    def get_eph(self, dt, planet, siderial):

        j_date = julian.to_jd(dt)

        result = (ctypes.c_double * 6)()
        err = (ctypes.c_char * 4000)()

        iflag = SWE.SEFLG_SWIEPH | SWE.SEFLG_NONUT | SWE.SEFLG_SPEED

        if(siderial):
            iflag = iflag | SWE.SEFLG_SIDEREAL

        i = self.swe_calc_ut_wrapper(j_date, planet, iflag, result, err)

        err_msg = ctypes.cast(err,ctypes.c_char_p).value

        if (err_msg):
            print(err_msg, j_date)
            #exit(1)

        if (i != iflag):
            print('i and iflag are not same')
            #print(ctypes.cast(err,ctypes.c_char_p).value)
            #exit(-1)

        return result[0]

    def get_eph_speed(self, dt, planet, siderial):

        j_date = julian.to_jd(dt)

        result = (ctypes.c_double * 6)()
        err = (ctypes.c_char * 4000)()

        iflag = SWE.SEFLG_SWIEPH | SWE.SEFLG_NONUT | SWE.SEFLG_SPEED

        if(siderial):
            iflag = iflag | SWE.SEFLG_SIDEREAL

        i = self.swe_calc_ut_wrapper(j_date, planet, iflag, result, err)

        err_msg = ctypes.cast(err,ctypes.c_char_p).value

        if (err_msg):
            print(err_msg, j_date)
            #exit(1)

        if (i != iflag):
            print('i and iflag are not same')
            #print(ctypes.cast(err,ctypes.c_char_p).value)
            #exit(-1)

        #print(iflag, j_date, result[0], result[1], result[2], result[3], result[4], result[5])
        return (result[0], result[3])

    def get_rise_set(self, nj_dt, lat, long):

        dt = julian.to_jd(nj_dt)

        # Get approximate 6PM in local time for before day
        dt = dt - (long/360) - (6/24)

        geopos = (ctypes.c_double * 3)()
        geopos[0]= long
        geopos[1]= lat
        res = (ctypes.c_double * 1)()
        star_name = (ctypes.c_char * 4000)()
        err = (ctypes.c_char * 4000)()

        self.swe_rise_trans_wrapper(dt, 0, star_name, SWE.SEFLG_SWIEPH, SWE.SE_CALC_RISE  | SWE.SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
        sunrise_dt = res[0]
        err_msg = ctypes.cast(err,ctypes.c_char_p).value

        if (err_msg):
            print(err_msg, dt)

        self.swe_rise_trans_wrapper(sunrise_dt, 0, star_name, SWE.SEFLG_SWIEPH, SWE.SE_CALC_SET  | SWE.SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
        sunset_dt = res[0]
        err_msg = ctypes.cast(err,ctypes.c_char_p).value

        if (err_msg):
            print(err_msg, dt)

        self.swe_rise_trans_wrapper(sunrise_dt, 1, star_name, SWE.SEFLG_SWIEPH, SWE.SE_CALC_RISE  | SWE.SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
        moonrise_dt = res[0]
        err_msg = ctypes.cast(err,ctypes.c_char_p).value

        if (err_msg):
            print(err_msg, dt)

        self.swe_rise_trans_wrapper(sunrise_dt, 1, star_name, SWE.SEFLG_SWIEPH, SWE.SE_CALC_SET  | SWE.SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
        moonset_dt = res[0]
        err_msg = ctypes.cast(err,ctypes.c_char_p).value

        if (err_msg):
            print(err_msg, dt)

        self.swe_rise_trans_wrapper(sunset_dt, 0, star_name, SWE.SEFLG_SWIEPH, SWE.SE_CALC_RISE  | SWE.SE_BIT_HINDU_RISING, geopos, 0, 0, res, err);
        nextday_sunrise_dt = res[0]
        err_msg = ctypes.cast(err,ctypes.c_char_p).value

        if (err_msg):
            print(err_msg, dt)

        sunrise_njdt = julian.from_jd(sunrise_dt)
        sunset_njdt = julian.from_jd(sunset_dt)
        moonrise_njdt = julian.from_jd(moonrise_dt)
        moonset_njdt = julian.from_jd(moonset_dt)
        nextday_sunrise_njdt = julian.from_jd(nextday_sunrise_dt)


        if moonrise_njdt > nextday_sunrise_njdt:
            moonrise_njdt = None

        if moonset_njdt > nextday_sunrise_njdt:
            moonset_njdt = None

        return [sunrise_njdt, sunset_njdt, moonrise_njdt, moonset_njdt, nextday_sunrise_njdt ]

    def get_asc(self, nj_dt, lat, long):

        dt = julian.to_jd(nj_dt)
        iflag = SWE.SEFLG_SWIEPH | SWE.SEFLG_SIDEREAL
        cusps = (ctypes.c_double * 13)()
        ascmc = (ctypes.c_double * 10)()

        self.swe_houses_ex_wrapper(dt, iflag, lat, long, 65, cusps, ascmc);

        return ascmc[0];

if __name__ == '__main__':

    swe1 = SWE()

    # x = swe1.get_asc(datetime.fromisoformat('2022-07-22'), 17.41, 78.47)
    # print(x)
    #julian.from_jd

    # dt = datetime.fromisoformat('2022-07-22 14:30:00')
    # jd = julian.to_jd(dt)
    # #print(datetime.now(), jd)
    
    # x = swe1.get_eph(jd, 0, True)
    # print(x)

    print(swe1.get_lun_ecl(datetime.fromisoformat('1992-05-21'), 6.93, 79.84))
    #print(x)
