******* 20140401
* Solve p(x) = 0;

******************
* Graphics Solution
*****************;
DATA x;
	do x = 0 to 2 by .001;
	* can try smaller window and smaller steps;
	* do x = 0.999 to 1.001 by .00000001;
		p = 1 - 6*x + 15*x**2 - 20*x**3  + 15*x**4 - 6*x**5 + x**6;
		output;
	end;
run;

symbol1 v=none i = j l = 1 c = red;
* 		no symbols plotted for each value
			interpolate by joining data points
				l=1 solid line
					color = name of color .....;

proc gplot;
	plot p*x;
run;



******************
* numerical techniques solution
*****************;

* to solve f(x) = x**3 - x - 1
* coefficient for each term 1 0 -1 -1;

proc iml;
	px = {1 0 -1 -1}; * order highest -> lowest;
	x = polyroot(px);
	print x;
quit;

* will get 

-0.662359 0.5622795 
-0.662359 -0.56228 
1.324718 0 

two imaginary roots are -0.662359 +/- 0.5622795i
one real root is 1.324718;



***********************;

DATA work.function;
	do x = -2 to 2 by .001;
		p = - 1 - x + 0*x**2 + x**3;
		output;
	end;
run;

symbol1 v=none i = j l = 1 c = red;

proc gplot;
	plot p*x / vaxis = axis1 vref = 0; *draw line on vert axis p=0;
run;

data bisect;
	a = -2;
	b = 2;
	tol = 0.00000001;
	* how close to 0 do i need to be within +/- tol;

	numloops = 100;
	

	do i =1 to numloops;
		mid = (a + b)/2;
		
		ya = a**3 - a -1;
		yb = b**3 - b -1;

		ym = mid**3 - mid -1;

		* y(mid)=0 or close to 0;

		if (abs(ym) le tol) then i = numloops + 1;

		else if ym*ya lt 0 then b = mid;
			else a = mid;
			output;
	end;
run;

proc print noobs;
	var i mid ym ya yb;
	format mid ym ya yb best12.8;
run;




data work.bisect1;
	
	a = -2;
	b = 2;
	tol = 0.0000000001;

	numloops =100;
	i = 0;
	gggg: i = i + 1;
		mid = (a+b)/2;
		ya = a**3 - a -1;
		yb = b**3 - b -1;
		ym = mid**3 - mid -1;

		* y(mid)=0 or close to 0;
		if ym*ya lt 0 then b = mid;
			else a = mid;
			output;
		if abs(ym) > tol and i< numloops then goto gggg;

run;


proc print noobs;
	var i mid ym ya yb;
	format mid ym ya yb best12.8;
run;


************************************
* macrotize this methods
* next week R
* 2 new methods;

* macro
	initial values for a, b
	f(x)
	tol
	numloops
*;

%macro bisect(a, b, fx, tol, numloops)

data bisectMacro;
	a = &a;
	b = &b;
	tol = &tol;
	numloops = &numloops;

	i = 0;
	gggg: i = i + 1;
		mid = (a+b)/2;

		x = a;
		ya = &fx;
		x = b;
		yb = &fx;
		x = mid;
		ym = &fx;

		* y(mid)=0 or close to 0;
		if ym*ya lt 0 then b = mid;
			else a = mid;
			output;
		if abs(ym) > tol and i< numloops then goto gggg;
run;


proc print noobs;
	var i mid ym;
	format mid ym best12.8;
run;
%mend;

options mprint symbolgen;
%bisect(-2,2, x*x*x-x-1, 0.000001, 100);
