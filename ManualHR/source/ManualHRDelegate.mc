using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Tme;
using Toybox.Application as App;

class ManualHRDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
    	var menu = new Rez.Menus.MainMenu();
    	menu.setTitle(Ui.loadResource(Rez.Strings.MainMenuTitle));
        Ui.pushView(menu, new ManualHRMenuDelegate(), Ui.SLIDE_LEFT);
        return true;
    }

    function onSelect(){
    	//Start the timer at this press
    	Sys.println("Start button pressed");
    	if (running == false){
    		running = true;
    		startTime_ms = Sys.getTimer();
    		//startTime = clockTimeToSeconds(Sys.getClockTime());
    		//Sys.println("Start time [s]:" + startTime + "Millis: " + millis.format("%.2f"));
    		HR_value = "Count " + HB_count.format("%.0d") + " beats";
    		Ui.requestUpdate();
    	}
    	else {
    		running = false;
    		var stopTime_ms = Sys.getTimer();
    		//var stopTime = clockTimeToSeconds(Sys.getClockTime());
    		//The stopTime has hour, min, sec as accessable ivars
    		//Sys.println("Stop time [s]:" + stopTime + "Millis: " + millis.format("%.2f"));
    		var duration_ms = stopTime_ms - startTime_ms;
    		Sys.println("Duration = " + duration_ms); 
  
    		var durationPerBeat = duration_ms/HB_count;
    		Sys.println("Duration / beat [ms]: " + durationPerBeat);
    		if (durationPerBeat == 0) { HR_value = "infinite bpm";}
    		else {
    			var result = 60000.0/durationPerBeat;
    			HR_value  = result.format("%.0f") + " bpm";
    			Sys.println("HR estimate: " + result.format("%.4f"));
			}
			
    		Ui.requestUpdate();
    	}
    	return true;
    }
    
  // function clockTimeToSeconds(time) {
  //  	return (time.sec + 60.0*time.min + 360.0*time.hour);
  //  }
    

}