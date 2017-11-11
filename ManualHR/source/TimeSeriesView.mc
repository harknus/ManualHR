using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;


class TimeSeriesView extends Ui.View {
	hidden var data = null;
	hidden var nrSamples;
	
	hidden const line_color = Gfx.COLOR_WHITE;
	hidden const text_color = Gfx.COLOR_WHITE; 
	hidden const bg_color = Gfx.COLOR_BLACK;
	
	function initialize() {	
		if (history != null && history.getHasData()) { 
			data = history.getTimeSamples();
			nrSamples = data.size(); 
		}
        View.initialize();
    }
    
    //! Load your resources here
    function onLayout(dc) {
    	// If no data is available then show the same error message as 
    	// for the histogram.
    	setLayout(Rez.Layouts.HistoryLayout(dc));
    }
    
    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }
    
    //! Update the view
    function onUpdate(dc) {
    	if(data != null) {
	    	//Clear stuff
    		dc.setColor(text_color, bg_color);
        	dc.clear();
        	
        	// draw the graph
        	dc.setPenWidth(1);
		
			//Parameters for Fenix3
			var x1 = 25;
			var y1 = 70;
			var x2 = 195;
			var y2 = 160;
        	
        	dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
			text(dc, 109, 40, Gfx.FONT_TINY, "Latest HR measurements");
			
			//Draw the axes
			dc.setColor(line_color, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(x1,y1,x2,y1); dc.drawPoint(x2,y1);
        	dc.drawLine(x1,y2,x2,y2); dc.drawPoint(x2,y2);
        	dc.drawLine(x1, y2, x2, y2); 
        	
    	}
    	// Call the parent onUpdate function to redraw the layout
        else { View.onUpdate(dc); }
    }
    hidden function text(dc, x, y, font, s) {
        dc.drawText(x, y, font, s,
                    Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
}
class TimeSeriesViewDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		BehaviorDelegate.initialize();
	}
}