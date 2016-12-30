using Toybox.System as Sys;
//Setting up linked list to handle history of HR measurements
class LinkedObject {
	hidden var object;
	hidden var next = null;
	
	function initialize(obj) {
		object = obj;
	}
	
	function getObject() {
		return object;
	}
	
	function getNext() {
		return next;
	}
	
	function getSize() {
		if (next == null) { return 1; }
		else { return 1 + next.getSize(); }
	}
	
	function getLast() {
		if (next == null) { return self; }
		else { return next.getLast(); }
	}
	
	function addObjectToEndOfList(obj) {
		if (next == null) { next = new LinkedObject(obj); }
		else { next.addObjectToEndOfList(obj); }
	}
	
	function toArray() {
		var listSize = getSize();
		var array = new [listSize];
		addSelfToArray(array, 0);
		return array;
	}
	
	hidden function addSelfToArray(array,idx) {
		array[idx] = object.getValue();
		if (next != null) { next.addSelfToArray(array, idx+1); }
	}
	
	function toString() {
		if (next == null) { return object.toString(); }
		else { return object.toString() + "\n" +  next.toString(); }
	}
	
	//! deleteList() - most likely an unnecessary 
	//! function since the reference counting takes care of this.
	//! clears up the memory of the part of the list that is later
	//! than the initiator object of the call using reference  
	//! counting, the initiator of the call will be
	//! deleted as soon as the final pointer is dropped.
	function deleteList() {
		if (next == null) { return; }
		else { next = null; return; }
	}
}

class HRData {
	hidden var HR;		   //The numeric HR vallue
	hidden var timeStamp;  //Moment of the HR
	
	function initialize(aHR, aTimeStamp) {
		HR = aHR;
		timeStamp = aTimeStamp;
	}
	
	function getValue() { return HR; }
	function getHR() { return HR; }
	function getTimeStamp() { return timeStamp; }
	
	function toString() {
		return "Time: " + timeStamp.toString() + ", HR: " + HR.toString(); 
	}
}