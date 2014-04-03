* 2014/02/04 from 2014/01/28;

* Read in kw.dat;

DATA WORK.attitude;
	INFILE 'S:\course\bios532\2014\kw.dat';
	INPUT	Class Attitude;
RUN;

* List all the possible entries;
PROC PRINT;
RUN;

* glm: general linear model ;
proc glm data = att;
	class class;
	model attitude = class;
	means class;
	means class/tukey cldiff;
	*cldiff confidence level difference;

run;

* npar1way tests the null hypothesis on 1 way  ;
proc npar1way data = att wilcoxon; * wilcoxon === kruskal-wallis test;
	class class;
	var attitude;
run;



ods trace on;
proc npar1way data=att wilcoxon; * wilcoxon === kw;
	class class;
	var attitude;
run;


ods trace off;
proc npar1way data=att wilcoxon; * wilcoxon === kw;
	class class;
	ods output wilcoxonscores=work.ws;
	var attitude;
run;

proc print data=ws;
run;


*take ws that has 3 lines of data with var names N and meanscore
 and create a dataset with 1 line of data with var names
 n1 n2 n3 rank1 rank2 rank3;

*do in 3 datasteps
	gr1 using just class1
	gr2 using 	2
	gr3			3
 and then merge them;

data work.gr1;
   set ws;
   if class=1;
   n1=N;
   rank1=meanscore;
   keep n1 rank1;
run;
proc print;
run;



data work.gr2;
	set ws;
	if class = 2;
	n2 = N;
	rank2 = meanscore;
	keep n2 rank2;
run;

proc print;
run;


data work.gr3;
	set ws;
	if class = 3;
	n3 = N;
	rank3 = meanscore;
	keep n3 rank3;
run;

proc print;
run;

data oneline;
	merge gr1 gr2 gr3;
run;

proc print;
run;

data tukey;
*show how to get tukey from sas;
	set oneline;
	tukey = probmc("range", . , 0.95, . , 3)/sqrt(2);

					* range is studentize range - q dist;
							* the output should be the quantile and not the prob;
								* 1 - alpha;
									* df - infinite is .;
										* k the # of groups;
	N = n1 + n2 + n3;
	* v= n*(n+1)*(1/n1 +1/n2)/12;
	sd12 = sqrt (N * (N +1)*((1/n1)+ (1/n2))/12);
	diff12 = rank1 - rank2;
	lcl12= diff12 - sd12*tukey;
	ucl12= diff12 + sd12*tukey;

	sd13 = sqrt (N * (N +1)*((1/n1)+ (1/n3))/12);
	diff13 = rank1 - rank3;
	lcl13= diff13 - sd13*tukey;
	ucl13= diff13 + sd13*tukey;

	sd23 = sqrt (N * (N +1)*((1/n2)+ (1/n3))/12);
	diff23 = rank2 - rank3;
	lcl23= diff23 - sd23*tukey;
	ucl23= diff23 + sd23*tukey;

run;

PROC PRINT;
RUN;

data posthoc;
	set tukey;
	comp = '1 - 2'; diff= diff12; lcl=lcl12; ucl=ucl12; output;
	comp = '1 - 3'; diff= diff13; lcl=lcl13; ucl=ucl13; output;
	comp = '2 - 3'; diff= diff23; lcl=lcl23; ucl=ucl23; output;
	keep comp diff lcl ucl;
run;

proc print noobs;
run;

data final;
	set posthoc;

	* lcl*ucl if + then the ci does NOT include zero ---sign;
	s = lcl * ucl;
	if s>0 then sig='***'; else sig='   ';

	* label make the table prettier;
	label comp= 'Comparison'
		  diff= 'Difference in Ranks'
		  lcl = 'Lower CI'
		  ucl = 'Upper CI'
		  sig = 'Significance';
	drop s;
run;

proc print label noobs;
run;

** make a macro;
%macro x;

%do i = 1 %to 3;
	data gr&i;
	set ws;
		if class = &i;
		n&i = n;
		rank&i = meanscore;
		keep n&i rank&i;
run;
%end; *end do loop;
%mend;

options mprint symbolgen mlogic;
%x;

** Generalize to N groups;
%macro x(numgroups);

%do i = 1 %to &numgroups;
	data gr&i;
	set ws;
		if class = &i;
		n&i = n;
		rank&i = meanscore;
		keep n&i rank&i;
run;
%end; *end do loop;
%mend;

options mprint symbolgen mlogic;
** Calling numgroups =3 ;
%x(3);

* Merging method in simple version;
data online;
	merge gr1-gr3;
run;
proc print;
run;

* Alternative Merging step;
data work.oneline;
	array ss(3) n1-n3; *sample score;
	array ms(3) rank1 - rank3; *mean score;
	ngroups = 3;
	do i = 1 to ngroups;
		set ws;
		ss(i) = n;
		ms(i) = meanscore;
	end;
	keep n1-n3 rank1-rank3 ngroups;
run;

proc print;
run;

* Merge in a Macro;

%macro y(ngrops);

data work.oneline;
	array ss(&ngroups) n1-n&ngroups; *sample score;
	array ms(&ngroups) rank1 - rank&ngroups; *mean score;
	ngroups = &ngroups;
	do i = 1 to ngroups;
		set ws;
		ss(i) = n;
		ms(i) = meanscore;
	end;
	keep n1-n&ngroups rank1-rank&ngroups ngroups;
