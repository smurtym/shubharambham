# Ingredients
 * Swiss Ephemeris Library
 * Database: PostgreSQL
 * API: Fast API with Python
 * UI: jQuery
 * Hosting Server: nginx (and thanks to ZeroSSL for certs)
	
# High level Recipe
 * Install PostgreSQL
 ## Preparing data using scripts in db directory
  * These steps are NOT optimized, but this is one time preparation. Throw them on a compute optimized instance (like c6g.8xlarge on AWS).
  * Prepare Swiss Ephemeris Library
  ```sh
git clone https://github.com/aloistr/swisseph.git
cd swisseph
make libswe.so 
cd ..
mkdir data
cd data
wget https://www.astro.com/ftp/swisseph/ephe/sepl_18.se1
wget https://www.astro.com/ftp/swisseph/ephe/semo_18.se1
```
  * Create initial schema : pre_steps.sql
  * Run raw data generation scripts

```sh
python3 panchang_raw.py
python3 db/smrs.py
python3 eclipse_raw.py
```
  * Run formatted data preparation script : post_steps.sql
 ## Host API and UI 
  * Use nginx.conf in config directory

# License: 
 * AGPL because swisseph library is AGPL
