using Toybox.WatchUi as Ui;
using Toybox.Application as App;


class ManualHRInfoView extends Ui.View {

	function initialize() {
        View.initialize();
    }
    
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.InfoLayout(dc));
    }

	//! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }
    
    //! Update the view
    function onUpdate(dc) {
    	
    	var countLessOneLabel =  View.findDrawableById("infoCountLessOne");
    	var countLabel = View.findDrawableById("infoCount");
    	
    	countLessOneLabel.setText((HB_count-1).format("%.0d"));
    	countLabel.setText(HB_count.format("%.0d"));
    	
    	
    	// Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }
    
    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
    
}