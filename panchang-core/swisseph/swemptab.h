/* SWISSEPH

   ATTENTION: this source file is not to be compiled separately,
   as it is #included by swemplan
 */

/* Copyright (C) 1997 - 2021 Astrodienst AG, Switzerland.  All rights reserved.

  License conditions
  ------------------

  This file is part of Swiss Ephemeris.

  Swiss Ephemeris is distributed with NO WARRANTY OF ANY KIND.  No author
  or distributor accepts any responsibility for the consequences of using it,
  or for whether it serves any particular purpose or works at all, unless he
  or she says so in writing.  

  Swiss Ephemeris is made available by its authors under a dual licensing
  system. The software developer, who uses any part of Swiss Ephemeris
  in his or her software, must choose between one of the two license models,
  which are
  a) GNU Affero General Public License (AGPL)
  b) Swiss Ephemeris Professional License

  The choice must be made before the software developer distributes software
  containing parts of Swiss Ephemeris to others, and before any public
  service using the developed software is activated.

  If the developer choses the AGPL software license, he or she must fulfill
  the conditions of that license, which includes the obligation to place his
  or her whole software project under the AGPL or a compatible license.
  See https://www.gnu.org/licenses/agpl-3.0.html

  If the developer choses the Swiss Ephemeris Professional license,
  he must follow the instructions as found in http://www.astro.com/swisseph/ 
  and purchase the Swiss Ephemeris Professional Edition from Astrodienst
  and sign the corresponding license contract.

  The License grants you the right to use, copy, modify and redistribute
  Swiss Ephemeris, but only under certain conditions described in the License.
  Among other things, the License requires that the copyright notices and
  this notice be preserved on all copies.

  Authors of the Swiss Ephemeris: Dieter Koch and Alois Treindl

  The authors of Swiss Ephemeris have no control or influence over any of
  the derived works, i.e. over software or services created by other
  programmers which use Swiss Ephemeris functions.

  The names of the authors or of the copyright holder (Astrodienst) must not
  be used for promoting any software, product or service which uses or contains
  the Swiss Ephemeris. This copyright notice is the ONLY place where the
  names of the authors can legally appear, except in cases where they have
  given special permission in writing.

  The trademarks 'Swiss Ephemeris' and 'Swiss Ephemeris inside' may be used
  for promoting such software, products or services.
*/

/*
First date in file = 1228000.50
Number of records = 397276.0
Days per record = 4.0
      Julian Years      Lon    Lat    Rad
 -1349.9 to  -1000.0:   0.42   0.18   0.16 
 -1000.0 to   -500.0:   0.37   0.19   0.13 
  -500.0 to      0.0:   0.35   0.17   0.12 
     0.0 to    500.0:   0.34   0.15   0.10 
   500.0 to   1000.0:   0.28   0.14   0.09 
  1000.0 to   1500.0:   0.34   0.14   0.09 
  1500.0 to   2000.0:   0.35   0.13   0.09 
  2000.0 to   2500.0:   0.38   0.12   0.12 
  2500.0 to   3000.0:   0.42   0.13   0.16 
  3000.0 to   3000.8:  0.252  0.087  0.115 
*/
static double mertab1[] = {};
static double mertabb[] = {};
static double mertabr[] = {};
static signed char merargs[] = {};
static struct plantbl mer404 = {};
/*
mer404
ventabl
*/




/*
First date in file = 1228000.50
Number of records = 397276.0
Days per record = 4.0
      Julian Years      Lon    Lat    Rad
 -1349.9 to  -1000.0:   0.23   0.15   0.10 
 -1000.0 to   -500.0:   0.25   0.15   0.10 
  -500.0 to      0.0:   0.20   0.13   0.09 
     0.0 to    500.0:   0.16   0.11   0.08 
   500.0 to   1000.0:   0.19   0.09   0.08 
  1000.0 to   1500.0:   0.16   0.09   0.08 
  1500.0 to   2000.0:   0.21   0.12   0.08 
  2000.0 to   2500.0:   0.28   0.14   0.09 
  2500.0 to   3000.0:   0.30   0.15   0.10 
  3000.0 to   3000.8:  0.116  0.062  0.058 
*/
static double ventabl[] = {};
static double ventabb[] = {};
static double ventabr[] = {};

