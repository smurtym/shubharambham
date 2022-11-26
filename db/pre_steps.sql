drop table if exists cities;

CREATE TABLE cities (
	city_id int4 NOT NULL,
	category_id int4,
	category_name text NULL,
	city_name text NULL,
	lat float4 NULL,
	long float4 NULL,
	tz text NULL,
	CONSTRAINT cities_pk PRIMARY KEY (city_id)
);

delete from cities;

insert into cities values(772240924,1, 'తెలంగాణ', 'ఆదిలాబాద్',19.67,78.54,'Asia/Kolkata');
insert into cities values(339825913,1, 'తెలంగాణ', 'కరీంనగర్',18.43,79.12,'Asia/Kolkata');
insert into cities values(587228693,1, 'తెలంగాణ', 'ఖమ్మం',17.24,80.16,'Asia/Kolkata');
insert into cities values(342600699,1, 'తెలంగాణ', 'నల్గొండ',17.06,79.27,'Asia/Kolkata');
insert into cities values(471125004,1, 'తెలంగాణ', 'నిజామాబాద్',18.67,78.11,'Asia/Kolkata');
insert into cities values(362450446,1, 'తెలంగాణ', 'భద్రాచలం',17.67,80.89,'Asia/Kolkata');
insert into cities values(306559489,1, 'తెలంగాణ', 'మంచిర్యాల',18.88,79.45,'Asia/Kolkata');
insert into cities values(372484789,1, 'తెలంగాణ', 'మహబూబ్‌నగర్',16.75,77.99,'Asia/Kolkata');
insert into cities values(255991667,1, 'తెలంగాణ', 'వరంగల్',17.97,79.59,'Asia/Kolkata');
insert into cities values(943768537,1, 'తెలంగాణ', 'హైదరాబాద్',17.39,78.47,'Asia/Kolkata');
insert into cities values(171386536,2, 'ఆంధ్రప్రదేశ్', 'అనంతపురం',14.67,77.6,'Asia/Kolkata');
insert into cities values(225349368,2, 'ఆంధ్రప్రదేశ్', 'అన్నవరం',17.28,82.4,'Asia/Kolkata');
insert into cities values(310650369,2, 'ఆంధ్రప్రదేశ్', 'అమలాపురం',16.58,82,'Asia/Kolkata');
insert into cities values(202927087,2, 'ఆంధ్రప్రదేశ్', 'ఇచ్ఛాపురం',19.11,84.69,'Asia/Kolkata');
insert into cities values(991131047,2, 'ఆంధ్రప్రదేశ్', 'ఏలూరు',16.71,81.11,'Asia/Kolkata');
insert into cities values(544553622,2, 'ఆంధ్రప్రదేశ్', 'ఒంగోలు',15.51,80.05,'Asia/Kolkata');
insert into cities values(752530348,2, 'ఆంధ్రప్రదేశ్', 'కడప',14.48,78.83,'Asia/Kolkata');
insert into cities values(201551598,2, 'ఆంధ్రప్రదేశ్', 'కర్నూలు',15.84,78.03,'Asia/Kolkata');
insert into cities values(210705174,2, 'ఆంధ్రప్రదేశ్', 'కాకినాడ',16.96,82.23,'Asia/Kolkata');
insert into cities values(679716923,2, 'ఆంధ్రప్రదేశ్', 'గుంటూరు',16.32,80.42,'Asia/Kolkata');
insert into cities values(125317333,2, 'ఆంధ్రప్రదేశ్', 'చిత్తూరు',13.21,79.1,'Asia/Kolkata');
insert into cities values(278181834,2, 'ఆంధ్రప్రదేశ్', 'తిరుపతి',13.64,79.42,'Asia/Kolkata');
insert into cities values(555959824,2, 'ఆంధ్రప్రదేశ్', 'నంద్యాల',15.47,78.48,'Asia/Kolkata');
insert into cities values(721851149,2, 'ఆంధ్రప్రదేశ్', 'నెల్లూరు',14.44,79.98,'Asia/Kolkata');
insert into cities values(869286174,2, 'ఆంధ్రప్రదేశ్', 'మచిలిపట్నం',16.18,81.13,'Asia/Kolkata');
insert into cities values(850026430,2, 'ఆంధ్రప్రదేశ్', 'రాజమండ్రి',17,81.78,'Asia/Kolkata');
insert into cities values(365557366,2, 'ఆంధ్రప్రదేశ్', 'విజయవాడ',16.51,80.64,'Asia/Kolkata');
insert into cities values(601918397,2, 'ఆంధ్రప్రదేశ్', 'విశాఖపట్నం',17.73,83.32,'Asia/Kolkata');
insert into cities values(899622383,2, 'ఆంధ్రప్రదేశ్', 'శ్రీకాకుళం',18.3,83.89,'Asia/Kolkata');
insert into cities values(883002308,2, 'ఆంధ్రప్రదేశ్', 'హిందూపురం',13.82,77.49,'Asia/Kolkata');
insert into cities values(866690461,3, 'ఇతర భారత రాష్ట్రాలు', 'అహ్మదాబాద్',23.01,72.56,'Asia/Kolkata');
insert into cities values(676032786,3, 'ఇతర భారత రాష్ట్రాలు', 'ఉజ్జయిని',23.17,75.79,'Asia/Kolkata');
insert into cities values(959368156,3, 'ఇతర భారత రాష్ట్రాలు', 'కలకత్తా',22.52,88.36,'Asia/Kolkata');
insert into cities values(715452672,3, 'ఇతర భారత రాష్ట్రాలు', 'కొచ్చి',9.94,76.25,'Asia/Kolkata');
insert into cities values(538780271,3, 'ఇతర భారత రాష్ట్రాలు', 'కోయంబత్తూర్',11.01,76.99,'Asia/Kolkata');
insert into cities values(694150496,3, 'ఇతర భారత రాష్ట్రాలు', 'గయ',24.79,84.99,'Asia/Kolkata');
insert into cities values(197960191,3, 'ఇతర భారత రాష్ట్రాలు', 'గౌహతి',26.17,91.77,'Asia/Kolkata');
insert into cities values(600523264,3, 'ఇతర భారత రాష్ట్రాలు', 'చండీగఢ్',30.73,76.78,'Asia/Kolkata');
insert into cities values(317839718,3, 'ఇతర భారత రాష్ట్రాలు', 'చెన్నై',13.07,80.22,'Asia/Kolkata');
insert into cities values(467585658,3, 'ఇతర భారత రాష్ట్రాలు', 'జైపూర్',26.89,75.79,'Asia/Kolkata');
insert into cities values(775959891,3, 'ఇతర భారత రాష్ట్రాలు', 'ఢిల్లీ',28.56,77.16,'Asia/Kolkata');
insert into cities values(434493513,3, 'ఇతర భారత రాష్ట్రాలు', 'తిరువనంతపురం',8.51,76.95,'Asia/Kolkata');
insert into cities values(460580156,3, 'ఇతర భారత రాష్ట్రాలు', 'పాట్నా',25.62,85.11,'Asia/Kolkata');
insert into cities values(790755124,3, 'ఇతర భారత రాష్ట్రాలు', 'పూణే',18.52,73.87,'Asia/Kolkata');
insert into cities values(546395449,3, 'ఇతర భారత రాష్ట్రాలు', 'బరంపురం',19.31,84.8,'Asia/Kolkata');
insert into cities values(843365956,3, 'ఇతర భారత రాష్ట్రాలు', 'బళ్ళారి',15.14,76.93,'Asia/Kolkata');
insert into cities values(984124567,3, 'ఇతర భారత రాష్ట్రాలు', 'బెంగుళూరు',12.97,77.61,'Asia/Kolkata');
insert into cities values(110514460,3, 'ఇతర భారత రాష్ట్రాలు', 'భువనేశ్వర్',20.26,85.81,'Asia/Kolkata');
insert into cities values(520763311,3, 'ఇతర భారత రాష్ట్రాలు', 'భోపాల్',23.24,77.44,'Asia/Kolkata');
insert into cities values(780234565,3, 'ఇతర భారత రాష్ట్రాలు', 'మంగుళూరు',12.9,74.85,'Asia/Kolkata');
insert into cities values(116167129,3, 'ఇతర భారత రాష్ట్రాలు', 'మదురై',9.93,78.13,'Asia/Kolkata');
insert into cities values(752873774,3, 'ఇతర భారత రాష్ట్రాలు', 'ముంబయి',19.13,72.89,'Asia/Kolkata');
insert into cities values(951809924,3, 'ఇతర భారత రాష్ట్రాలు', 'మైసూర్',12.32,76.64,'Asia/Kolkata');
insert into cities values(500497207,3, 'ఇతర భారత రాష్ట్రాలు', 'రాయ్‌పూర్',21.24,81.65,'Asia/Kolkata');
insert into cities values(120022203,3, 'ఇతర భారత రాష్ట్రాలు', 'లక్నో',26.86,80.94,'Asia/Kolkata');
insert into cities values(942908400,3, 'ఇతర భారత రాష్ట్రాలు', 'వారణాసి',25.29,83,'Asia/Kolkata');
insert into cities values(712359635,4, 'ఇతర ఆసియా దేశాలు', 'అబూదాబి',24.39,54.42,'Asia/Dubai');
insert into cities values(181396335,4, 'ఇతర ఆసియా దేశాలు', 'ఇజ్రాయిల్/జెరుసలేం',31.76,35.22,'Asia/Jerusalem');
insert into cities values(555364625,4, 'ఇతర ఆసియా దేశాలు', 'ఇజ్రాయిల్/టెల్అవీవ్',32.07,34.78,'Asia/Jerusalem');
insert into cities values(515363066,4, 'ఇతర ఆసియా దేశాలు', 'ఖతార్/దోహా',25.25,51.56,'Asia/Qatar');
insert into cities values(102502195,4, 'ఇతర ఆసియా దేశాలు', 'చైనా/బీజింగ్',39.94,116.42,'Asia/Shanghai');
insert into cities values(101044558,4, 'ఇతర ఆసియా దేశాలు', 'చైనా/షాంఘై',31.25,121.48,'Asia/Shanghai');
insert into cities values(192650360,4, 'ఇతర ఆసియా దేశాలు', 'జపాన్/టోక్యో',35.7,139.75,'Asia/Tokyo');
insert into cities values(373589880,4, 'ఇతర ఆసియా దేశాలు', 'టిబెట్/లాసా',29.65,91.13,'Asia/Shanghai');
insert into cities values(406649389,4, 'ఇతర ఆసియా దేశాలు', 'తైవాన్/తైపి',25.05,121.53,'Asia/Taipei');
insert into cities values(170080878,4, 'ఇతర ఆసియా దేశాలు', 'థాయ్‌లాండ్/బ్యాంకాక్',13.72,100.49,'Asia/Bangkok');
insert into cities values(967442869,4, 'ఇతర ఆసియా దేశాలు', 'దక్షిణకొరియా/సియోల్',37.54,127.01,'Asia/Seoul');
insert into cities values(101108056,4, 'ఇతర ఆసియా దేశాలు', 'దుబాయి',25.12,55.3,'Asia/Dubai');
insert into cities values(398357373,4, 'ఇతర ఆసియా దేశాలు', 'నేపాల్/ఖాట్మాండు',27.7,85.32,'Asia/Kathmandu');
insert into cities values(372568786,4, 'ఇతర ఆసియా దేశాలు', 'బంగ్లాదేశ్/ఢాకా',23.78,90.35,'Asia/Dhaka');
insert into cities values(434610919,4, 'ఇతర ఆసియా దేశాలు', 'మయన్మార్/రంగూన్',16.81,96.16,'Asia/Yangon');
insert into cities values(340390598,4, 'ఇతర ఆసియా దేశాలు', 'మలేషియా/కౌలాలంపూర్',3.16,101.69,'Asia/Kuala_Lumpur');
insert into cities values(983965488,4, 'ఇతర ఆసియా దేశాలు', 'శ్రీలంక/కొలంబో',6.93,79.84,'Asia/Colombo');
insert into cities values(264165181,4, 'ఇతర ఆసియా దేశాలు', 'సింగపూర్',1.32,103.83,'Asia/Singapore');
insert into cities values(966611782,4, 'ఇతర ఆసియా దేశాలు', 'సౌదీఅరేబియా/రియాద్',24.71,46.71,'Asia/Riyadh');
insert into cities values(173274115,4, 'ఇతర ఆసియా దేశాలు', 'హాంకాంగ్',22.32,114.17,'Asia/Hong_Kong');
insert into cities values(551721210,5, 'ఉత్తర అమెరికా', 'ఇలెనోయి/చికాగో',41.88,-87.66,'America/Chicago');
insert into cities values(867511840,5, 'ఉత్తర అమెరికా', 'ఓరిగాన్/పోర్ట్‌లాండ్',45.53,-122.65,'America/Los_Angeles');
insert into cities values(978479088,5, 'ఉత్తర అమెరికా', 'కనెటికట్/హాట్‌ఫోర్డ్',41.77,-72.69,'America/New_York');
insert into cities values(951088432,5, 'ఉత్తర అమెరికా', 'కాలిఫోర్నియా/లాస్ఏంజెలెస్',34.02,-118.24,'America/Los_Angeles');
insert into cities values(983518436,5, 'ఉత్తర అమెరికా', 'కాలిఫోర్నియా/శాన్‌జోస్',37.3,-121.96,'America/Los_Angeles');
insert into cities values(918110200,5, 'ఉత్తర అమెరికా', 'కాలిఫోర్నియా/శాన్‌ఫ్రాన్సిస్కో',37.76,-122.47,'America/Los_Angeles');
insert into cities values(759905586,5, 'ఉత్తర అమెరికా', 'కెనడా/టొరంటో',43.65,-79.38,'America/Toronto');
insert into cities values(174883272,5, 'ఉత్తర అమెరికా', 'కెనడా/వాంకూవర్',49.28,-123.12,'America/Vancouver');
insert into cities values(478864849,5, 'ఉత్తర అమెరికా', 'కొలరాడో/డెన్వర్ ',39.74,-104.99,'America/Denver');
insert into cities values(104168135,5, 'ఉత్తర అమెరికా', 'టెక్సాస్/ఆస్టిన్',30.22,-97.84,'America/Chicago');
insert into cities values(852442465,5, 'ఉత్తర అమెరికా', 'టెక్సాస్/డల్లాస్',32.74,-96.78,'America/Chicago');
insert into cities values(562848303,5, 'ఉత్తర అమెరికా', 'టెక్సాస్/హ్యూస్టన్',29.75,-95.37,'America/Chicago');
insert into cities values(436910894,5, 'ఉత్తర అమెరికా', 'డెలవేర్/విల్మింగ్టన్',39.72,-75.51,'America/New_York');
insert into cities values(742476496,5, 'ఉత్తర అమెరికా', 'నెబ్రాస్కా/ఒమెహ',41.26,-95.99,'America/Chicago');
insert into cities values(713692468,5, 'ఉత్తర అమెరికా', 'న్యూజెర్సి/న్యూఎర్క్',40.72,-74.19,'America/New_York');
insert into cities values(715074816,5, 'ఉత్తర అమెరికా', 'న్యూయార్క్',40.67,-73.94,'America/New_York');
insert into cities values(461118533,5, 'ఉత్తర అమెరికా', 'మిస్సోరి/క్యాన్సాస్‌సిటి',39.11,-94.63,'America/Chicago');
insert into cities values(143183685,5, 'ఉత్తర అమెరికా', 'యుటా/సాల్ట్‌లేక్‌సిటి',40.77,-111.93,'America/Denver');
insert into cities values(802492897,5, 'ఉత్తర అమెరికా', 'వర్జీనియా/రిచ్‌మండ్',37.52,-77.47,'America/New_York');
insert into cities values(828241729,5, 'ఉత్తర అమెరికా', 'వాషింగ్టన్ డిసి',38.83,-77.02,'America/New_York');
insert into cities values(711912474,5, 'ఉత్తర అమెరికా', 'వాషింగ్టన్/సియాటెల్',47.67,-122.33,'America/Los_Angeles');
insert into cities values(730105747,6, 'యూరోప్', 'జర్మని/బెర్లిన్',52.52,13.41,'Europe/Berlin');
insert into cities values(117062344,6, 'యూరోప్', 'జర్మని/మ్యూనిక్',48.15,11.54,'Europe/Berlin');
insert into cities values(488713931,6, 'యూరోప్', 'డెన్మార్క్/కోపెన్‌హాగన్',55.7,12.5,'Europe/Copenhagen');
insert into cities values(479144466,6, 'యూరోప్', 'నార్వే/ఓస్లో',59.92,10.74,'Europe/Oslo');
insert into cities values(663644438,6, 'యూరోప్', 'నెదర్లాండ్/ఆమ్‌స్టర్‌డ్యామ్',52.37,4.9,'Europe/Amsterdam');
insert into cities values(145575666,6, 'యూరోప్', 'ఫిన్‌లాండ్/హెల్సింకి',60.21,25,'Europe/Helsinki');
insert into cities values(920189517,6, 'యూరోప్', 'ఫ్రాన్స్/పారిస్',48.86,2.34,'Europe/Paris');
insert into cities values(754530369,6, 'యూరోప్', 'రష్యా/మాస్కో',55.74,37.62,'Europe/Moscow');
insert into cities values(919754337,6, 'యూరోప్', 'లండన్',51.51,-0.1,'Europe/London');
insert into cities values(626987594,6, 'యూరోప్', 'స్కాట్‌లాండ్/ఎడిన్‌బర్గ్',55.93,-3.31,'Europe/London');
insert into cities values(156485868,6, 'యూరోప్', 'స్పెయిన్/మాడ్రిడ్',40.43,-3.67,'Europe/Madrid');
insert into cities values(276781322,6, 'యూరోప్', 'స్వీడన్/స్టాక్‌హోం',59.28,18.04,'Europe/Stockholm');
insert into cities values(430259477,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'అర్జంటినా/బ్యూనొస్ఏరీజ్',-34.61,-58.45,'America/Argentina/Buenos_Aires');
insert into cities values(359329027,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'ఆస్ట్రేలియా/పెర్త్',-31.96,115.83,'Australia/Perth');
insert into cities values(349409483,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'ఆస్ట్రేలియా/మెల్‌బోర్న్',-37.83,144.98,'Australia/Melbourne');
insert into cities values(447909578,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'ఆస్ట్రేలియా/సిడ్నీ',-33.87,151.21,'Australia/Sydney');
insert into cities values(212971046,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'ఈజిప్ట్/కైరో',30.08,31.32,'Africa/Cairo');
insert into cities values(849601565,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'కెన్యా/నైరోబి',-1.28,36.82,'Africa/Nairobi');
insert into cities values(937062013,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'చిలి/శాంటియాగో',-33.43,-70.63,'America/Santiago');
insert into cities values(203552764,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'దక్షిణాఫ్రికా/కేప్‌టౌన్',-33.92,18.54,'Africa/Johannesburg');
insert into cities values(551528029,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'నైజీరియా/అబూజ',9.07,7.48,'Africa/Lagos');
insert into cities values(163348959,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'నైజీరియా/లాగోస్',6.45,3.4,'Africa/Lagos');
insert into cities values(251008392,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'న్యూజిలాండ్/ఆక్లాండ్',-36.85,174.76,'Pacific/Auckland');
insert into cities values(988318368,7, 'ఇతర ఖండములు(ఆస్ట్రేలియా/ఆఫ్రికా/దక్షిణ అమెరికా)', 'బ్రెజిల్/సౌపౌలో',-23.57,-46.66,'America/Sao_Paulo');

