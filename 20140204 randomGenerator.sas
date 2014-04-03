* simple uniform random # generator;
* n = 30 #s using 79 as the seed, p1 = 263, p2 = 71, N =100;

data new;
	seed =79; p1 = 263; p2 = 71; N =100;

	do i = 1 to 30;
		x = p1*seed + p2;
		seed= mod(x,n);
		uni = seed/n;
		output;
	end;

run;

proc print;
run;