static signed char venargs[] = {};
/* Total terms = 108, small = 107 */
static struct plantbl ven404 = {};

/*
First date in file = 1228000.50
Number of records = 264850.0
Days per record = 6.0
      Julian Years      Lon    Lat    Rad
 -1349.9 to  -1000.0:   0.13   0.06   0.07 
 -1000.0 to   -500.0:   0.12   0.06   0.06 
  -500.0 to      0.0:   0.12   0.06   0.08 
     0.0 to    500.0:   0.12   0.05   0.06 
   500.0 to   1000.0:   0.12   0.05   0.07 
  1000.0 to   1500.0:   0.11   0.05   0.07 
  1500.0 to   2000.0:   0.11   0.05   0.06 
  2000.0 to   2500.0:   0.11   0.05   0.06 
  2500.0 to   3000.0:   0.14   0.06   0.07 
  3000.0 to   3000.8:  0.074  0.048  0.044 
*/

static double eartabl[] = {};
static double eartabb[] = {};
static double eartabr[] = {};

static signed char earargs[] = {};
/* Total terms = 135, small = 134 */
static struct plantbl ear404 = {};
/*
First date in file = 1228000.50
Number of records = 397276.0
Days per record = 4.0
      Julian Years      Lon    Lat    Rad
 -1349.9 to  -1000.0:   0.42   0.18   0.25 
 -1000.0 to   -500.0:   0.45   0.14   0.21 
  -500.0 to      0.0:   0.37   0.10   0.20 
     0.0 to    500.0:   0.33   0.09   0.22 
   500.0 to   1000.0:   0.48   0.07   0.22 
  1000.0 to   1500.0:   0.40   0.07   0.19 
  1500.0 to   2000.0:   0.36   0.11   0.19 
  2000.0 to   2500.0:   0.38   0.14   0.20 
  2500.0 to   3000.0:   0.45   0.15   0.24 
  3000.0 to   3000.8:  0.182  0.125  0.087 
*/

static double martabl[] = {};
static double martabb[] = {};
static double martabr[] = {};

static signed char marargs[] = {};
/* Total terms = 201, small = 199 */
static struct plantbl mar404 = {};

/*
First date in file = 625296.50
Number of records = 16731.0
Days per record = 131.0
      Julian Years      Lon    Lat    Rad
 -3000.0 to  -2499.7:   0.64   0.09   0.40 
 -2499.7 to  -1999.7:   0.70   0.09   0.45 
 -1999.7 to  -1499.7:   0.44   0.08   0.32 
 -1499.7 to   -999.8:   0.42   0.07   0.32 
  -999.8 to   -499.8:   0.55   0.06   0.34 
  -499.8 to      0.2:   0.43   0.06   0.31 
     0.2 to    500.2:   0.56   0.07   0.32 
   500.2 to   1000.1:   0.49   0.06   0.41 
  1000.1 to   1500.1:   0.48   0.06   0.38 
  1500.1 to   2000.1:   0.56   0.06   0.38 
  2000.1 to   2500.0:   0.63   0.08   0.33 
  2500.0 to   3000.0:   0.70   0.09   0.36 
  3000.0 to   3000.4:  0.526  0.023  0.190 
*/
static double juptabl[] = {};
static double juptabb[] = {};
static double juptabr[] = {};

static signed char jupargs[] = {};
/* Total terms = 142, small = 140 */
static struct plantbl jup404 = {};

/*
First date in file = 625296.50
Number of records = 16731.0
Days per record = 131.0
      Julian Years      Lon    Lat    Rad
 -3000.0 to  -2499.7:   0.78   0.26   0.55 
 -2499.7 to  -1999.7:   0.66   0.19   0.57 
 -1999.7 to  -1499.7:   0.62   0.19   0.53 
 -1499.7 to   -999.8:   0.79   0.17   0.61 
  -999.8 to   -499.8:   0.78   0.15   0.42 
  -499.8 to      0.2:   0.75   0.19   0.52 
     0.2 to    500.2:   0.62   0.18   0.41 
   500.2 to   1000.1:   0.56   0.13   0.54 
  1000.1 to   1500.1:   0.53   0.15   0.41 
  1500.1 to   2000.1:   0.51   0.15   0.49 
  2000.1 to   2500.0:   0.52   0.13   0.41 
  2500.0 to   3000.0:   0.63   0.22   0.53 
  3000.0 to   3000.4:  0.047  0.073  0.086 
*/
static double sattabl[] = {};
static double sattabb[] = {};
static double sattabr[] = {};

