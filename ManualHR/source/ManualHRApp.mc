using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Tme;

var historyList = null;

class ManualHRApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart(state) {
    	var hrHistory = App.getApp().getProperty("HR_HISTORY");
    	var timeHistory = App.getApp().getProperty("TIME_HISTORY");
        if (hrHistory != null && timeHistory != null) {
        	var sample = new HRData(hrHistory[0], new Tme.Moment(timeHistory[0]));
        	historyList = new LinkedObject(sample);
        	for( var i = 1; i < hrHistory.size(); i++ ) {
        		sample = new HRData(hrHistory[i], new Tme.Moment(timeHistory[i]));
				historyList.addObjectToEndOfList(sample);
			}
			//Sys.println("List size: " + historyList.getSize() + "\n" + historyList + "\n\n");
      	}
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    	if (historyList != null) {
    		//Sys.println("List size: " + historyList.getSize() + "\n" + historyList + "\n\n");
    		
    		//Extract out all of the history to list for persistence
    		var listSize = historyList.getSize();
    		var hrHistory = new [listSize];
    		var timeHistory = new [listSize];
    		
    		var item = historyList;
    		for( var i = 0; i < historyList.getSize(); i++ ) {
    			//Sys.println("i=" + i + " object: " + item.getObject());
    			hrHistory[i] = item.getObject().getHR();
    			timeHistory[i] = item.getObject().getTimeStamp().value();
    			item = item.getNext();
			} 	
   			App.getApp().setProperty("HR_HISTORY", hrHistory);
   			App.getApp().setProperty("TIME_HISTORY", timeHistory);
   		}
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new ManualHRView(), new ManualHRDelegate() ];
    }

}

