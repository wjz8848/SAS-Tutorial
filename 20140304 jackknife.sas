data jack;
	input y @@;
	cards;
	45 55 82 78 56 60 77 66 90 66
	53 51 63 98 67 23 21 95 24 58
	;

proc means;
run;

data jack1;
	array y(20) y1-y20;
	input y1-y20;
	* now do data manipulation;
	* delete the ith obs and calc the mean;

	do i =1 to 20;
		sum = 0;
		do j = 1 to 20;
		* if i = j do NOT use it;
		if i ne j then sum = sum +y(j);
		end;

		xbar = sum/19;
		output;
	end;
	cards;
	45 55 82 78 56 60 77 66 90 66
	53 51 63 98 67 23 21 95 24 58
	;
	
proc means;
run;

proc print;
	var i xbar;
run;

proc means css;
	var xbar;
run;

* low level graphics;
proc chart data = jack1;
	vbar xbar;
run;

proc gchart;
	vbar xbar / midpoints= 66 to 69 by .5;
run;

proc gchart;
	vbar xbar / midpoints= 1 to 100 by 1;
run;

data final;
*.....
	
