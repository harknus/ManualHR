using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;


class HistoryView extends Ui.View {

	hidden var histogram;
	hidden var nrOfBins = 5;
	function initialize() {
		
		if (historyList != null) { 
			var historyModel = new HistoryModel(historyList.toArray());
			histogram = new Histogram(historyModel, nrOfBins);
		}
        View.initialize();
    }
    
    //! Load your resources here
    function onLayout(dc) {
       //setLayout(Rez.Layouts.InfoLayout(dc));
    }

	//! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }
    
    //! Update the view
    function onUpdate(dc) {
    	// Here we draw the graph
    	histogram.draw(dc);
    	
    	// Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
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
	 
	function onNextPage() {
	   	return false;
    }
}