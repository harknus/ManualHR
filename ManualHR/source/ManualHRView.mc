using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

var startTime_ms;
var HR_value;
var HB_count;
var running;
var totalTime;
var duration;


class ManualHRView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        
        HB_count = App.getApp().getProperty("NR_BEATS_TO_COUNT");
        if (HB_count == null) {HB_count = 10.0;}
        
        running = false;
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    
    	var label = View.findDrawableById("HR_label");
    	if(null != HR_value) {
    		label.setText(HR_value);
    		//var bpmLabel = View.findDrawableById("bpmLabel");
    		//if (running == true) {
    		//	bpmLabel.setText("beats to count");
			//} else {
			//	bpmLabel.setText("bpm");
			//}
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
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

}
