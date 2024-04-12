setResult("total turning",0,"total turning");
setResult("rbp",0,"retro-branch-pause");
setResult("rbs",0,"retro-branch-straight");
setResult("ptb",0,"paused-to-branch");
Dialog.create("Movie settings"); Dialog.addNumber("pixel size(µm)",0.129); 
Dialog.addNumber("frame rate(frames/sec)", 4.9); Dialog.show;
scalex=Dialog.getNumber();
scalet=Dialog.getNumber();
count=roiManager("count");
bound_min=newArray(4);
bound_max=newArray(4);
for(i=0;i<4;i++){
	roiManager("Select",i);
	if((selectionType()==0)) {
		getSelectionCoordinates(a,b);
		bound_min[i]= a[0];
		bound_max[i]=a[2];}
	else{exit("Please input rectangular area");}}
sbound_min=Array.sort(bound_min);
sbound_max=Array.sort(bound_max);
turning=rbp=rbs=ptb=turning_tag=countvel=countRL=countpf=countpd=0; 
for(i=4; i<roiManager("count"); i++){
		roiManager("Select",i);
		if(selectionType==6){
			getSelectionCoordinates(x1,t);}
		else {exit("Only works on segmented lines.");}
		if((x1[x1.length-1]<x1[0] && t[t.length-1]<t[0]) || (x1[x1.length-1]>x1[0] && t[t.length-1]>t[0])){
				x1=Array.sort(x1);
				if((x1[0]<=sbound_max[0])){ //retrograde from branch toward cell body
					if(x1[0]<=sbound_min[0] && sbound_min[1]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[1]) {rbp++; turning_tag=0;}
					else if(x1[0]<=sbound_min[0] && sbound_min[2]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[2]) {rbs++; turning_tag=0;}	
					else if(x1[0]<=sbound_min[0] && sbound_min[3]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[3]) {rbs++; turning_tag=0;}	
					else if(x1[0]<=sbound_min[0] && sbound_max[3]<x1[x1.length-1]) {rbs++; turning_tag=0;}	
     				else if(x1[0]<=sbound_min[0] && x1[x1.length-1]>sbound_max[0] && x1[x1.length-1]<=sbound_min[1]) {rbp++; turning_tag=0;}
     				else if(sbound_min[0]<x1[0] && x1[0]<=sbound_max[0] && sbound_min[1]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[1]) {rbp++; turning_tag=0;}
					else if(sbound_min[0]<x1[0] && x1[0]<=sbound_max[0] && sbound_min[2]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[2]) {rbs++; turning_tag=0;}
					else if(sbound_min[0]<x1[0] && x1[0]<=sbound_max[0] && sbound_min[3]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[3]) {rbs++; turning_tag=0;}
					else if(sbound_min[0]<x1[0] && x1[0]<=sbound_max[0] && sbound_max[3]<x1[x1.length-1]) {rbs++; turning_tag=0;}
					else if(sbound_min[0]<x1[0] && x1[0]<=sbound_max[0] && x1[x1.length-1]>sbound_max[0] && x1[x1.length-1]<=sbound_min[1]) {rbp++; turning_tag=0;}
				}} //closed retrograde selection
		else if((x1[x1.length-1]<x1[0] && t[t.length-1]>t[0])||(x1[x1.length-1]>x1[0] && t[t.length-1]<t[0])){ //anterograde from cb to branch
				x1=Array.sort(x1);
				if(x1[0]<=sbound_min[0]){ //all particles coming into branch beyond 5um
					if(x1[x1.length-1]>sbound_max[3]) {turning++; turning_tag=1;}
					else if(sbound_min[3]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[3]) {turning++; turning_tag=1;}
					else if(sbound_min[2]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[2]) {turning++; turning_tag=1;}
					else if(sbound_min[1]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[1]) {ptb++; turning_tag=0;}
					else if(x1[x1.length-1]<=sbound_min[1] && x1[x1.length-1]>sbound_max[0]) {ptb++; turning_tag=0;}}								
				else if(x1[0]>sbound_min[0] && x1[0]<=sbound_max[0]){ //all particles coming within 5um in branch
					if(x1[x1.length-1]>sbound_max[3]) {turning++; turning_tag=1;}
					else if(sbound_min[3]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[3]) {turning++; turning_tag=1;}
					else if(sbound_min[2]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[2]) {turning++; turning_tag=1;}
					else if(sbound_min[1]<x1[x1.length-1] && x1[x1.length-1]<=sbound_max[1]) {ptb++; turning_tag=0;}
					else if(x1[x1.length-1]<=sbound_min[1] && x1[x1.length-1]>sbound_max[0]) {ptb++; turning_tag=0;}}}//closed anterograde selection	

//edit code from below		
		if(turning_tag==1){
			setResult("turning-segRL",0,"turning-segment run lengths");
			setResult("turning-segvel",0,"turning-segment velocities");
			setResult("turning-pf",0,"turning-pause frequency per distance covered");
			setResult("turning-pd",0,"turning-pause duration per total time");
			roiManager("Select",i);
			getSelectionCoordinates(x1,t);
			x= newArray(x1.length);
   			rank_pos=Array.rankPositions(t);
			rank=Array.rankPositions(rank_pos);
			for(p=0;p<t.length;p++){
				for(q=0;q<t.length;q++){
					if(rank[q]==p){x[p]=x1[q];} else{continue;}}}
  			Array.sort(t);
  			v= newArray(x.length-1); segrl=newArray(0);
   			for(j=0;j<x.length-1;j++){v[j]= scalex*scalet*(x[j+1]-x[j])/(t[j+1]-t[j]);
   				if(v[j]<=-0.16){//only absolute velocity values greater than 0.16 are considered
   					setResult("turning-segvel", countvel+1, abs(v[j])); countvel+=1;}
   				//sum continuous segment RLs
   				if(j==0 && v[j]<=-0.16){segrl=Array.concat(segrl,scalex*(x[j+1]-x[j]));}
   				else if(j>0 && v[j]<=-0.16){
   					if(segrl.length==0){segrl=Array.concat(segrl,scalex*(x[j+1]-x[j]));}
   					else if(segrl.length>0){
   					if(segrl[segrl.length-1]<0 && v[j-1]<=-0.16){segrl[segrl.length-1]+=scalex*(x[j+1]-x[j]);} 
   					else if(segrl[segrl.length-1]<0 && v[j-1]>-0.16){segrl=Array.concat(segrl,scalex*(x[j+1]-x[j]));}}}}
   				//account for pauses- segrl has to break with every pause
   			for(l=0;l<segrl.length;l++){setResult("turning-segRL", countRL+1, abs(segrl[l])); countRL+=1;}

   			//for pause duration and frequency  	
  			v= newArray(x.length-1);
   			for(j=0;j<x.length-1;j++){v[j]= (x[j+1]-x[j])/(t[j+1]-t[j]);}
    		//type of vesicle movement		
			ap_time=0; pd=0; antero_pauses= newArray(0); retro_pauses= newArray(0); counter_pause=0; antero_pausecount=0; retro_pausecount=0;
			for(m=0;m<v.length;m++){
				if(-0.25<v[m] && v[m]<=0){antero_pauses=Array.concat(antero_pauses,m); counter_pause+=1; pd+=abs((t[m+1]-t[m])/scalet);}
				else if(0<v[m] && v[m]<0.25){retro_pauses=Array.concat(retro_pauses,m); counter_pause+=1; pd+=abs((t[m+1]-t[m])/scalet);}		
			}//end of pause counter- for loop
	
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
			total_pausecount= antero_pausecount + retro_pausecount;
			setResult("turning-pf", countpf+1, total_pausecount/(scalex*abs(x[x.length-1]-x[0]))); countpf+=1;
	setResult("turning-pd", countpd+1, abs(pd)*scalet/(t[t.length-1]-t[0])); countpd+=1;}}//close turning tag if condition & pause counter closed
	updateResults();}//closed for loop

setResult("total turning",1, turning);
setResult("rbp",1,rbp);
setResult("rbs",1,rbs);
setResult("ptb",1,ptb);
updateResults();