create table year_names(id int, name varchar);

insert into year_names values(1,'ప్రభవ');
insert into year_names values(2,'విభవ');
insert into year_names values(3,'శుక్ల');
insert into year_names values(4,'ప్రమోద్యూత');
insert into year_names values(5,'ప్రజోత్పత్తి');
insert into year_names values(6,'ఆంగీరస');
insert into year_names values(7,'శ్రీముఖ');
insert into year_names values(8,'భావ');
insert into year_names values(9,'యువ');
insert into year_names values(10,'ధాత');
insert into year_names values(11,'ఈశ్వర');
insert into year_names values(12,'బహుధాన్య');
insert into year_names values(13,'ప్రమాధి');
insert into year_names values(14,'విక్రమ');
insert into year_names values(15,'వృష');
insert into year_names values(16,'చిత్రభాను');
insert into year_names values(17,'స్వభాను');
insert into year_names values(18,'తారణ');
insert into year_names values(19,'పార్థివ');
insert into year_names values(20,'వ్యయ');
insert into year_names values(21,'సర్వజిత్తు');
insert into year_names values(22,'సర్వధారి');
insert into year_names values(23,'విరోధి');
insert into year_names values(24,'వికృతి');
insert into year_names values(25,'ఖర');
insert into year_names values(26,'నందన');
insert into year_names values(27,'విజయ');
insert into year_names values(28,'జయ');
insert into year_names values(29,'మన్మధ');
insert into year_names values(30,'దుర్ముఖి');
insert into year_names values(31,'హేవళంబి');
insert into year_names values(32,'విళంబి');
insert into year_names values(33,'వికారి');
insert into year_names values(34,'శార్వరి');
insert into year_names values(35,'ప్లవ');
insert into year_names values(36,'శుభకృతు');
insert into year_names values(37,'శోభకృతు');
insert into year_names values(38,'క్రోధి');
insert into year_names values(39,'విశ్వావసు');
insert into year_names values(40,'పరాభవ');
insert into year_names values(41,'ప్లవంగ');
insert into year_names values(42,'కీలక');
insert into year_names values(43,'సౌమ్య');
insert into year_names values(44,'సాధారణ');
insert into year_names values(45,'విరోధికృతు');
insert into year_names values(46,'పరిధావి');
insert into year_names values(47,'ప్రమాదీచ');
insert into year_names values(48,'ఆనంద');
insert into year_names values(49,'రాక్షస');
insert into year_names values(50,'నల');
insert into year_names values(51,'పింగళ');
insert into year_names values(52,'కాళయుక్తి');
insert into year_names values(53,'సిద్ధార్ది');
insert into year_names values(54,'రౌద్రి');
insert into year_names values(55,'దుర్మతి');
insert into year_names values(56,'దుందుభి');
insert into year_names values(57,'రుధిరోద్గారి');
insert into year_names values(58,'రక్తాక్షి');
insert into year_names values(59,'క్రోధన');
insert into year_names values(60,'అక్షయ');

