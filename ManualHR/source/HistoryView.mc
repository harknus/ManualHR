using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;


class HistoryView extends Ui.View {

	hidden var histogram;
	hidden var nrOfBins = 5;
	function initialize() {
		
		if (history != null) { 
			histogram = new Histogram(history, nrOfBins);
		}
        View.initialize();
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
    	// Here we draw the graph
    	if(histogram != null) { histogram.draw(dc); }
    	// Call the parent onUpdate function to redraw the layout
        else { View.onUpdate(dc); }
    }
    
    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
    
}

class HistoryViewDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		BehaviorDelegate.initialize();
	}
	 
	function onMenu() {
		//Push menu to allow clearing the history
		var menu = new Rez.Menus.HistoryMenu();
    	menu.setTitle(Ui.loadResource(Rez.Strings.HistoryMenuTitle));
        Ui.pushView(menu, new HistoryMenuDelegate(), Ui.SLIDE_LEFT);
	   	return true;
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
        	
        } else if (item == :item_2) {
        	//Select bin count
        	
        } 
    }
}