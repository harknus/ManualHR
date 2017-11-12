using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;


class TimeSeriesView extends Ui.View {
	hidden var data = null;
	hidden var nrSamples;
	
	hidden const line_color = Gfx.COLOR_WHITE;
	hidden const text_color = Gfx.COLOR_WHITE;
	hidden const sample_color = Gfx.COLOR_RED;
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
			var x1 = 15; // 25
			var y1 = 70;
			var x2 = 195;
			var y2 = 160;
        	
        	dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
			text(dc, 109, 30, Gfx.FONT_TINY, "Latest " + (nrSamples-1));
			text(dc, 109, 50, Gfx.FONT_TINY, "HR measurements");
			
			//Draw the axes
			//dc.setColor(line_color, Gfx.COLOR_TRANSPARENT);
        	//dc.drawLine(x1,y1,x1,y2); dc.drawPoint(x1,y2);
        	//dc.drawLine(x1,y2+5,x2,y2+5); dc.drawPoint(x2,y2+5);
        	//dc.drawLine(x2, y1, x2, y2); 
        	
        	//draw the data
        	var xOffsetL = 0;
        	var xStep = (x2-x1-2*xOffsetL) / (nrSamples+1);
        	var recidue = (x2-x1-2*xOffsetL) % (nrSamples+1);
			xOffsetL = (2*xOffsetL + recidue)/2;
			var xOffsetR = (2*xOffsetL + recidue) % 2 == 0 ? xOffsetL : xOffsetL+1;
			
			var yOffset = 3;
			var minDataValue = getMinValue();
			var yRange = getMaxValue() - minDataValue;
			var yScale = (yRange == 0)? 1 : (y2-y1-yOffset)/yRange; 
		
			for (var i=0; i<nrSamples ; i++) {
				var x = x1 + xStep*(i+1) + xOffsetL;
				var y = y2 - (data[i]- minDataValue)*yScale - yOffset;
				
				//Draw lines between points
				if (i<nrSamples-1) {
					if (i==0) { dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);}
					else      { dc.setColor(line_color, Gfx.COLOR_TRANSPARENT);}
					var xNxt = x1 + xStep*(i+2) + xOffsetL;
					var yNxt = y2 - (data[i+1] - minDataValue)*yScale - yOffset;
	        		dc.drawLine(x,y,xNxt,yNxt);
        		}
				if (i != 0) { // first data point is just for showing history
					drawSquareAtCenter(dc,x,y);
					var yText = (i%2==0)? y-10 : y+8;
					text(dc, x, yText, Gfx.FONT_XTINY, data[i]);
				}
			}
    	}
    	// Call the parent onUpdate function to redraw the layout
        else { View.onUpdate(dc); }
    }
    
    hidden function getMaxValue() {
    	var retval = 0;
    	for (var i=0; i<nrSamples ; i++) {
    		if (data[i] > retval) {retval = data[i];}
    	}
    	return retval;
    }
    
    hidden function getMinValue() {
   		var retval = 300;
    	for (var i=0; i<nrSamples ; i++) {
    		if (data[i] < retval) {retval = data[i];}
    	}
    	return retval;
    }
    
    hidden function drawSquareAtCenter(dc,x,y) {
    	var halfWidth = 2;
    	dc.setColor(sample_color, Gfx.COLOR_TRANSPARENT);
    	dc.fillRectangle(x-halfWidth, y-halfWidth, 2*halfWidth, 2*halfWidth);
    	//Sys.println("(x,y) = (" + x + "," + y + ")");
    }
    
    hidden function text(dc, x, y, font, s) {
    	dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, s,
                    Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
}
class TimeSeriesViewDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		BehaviorDelegate.initialize();
	}
}