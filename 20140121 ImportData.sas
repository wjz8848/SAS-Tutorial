PROC IMPORT OUT = WORK.weight
			DATATABLE = "CRCWGHT"
			DBMS = ACCESS REPLACE;
     DATABASE = "S:\course\Bios532\2014\crc301.mdb"; 
     SCANMEMO = YES;
     USEDATE = NO;
     SCANTIME = YES;
RUN;

PROC contents data = work.weight varnum; /* by variable order not alphabetical */;

RUN; 

PROC print;
run;

PROC print data = weight(obs = 10); * first 10 record;
run;

* sort the data by id and visitno;
proc sort data = work.weight;
	by id visitno;
run;

PROC contents data = work.weight varnum; 
* There is Sorting Information at the end;

RUN; 

data visit1;
	set work.weight;
	* now use only visitno = 1;
	if visitno = 1;
	* Assign new variable to the first observation;
	baselinewt = weight;
	keep id baselinewt;
run;

proc print;

run;


data x;
	merge work.weight visit1;
	by id;
	change = baselinewt - weight;
run;

proc print data = x (obs = 20);
var id visitno weight baselinewt change;
run;

* used 2 datasteps;

* now do in 1 datastep;

data work.change;
	set work.weight;
	by id;
	* first.id = 1 if this record is the first for ta given id
	  last.id = 1 if this is the last record for a given id;
	* else it equals 0
	  1 = TRUE
	  0 = FALSE;
	* Not assuming that the first record for everybody is visitno = 1
	  If I did and someone did not get a baseline visit then I would
	  incorrectly use visit#2 as their baseline;

	if  first.id then baselinewt = .;

	*if visitno = 1 then use withgt as baseline wt;
	if visitno = 1 then baselinewt = weight;
	retain baselinewt;
	change = weight - baselinewt;
	
	if visitno = 1 then delete; * or if visitno ~= 1; * ~= is not equals (!=);
run;

proc print data = work.change (obs = 173);
	var id visitno weight baselinewt change;

run;

proc means;
	class visitno; ** separate means by visit;
	var change;
run;


* want change from prevous visit;
* lag says remember the obs from previous record
  lag2 says remember from 2 obs ago...
  obs  x    lag(x)  lag2(x)
  1    5    .       .
  2    11   5
  3    6    11      5
  4    ....                ;
data work.change;
	set work.weight;
	by id;
	prevt = lag(weight);
run;

proc print data = work.change1;
	var id visitno weight prewt;
run;

* This will use previous person's last visit as the new person's prewt;

data work.change1;
	set work.weight;
	by id;
	prewt = lag(weight);

	if first.id then prewt = .;
	change = prewt - weight;
run;

proc print data = work.change1;
	var id visitno weight prewt change;
run;

