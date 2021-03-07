setResult("Vesicle No.",0,"Vesicle No.");//vesicle label
setResult("Initial direction",0,"Initial direction");
setResult("No. of antero pauses",0,"No. of antero pauses");
setResult("No. of retro pauses",0,"No. of retro pauses");
setResult("No. of antero pauses per unit time", 0, "No. of antero pauses per unit time");
setResult("No. of retro pauses per unit time", 0, "No. of retro pauses per unit time");
setResult("motion type", 0, "motion type");
setResult("mean rl",0,"mean rl");
setResult("pause duration", 0, "pause duration");

count=roiManager("count");
//looping through particles in ROI Manager

for(i=0;i<count;i++){
	roiManager("Select",i);
	roiManager("Rename",i+1);
	setResult("Vesicle No.",i+1,i+1);
   	getSelectionCoordinates(x1,t);
   	x= newArray(x1.length);
   	indices= newArray(0);

//sort positions according to increasing time
	rank_pos=Array.rankPositions(t);
	rank=Array.rankPositions(rank_pos);
	for(p=0;p<t.length;p++){
		for(q=0;q<t.length;q++){
			if(rank[q]==p){x[p]=x1[q];} else{continue;}}}
  	Array.sort(t);

//initial and net direction of vesicle
	if(x[0]>x[1]){setResult("Initial direction",i+1,"Anterograde");}
	else if(x[0]<x[1]){setResult("Initial direction",i+1,"Retrograde");}
	else if(x[0]==x[1]){setResult("Initial direction",i+1,"Stationary");}
   	
//first differential of position-velocity  	
  	v= newArray(x.length-1);
   	for(j=0;j<x.length-1;j++){v[j]= (x[j+1]-x[j])/(t[j+1]-t[j]);}
    //print("Vesicle "+i+1+ " velocities");
    //Array.print(v);
//type of vesicle movement		
	ap_time=0; pd=0; sm_rl=newArray(0); r_rl= newArray(0); st_rl= newArray(0); antero_pauses= newArray(0); retro_pauses= newArray(0); counter_pause=0; antero_pausecount=0; retro_pausecount=0;
	for(m=0;m<v.length;m++){
		if(-0.25<v[m] && v[m]<=0){antero_pauses=Array.concat(antero_pauses,m); counter_pause+=1; pd+=abs((t[m+1]-t[m])/4.9);}
		else if(0<v[m] && v[m]<0.25){retro_pauses=Array.concat(retro_pauses,m); counter_pause+=1; pd+=abs((t[m+1]-t[m])/4.9);}		
		}//end of pause counter- for loop
	print(i+1+" pause counter= "+counter_pause);
//number and direction of vesicle pauses in trajectory 
	min1=max1=min2=max2=pause_start=pause_end=start=end=0;
	if(counter_pause>0){
		if(antero_pauses.length==1){antero_pausecount=1;}
		else if(antero_pauses.length>1){antero_dif= newArray(antero_pauses.length-1);
			for(y1=0;y1<antero_pauses.length-1;y1++){
				antero_dif[y1]=antero_pauses[y1+1]-antero_pauses[y1];}
				Array.getStatistics(antero_dif, min1, max1, mean1, stdDev1);
				if(max1>1 && antero_dif.length>1){
					for(r=0;r<antero_dif.length-1;r++){
						if(abs(antero_dif[r])>1){antero_pausecount+=1;}}//closing pause counter- pause count is 2 less than actual value
						if(antero_pausecount>0) {antero_pausecount+=2;}} //add 2 to non-zero pause count value to make it accurate
				else if(max1>1 && antero_dif.length==1){antero_pausecount=2;}
				else if(max1==1 || min1==-1){antero_pausecount=1;}}
		setResult("No. of antero pauses", i+1, antero_pausecount);
		if(antero_pausecount>1){
			pause_start=t[antero_pauses[0]];
			pause_end=t[antero_pauses[antero_pauses.length-1]];
			ap_time= (antero_pausecount*4.9)/(pause_end+1-pause_start);
			setResult("No. of antero pauses per unit time",i+1, ap_time);}
		else if(antero_pausecount==1){
			start=t[0];end=t[t.length-1];
			ap_time= (antero_pausecount*4.9)/(end+1-start);
			setResult("No. of antero pauses per unit time",i+1, ap_time);}
		if(retro_pauses.length==1){retro_pausecount=1;}
		else if(retro_pauses.length>1){retro_dif= newArray(retro_pauses.length-1);
			for(y2=0;y2<retro_pauses.length-1;y2++){
				retro_dif[y2]=retro_pauses[y2+1]-retro_pauses[y2];}
				Array.getStatistics(retro_dif, min2, max2, mean2, stdDev2);
				if(max2>1 && retro_dif.length>1){
					for(r=0;r<retro_dif.length-1;r++){
						if(abs(retro_dif[r])>1){retro_pausecount+=1;}}//closing pause counter- pause count is 2 less than actual value
						if (retro_pausecount>0) {retro_pausecount+=2;}} //add 2 to non-zero pause count value to make it accurate
				else if(max1>1 && retro_dif.length==1){retro_pausecount=2;}
				else if(max2==1 || min2==-1){retro_pausecount=1;}}
		setResult("No. of retro pauses", i+1, retro_pausecount);
		if(retro_pausecount>1){
			pause_start=t[retro_pauses[0]];
			pause_end=t[retro_pauses[retro_pauses.length-1]];
			setResult("No. of retro pauses per unit time",i+1, (retro_pausecount*4.9)/(pause_end+1-pause_start));}//if 2 or more pauses, pauses are normalized to time from start of first pause to end of last pause
		else if(retro_pausecount==1){
			start=t[0];end=t[t.length-1];
			setResult("No. of retro pauses per unit time",i+1, (retro_pausecount*4.9)/(end+1-start));}//if only 1 pause, pause is normalized to total vesicle trajectory duration
}
	if(x[0]>x[1] && ap_time<0.15){setResult("motion type",i+1,"SmA");
		for(q=0;q<v.length;q++){
			if(v[q]<-0.25){sm_rl=Array.concat(sm_rl, abs(x[q+1]-x[q]));}}
		Array.getStatistics(sm_rl, min3, max3, mean3, stdDev3);
		setResult("mean rl", i+1, mean3*0.13);
		setResult("pause duration", i+1, abs(pd));	
	}
	else if(x[0]<x[1]){setResult("motion type",i+1,"R");
		for(q=0;q<v.length;q++){
			if(v[q]>0.25){r_rl=Array.concat(r_rl, abs(x[q+1]-x[q]));}}
		Array.getStatistics(r_rl, min4, max4, mean4, stdDev4);
		setResult("mean rl", i+1, mean4*0.13);	
		setResult("pause duration", i+1, abs(pd));
	}
	else if(x[0]>x[1] && ap_time>=0.15){setResult("motion type",i+1,"StA");
		for(q=0;q<v.length;q++){
			if(v[q]<-0.25){st_rl=Array.concat(st_rl, abs(x[q+1]-x[q]));}}
		Array.getStatistics(st_rl, min5, max5, mean5, stdDev5);
		setResult("mean rl", i+1, mean5*0.13);
		setResult("pause duration", i+1, abs(pd));	
	}
	updateResults();
}//end of for loop of vesicles in ROI manager