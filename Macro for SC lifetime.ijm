requires("1.49u");
setResult("vesicle number", 0, "vesicle number");
setResult("vesicle type", 0, "vesicle type");
setResult("vesicle duration",0,"vesicle duration");
setResult("Sum ant",0,"Sum ant");
setResult("Sum ret", 0, "Sum ret");
setResult("Sum Stationary",0,"Sum Stationary");
setResult("Sum 15-45s",0,"Sum 15-45s");
setResult("Sum 45-1min",0,"Sum 45-1min");
setResult("Sum 1min-2min",0,"Sum 1min-2min");
setResult("Sum 2min-3min",0,"Sum 2min-3min");
setResult("Sum >45s",0,"Sum >45s");
setResult("Sum >1min",0,"Sum >1min");
setResult("Sum >2min",0,"Sum >2min");
setResult("Sum >3min",0,"Sum >3min");
setResult("SC Lifetime (sec)",0,"SC Lifetime (sec)");
setResult("Total short lived SC",0,"Total short lived SC");
setResult("Total long lived SC",0,"Total long lived SC");
count=roiManager("count");
ret_count=ant_count=stat_count=0;
llsc1_count=llsc2_count=llsc3_count=llsc4_count=slsc1_count=slsc2_count=slsc3_count=slsc4_count=llsct_count=slsct_count=0
//Looping through particles in ROI
llsc=slsc=0;
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
	//direction of vesicle
/*	if(sorted_d[0]>sorted_d[1]){setResult("vesicle type",i+1,"Anterograde");}
	else if(sorted_d[0]<sorted_d[1]){setResult("vesicle type",i+1,"Retrograde");}
	else if(sorted_d[0]==sorted_d[1]){setResult("vesicle type",i+1,"Stationary");} */
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
					setResult("SC Lifetime (sec)",i+1,duration);
					print("particle "+i+1+" t0= "+t[0]+ " tlast= "+t[t.length-1]);
					slsc0=slsc1=slsc2=slsc3=slsc4=llsc0=llsc1=llsc2=llsc3=llsc4=0;
					if(t[0]<3||t[t.length-1]>444){llsc++;
					   if(duration<15){llsc0++;}
					   else if(duration>=15 && duration<=45){llsc1++;}
					   else if(duration>45 && duration<=60){llsc2++;}
					   else if(duration>60 && duration<=120){llsc3++;}
					   else if(duration>120){llsc4++;}}
					else {slsc++;
					    if(duration<15){slsc0++;}
						else if(duration>15 && duration<=45){slsc1++;}
						else if(duration>45 && duration<=60){slsc2++;}
						else if(duration>60 && duration<=120){slsc3++;}
						else if(duration>120){slsc4++;}}}
					   
					

					if(llsc0>0){setResult("vesicle duration",i+1,"Long lived SC(ambiguous)");}
					else if(llsc1>0){print(i+1+" meh");setResult("vesicle duration", i+1, "Long Lived SC(ambiguous)");llsc1_count++;setResult("Sum >45s",1,llsc1_count);llsct_count++;setResult("Total long lived SC",i+1,llsct_count);}
					else if(llsc2>0){print(i+1+" yay");setResult("vesicle duration",i+1,"Long Lived SC(ambiguous)");llsc2_count++;setResult("Sum >1min",1,llsc2_count);llsct_count++;setResult("Total long lived SC",i+1,llsct_count);}
					else if(llsc3>0){print(i+1+" boo");setResult("vesicle duration",i+1,"Long Lived SC(ambiguous)");llsc3_count++;setResult("Sum >2min",1,llsc3_count);llsct_count++;setResult("Total long lived SC",i+1,llsct_count);}
					else if(llsc4>0){print(i+1+" pfft");setResult("vesicle duration",i+1,"Long Lived SC(ambiguous)");llsc4_count++;setResult("Sum >3min",1,llsc4_count);llsct_count++;setResult("Total long lived SC",i+1,llsct_count);}
					else if(slsc0>0){setResult("vesicle duration",i+1,"Short Lived SC");}
					else if(slsc1>0){setResult("vesicle duration",i+1,"Short Lived SC");slsc1_count++;setResult("Sum 15-45s",1,slsc1_count);slsct_count++;setResult("Total short lived SC",i+1,slsct_count);}
					else if(slsc2>0){setResult("vesicle duration",i+1,"Long Lived SC");slsc2_count++;setResult("Sum 45-1min",1,slsc2_count);llsct_count++;setResult("Total long lived SC",i+1,llsct_count);}
					else if(slsc3>0){setResult("vesicle duration",i+1,"Long Lived SC");slsc3_count++;setResult("Sum 1min-2min",1,slsc3_count);llsct_count++;setResult("Total long lived SC",i+1,llsct_count);}
					else if(slsc4>0){setResult("vesicle duration",i+1,"Long Lived SC");slsc4_count++;setResult("Sum 2min-3min",1,slsc4_count);llsct_count++;setResult("Total long lived SC",i+1,llsct_count);}
}