create table ayana_names(id int, name varchar);

insert into ayana_names values(1,'ఉత్తర');
insert into ayana_names values(2,'దక్షిణ');

create table ritu_names(id int, name varchar);

insert into ritu_names values(1,'వసంత');
insert into ritu_names values(2,'గ్రీష్మ');
insert into ritu_names values(3,'వర్ష');
insert into ritu_names values(4,'శరద్');
insert into ritu_names values(5,'హేమంత');
insert into ritu_names values(6,'శిశిర');

create table masa_names(id int, name varchar);

insert into masa_names values(1, 'చైత్ర');
insert into masa_names values(2, 'వైశాఖ');
insert into masa_names values(3, 'జ్యేష్ఠ');
insert into masa_names values(4, 'ఆషాఢ');
insert into masa_names values(5, 'శ్రావణ');
insert into masa_names values(6, 'భాద్రపద');
insert into masa_names values(7, 'ఆశ్వయుజ');
insert into masa_names values(8, 'కార్తీక');
insert into masa_names values(9, 'మార్గశిర');
insert into masa_names values(10, 'పుష్య');
insert into masa_names values(11, 'మాఘ');
insert into masa_names values(12, 'ఫాల్గుణ');

create table nakshatra_names(id int, name varchar);

insert into nakshatra_names values(1, 'అశ్విని'   );
insert into nakshatra_names values(2, 'భరణి' );
insert into nakshatra_names values(3, 'కృత్తిక' );
insert into nakshatra_names values(4, 'రోహిణి' );
insert into nakshatra_names values(5, 'మృగశిర' );
insert into nakshatra_names values(6, 'ఆరుద్ర' );
insert into nakshatra_names values(7, 'పునర్వసు' );
insert into nakshatra_names values(8, 'పుష్యమి' );
insert into nakshatra_names values(9, 'ఆశ్లేష' );
insert into nakshatra_names values(10, 'మఖ' );
insert into nakshatra_names values(11, 'పుబ్బ' );
insert into nakshatra_names values(12, 'ఉత్తర' );
insert into nakshatra_names values(13, 'హస్త' );
insert into nakshatra_names values(14, 'చిత్త' );
insert into nakshatra_names values(15, 'స్వాతి' );
insert into nakshatra_names values(16, 'విశాఖ' );
insert into nakshatra_names values(17, 'అనూరాధ' );
insert into nakshatra_names values(18, 'జ్యేష్ఠ' );
insert into nakshatra_names values(19, 'మూల' );
insert into nakshatra_names values(20, 'పూర్వాషాఢ' );
insert into nakshatra_names values(21, 'ఉత్తరాషాఢ' );
insert into nakshatra_names values(22, 'శ్రవణం' );
insert into nakshatra_names values(23, 'ధనిష్ట' );
insert into nakshatra_names values(24, 'శతభిష' );
insert into nakshatra_names values(25, 'పూర్వాభాద్ర' );
insert into nakshatra_names values(26, 'ఉత్తరాభాద్ర' );
insert into nakshatra_names values(27, 'రేవతి' );

