* use lag logic to calculate area under the curve (AUC);
* the Rectangular rule;

data work.x;
	input x y;
	cards;
	2 1
	4 2
	6 4
	8 3
	;
run;

proc print;

run;

data work.aucRetangular;
	set x;
	prex = lag(x);
	prey = lag(y);
	auc = (x - prex) * prey;
run;

proc print;
run;

proc means sum;
	var auc;
run;


* Alternative approach;

data work.auc1;
	set x;
	prex = lag(x);
	prey = lag(y);
	if _n_ = 1 then auc = 0;	* _n_ is the obs #;
	auc + (x - prex) * prey; * well, stupid SAS actually means auc += (x - prex) * prey.....;

run;

proc print;
	* only show up when x = 8 (last obs);
	var auc;
	where x = 8;
run;

* or change auc only to keep last obs;

*/////////////////////////////////////////////////////*;

*Mid-point rule;
*Use (prey + y) / 2 as the height;

data work.aucMidpoint;
	set x;
	prex = lag(x);
	prey = lag(y);
	auc = (x - prex) * ((prey + y) / 2);
run;

proc print;
run;

proc means sum;
	var auc;
run;


*/////////////////////////////////////////////////////*;

* Trapezoid rule;
* use Area = 0.5 * height * (b1 + b2)
	height = x - prex
	b1 = prey
	b2 = y;
* Trapezoid rule is identically to Mid-point rule;

data work.aucTrapezoid;
	set x;
	prex = lag(x);
	prey = lag(y);
	height = x - prex;
	b1 = prey;
	b2 = y;
	auc = 0.5 * height * (b1 + b2);
run;

proc print;
run;

proc means sum;
	var auc;
run;

*/////////////////////////////////////////////////////*;

* Suppose we have 1 obs per person with 4 xs and 4 ys
  instead of 4 obs with 1 x and 1 y;

data work.oneobs;
	input x1 y1 x2 y2 x3 y3 x4 y4;
	*equals cards;
	datalines; 
	2 1 4 2 6 4 8 3 
	;
	*Because punch card is yellow, SAS retained the yellow color for input;
run;

proc print;
run;

data work.aucOneObs;
	set work.oneobs;
	auc = 	.5 * (x2 - x1) * (y2 + y1) +
			.5 * (x3 - x2) * (y3 + y2) +
			.5 * (x4 - x3) * (y4 + y3);
run; 

proc print;
run;

* array statement instead;

data work.aucArray;
	set work.oneobs;
	array x(4) x1-x4;
	array y(4) y1-y4;
	aucArray = 0;
	do i = 2 to 4;
		aucArray = aucArray + 0.5 * (x(i) - x(i-1)) * (y(i) + y(i-1));
	end;
		drop i;
run;

proc print;
run;


*macrofy the above datastep;
* only parameter is # time points - nt;

%macro aucArray(nt);
data work.aucArrayMacro;
	set work.oneobs;
	array x(&nt) x1-x&nt;
	array y(&nt) y1-y&nt;
	aucArray = 0;
	do i = 2 to &nt;
		aucArray = aucArray + 0.5 * (x(i) - x(i-1)) * (y(i) + y(i-1));
	end;
		drop i;
run;

proc print;
run;

%mend;

options symbolgen mprint;
%aucArray(4);


* create a new dataset then use the macro;

data work.oneobs2;
	input x1 y1 x2 y2 x3 y3 x4 y4 x5 y5;
	datalines; 
	2 1 4 2 6 4 8 3 10 2
	;
run;

proc print;
run;

%aucArray(5);
