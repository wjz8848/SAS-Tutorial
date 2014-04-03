*** silly golo simulator for bios 531 ***;

data work.sillyGolo;

	array scorecard(18) hole1-hole18;	*sotres results for the 18 holes;
	array dice(9) dice1-dice9;
	seed=12345;

	do iterations = 1 to 1000;	* play game 1000 times;
		do frontback = 0, 1; *frontback (0) = first nine (frontnone), (1) = holes10-18 (backnine);
			rolls = 1;
			
			do while(rolls le 9);	*first roll dice and find min;
				best = 100;	* anything >= 4;
				do die = 1 to 10-rools;	*roll up to 9 dice;
				dice(die) = rantbl(seed, 1/12, 1/4, 1/6, 1/6, 1/4, 1/12) - 2;
					if dice(die) < best then best = dice(die);
			end; * the rolling of dice;

		* now find out how many had the lowest score;
			mincount = 0;
				do die = 1 to 10-rolls;
					if dice(die) = best
						then mincount = mincount + 1;
				end; 
		* now assign rolls+mincount scorecard to be best;

				do i = i to mincount;
					scorecard(rolls + i - 1 + frontback * 9) = best;
					* if frontback = 0 then this is rolls, else rolls + 9;
				end; * update scorecard;

				rolls = rolls + mincount;
		end;

		frontnine = sum( of hole1-hole9);
		backnine = sum( of hole10-hole18);

		score = frontnine + backnine;
		output;
	end;	*games played;

	keep iterations hole1-hole18 frontnine backnine score;
	run;


	proc means data=work.sillyGolo;

	
						