create table thithi_names(id int, paksha varchar, name varchar);

insert into thithi_names values( 1,  'శుక్ల', 'పాడ్యమి' );
insert into thithi_names values( 2,  'శుక్ల', 'విదియ' );
insert into thithi_names values( 3,  'శుక్ల', 'తదియ' );
insert into thithi_names values( 4,  'శుక్ల', 'చవితి' );
insert into thithi_names values( 5,  'శుక్ల', 'పంచమి' );
insert into thithi_names values( 6,  'శుక్ల', 'షష్ఠి' );
insert into thithi_names values( 7,  'శుక్ల', 'సప్తమి' );
insert into thithi_names values( 8,  'శుక్ల', 'అష్టమి' );
insert into thithi_names values( 9,  'శుక్ల', 'నవమి' );
insert into thithi_names values( 10, 'శుక్ల', 'దశమి' );
insert into thithi_names values( 11, 'శుక్ల', 'ఏకాదశి' );
insert into thithi_names values( 12, 'శుక్ల', 'ద్వాదశి' );
insert into thithi_names values( 13, 'శుక్ల', 'త్రయోదశి' );
insert into thithi_names values( 14, 'శుక్ల', 'చతుర్ధశి' );
insert into thithi_names values( 15, 'శుక్ల', 'పూర్ణిమ' );
insert into thithi_names values( 16, 'కృష్ణ', 'పాడ్యమి' );
insert into thithi_names values( 17, 'కృష్ణ', 'విదియ' );
insert into thithi_names values( 18, 'కృష్ణ', 'తదియ' );
insert into thithi_names values( 19, 'కృష్ణ', 'చవితి' );
insert into thithi_names values( 20, 'కృష్ణ', 'పంచమి' );
insert into thithi_names values( 21, 'కృష్ణ', 'షష్ఠి' );
insert into thithi_names values( 22, 'కృష్ణ', 'సప్తమి' );
insert into thithi_names values( 23, 'కృష్ణ', 'అష్టమి' );
insert into thithi_names values( 24, 'కృష్ణ', 'నవమి' );
insert into thithi_names values( 25, 'కృష్ణ', 'దశమి' );
insert into thithi_names values( 26, 'కృష్ణ', 'ఏకాదశి' );
insert into thithi_names values( 27, 'కృష్ణ', 'ద్వాదశి' );
insert into thithi_names values( 28, 'కృష్ణ', 'త్రయోదశి' );
insert into thithi_names values( 29, 'కృష్ణ', 'చతుర్ధశి' );
insert into thithi_names values( 30, 'కృష్ణ', 'అమావాస్య' );

