using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;

var startTime_ms;
var HR_value;
var HB_count;
var running;


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
    	if(null != HR_value) {
    		var label = View.findDrawableById("HR_label");
    		label.setText(HR_value);
    	}
    	
    	var label1 = View.findDrawableById("prompt1");
    	var label2 = View.findDrawableById("prompt2");
    	var newTxt1;
    	var newTxt2;
    	if (running == true) {
    	    newTxt1 = Ui.loadResource(Rez.Strings.prompt1Running);
    	    newTxt2 = Ui.loadResource(Rez.Strings.prompt2Running);
    	}
    	else {
    		newTxt1 = Ui.loadResource(Rez.Strings.prompt1);
    	    newTxt2 = Ui.loadResource(Rez.Strings.prompt2start) + HB_count.format("%.0d") + Ui.loadResource(Rez.Strings.prompt2end);
    	}
    	label1.setText(newTxt1);
    	label2.setText(newTxt2);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

}
