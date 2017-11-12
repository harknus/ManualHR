using Toybox.Application as App;
using Toybox.System as Sys;

//! Class HistoryModel supports data values for HR between 0 and 220.
class HistoryModel {
	
	const hrHistoryVersion = 2;
	const dataSize = 220;
	hidden var data = new [dataSize];
	hidden var dataRange;
	hidden var hasData;
	
	const nrTimeSamples = 11;
	hidden var timeSamples = new [nrTimeSamples]; 
	hidden var startIdxOfTimeSamples = 0;
	
	//! function initialize(inputData, aBinSize) 
	//! Input data is assumed to be an array of yValues
	//! binSize is the number of bins that shoudl be visualized
	function initialize(){
		var dataRead = readDataFromObjectStore();
		if (!dataRead) { // No previous data in storage
			//Initialize data with only zeros
			hasData = false;
			data = new [dataSize];
			for (var i=0; i < dataSize ; i++) { data[i] = 0; }
			
			initTimeSamples();
			
		}
		else { hasData = true; }
	}
	
	hidden function initTimeSamples() {
			timeSamples = new [nrTimeSamples];
			for (var i=0; i < nrTimeSamples; i++) { timeSamples[i] = 0;}
			startIdxOfTimeSamples = 0;
	}
	
	function getHasData() {
		return self.hasData;
	}
	
	//! function getDataRange()
	//! returns an array specifying [minX, maxX, minY, maxY] for the histogram
	function getDataRange(){
		if(dataRange != null) { return dataRange; }
	
		var minX =  dataSize/2, maxX = dataSize/2, minY = 10000, maxY = 0;
		var doneMinX = false;
		var doneMaxX = false;
		for (var i=0; i < dataSize ; i++) {
			if (doneMinX == false && data[i] > 0) { minX=i; doneMinX = true; }
			if (doneMaxX == false && data[dataSize-1-i] > 0) { maxX=dataSize-1-i; doneMaxX = true;}
			if (data[i] > maxY) { maxY = data[i]; }
			if (data[i] < minY) { minY = data[i]; }
		}
		dataRange = [minX, maxX, minY, maxY];
		return [minX, maxX, minY, maxY];
	}
	
	//! function getNonZeroRange()
	function getNonZeroRange() {
		var retArray = self.getDataRange();
		return retArray[1] - retArray[0];
	}
	
	//! function getDataFor(xValue)
	//! returns the corresponding data for the xValue or null 
	//! if the xValue is not in the data set null is returned
	function getDataFor(xValue){
		if (xValue >= 0 && xValue < dataSize) { return data[xValue]; }
		else { return null; }
	}
	
	//! function getTotalNumberOfSamples()
	//! returns the total number of samples in the history
	function getTotalNumberOfSamples() {
		var retval = 0;
		for (var i=0; i < dataSize ; i++) {
			retval += data[i];
		}
		return retval;
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
			dataRange = null;
			//Sys.println("Data value prior to adding one: " + data[value]);
			data[value] += 1;
			hasData = true;
		}
		// Add value to the time history
		timeSamples[startIdxOfTimeSamples] = value;
		startIdxOfTimeSamples = (startIdxOfTimeSamples +1) % nrTimeSamples;
		//Sys.println("StartIdxOfTimeHistory: " + startIdxOfTimeSamples + "\nTime history: " + timeSamples);
		
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
	        	var timeHist = App.getApp().getProperty("TIME_HISTORY");
    			if (timeHist != null) {
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
	        else if ( hrHistoryVersion == 1 ) {
	        	//Sys.print(" new version data");
	        	data = hrHistory;
	        	initTimeSamples();
	        } 
	        else if ( hrHistoryVersion == 2 ) {
	        	data = hrHistory;
	        	var timeSampl = App.getApp().getProperty("HR_TIME_SAMPLES");
	        	if (timeSampl != null) {
	        		timeSamples = timeSampl;
	        	}
	        	else { initTimeSamples(); }
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
	
	//! function getTimeSamples()
	//! Returns the sorted the HR time samples so that the oldest value 
	//! is in the 0 position in the array when saving and showing visually
	function getTimeSamples() {
		var retvar = new [nrTimeSamples];
		for (var i=0; i <nrTimeSamples; i++) {
			retvar[i] = timeSamples[(startIdxOfTimeSamples + i) % nrTimeSamples];
		}
		return retvar;
	}
	
	function saveDataToObjectStore() {
		App.getApp().setProperty("HR_HISTORY", data);
		App.getApp().setProperty("HR_TIME_SAMPLES", getTimeSamples());
		App.getApp().setProperty("HR_HISTORY_VERSION", hrHistoryVersion);
	}
	
	function clearHistoryInObjectStore() {
		App.getApp().deleteProperty("HR_HISTORY_VERSION");
       	App.getApp().deleteProperty("HR_HISTORY");
       	App.getApp().deleteProperty("HR_TIME_SAMPLES");
	}
	
	function toString() {
		return "HistoryModel(v"+ hrHistoryVersion +"): " + data.toString();
	}
}