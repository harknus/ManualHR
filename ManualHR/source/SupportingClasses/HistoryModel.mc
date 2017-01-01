using Toybox.Application as App;
using Toybox.System as Sys;

//! Class HistoryModel supports data values for HR between 0 and 220.
class HistoryModel {
	
	const hrHistoryVersion = 1;
	const dataSize = 220;
	hidden var data = new [dataSize];
	
	//! function initialize(inputData, aBinSize) 
	//! Input data is assumed to be an array of yValues
	//! binSize is the number of bins that shoudl be visualized
	function initialize(){
		var dataRead = readDataFromObjectStore();
		if (!dataRead) { // No previous data in storage
			//Initialize data with only zeros
			data = new [dataSize];
			for (var i=0; i < dataSize ; i++) { data[i] = 0; }
		}
	}
	
	//! function getDataRange()
	//! returns an array specifying [minX, maxX, minY, maxY] 
	function getDataRange(){
		var minX =  dataSize/2, maxX = dataSize/2, minY = 10000, maxY = 0;
		var doneMinX = false;
		var doneMaxX = false;
		for (var i=0; i < dataSize ; i++) {
			if (doneMinX == false && data[i] > 0) { minX=i; doneMinX = true; }
			if (doneMaxX == false && data[dataSize-1-i] > 0) { maxX=dataSize-1-i; doneMaxX = true;}
			if (data[i] > maxY) { maxY = data[i]; }
			if (data[i] < minY) { minY = data[i]; }
		}
		return [minX, maxX, minY, maxY];
	}
	
	//! function getDataFor(xValue)
	//! returns the corresponding data for the xValue or null 
	//! if the xValue is not in the data set 
	function getDataFor(xValue){
		if (xValue >= 0 && xValue < dataSize) { return data[xValue]; }
		else { return null; }
	}
	
	// ! Input data is assumed to be an array of xValues
	//hidden function readData(inputData) {
	//	if (inputData != null) {
	//		for (var i = 0; i < inputData.size() ; i++) {
	//			addValueToData(inputData[i].toNumber());
	//		}
	//	}
	//}
	
	function addValueToData(value) {
	//Sys.println("Adding to data storage value: " + value);
		if (0 <= value && value < dataSize) {
			//Sys.println("Data value prior to adding one: " + data[value]);
			data[value] += 1;
		}
	}
	
	function readDataFromObjectStore() {
		//Sys.print("reading data from storage - ");
		//App.getApp().deleteProperty("HR_HISTORY_VERSION");
		var hrHistory = App.getApp().getProperty("HR_HISTORY");
		var hrHistoryVersion = App.getApp().getProperty("HR_HISTORY_VERSION");
		if (hrHistory != null) {
			if ( hrHistoryVersion == null ) {
				//Sys.print(" first version data");
	        	//First version of data storage
	        	var timeHistory = App.getApp().getProperty("TIME_HISTORY");
    			if (timeHistory != null) {
    				//Remove this data - clean up old storage
    				App.getApp().deleteProperty("TIME_HISTORY");
    			}
    			//Init data storage
    			data = new [dataSize];
				for (var i=0; i < dataSize ; i++) { data[i] = 0; }
	        	//Read data
	        	for( var i = 0; i < hrHistory.size(); i++ ) {
	        		addValueToData(hrHistory[i]);
	        	}
	        }
	        else if ( hrHistoryVersion == 1) {
	        	//Sys.print(" new version data");
	        	data = hrHistory;
	        }
	        else {
	        	//Sys.print(" no good version data found");
	        	return false;
	        }
	        return true;
	    }
	    else {
	    	return false;
	    }
	}
	
	function saveDataToObjectStore() {
		App.getApp().setProperty("HR_HISTORY", data);
		App.getApp().setProperty("HR_HISTORY_VERSION", hrHistoryVersion);
	}
	
	function toString() {
		return "HistoryModel(v"+ hrHistoryVersion +"): " + data.toString();
	}
}