drop table if exists durmuhurtham_parts;
create table durmuhurtham_parts(week int, d1 int, d2 int);
insert into durmuhurtham_parts values(0, 13, -1);
insert into durmuhurtham_parts values(1, 8, 11);
insert into durmuhurtham_parts values(2, 3, 21);
insert into durmuhurtham_parts values(3, 7, -1);
insert into durmuhurtham_parts values(4, 5, 11);
insert into durmuhurtham_parts values(5, 3, 8);
insert into durmuhurtham_parts values(6, 0, 1);

DROP TABLE if exists day_names;

CREATE TABLE day_names (
	id int4 NULL,
	"name" varchar NULL,
	telugu_name varchar NULL
);

INSERT INTO day_names (id,"name",telugu_name) VALUES
	 (1,'ఆది (భాను)','ఆది'),
	 (2,'సోమ (ఇందు)','సోమ'),
	 (3,'మంగళ (భౌమ)','మంగళ'),
	 (4,'బుధ (సౌమ్య)','బుధ'),
	 (5,'గురు (బృహస్పతి)','గురు'),
	 (6,'శుక్ర (భృగు)','శుక్ర'),
	 (7,'శని (స్థిర)','శని');


DROP TABLE if exists english_month_names;

CREATE TABLE english_month_names (
	id int4 NULL,
	"name" varchar NULL
);

