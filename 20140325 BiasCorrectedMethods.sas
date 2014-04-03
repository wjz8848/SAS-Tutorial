*** 20140325

*** recap of last class
	Bootstraping : 1000 reps of (population - random one element)
				   No frequency is generated (>SAS9.2)

					proc corr -> univariate
*****************************************************************

*** Today : Bias Corrected (BC) Method and Bias Corrected accelerated (BCa) Method

* in the n = 1000 replicates how many were <= original correlation
  0.62816
;

******************************************************************;
*** input was from last lecture;
data boot;
   infile 's:\course\bios532\2014\resampling\bootreg.txt' dlm=',' firstobs=2;
   input x y;
run;
proc corr; var y; with x;
run;

* now do this not 1 rep but 1000 reps;

proc surveyselect
      data=boot /* name of the population - our sample */
	  out=bootsample1 
	  n=100 /* sample size of each rep - sample of your orig data */
	  method=urs /* srs - simple random sample - now urs - WITH replacement */
	  seed=3327783
	  rep=1000  
	  outhits;
run;
proc contents data=bootsample1;
run;



ods select none;   * no results in output window;
proc corr nosimple data=bootsample1;
  by replicate;
  var x; with y;
  ods output pearsoncorr=r;
run;



proc univariate freq data=r;
   var x;
   output out=stats pctlpre=p_ pctlpts =2.5 97.5 pctlname=lower upper;
   run;
   ods select all;
proc print;
run;
*** end of last lecture;
******************************************************************;



data bcl;
	set r;
	smaller = 0;
	* if current corr <= 0.62816 then count that;
	if x <= 0.62816 then smaller = 1;
run;
* now have 1000 values that are either 0 (not smaller) or 1 (smaller or =);

proc means noprint data = bcl;
	var smaller;
	output out = bc2 mean=mean;
run;

proc print data = bc2;
run;



	
