using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Tme;
using Toybox.Application as App;

class ManualHRDelegate extends Ui.BehaviorDelegate {
    
    hidden var callbackView;
    
    hidden var timer;
    hidden var vibrationCount = 0;
    hidden const maxNrVibrations = 10;
    hidden var durationPerBeat;
    hidden var result;
    hidden var startTime_ms;

    function initialize(view) {
    	callbackView = view;
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    	var menu = new Rez.Menus.MainMenu();
    	menu.setTitle(Ui.loadResource(Rez.Strings.MainMenuTitle));
        Ui.pushView(menu, new ManualHRMenuDelegate(callbackView), Ui.SLIDE_LEFT);
        return true;
    }

	//Resets the timer
	hidden function resetTimer() {
		timer.stop();
    	vibrationCount = 0;
	}

	function onBack() {
		if (timer != null) { resetTimer(); }
		false;
	}
	
    function onSelect(){
    	//Start the timer at this press
    	if (callbackView.running == false){
    		if (timer != null) {
    			resetTimer();
    		}
    		callbackView.running = true;
    		callbackView.HR_value = null;
    		callbackView.shouldShowSaveIcon = false;
    		startTime_ms = Sys.getTimer();
    		Ui.requestUpdate();
    	}
    	else {
    		//Stop the counting
    		callbackView.running = false;
    		var stopTime_ms = Sys.getTimer();
    		var duration_ms = stopTime_ms - startTime_ms;
    		//Sys.println("Duration = " + duration_ms); 
  			callbackView.totalTime = duration_ms/1000.0;
  
    		durationPerBeat = duration_ms/callbackView.HB_count;
    		callbackView.duration = durationPerBeat/1000.0;
    		//Sys.println("Duration / beat [ms]: " + durationPerBeat);
    		if (durationPerBeat == 0) { callbackView.HR_value = "inf";}
    		else {
    			result = 60000.0/durationPerBeat;
    			callbackView.HR_value  = result.format("%.0f");
    			
    			//Only allow saving if the value is less than 220
    			if (result < 220) { callbackView.shouldShowSaveIcon = true; }
   			}
			
			//Start vibration if interval is large enough
			if (durationPerBeat > 50){
				timer = new Timer.Timer();
				timer.start(method(:onTimer), durationPerBeat, true);
				callbackView.shouldShowRepeatIcon = true;
			}
    		Ui.requestUpdate();
    	}
    	return true;
    }
   
   	var vibForSave = [new Attention.VibeProfile(50,100)];
    
    function onPreviousPage() {
    	if (result != null && callbackView.shouldShowSaveIcon) { //Result is set only after first measurmement
	    	resetTimer();
	    	//Sys.println("HR estimate: " + result.format("%.4f"));
	    	if (history == null) { history = new HistoryModel(); }
	    	history.addValueToData(result.toNumber());
	    	//Sys.println(history);
	    	result = null; //Prevent saving again
	    	callbackView.shouldShowSaveIcon = false;
	    	Ui.requestUpdate();
	    	Attention.vibrate(vibForSave);
		}
    	return true;
    }
    
    function onNextPage() {
   		if (timer != null) {
   			resetTimer();
   			timer.start(method(:onTimer), durationPerBeat, true);
   		}
   		return true;
    }
    
    var vibrationProfile = [new Attention.VibeProfile(10,20),
    						new Attention.VibeProfile(25,50),
    						new Attention.VibeProfile(10,20)];
    						
    function onTimer() {
    	Attention.vibrate(vibrationProfile);
    	vibrationCount = vibrationCount + 1;
    	if (vibrationCount >= maxNrVibrations) {
    		resetTimer();
    	}
    }
}