%macro rng(seed, p1, p2, n);

data new;
	seed = &seed;
	p1 = &p1;
	p2 = &p2;
	n = &n;

	do i=1 to 30;
		x = p1 * seed + p2;
		seed = mod(x,n);
		uni = seed/n;
		output;
	end;

proc print;
	title "seed = &seed, p1 = &p1, p2 = &p2, n =&n";
run;

%mend;

%rng(77, 261, 19, 23);

*p1 is set to be 397204094;
*p2 is set to be 0, and this is called linear modulation?;

%rng(1, 397204094, 0, (2**31-1))


