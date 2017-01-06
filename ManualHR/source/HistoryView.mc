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
			nrOfBins = (maxNrOfBins==0)? 1 : maxNrOfBins;
			histogram = new Histogram(history, nrOfBins);
		}
        View.initialize();
    }
    
    function getMaxNrOfBins() {
    	return maxNrOfBins;
    }
    
    function modifyNrOfBins(increase) {
    	var newNrOfBins = nrOfBins + increase;
    	self.setNrOfBins(newNrOfBins);
    }
    
    function setNrOfBins(newNrOfBins) {
    	
    	//Sanity check of number of bins that is set
    	if (1 >= newNrOfBins) { newNrOfBins = 2; }
    	if (maxNrOfBins < newNrOfBins) { newNrOfBins = maxNrOfBins; }
    	
    	self.nrOfBins = newNrOfBins;
    	
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
    		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
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
        Ui.pushView(menu, new HistoryMenuDelegate(callbackView), Ui.SLIDE_LEFT);
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

	hidden var callbackView;
	
	function initialize(view) {
		//Sys.println("init HistoryMenuDelegate with callbackview:" + view);
        MenuInputDelegate.initialize();
        callbackView = view;
    }
    
    function onMenuItem(item) {
    	//Sys.println("Item selected: " + item);
        if (item == :SetNumberOfBins) {
            //Sys.println("Pushing Number Picker");
        	Ui.pushView(new MyNumberPicker(callbackView.getMaxNrOfBins()), 
        				new MyNumberPickerDelegate(callbackView), 
        				Ui.SLIDE_LEFT);
        }
        else if (item == :ClearHistory) {
        	//Reset history
        	App.getApp().deleteProperty("HR_HISTORY_VERSION");
        	App.getApp().deleteProperty("HR_HISTORY");
        	history = null;
        } 
    }
}

class MyNumberPicker extends Ui.Picker {
	hidden var entalFactory;
	hidden var tiotalFactory;
	hidden var hundratalFactory;
	hidden var maxNrOfBins;
	
	function initialize(aMaxNrBins) {
		maxNrOfBins = aMaxNrBins;
		var title = new Ui.Text({:text=>Rez.Strings.NumberPickerTitle, 
        						 :locX =>Ui.LAYOUT_HALIGN_CENTER, 
        						 :locY=>Ui.LAYOUT_VALIGN_BOTTOM, 
        						 :color=>Gfx.COLOR_WHITE});
        var factories;
        if (aMaxNrBins > 99) {
        	hundratalFactory = new NumberFactory( 0, aMaxNrBins/100, 1, {:font=>Gfx.FONT_NUMBER_HOT});
        	tiotalFactory = new NumberFactory( 0, 9, 1, {:font=>Gfx.FONT_NUMBER_HOT});
        	entalFactory = new NumberFactory(0, 9, 1, {:font=>Gfx.FONT_NUMBER_HOT});
        	factories = [hundratalFactory, tiotalFactory, entalFactory];
        } 
        if (aMaxNrBins > 9) {
        	tiotalFactory = new NumberFactory( 0, aMaxNrBins/10, 1, {:font=>Gfx.FONT_NUMBER_HOT, :format=>"%.0d"});
        	entalFactory = new NumberFactory(0, 9, 1, {:font=>Gfx.FONT_NUMBER_HOT, :format=>"%.0d"});
        	factories = [tiotalFactory, entalFactory];
        }
        else {
        	entalFactory = new NumberFactory(2, aMaxNrBins, 1, {:font=>Gfx.FONT_NUMBER_HOT, :format=>"%.0d"});
        	factories = [entalFactory];
        }
        
        Picker.initialize({:title=>title, :pattern=>factories});
    }
    
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
       
        Picker.onUpdate(dc);
    }
}

class MyNumberPickerDelegate extends Ui.PickerDelegate {
	hidden var callbackView;
	
	function initialize(view) {
		//Sys.println("MyNumberPickerDelegate with callbackView:" + view);
		callbackView = view;
		PickerDelegate.initialize();
	}

    function onCancel() {
        Ui.popView(Ui.SLIDE_RIGHT);
    }

    function onAccept(values) {
    	var nrOfBins;
        if      (values.size() == 3) { nrOfBins = 100*values[0] + 10*values[1] + values[2]; }
        else if (values.size() == 2) { nrOfBins = 10*values[0] + values[1]; }
        else { nrOfBins = values[0]; }
        
        callbackView.setNrOfBins(nrOfBins);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}