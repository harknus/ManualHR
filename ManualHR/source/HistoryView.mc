using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Time as Tme;

class HistoryView extends Ui.View {

	hidden var histogram;
	hidden var nrOfBins = 10;
	hidden var maxNrOfBins;
	hidden var userGender;
	hidden var userAge;
	
	hidden var menuIcon; 
	
	function initialize() {	
		if (history != null && history.getHasData()) { 
			maxNrOfBins = history.getNonZeroRange();
			maxNrOfBins = (maxNrOfBins==0)? 1 : maxNrOfBins; //maxNrOfBins may never be zero
			nrOfBins = maxNrOfBins;
			
			var profile = UserProfile.getProfile(); 
			userGender = profile.gender;
			var now = Tme.Gregorian.info(Tme.today(), Tme.FORMAT_SHORT);
			userAge = now.year - profile.birthYear;
			
			//Sys.println("gender: " + userGender + " age: " + userAge);
			
			histogram = new Histogram(history, nrOfBins, userGender, userAge);
		}
        View.initialize();
    }
    
    //! function resetHistory()
    //! resets the history and clears the histogram
    function resetHistory() {
    	App.getApp().deleteProperty("HR_HISTORY_VERSION");
       	App.getApp().deleteProperty("HR_HISTORY");
       	history = null;
    	histogram = null;
    }
    
    function getMaxNrOfBins() {
    	return maxNrOfBins;
    }
    
    function modifyNrOfBins(increase) {
    	var newNrOfBins = nrOfBins + increase;
    	self.setNrOfBins(newNrOfBins);
    }
    
    function setNrOfBins(newNrOfBins) {
    	
    	if (histogram == null) { return; }
    	
    	//Sanity check of number of bins that is set
    	if (newNrOfBins < 1) { newNrOfBins = 1; }
    	if (maxNrOfBins < newNrOfBins) { newNrOfBins = maxNrOfBins; }
    	
    	self.nrOfBins = newNrOfBins;
    	
    	histogram =  new Histogram(history, nrOfBins, userGender, userAge);
    	
    	Ui.requestUpdate();
    }
    
    //! Load your resources here
    function onLayout(dc) {
       setLayout(Rez.Layouts.HistoryLayout(dc));
       menuIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.MenuIcon, :locX=>6, :locY=>100} );
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
    		
    		if (nrOfBins > 1) {
        		//Draw down arrow
        		self.drawArrow(dc, 109, 213, 5, false);
	        }
	        if (nrOfBins < maxNrOfBins) {
	        	//Draw up arrow
        		self.drawArrow(dc, 109, 5, 5, true);
	        }
	        
	        //Draw the menu icon
	        menuIcon.draw(dc); 
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
		if (history != null) {
			//Push menu to allow clearing the history
			var menu = new Rez.Menus.HistoryMenu();
	    	menu.setTitle(Ui.loadResource(Rez.Strings.HistoryMenuTitle));
	        Ui.pushView(menu, new HistoryMenuDelegate(callbackView), Ui.SLIDE_LEFT);
		   	return true;
	   	}
	   	else {
	   		return false;
	   	}
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
        	//Reset history, with intitial query
        	var dialogueView = new Ui.Confirmation("Clear all history?");
        	var dialogueDelegate = new ClearHistoryDialogueDelegate(callbackView);
        	Ui.pushView(dialogueView, dialogueDelegate, Ui.SLIDE_LEFT);
        } 
    }
}

class ClearHistoryDialogueDelegate extends Ui.ConfirmationDelegate {
	hidden var callbackView;
	function initialize(view) {
        ConfirmationDelegate.initialize();
        callbackView = view;
    }
    function onResponse(response) {
	    if (response == Ui.CONFIRM_YES) {
	    	callbackView.resetHistory();
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
    }
}