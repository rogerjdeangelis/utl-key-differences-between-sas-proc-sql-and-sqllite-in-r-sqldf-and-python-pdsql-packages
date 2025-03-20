%let pgm=utl-key-differences-between-sas-proc-sql-and-sqllite-in-r-sqldf-and-python-pdsql-packages;

%stop_submission;

   CONTENTS

       1 sql sas r pythonl
       2 suprised by sql group by

Key differences between sas proc sql and sqllite in r sqldf and python pdsql packages

github
https://tinyurl.com/j7wu5e2y
https://github.com/rogerjdeangelis/utl-key-differences-between-sas-proc-sql-and-sqllite-in-r-sqldf-and-python-pdsql-packages

related repo
https://tinyurl.com/2s3shb44
https://github.com/rogerjdeangelis/utl_syntax-and-operational-order-of-sql-statements

sas communities
sashttps://tinyurl.com/e7ryaem6
https://communities.sas.com/t5/SAS-Programming/proc-sql-when-rename-variable-does-group-use-old-or-new-variable/m-p/851761#M336682

/*             _                                      _   _
/ |  ___  __ _| |  ___  __ _ ___   _ __   _ __  _   _| |_| |__   ___  _ __
| | / __|/ _` | | / __|/ _` / __| | `__| | `_ \| | | | __| `_ \ / _ \| `_ \
| | \__ \ (_| | | \__ \ (_| \__ \ | |    | |_) | |_| | |_| | | | (_) | | | |
|_| |___/\__, |_| |___/\__,_|___/ |_|    | .__/ \__, |\__|_| |_|\___/|_| |_|
            |_|                          |_|    |___/
*/

/**************************************************************************************************************************/
/* SOAPBOX ON                  |                                                                                          */
/*                             |                                                                                          */
/*  These are my obsevations   |                                                                                          */
/*                             |                                                                                          */
/*    SAS                      |  R sqldf and python pdsql                                                                */
/*                             |                                                                                          */
/*   calculated                |  need a subquery                                                                         */
/*                             |                                                                                          */
/*   group by alias            |                                                                                          */
/*                             |                                                                                          */
/*   automated joins           |  need asubquery                                                                          */
/*    for select summary       |                                                                                          */
/*    stats (row reduction)    |                                                                                          */
/*                             |                                                                                          */
/*   not supported             |  GROUP_CONCAT(name,',')  combines rows base on group by  John,Alice,Mike                 */
/*                             |                          pne observation per department                                  */
/*                             |                                                                                          */
/*   SAS macro %sqlpartition   |  PARTITION (seq within group as one example, very useful)                                */
/*                             |                                                                                          */
/*   unsupportes monotonic()   |  ROW_NUMBER()                                                                            */
/*                             |                                                                                          */
/*   not supported             |  RANK()                                                                                  */
/*                             |                                                                                          */
/*   not supported             |  DENSE_RANK()                                                                            */
/*                             |                                                                                          */
/*   not supported             |  PERCENT_RANK()                                                                          */
/*                             |                                                                                          */
/*   not supported             |  CUME_DIST()                                                                             */
/*                             |                                                                                          */
/*   not supported             |  NTILE(N)                                                                                */
/*                             |                                                                                          */
/*   not supported             |  LAG(expr)                                                                               */
/*                             |                                                                                          */
/*   not supported             |  LEAD(expr)                                                                              */
/*                             |                                                                                          */
/*   not supported             |  FIRST_VALUE(expr)                                                                       */
/*                             |                                                                                          */
/*   not supported             |  LAST_VALUE(expr)                                                                        */
/*                             |                                                                                          */
/*   not supported             |  NTH_VALUE(expr, N)                                                                      */
/*                             |                                                                                          */
/* SOAPBOX ON                  |                                                                                          */
/**************************************************************************************************************************/
                                                                                                          _
/*___                         _              _   _                       _   __ _ _ __ ___  _   _ _ __   | |__  _   _
|___ \   ___ _   _ _ __  _ __(_)___  ___  __| | | |__  _   _   ___  __ _| | / _` | `__/ _ \| | | | `_ \  | `_ \| | | |
  __) | / __| | | | `_ \| `__| / __|/ _ \/ _` | | `_ \| | | | / __|/ _` | || (_| | | | (_) | |_| | |_) | | |_) | |_| |
 / __/  \__ \ |_| | |_) | |  | \__ \  __/ (_| | | |_) | |_| | \__ \ (_| | | \__, |_|  \___/ \__,_| .__/  |_.__/ \__, |
|_____| |___/\__,_| .__/|_|  |_|___/\___|\__,_| |_.__/ \__, | |___/\__, |_| |___/                |_|            |___/
 ___  __ _ __     |_|                                  |___/          |_|
/ __|/ _` / __|
\__ \ (_| \__ \
|___/\__,_|___/
*/

SOAPBOX ON

  My understanding odf sql was that last
  excuted clause was the 'select' clause,
  with the exception of the 'order by' clause.
  The first was the 'from' clause
  followed by on and where and then group by.
  This is obviously not true

SOAPBOX OFF

proc sql;
  create
     table sd1.want as
  select
     mod(age,5)  as modage
    ,avg(height) as avghgt
  from
     sashelp.class
  group
    by modage
  order
    by modage
  ;
quit;


/**************************************************************************************************************************/
/*  MODAGE     AVGHGT                                                                                                     */
/*                                                                                                                        */
/*     0      65.6250                                                                                                     */
/*     1      60.2667                                                                                                     */
/*     2      59.4400                                                                                                     */
/*     3      61.4333                                                                                                     */
/*     4      64.9000                                                                                                     */
/**************************************************************************************************************************/

/*                  _   _
 _ __   _ __  _   _| |_| |__   ___  _ __
| `__| | `_ \| | | | __| `_ \ / _ \| `_ \
| |    | |_) | |_| | |_| | | | (_) | | | |
|_|    | .__/ \__, |\__|_| |_|\___/|_| |_|
       |_|    |___/
*/

/*---- SAME CODE IN PYTHON ----*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(sqldf)
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
want<-sqldf('
  select
     age % 5 as modage
    ,avg(height) as avghgt
  from
     have
  group
    by modage
  order
    by modage
')
print(want)
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/* R                | SAS                                                                                                 */
/* modage   avghgt  | ROWNAMES    MODAGE     AVGHGT                                                                       */
/*                  |                                                                                                     */
/*      0 65.62500  |     1          0      65.6250                                                                       */
/*      1 60.26667  |     2          1      60.2667                                                                       */
/*      2 59.44000  |     3          2      59.4400                                                                       */
/*      3 61.43333  |     4          3      61.4333                                                                       */
/*      4 64.90000  |     5          4      64.9000                                                                       */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
