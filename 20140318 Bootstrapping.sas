*** 20140318 Bootstrapping;

data boot;
	infile 's:/course/bios532/2014/resampling/bootreg.txt' dlm=',' firstobs=2;
	input x y;
run;

proc print;
run;

symbol1 v = dot i = rl l = 1 c = red;
proc gplot;
	plot y*x;
run;

proc corr;
run;

ods trace on;
proc corr nosimple;
	var y;
	with x;
run;

ods trace off;
proc corr data = boot;
	var y; with x;
	ods output pearsoncorr = r;
run;

proc print data = r;
run;

proc surveyselect
	data = boot /* name of the population - our sample */
	out = bootsample
	n = 100 /* sample size of each rep - sample of your orig data */
	method = urs /* srs - simple random sample - now urs - WITH replacement */
	seed = 3327782
	rep = 1;
run;

proc print data = bootsample;
run;


data bootsample1;
	set bootsample;
		do i = 1 to numberhits;
			output;
		end;
	drop numberhits i;
run;

proc print;
run;


proc surveyselect
	data = boot /* name of the population - our sample */
	out = bootsample2
	n = 100 /* sample size of each rep - sample of your orig data */
	method = urs /* srs - simple random sample - now urs - WITH replacement */
	seed = 3327782
	rep = 10000;
run;

proc contents data = bootsample2;
run;


data bootsample3;
   set bootsample;
     do i=1 to numberhits;
	     output;
	 end;
   drop numberhits i;
run;

ods select none;   * no results in output window;
proc corr nosimple data=bootsample3;
  by replicate;
  var x; with y;
  ods output pearsoncorr=r;
run;

ods graphics off;
ods select all;
proc univariate;
    var x;
	 histogram x / normal;
run;


proc means data=r noprint;
   var x;
    output out=bt mean=xbar std=s;
run;
proc print;
run;


data final;
	set bt;
	t = tinv(0.975, 99);
	lower = xbar - t *s;
	upper = xbar + t*s;
run;

proc print;
	var xbar lower upper;
run;

proc univariate freq data = r;
	var x;
run;

proc univariate freq data=r;
	var x;
	output out=stats pctlpre=p_ pctlpts 2.5 97.5 pctlname=lower upper;
run;

proc print;
run;

*** Need to be fixed ***;
