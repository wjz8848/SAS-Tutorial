*20140225 Uses of Random Numbers (Left Overs)
;

**********************************************
 Last week -> ended with teaching stat
			  showed Central Limit Theorem(CLT);
**********************************************
 This time ->
	2 group t-test;

* n = 22 at random using Normal u = 0 and sigma = 1  -- call it group 1
								mu = 0 and sigma = 1 -- call it group 2
  2 group t-test and save the pvalue;
**********************************************;

data x;
	seed = 1333;
	gr = 1;
	do i = 1 to 22;
		x = normal(seed);
		*mu = 0 and sigma = 1;
		output;
	end;

	gr = 2;
	do i = 1 to 22;
		x = normal(seed) + 1;
		*mu = 0 and sigma = 1;
		output;
	end;
run;

proc print;
run;

ods trace on;
* to find out name of the sas tables to create a sas dataset of pvalues;
proc ttest;
	class gr;
	var x;
run;

ods graphics off; * Don't want to save all the graphics;

ods trace off;
ods select none; * do not display any output into the out window;
proc ttest;
	class gr;
	var x;
	ods output ttest=ttests;
run;

ods select all;
proc print data= ttests; * turn on the output to the output window;
run;

proc print data = ttests label noobs;
	format probt;
run;

*** do this n = 1000 times and look at how many times p<0.05;

* generate a large population with 2 groups 
							N = 1000 per group;

* later i will draw samples from this population;

data work.population;
	do group = 1 to 2;
		do i = 1 to 10000;
			y = rannor(12345) + (group - 1);
			* group = 1 does not add anything
					  2 adds a 1;
			output;
		end; * i loop;
	end; *group;

	drop i;
run;

proc means;
	class group;
run;

* do 2 samples from this population at random
	each with a sample size = 22;

proc surveyselect data = work.population
			out = work.samples	/* output name */
			n = 22				/* sample size for each group */
			method = srs		/* simple random sample METHOD */
			seed = 54321 		/* set seed (not mandatory)*/
			rep = 2 			/* replicates to generate */
			;
		strata group;
run;

proc print data = work.samples;
run;

proc sort data = work.samples;
	by replicate y;
run;

proc print data = work.samples;
run;

* now do 1000 times instead of 2;

proc surveyselect data = work.population
			out = work.samples	/* output name */
			n = 22				/* sample size for each group */
			method = srs		/* simple random sample METHOD */
			seed = 54321 		/* set seed (not mandatory)*/
			rep = 1000 			/* replicates to generate */
			;
		strata group;
run;

proc sort data = work.samples;
	 by replicate;
run;

* ttests by replicates;

ods select none;
proc ttest;
	class group;
	by replicate;
	var y;
	ods output ttests= ttests;
run;


data work.ts;
	set work.ttests;
	if method = 'Pooled';
	* do i reject h0 (ie is p-value <0.05);
	reject = (probt lt 0.05);
keep reject;
run;

ods select all;
proc freq data = ts;
	tables reject;
	title n=22 per group;
run;

*****************************************
* Now test a group of 18;

proc surveyselect data = work.population
			out = work.samples	/* output name */
			n = 18				/* sample size for each group */
			method = srs		/* simple random sample METHOD */
			seed = 54321 		/* set seed (not mandatory)*/
			rep = 1000 			/* replicates to generate */
			;
		strata group;
run;

proc sort data = work.samples;
	 by replicate;
run;

* ttests by replicates;

ods select none;
proc ttest;
	class group;
	by replicate;
	var y;
	ods output ttests= ttests;
run;


data work.ts;
	set work.ttests;
	if method = 'Pooled';
	* do i reject h0 (ie is p-value <0.05);
	reject = (probt lt 0.05);
keep reject;
run;

ods select all;
proc freq data = ts;
	tables reject;
	title n=18 per group;
run;

*************************************;

proc iml;
	* define mu vector;
	mu = {10,20};
	print mu;

	* define sigma matrix;
	sig = {1 .5,
		   .5 1.25};
	print sig;

	seed = 1111770;
	n = 30;

	* get iml to generate the numbers;
	call vnormal(series, mu, sig, n, seed);
		* matrix that has the output;
	print series;

	* save to sas dataset;
	* by def sas names the columns - variables col1 and col2;
	* I want it as y1 and y2;

	names = {"y1" "y2"};
	
	create work.data from series [colnames = names];


proc print data = work.data;
run;

data x(type = cov); *** not a regular sas dataset but a var-cov dataset;
	input _type_ $ name $ y1 y2;
	cards;
	cov y1 1 0.5
	cov y2 0.5 1.25
	;
run;

proc print;
run;
proc contents;
run;

proc contents data = data;
run;

proc simnormal data = x out = xx numreal = 300 seed = 1111770;
			* Cov Matrix, output,   n ,     seed;
	var y1 y2;
run;

proc corr cov;
run;

data xxx;
	set xx;
	 y1 = y1 + 10;
	 y2 = y2 + 20;
run;

proc means;
	var y1 y2;
run;
