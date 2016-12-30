//! Class HistoryModel supports data values for HR between 0 and 220.
class HistoryModel {
	
	const dataSize = 220;
	hidden var data = new [dataSize];
	
	//! function initialize(inputData, aBinSize) 
	//! Input data is assumed to be an array of yValues
	//! binSize is the number of bins that shoudl be visualized
	function initialize(inputData){
		//Initialize data with only zeros
		for (var i=0; i < dataSize ; i++) { data[i] = 0; }
		//add any data that is in the input data
		readData(inputData);
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
	
	//! Input data is assumed to be an array of xValues
	hidden function readData(inputData) {
		if (inputData != null) {
			for (var i = 0; i < inputData.size() ; i++) {
				addValueToData(inputData[i].toNumber());
			}
		}
	}
	
	hidden function addValueToData(value) {
		if (value >= 0 && value < dataSize) {
			data[value] += 1;
		}
	}
}