* generate uniform data 0 - 10 integers (discrete uniform)
  1 to 10 with equal prob - discrete;

data x;
	seed = 1234567;
	do i = 1 to 10000;
		x = int (uniform(seed)*10) + 1;
		* 			0,1
		*			0 to close to 10;
		*			1 to 10;
		output;
	end;

proc freq;
	table x;
run;

***************************

* rantbl for some tabular dist with p1=.25, p2=.5, p3=.25;

data y;
	seed= -55;
	do i=1 to 10;
		x=rantbl(seed, .25, .5, .25);
		output;
	end;
run;

proc freq;
	table x;
run;



* do a t distr;

data z;
	call streaminit(372893);
	do i=1 to 10;
		x=rand('t', 22);
		* a lot of options in 't' place;
		output;
	end;
run;

proc freq;
	table x;
run;
