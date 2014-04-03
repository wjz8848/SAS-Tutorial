*** 20140318 

*** Last lecture: Jackknife in SAS and R ;

*** Intuition: 	1. calculate the mean/std of n sample values
				2. delete one of the sample value, calculate the other (n-1) values' mean/std
				3. there will be (n-1) means/stds and calculate the stds
				4. if the first std ~= the last std, that indicates the sample is not flunctuating much;

data jack1;
	input y @@;
	id + 1;
	cards;
	45 55 82 78 56 60 77 66 90 66
	53 61 63 98 70 71 65 72 68 59
	;
run;

proc print;
run;

data jack2;
	set jack1;
		do rep = 1 to 20;
			if rep ne id then output;
		end;
run;

proc print data = jack2 (obs = 40);
	data y id rep;
run;

proc sort data= jack2;
	by rep;
run;

proc print data = jack2 (obs = 40);
run;

proc means data = jack2 noprint;
	var y;
	by rep;
	output out = stats mean = ybar std = sd
			median = median skew = skew kurt = kurtosis;
run;

proc print data = stats;
run;

proc means data=stats mean std css;
	var ybar sd median skew kurtosis;
	output out=last
	css = cssybar csssd cssmedian cssskew csskurt;
run;

proc print;
run;

data last1;
	set last;
	*SE = sqrt(css*19/20);
	seybar = (cssybar*19/20)**.5;
	sesd = sqrt(csssd*19/20);
	semedian = sqrt(cssmedian*19/20);
	seskew = sqrt(cssskew*19/20);
	sekurt = sqrt(csskurt*19/20);
run;

proc print data = last1;
run;
