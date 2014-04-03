*Post-task test;

*Nonparametric;

*Kruskal-Wallis Test;

*Tukey's;

data work.att;
	infile 's:\course\bios532\2014\KW.dat';

	input class attitude;

run;


proc print;
run;


proc glm data = att;
	class class;
	model attitude = class;
	means class;
	means class/tukey cldiff;
	*cldiff confidence level difference;

run;

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

	tukey = probmc("range", . , 0.95, . , 3)/sqrt(2);

					* range is studentize range - q dist;
							* the output should be the quantile and not the prob;
								* 1 - alpha;
									* df - infinite is .;
										* k the # of groups;

run;

proc print;
run;


*************;
data tukey;
	set oneline;
		tukey = probmc("range", . , 0.95, . , 3)/sqrt(2);
		N = n1 + n2 + n3;
		* v = N * (N + 1) * (1 / n1 + 1 / n2) /  12;
		* s = sqrt(V);

		* soph(1) vs jr(2);
		sd12 = sqrt (N * (N + 1) * ((1 / n1) + (1 / n2)) / 12);
		diff12 = rank1 - rank2;
		*lower confidence level;
		lcl12 = diff12 - sd12 * tukey;
		*Upper confidence level;
		ucl12 = diff12 + sd12 * tukey;

		*add 1 vs 3 and 2 vs 3;
run;

proc print data = tukey;
	var n1 n2 rank1 rank2 diff12 lcl12 ucl12;
run;
