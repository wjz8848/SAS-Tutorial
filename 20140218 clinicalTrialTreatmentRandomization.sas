* Treatment patient randomization;

* Treatment A and B equally prob;

data a;
	seed=123565;
	
	person=0;

	* suppose i need 200 people
	* I am generating 45 at a time
	* 200/4 = 50 bloock;

	do i = 1 to 50;
		A = rantbl(seed, 1/6, 1/6, 1/6, 1/6, 1/6, 1/6);
		if A = 1 then do; *AABB;
			trt = 'A'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
		end;

		if A = 2 then do; *ABAB;
			trt = 'A'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
		end;

		if A = 3 then do; *ABBA;
			trt = 'A'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
		end;

		if A = 4 then do; *BBAA;
			trt = 'B'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
		end;

		if A = 5 then do; *BABA;
			trt = 'B'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
		end;

		if A = 6 then do; *BAAB;
			trt = 'B'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
			trt = 'A'; person = person + 1; output;
			trt = 'B'; person = person + 1; output;
		end;
	end;*i loop;

run;

proc print noobs;
	var person trt;
run;

* what if block size is not 2;

* e.g. AABB and randomly reorder them;
* and do this 50 times;
* add an additional varibale - x which is random uniform;
* and then sort by x;

data shuffle;
	seed = 123456;
	do block = 1 to 50;
		trt='A'; x = uniform(seed);output;
		trt='A'; x = uniform(seed);output;
		trt='B'; x = uniform(seed);output;
		trt='B'; x = uniform(seed);output;
	end;
run;

proc sort; by block x;

data final;
	set shuffle;
	* set the starting number;
	if _n_ = 1 then personID = 1000;
	personID + 1;

proc print noobs;
	var personID block trt;
run;

**************************************
* in class assignment

* take this code and use 4As and 4Bs;
* generate 32 people;

data shuffleAssignment;
	seed = 123456;
	do block = 1 to 4;
		trt='A'; x = uniform(seed);output;
		trt='A'; x = uniform(seed);output;
		trt='A'; x = uniform(seed);output;
		trt='A'; x = uniform(seed);output;
		trt='B'; x = uniform(seed);output;
		trt='B'; x = uniform(seed);output;
		trt='B'; x = uniform(seed);output;
		trt='B'; x = uniform(seed);output;
	end;
run;

proc sort; by block x;

data final;
	set shuffleAssignment;
	* set the starting number;
	if _n_ = 1 then personID = 2000;
	personID + 1;

proc print noobs;
	var personID block trt;
run;

* done;
****************************************

* central limit theroem;
* generate uniform data (100 obs);
* calc the mean (sample);
* do this 1000 times;
* show dist of these 1000 means;

data clt;
	seed = 100;
	do rep = 1 to 1000;
		do j = 1 to 100;
			x = uniform(seed);
			output;
		end;
	end;
run;

proc means noprint;
	by rep;
		var x;
		output out = new mean = xbar;
run;

proc print data = new (obs = 10);
run;

ods on;
* do a histogram;
proc univariate plot normal;
	histogram xbar / normal;
	var xbar;
run;
