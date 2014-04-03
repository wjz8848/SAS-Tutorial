*first read in data appenc10.txt;
*It looks like a bunch of numbers;

data work.disease;
	infile 's:\course\bios532\2014\appenc10.txt';

	*It doesn't contains information about the meanings of the number;
	*Need to assign the meaning of each column;
	input
	id age sex sector disease savings;

run;

proc print;
run;


*turn on nice stat graphics;
ods graphics on;

*roc sens (y) vs 1-spec (x);
*logistic give you whole flavors;
proc logistic data = work.disease plot = (roc);
	class sex;
	* code for having disease (1);
	model disease (event = '1') = age sex sector;

run;




*ods to get at internal sas data;
ods trace on;

proc logistic data = work.disease plot = (roc);
	class sex;
	* code for having disease (1);
	*ctable give info concerning AUC;
	model disease (event = '1') = age sex sector / ctable;

run;





*ods to get at internal sas data;
*ods off ;
ods trace off;

proc logistic data = work.disease plot = (roc);
	class sex;
	*ctable give info concerning AUC;
	model disease (event = '1') = age sex sector / ctable;
	ods output roccurve = roccurve;
run;

proc print data = roccurve;
run;



data auc;
	set roccurve;
	x = _1mspec_;
	y = _sensit_;
	keep x y;
run;



proc print;
run;



data auc1;
	set auc;
	prex = lag(x);
	prey = lag(y); *lag() gets previous obs value;
	h = x -prex;
	if _n_ = 1 then auc = 0;
		else auc + 0.5 * h * (y + prey);

run;

proc print;
	var auc;
run;


*ods can make pdf, rtf, ps, html, and others;
*By default all files are stored in the current folder;
*You can either store all files there OR give path;

*Example would be ;
ods pdf file = 'c:\users\jwang67\example.pdf';
ods ps file =  'example.ps';
ods rtf file = 'example.rtf' sasdate; 
*By default the date/time is when you open this file in word, sasdate says use date/time that it was created;

ods html file = 'xxx.html';



proc logistic data = work.disease plot = (roc);
	class sex;
	*code for having disease (1);
	*ctable give info concerning AUC;
	model disease (event = '1') = age sex sector;

run;

proc ttest data = work.disease;
	class disease;
	var age;
run;

proc freq data = work.disease;
	tables diesease * (sex sector);

run;


*The file will only be stored after you do a CLOSE!;
ods pdf close;
ods ps close;
ods rtf close;
ods html close;

proc template;
	list styles;
run;



ods pdf file = 'c:\users\jwang67\money.pdf' style = money;




proc logistic data = work.disease plot = (roc);
	class sex;
	*code for having disease (1);
	*ctable give info concerning AUC;
	model disease (event = '1') = age sex sector;

run;

proc ttest data = work.disease;
	class disease;
	var age;
run;

proc freq data = work.disease;
	tables diesease * (sex sector);

run;


*The file will only be stored after you do a CLOSE!;
ods pdf close;



********************************;


ods pdf file = 'c:\users\jwang67\journal.pdf' style = journal;




proc logistic data = work.disease plot = (roc);
	class sex;
	*code for having disease (1);
	*ctable give info concerning AUC;
	model disease (event = '1') = age sex sector;

run;

proc ttest data = work.disease;
	class disease;
	var age;
run;

proc freq data = work.disease;
	tables diesease * (sex sector);

run;


*The file will only be stored after you do a CLOSE!;
ods pdf close;



********************************;
*BarrettsBlue Style;


ods pdf file = 'c:\users\jwang67\bb.pdf' style = BarrettsBlue;




proc logistic data = work.disease plot = (roc);
	class sex;
	*code for having disease (1);
	*ctable give info concerning AUC;
	model disease (event = '1') = age sex sector;

run;

proc ttest data = work.disease;
	class disease;
	var age;
run;

proc freq data = work.disease;
	tables diesease * (sex sector);

run;


*The file will only be stored after you do a CLOSE!;
ods pdf close;



********************************;
*WaterColor Style;


ods pdf file = 'c:\users\jwang67\wc.pdf' style = watercolor;




proc logistic data = work.disease plot = (roc);
	class sex;
	*code for having disease (1);
	*ctable give info concerning AUC;
	model disease (event = '1') = age sex sector;

run;

proc ttest data = work.disease;
	class disease;
	var age;
run;

proc freq data = work.disease;
	tables diesease * (sex sector);

run;


*The file will only be stored after you do a CLOSE!;
ods pdf close;

