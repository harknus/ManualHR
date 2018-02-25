using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class ManualHRMenuDelegate extends Ui.MenuInputDelegate {
	
	hidden var callbackView;
	
    function initialize(view) {
        MenuInputDelegate.initialize();
        callbackView = view;
    }

    function onMenuItem(item) {
        if (item == :item_1) {
        	// Show the history as a time series
        	if (history == null) { history = new HistoryModel(); }
        	Ui.pushView(new TimeSeriesView(), new TimeSeriesViewDelegate(), Ui.SLIDE_LEFT);
        } else if (item == :item_2) {
        	//Show the history as histogram
        	if (history == null) { history = new HistoryModel(); }
        	var histogramView = new HistogramView();
        	var histogramViewDelegate = new HistogramViewDelegate();
        	histogramViewDelegate.setCallbackView(histogramView);
        	Ui.pushView(histogramView, histogramViewDelegate, Ui.SLIDE_LEFT);
        } else if (item == :item_3) {
        	//Show selector for the nubmer of heart beats to count
        	var countMenu = new Rez.Menus.NrCountMenu();
        	var title = Ui.loadResource(Rez.Strings.NrCountMenuTitle);
        	countMenu.setTitle(title);
        	Ui.pushView(countMenu, new NrCountMenuDelegate(callbackView), Ui.SLIDE_LEFT);
        } else if (item == :item_4) {
        	//Show instructions
           Ui.pushView(new ManualHRInfoView(callbackView.HB_count), new ManualHRInfoViewDelegate(), Ui.SLIDE_LEFT);
        } else if (item == :about) {
        	Ui.pushView(new AboutView(), new AboutViewDelegate(), Ui.SLIDE_LEFT);
        }
    }
}

class NrCountMenuDelegate extends Ui.MenuInputDelegate {

	hidden var callbackView;

	function initialize(view) {
        MenuInputDelegate.initialize();
        callbackView = view;
    }

    function onMenuItem(item) {
    	var count = null;
    	if (item == :count5) {count = 5;}
    	if (item == :count10) {count = 10;}
    	if (item == :count15) {count = 15;}
    	if (item == :count20) {count = 20;}
    	if (item == :count25) {count = 25;}
    	if (item == :count30) {count = 30;}
    	if (item == :count35) {count = 35;}
    	if (item == :count40) {count = 40;}
    	if (item == :count45) {count = 45;}
    	if (item == :count50) {count = 50;}
    	if (item == :count55) {count = 55;}
    	if (item == :count60) {count = 60;}
    	
    	callbackView.HB_count = 1.0*count;
    	App.getApp().setProperty("NR_BEATS_TO_COUNT", count); 
    	//Sys.println("Setting nr of heartbeats to count to:" + count);
    }
}

