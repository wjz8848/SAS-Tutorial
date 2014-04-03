*** 20140325 Permutation Tests

*** Null Hypothesis : mu1 = mu2

*** make up data
		N(u=1, s=1)
		N(u=2, s=1)
		 n1=10 n2=15 --25;

data perm;
	do i = 1 to 25;
		if i le 10 then group=1; else group=2;
		y=normal(63931) + group;
		output;
	end;
run;

proc print data=perm;
run;

* do a 2-group ttest
	save the t-test t value;
ods trace on;
proc ttest;
	class group;
	var y;
run;
ods graphics off;
ods trace off;

proc ttest;
	ods output ttest=ttests;
	class group;
	var y;
run;

proc print data= ttests;
run;

data perm1;
	set perm;
	x = ranuni(331122);
run;

proc sort; by x;

data perm2;
	set perm1;
	if _n_ le 10 then group=1; else group=2;
run;

proc print data=perm2;
run;

data perm3;
	set perm;
	do rep= 1 to 2;
		x=ranuni(331122);
		output;
	end;
run;

proc print data=perm3;
run;

proc sort;
	by rep x;

data perm4;
	set perm3;
	by rep x;
	if first.rep then member = 1; else member+1;
	if member le 10 then group=1; else group =2;
run;

ods select none; * do not want 1000 pages in output window;

proc ttest data=perm4;
	by rep;
	var y;
	class group;
	ods output ttests= tout;
run;
ods select all;

data perm5;
	set tout;
	if method="Pooled";
run;

proc univariate freq;
	var tvalue;
run;

data perm6;
	set perm5;
	if abs(tvalue)> 2.74 then extreme=1; else extreme = 0;
run;

proc means;
	var extreme;
run;