INSERT INTO english_month_names (id,"name") VALUES
	 (1,'జనవరి'),
	 (2,'ఫిబ్రవరి'),
	 (3,'మార్చి'),
	 (4,'ఏప్రిల్'),
	 (5,'మే'),
	 (6,'జూన్'),
	 (7,'జూలై'),
	 (8,'ఆగస్ట్'),
	 (9,'సెప్టెంబర్'),
	 (10,'అక్టోబర్'),
	 (11,'నవంబర్'),
	 (12,'డిసెంబర్');

DROP TABLE if exists rasi_names;

CREATE TABLE rasi_names (
	id int4 NULL,
	"name" varchar NULL
);

INSERT INTO rasi_names (id,"name") VALUES
	 (1,'మేష'),
	 (2,'వృషభ'),
	 (3,'మిథున'),
	 (4,'కర్కాటక'),
	 (5,'సింహ'),
	 (6,'కన్యా'),
	 (7,'తుల'),
	 (8,'వృశ్చిక'),
	 (9,'ధనస్సు'),
	 (10,'మకర'),
	 (11,'కుంభ'),
	 (12,'మీన');

---------------------------------
-- Tables that will be loaded from Python scripts

drop table if exists sayana_surya_starts;

create table sayana_surya_starts (
	t timestamp null,
	masa_num float8 null
);

