create table eph_raw
(
      jd double,
      jd_before_30s double,
      sun double,
      sun_before_30s double,
      moon double,
      moon_before_30s double,
      mars double,
      mars_before_30s double,
      mercury double,
      mercury_before_30s double,
      jupiter double,
      jupiter_before_30s double,
      venus double,
      venus_before_30s double,
      saturn double,
      saturn_before_30s double,
      true_node double,
      true_node_before_30s double,
      mean_node double,
      mean_node_before_30s double,
      true_chitra double,
      true_lahiri double,
      true_pushya double,
      true_revati double,
      galcent_mula_wilhelm double
);

create table smrs_raw(
      city_id int,
      jd double,
      sun_rise double,
      sun_set double,
      moon_rise double,
      moon_set double,
      next_day_sun_rise double
);

create table cities(
      city_id int,
      category_id int,
      category_name varchar,
      city_name varchar,
      lat double,
      long double,
      tz varchar
);

copy into cities from
s3://xxxxxxx/rawdata/cities.csv
CREDENTIALS = (AWS_KEY_ID = 'xxxxxxx' AWS_SECRET_KEY = 'xxxxxxx'  ) 
 FILE_FORMAT = (  TYPE =  CSV  COMPRESSION = AUTO  );


 select * from cities;


copy into smrs_raw from
s3://xxxxxxx/rawdata/smrs/
CREDENTIALS = (AWS_KEY_ID = 'xxxxxxx' AWS_SECRET_KEY = 'xxxxxxx'  ) 
 FILE_FORMAT = (  TYPE =  CSV  COMPRESSION = AUTO  );
 
 select * from smrs_raw;

copy into eph_raw from
s3://xxxxxxx/rawdata/eph/
CREDENTIALS = (AWS_KEY_ID = 'xxxxxxx' AWS_SECRET_KEY = 'xxxxxxx'  ) 
 FILE_FORMAT = (  TYPE =  CSV  COMPRESSION = AUTO  );

 create or replace table eph as 
 select jd, 
      jd_to_date(jd) dt,
      sun, sun_before_30s, lead(sun) over (order by jd) sun_after_30s,
      moon, moon_before_30s, lead(moon) over (order by jd) moon_after_30s,
      mars, mars_before_30s, lead(mars) over (order by jd) mars_after_30s,
      mercury, mercury_before_30s, lead(mercury) over (order by jd) mercury_after_30s,
      jupiter, jupiter_before_30s, lead(jupiter) over (order by jd) jupiter_after_30s,
      venus, venus_before_30s, lead(venus) over (order by jd) venus_after_30s,
      saturn, saturn_before_30s, lead(saturn) over (order by jd) saturn_after_30s,
      true_node, true_node_before_30s, lead(true_node) over (order by jd) true_node_after_30s,
      mean_node, mean_node_before_30s, lead(mean_node) over (order by jd) mean_node_after_30s,
      true_chitra, true_lahiri, true_pushya, true_revati, galcent_mula_wilhelm
      from eph_raw ;
      
 