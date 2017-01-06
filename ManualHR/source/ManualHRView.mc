using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Sensor as Sensor;

class ManualHRView extends Ui.View {
	hidden var saveIcon;
	hidden var repeatIcon;
	hidden var hr_has_connected = false;
	hidden var measuredHRValue = null;
	
	
	var HR_value;
	var HB_count;
	var running;
	var totalTime;
	var duration;
	var shouldShowSaveIcon = false;
	var shouldShowRepeatIcon = false;
	
	
    function initialize() {
        View.initialize();
        saveIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.SaveIcon, :locX=>6, :locY=>100} );
        repeatIcon = new Ui.Bitmap({:rezId=>Rez.Drawables.RepeatIcon, :locX=>10, :locY=>139} );
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout( Rez.Layouts.MainLayout(dc) );
        
        HB_count = App.getApp().getProperty("NR_BEATS_TO_COUNT");
        if (HB_count == null) {HB_count = 10.0;}
        running = false;
    }

	var vibForStartAlert = [new Attention.VibeProfile(10,20),
							new Attention.VibeProfile(100,40),
    				  		new Attention.VibeProfile(10,20),
    				  		new Attention.VibeProfile(0,200),
    				  		new Attention.VibeProfile(10,20),
    				  		new Attention.VibeProfile(100,40),
    				  		new Attention.VibeProfile(10,20)];
    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	Attention.vibrate(vibForStartAlert);
    	Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE] );
        Sensor.enableSensorEvents( method(:onSensor) );
    }

    //! Update the view
    function onUpdate(dc) {
    
    	var label = View.findDrawableById("HR_label");
    	if(null != HR_value) {
    		label.setText(HR_value);
    	}
    	else {
    		label.setText("--- ");
    	}
    	
    	if(null != duration && running == false) {
    		//Display subresults when available
    		var subResultString1 = View.findDrawableById("ResultLabelTimeBetweenBeats_value");
    		subResultString1.setText(duration.format("%.2f"));
    		var subResultString2 = View.findDrawableById("ResultLabelTotalTime_value");
    		subResultString2.setText(totalTime.format("%.2f"));
    	}
    	
    	var label1 = View.findDrawableById("prompt1");
    	var label2 = View.findDrawableById("prompt2");
    	var newTxt1;
    	var newTxt2;
    	if (running == true) {
    	    newTxt1 = Ui.loadResource(Rez.Strings.prompt1Running);
    	    newTxt2 = Ui.loadResource(Rez.Strings.prompt2Running) + HB_count.format("%.0d") + Ui.loadResource(Rez.Strings.prompt2end);
    	}
    	else {
    		newTxt1 = Ui.loadResource(Rez.Strings.prompt1);
    	    newTxt2 = Ui.loadResource(Rez.Strings.prompt2start) + HB_count.format("%.0d") + Ui.loadResource(Rez.Strings.prompt2end);
    	}
    	label1.setText(newTxt1);
    	label2.setText(newTxt2);
    	
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        //Draw the indicator that indicates that the counting is ongoing
        //works only on round displays
    	if (running == true) {
    		var penWidth = 4.0; 
    		var centr = dc.getWidth()/2.0;
    		dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_BLACK);
    		dc.setPenWidth(penWidth);
    		dc.drawCircle(centr, centr, centr - 0.5*penWidth); 
    	}
    	
    	if(shouldShowSaveIcon) { saveIcon.draw(dc); }
    	if(shouldShowRepeatIcon && running == false) { repeatIcon.draw(dc); }
    	
    	if(hr_has_connected) {
    		var x = 184;
    		var y =  62;
    		dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
    		dc.drawText(x, y, Gfx.FONT_XTINY, "Sensor HR: ", Gfx.TEXT_JUSTIFY_RIGHT);
    		if (measuredHRValue != null) {
    			dc.drawText(x+1, y, Gfx.FONT_XTINY, measuredHRValue.format("%.0d") , Gfx.TEXT_JUSTIFY_LEFT);
    		} else {
    			dc.drawText(x+1, y, Gfx.FONT_XTINY, "---", Gfx.TEXT_JUSTIFY_LEFT);
    		}
    	}
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

	hidden var vibForHRconnect = [new Attention.VibeProfile(50,100)];
	//! callback for HR sensor events
	function onSensor(sensorInfo) {
        if (sensorInfo.heartRate != null && !hr_has_connected) {
            if (Attention has :playTone) {
                Attention.playTone(Attention.TONE_KEY);
            }
            Attention.vibrate(vibForHRconnect);
            hr_has_connected = true;
        }
        measuredHRValue = sensorInfo.heartRate;
        Ui.requestUpdate();
    }
}