drop table if exists nirayana_surya_starts;

create table nirayana_surya_starts (
	t timestamp null,
	masa_num float8 null
);

drop table if exists nakshatra_ends;

create table nakshatra_ends (
	t timestamp null,
	nakshatra_num float8 null
);

drop table if exists thithi_ends;

create table thithi_ends (
	t timestamp null,
	thithi_num float8 null
);

drop table if exists varjyam;

create table varjyam (
	t timestamp null,
	is_end float8 null
);

drop table if exists smrs;

create table smrs (
	dt timestamp null,
	sunrise timestamp null,
	sunset timestamp null,
	moonrise timestamp null,
	moonset timestamp null,
	next_sunrise timestamp null,
	city_id int8 null,
	"year" int4 null
);

drop table if exists eclipse_raw;

create table eclipse_raw (
	city_id int4 null,
	eclipse_category varchar null,
	eclipse_type varchar null,
	start_time_utc timestamp null,
	max_time_utc timestamp null,
	end_time_utc timestamp null,
	is_start_visible bool null,
	is_end_visible bool null,
	rise_time_during_eclipse_utc timestamp null,
	set_time_during_eclipse_utc timestamp null,
	moon_eph_start float8 null,
	moon_eph_end float8 null,
	rahu_eph float8 null
);

