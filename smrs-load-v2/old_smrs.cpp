#include <iostream>
#include <omp.h>
#include <fstream>
#include <string>
#include <iomanip>
#include <ctime>


#include "../swisseph/swephexp.h"
//#include "../swisseph/swephlib.h"

using namespace std;

void get_sun_moon_rise_set(double jd, double lat, double lon, 
    double &sun_rise, double &sun_set, double &moon_rise, double &moon_set, double &next_day_sunrise) {

    //double sun_rise, sun_set, moon_rise, moon_set, next_day_sunrise;
    char serr[AS_MAXCH];
    double pos[3];
    double res[1];

    pos[0] = lon;
    pos[1] = lat;

    // Get 6PM of before day in local time
    double start_jd = jd - (lon/360) - (6.0/24.0);

    // Get sun rise
    swe_rise_trans(start_jd, SE_SUN, NULL, SEFLG_SWIEPH, SE_CALC_RISE | SE_BIT_HINDU_RISING,
         pos, 0, 0, res, serr);
    sun_rise = res[0];

    // Get sun set
    swe_rise_trans(sun_rise, SE_SUN, NULL, SEFLG_SWIEPH, SE_CALC_SET | SE_BIT_HINDU_RISING,
         pos, 0, 0, res, serr);
    sun_set = res[0];

    // Get next day sun rise
    swe_rise_trans(sun_set, SE_SUN, NULL, SEFLG_SWIEPH, SE_CALC_RISE | SE_BIT_HINDU_RISING,
         pos, 0, 0, res, serr);
    next_day_sunrise = res[0];

    // Get moon rise
    swe_rise_trans(sun_rise, SE_MOON, NULL, SEFLG_SWIEPH, SE_CALC_RISE | SE_BIT_HINDU_RISING,
         pos, 0, 0, res, serr);
    moon_rise = res[0];

    if (moon_rise > next_day_sunrise) {
        // Moon rise is after next day sun rise, so moon rise is on next day
        moon_rise = -1;
    }

    // Get moon set
    swe_rise_trans(sun_rise, SE_MOON, NULL, SEFLG_SWIEPH, SE_CALC_SET | SE_BIT_HINDU_RISING,
         pos, 0, 0, res, serr);
    moon_set = res[0];

    if (moon_set > next_day_sunrise) {
        // Moon set is after next day sun rise, so moon set is on next day
        moon_set = -1;
    }

}

int main() {
    std::ifstream file("cities.csv");
    std::string line;

    swe_set_ephe_path("../swisseph/ephe");

    while (std::getline(file, line)) {
        // Split the line by tab

        // The line is in the format:
        // Columns: city_id, category_id, region_name, city_name, latitude, longitude, timezone_name

        // Split the line by tab
        std::string city_id, category_id, region_name, city_name, latitude, longitude, timezone_name;
        std::istringstream iss(line);
        std::getline(iss, city_id, '\t');
        std::getline(iss, category_id, '\t');
        std::getline(iss, region_name, '\t');
        std::getline(iss, city_name, '\t');
        std::getline(iss, latitude, '\t');
        std::getline(iss, longitude, '\t');
        std::getline(iss, timezone_name, '\t');

        // Print the city_id
        //std::cout << city_id << "\t"  << latitude << "\t" << longitude << "\n";

        // Convert the latitude and longitude to double
        double lat = std::stod(latitude);
        double lon = std::stod(longitude);

        cout << "Processing city " << city_name << "\n";

        string filename = "smrs/" + city_id + ".txt";
        ofstream file(filename, ios::out);
        file << std::fixed << std::setprecision(10);

        int year = 1950;

        while (year <= 2101)
        {
            double begin_jd = swe_julday(year, 1, 1, 0.0, SE_GREG_CAL);
            double end_jd = swe_julday(year + 1, 1, 1, 0.0, SE_GREG_CAL);

            double current_jd = begin_jd;
            int i = 0;
            while (current_jd < end_jd) {

            // Get sun and moon rise and set times
                double sun_rise, sun_set, moon_rise, moon_set, next_day_sunrise;
                get_sun_moon_rise_set(current_jd, lat, lon, sun_rise, sun_set, moon_rise, moon_set, next_day_sunrise);
                file << city_id
                     << "," << current_jd 
                     << "," << sun_rise 
                     << "," << sun_set
                     << "," << moon_rise 
                     << "," << moon_set
                     << "," << next_day_sunrise
                     << "\n";

                i++;
                current_jd = begin_jd + i;
            }   

            year++;
            
        }

    }

    return 0;
}