using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class HistoryView extends Ui.View {

	hidden var histogram;
	hidden var nrOfBins = 10;
	hidden var maxNrOfBins;
		
	function initialize() {	
		if (history != null) { 
			maxNrOfBins = history.getNonZeroRange();
			nrOfBins = 6;
			histogram = new Histogram(history, nrOfBins);
		}
        View.initialize();
    }
    
    function modifyNrOfBins(increase) {
    	var newNrOfBins = nrOfBins + increase;
    	if (1< newNrOfBins && newNrOfBins <= maxNrOfBins) { 
    		self.setNrOfBins(newNrOfBins);
    	}
    }
    
    function setNrOfBins(aNrOfBins) {
    	nrOfBins = aNrOfBins;
    	histogram =  new Histogram(history, nrOfBins);
    	Ui.requestUpdate();
    }
    
    //! Load your resources here
    function onLayout(dc) {
       setLayout(Rez.Layouts.HistoryLayout(dc));
    }

	//! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }
    
    //! Update the view
    function onUpdate(dc) {
    	if(histogram != null) { 
    		//Clear stuff
    		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        	dc.clear();
    		
    		// Here we draw the graph
    		histogram.draw(dc); 
    		if (nrOfBins > 2) {
        		//Draw down arrow
        		self.drawArrow(dc, 109, 213, 5, false);
	        }
	        if (nrOfBins < maxNrOfBins) {
	        	//Draw up arrow
        		self.drawArrow(dc, 109, 5, 5, true);
	        }
    	}
    	// Call the parent onUpdate function to redraw the layout
        else { View.onUpdate(dc); }
    }
    
    function drawArrow(dc, x, y, height, upwards) {
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.setPenWidth(1);
    	dc.drawPoint(x, y);
    	for (var n = 1; n < height; n++) {
    		var nextY = upwards ? y+n : y-n;
    		dc.drawLine(x-n, nextY, x+n, nextY);
    		dc.drawPoint(x+n, nextY);
    	}
    }
    
    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
    
}

class HistoryViewDelegate extends Ui.BehaviorDelegate {

	hidden var callbackView;

	function initialize() {
		BehaviorDelegate.initialize();
	}
	
	function setCallbackView(view) {
    	callbackView = view;
    }
	
	function onMenu() {
		//Push menu to allow clearing the history
		var menu = new Rez.Menus.HistoryMenu();
    	menu.setTitle(Ui.loadResource(Rez.Strings.HistoryMenuTitle));
        Ui.pushView(menu, new HistoryMenuDelegate(), Ui.SLIDE_LEFT);
	   	return true;
    }
    
    function onPreviousPage(){
    	callbackView.modifyNrOfBins(1);
    }
    function onNextPage() {
    	callbackView.modifyNrOfBins(-1);
    }
}

class HistoryMenuDelegate extends Ui.MenuInputDelegate {

	function initialize() {
        MenuInputDelegate.initialize();
    }
    
    function onMenuItem(item) {
        if (item == :item_1) {
        	//Reset history
        	App.getApp().deleteProperty("HR_HISTORY_VERSION");
        	App.getApp().deleteProperty("HR_HISTORY");
        	history = null;
        } 
    }
}