CREATE OR REPLACE FUNCTION time_formatter(t_int interval)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    res varchar;
begin
    with x as (select EXTRACT(EPOCH from t_int)/60 as t), 
    y as (select trunc(t/60) h, t%60 m from x)
    select 
        case when h<12 then 'ఉ.'
        when h>=12 and h<16 then 'మ.'
        when h>=16 and h<20 then 'సా.'
        when h>=20 and h<24 then 'రా.'
        else 'తె.'
        end || 
        to_char((h-1)%12+1, 'fm00')  || ':' || 
        to_char(m, 'fm00') into res 
    from y;
    return res;
end;
$function$
;

CREATE OR REPLACE FUNCTION format_eclipse_nakshatra_pada(moon_eph_start double precision, moon_eph_end double precision)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
 res varchar;
 pada1 integer;
 pada2 integer;
 nakshatra1 integer;
 nakshatra2 integer;
 rasi1 integer;
 rasi2 integer;
 nakshatra_pada1 integer;
 nakshatra_pada2 integer;
begin
	 pada1 := floor(moon_eph_start/(360.0/108));
	 pada2 := floor(moon_eph_end/(360.0/108));
	
	 nakshatra1 := floor(moon_eph_start/(360.0/27)) + 1;
	 nakshatra2 := floor(moon_eph_end/(360.0/27)) + 1;
	
	 rasi1 := floor(moon_eph_start/(360.0/12)) + 1;
	 rasi2 := floor(moon_eph_end/(360.0/12)) + 1;
	
	 nakshatra_pada1 := (pada1 % 4) + 1;
	 nakshatra_pada2 := (pada2 % 4) + 1;
	
	 res := 'aa';
	 if (pada1 = pada2) 
	 then
	   res := (select name from nakshatra_names where id = nakshatra1) || ' ' || nakshatra_pada1::text || 'వ పాదం (' ||
	            (select name from rasi_names where id = rasi1) || 'రాశి)';
	           
	 else
	    if (nakshatra1 = nakshatra2 and rasi1 = rasi2 and nakshatra_pada1 != nakshatra_pada2) then
	       res := (select name from nakshatra_names where id = nakshatra1) || ' ' || nakshatra_pada1::text || ',' || nakshatra_pada2::text ||  'వ పాదాలు (' ||
	            (select name from rasi_names where id = rasi1) || 'రాశి)';
	   else
	       res := (select name from nakshatra_names where id = nakshatra1) || ' ' || nakshatra_pada1::text || 'వ పాదం (' ||
	            (select name from rasi_names where id = rasi1) || 'రాశి), ' ||
	             (select name from nakshatra_names where id = nakshatra2) || ' ' || nakshatra_pada2::text || 'వ పాదం (' ||
	            (select name from rasi_names where id = rasi2) || 'రాశి), ' ;
	    end if;
	 end if;
	 
	 
	 return res;
end;
$function$
;
