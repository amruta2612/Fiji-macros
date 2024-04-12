macro "Segments_branch [q]"{
h= getHeight();
makeRectangle(0,0,30, h);
roiManager("add");
makeRectangle(40,0,8, h);
roiManager("add");
makeRectangle(50,0,30, h);
roiManager("add");
makeRectangle(90,0,77, h);
roiManager("add");
roiManager("select",0);
roiManager("rename", "5um in branch");
roiManager("select",1);
roiManager("rename", "-1um");
roiManager("select",2);
roiManager("rename", "-5um");
roiManager("select",3);
roiManager("rename", "-15um");
roiManager("Deselect");
roiManager("Set Color", "yellow");
roiManager("Set Line Width", 0);
}