static signed char satargs[] = {};
/* Total terms = 215, small = 211 */
static struct plantbl sat404 = {};

/*
First date in file = 625296.50
Number of records = 16731.0
Days per record = 131.0
      Julian Years      Lon    Lat    Rad
 -3000.0 to  -2499.7:   0.35   0.06   0.42 
 -2499.7 to  -1999.7:   0.50   0.06   0.38 
 -1999.7 to  -1499.7:   0.39   0.07   0.34 
 -1499.7 to   -999.8:   0.34   0.06   0.30 
  -999.8 to   -499.8:   0.35   0.05   0.32 
  -499.8 to      0.2:   0.32   0.05   0.27 
     0.2 to    500.2:   0.26   0.04   0.25 
   500.2 to   1000.1:   0.28   0.04   0.25 
  1000.1 to   1500.1:   0.26   0.06   0.31 
  1500.1 to   2000.1:   0.33   0.05   0.24 
  2000.1 to   2500.0:   0.32   0.06   0.26 
  2500.0 to   3000.0:   0.34   0.06   0.32 
  3000.0 to   3000.4:  0.406  0.035  0.172 
*/
static double uratabl[] = {};
static double uratabb[] = {};
static double uratabr[] = {};

static signed char uraargs[] = {};
/* Total terms = 177, small = 171 */
static struct plantbl ura404 = {};

/*
First date in file = 625296.50
Number of records = 16731.0
Days per record = 131.0
      Julian Years      Lon    Lat    Rad
 -3000.0 to  -2499.7:   0.44   0.30   0.50 
 -2499.7 to  -1999.7:   0.39   0.20   0.39 
 -1999.7 to  -1499.7:   0.31   0.15   0.31 
 -1499.7 to   -999.8:   0.32   0.19   0.36 
  -999.8 to   -499.8:   0.29   0.15   0.29 
  -499.8 to      0.2:   0.31   0.14   0.27 
     0.2 to    500.2:   0.28   0.14   0.27 
   500.2 to   1000.1:   0.34   0.15   0.39 
  1000.1 to   1500.1:   0.31   0.16   0.31 
  1500.1 to   2000.1:   0.33   0.16   0.29 
  2000.1 to   2500.0:   0.38   0.21   0.36 
  2500.0 to   3000.0:   0.43   0.25   0.46 
  3000.0 to   3000.4:  0.122  0.071  0.260 
*/
static double neptabl[] = {};
static double neptabb[] = {};
static double neptabr[] = {};

static signed char nepargs[] = {};
/* Total terms = 59, small = 58 */
static struct plantbl nep404 = {};

/*
First date in file = 625296.50
Number of records = 16731.0
Days per record = 131.0
      Julian Years      Lon    Lat    Rad
 -3000.0 to  -2499.7:   1.17   0.90   0.83 
 -2499.7 to  -1999.7:   0.57   0.51   0.58 
 -1999.7 to  -1499.7:   0.63   0.39   0.40 
 -1499.7 to   -999.8:   0.40   0.45   0.41 
  -999.8 to   -499.8:   0.42   0.22   0.30 
  -499.8 to      0.2:   0.41   0.24   0.35 
     0.2 to    500.2:   0.58   0.24   0.26 
   500.2 to   1000.1:   0.47   0.35   0.33 
  1000.1 to   1500.1:   0.43   0.31   0.28 
  1500.1 to   2000.1:   0.37   0.40   0.35 
  2000.1 to   2500.0:   0.46   0.35   0.39 
  2500.0 to   3000.0:   1.09   0.70   0.46 
  3000.0 to   3000.4:  0.871  0.395  0.051 
*/
static double plutabl[] = {};
static double plutabb[] = {};
static double plutabr[] = {};

static signed char pluargs[] = {};
/* Total terms = 173, small = 156 */
static struct plantbl plu404 = {};