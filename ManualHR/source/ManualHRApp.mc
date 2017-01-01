using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Tme;

var history = null; //This will be a global HistoryModel  

class ManualHRApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    function onStart(state) {
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    	if (history != null) {
    		history.saveDataToObjectStore();
   		}
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new ManualHRView(), new ManualHRDelegate() ];
    }

}

