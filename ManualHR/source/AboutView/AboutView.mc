using Toybox.WatchUi as Ui;

//! View to show centered text, useful for showing app info
class AboutView extends Ui.View {

	function initialize() {
        View.initialize();
    }
    
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.AboutViewLayout(dc));
    }

	//! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }
    
    //! Update the view
    function onUpdate(dc) {	
       	// Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }
    
    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
    
}

class AboutViewDelegate extends Ui.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
}
