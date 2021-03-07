requires("1.49u");
setResult("vesicle number", 0, "vesicle number");
setResult("vesicle type", 0, "vesicle type");
setResult("Sum ant",0,"Sum ant");
setResult("Sum ret", 0, "Sum ret");
setResult("Sum Stationary",0,"Sum Stationary");
setResult("SC Lifetime (sec)",0,"SC Lifetime (sec)");
count=roiManager("count");
ret_count=ant_count=stat_count=0;
//Looping through particles in ROI
for(i=0;i<count;i++){
	roiManager("Select", i);
	roiManager("Rename", i+1);
	setResult("vesicle number", i+1, i+1);
  	run("Interpolate","interval=0.8");
	getSelectionCoordinates(d, t);
	//sort positions according to increasing time (to avoid differences in marking of ROI)
	//followed by sorting distance,i.e., it changes after sorting of time independently
	sorted_d= newArray(d.length);
	position_sorting_time=Array.rankPositions(t);
	rank=Array.rankPositions(position_sorting_time);
	for(k=0;k<t.length;k++){
		for(p=0;p<t.length;p++){
			if(rank[p]==k){sorted_d[k]=d[p];} else{continue;}}}
	Array.sort(t);
	duration=0;
	v= newArray(d.length-1);
	for(x=0;x<v.length;x++){
		v[x]= (sorted_d[x+1]-sorted_d[x])/(t[x+1]-t[x]);	
		}
	ret=ant=stat=neutral=0;	
	if(v[0]<-0.25){ant++;}
	else if(v[0]>0.25){ret++;}
	else if(v[0]>=-0.25 && v[0]<=0.25){
		neutral++;
		for(z=1;z<v.length;z++){
			if(v[z]<-0.25){ant++;z=v.length+10;}
			else if(v[z]>0.25){ret++;z=v.length+10;}
			else if(v[z]>=-0.25 && v[z]<=0.25){stat++;}
		}}
	if(ant>0){setResult("vesicle type", i+1, "Anterograde");ant_count++;setResult("Sum ant",1,ant_count);}
	else if(ret>0){setResult("vesicle type", i+1, "Retrograde");ret_count++;setResult("Sum ret",1,ret_count);}
	else if(stat==v.length-1){setResult("vesicle type", i+1, "Stationary");stat_count++;setResult("Sum Stationary",1,stat_count);
					duration=(t[t.length-1]-t[0])/4.9;
					setResult("SC Lifetime (sec)",i+1,duration);}		
	
	}//for loop for roi particles