run;

%mend;

options mprint symbolgen mlogic;
** Calling numgroups =3 ;
%y(3);

proc print;
run;


* Transpose Method;
proc transpose data = ws out = ws1;
	var n;
run;

proc print data= ws1;
run;

**
* Transpose Method;
proc transpose data = ws 
	out = ws1(rename = (col1=n1 col2=n2 col3= n3));
	var n;
run;

proc print data= ws1;
run;

* Transpose Method;
proc transpose data = ws 
	out = ws2(rename = (col1=rank1 col2=rank2 col3= rank3));
	var meanscore;
run;

proc print data= ws2;
run;


data oneline2;
	merge ws1 ws2;
	keep n1-n3 rank1-rank3;
run;

proc print data = oneline2;
run;



proc transpose data =ws out = ws3;
	var n meanscore;
run;

proc print data =ws3;
run;

* proc rank -ranks data
	use this instead of npar1way;

proc rank data=att out = ranks;
	var attitude;
run;

proc print;
run;

proc means data = ranks;
	var attitude;
	by class;
	output out = new n=n mean = meanatt;

run;

proc print;
run;

* 2 methods for getting ws ---npar1way and one use proc rank;
* going from 3 lines to 1line;
* bruit force 3 datasets one at a time
			  3 datasets in a macro
`			  1 datastep using arrays
			  1 datastep 

;

data tukey;
	set online;
	ngroups =3 ;

	tukey = probmc("range", . , 0.95, . , ngroups)/sqrt(2);

	*ver easy to make mistakes in formulas;

	N = sum(of n1-n3);
	array ss(3) n1-n3;	*sample size;
	array ra(3) rank1-rank3;  *meanscore or rank;

	do i=1 to ngroups-1;
		do j = i+1 to ngroups;
			diff = ra(i) -ra(j);
			sd = sqrt (N * (N +1)*((1/ss(i))+ (1/ss(j)))/12);
			lcl= diff - sd*tukey;
			ucl= diff + sd*tukey;
			s = lcl * ucl;
			if s>0 then sig = '***'; else sig = '   ';
			class1 = i;
			class2 = j;
			output;
		end;
	end;

	label comp= 'Comparison'
		diff= 'Difference in Ranks'
		lcl = 'Lower CI'
		ucl = 'Upper CI'
		sig = 'Significance';
	keep class1 class2 diff lcl ucl sig;
run;

proc print noobs label;
	var class1 class2 diff lcl ucl sig;
run;


* macro one macro;

* macro --kwmacro
	dataset name - dsn
	variable name for dependent var - y
	variable name for grouping var - class
	number of groups - ngroups
	alpha - alpha;

* Reading ds att is not part of macro;


DATA WORK.attitude;
	INFILE 'S:\course\bios532\2014\kw.dat';
	INPUT	Class Attitude;
RUN;

%macro kwposthoc(dsm, y, class, ngroups, alpha);

* get ranks and create oneline;
* do not care about output from this proc;

ods select onne; *do not produce results to the output screen;

proc npar1way data=att wilcoxon; * wilcoxon === kw;
	class class;
	ods output wilcoxonscores=work.ws;
	var attitude;
run;
ods select all; * turn results window back on;

* directly paste from previous macro;
data work.oneline;
	array ss(&ngroups) n1-n&ngroups; *sample score;
	array ms(&ngroups) rank1 - rank&ngroups; *mean score;
	ngroups = &ngroups;
	do i = 1 to ngroups;
		set ws;
		ss(i) = n;
		ms(i) = meanscore;
	end;
	keep n1-n&ngroups rank1-rank&ngroups ngroups;
run;

data tukey;
	set online;
	
	tukey = probmc("range", . , 1-&alpha, . , ngroups)/sqrt(2);

	*ver easy to make mistakes in formulas;

	N = sum(of n1-n&ngroups);
	array ss(&ngroups) n1-n&ngroups;	*sample size;
	array ra(&ngroups) rank1-rank&ngroups;  *meanscore or rank;

	do i=1 to ngroups-1;
		do j = i+1 to ngroups;
			diff = ra(i) -ra(j);
			sd = sqrt (N * (N +1)*((1/ss(i))+ (1/ss(j)))/12);
			lcl= diff - sd*tukey;
			ucl= diff + sd*tukey;
			s = lcl * ucl;
			if s>0 then sig = '***'; else sig = '   ';
			class1 = i;
			class2 = j;
			output;
		end;
	end;

	label comp= 'Comparison'
		diff= 'Difference in Ranks'
		lcl = 'Lower CI'
		ucl = 'Upper CI'
		sig = 'Significance';
	keep class1 class2 diff lcl ucl sig;
run;

proc print data = tukey noobs label;
	var class1 class2 diff lcl ucl sig;
run;

%mend;

**!!!problems here;
options mprint symbolgen;
%kwposthoc(att, attitude, class, 3, 0.1);

options mprint symbolgen;
%kwposthoc(att, attitude, class, 3, 0.05);

options mprint symbolgen;
%kwposthoc(att, attitude, class, 3, 0.01);

*** project #1 is due 2 weeks from today

	submit the project online

	filename format
	yourname1.sas (jingzhiwang1.sas)

	Also put your name inside your code as a comment;

*** this is due Feb 18 at 23:59;

