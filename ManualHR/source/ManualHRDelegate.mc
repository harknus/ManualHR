using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Tme;
using Toybox.Application as App;

class ManualHRDelegate extends Ui.BehaviorDelegate {
    
    hidden var timer;
    hidden var vibrationCount = 0;
    hidden const maxNrVibrations = 10;
    hidden var durationPerBeat;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    	var menu = new Rez.Menus.MainMenu();
    	menu.setTitle(Ui.loadResource(Rez.Strings.MainMenuTitle));
        Ui.pushView(menu, new ManualHRMenuDelegate(), Ui.SLIDE_LEFT);
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
    	if (running == false){
    		if (timer != null) {
    			resetTimer();
    		}
    		running = true;
    		HR_value = null;
    		startTime_ms = Sys.getTimer();
    		Ui.requestUpdate();
    	}
    	else {
    		//Stop the counting
    		running = false;
    		var stopTime_ms = Sys.getTimer();
    		var duration_ms = stopTime_ms - startTime_ms;
    		//Sys.println("Duration = " + duration_ms); 
  			totalTime = duration_ms/1000.0;
  
    		durationPerBeat = duration_ms/HB_count;
    		duration = durationPerBeat/1000.0;
    		//Sys.println("Duration / beat [ms]: " + durationPerBeat);
    		if (durationPerBeat == 0) { HR_value = "infinite bpm";}
    		else {
    			var result = 60000.0/durationPerBeat;
    			HR_value  = result.format("%.0f");
    			//Sys.println("HR estimate: " + result.format("%.4f"));
    			var sample = new HRData(result, Tme.now());
    			if (historyList == null) { historyList = new LinkedObject(sample); }
    			else { historyList.addObjectToEndOfList(sample); }
    			//Sys.println("List size: " + historyList.getSize()+ "\n" + historyList + "\n\n");
			}
			
			//Start vibration if interval is large enough
			if (durationPerBeat > 50){
				timer = new Timer.Timer();
				timer.start(method(:onTimer), durationPerBeat, true);
			}
    		Ui.requestUpdate();
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