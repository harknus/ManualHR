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
	
	hidden var x1;
	hidden var y1;
	hidden var x2;
	hidden var y2;
	hidden var screenHeight;
	
	function initialize() {	
		if (history != null && history.getHasData()) { 
			data = history.getTimeSamples();
			nrSamples = data.size(); 
			
			// (x1, y1, x2, y2) = (15, 70, 195, 160) 218x218
			screenHeight = System.getDeviceSettings().screenHeight;
			x1 = 15;
			y1 = 75;
			x2 = screenHeight - x1 + 10; // Should be a bit off center since the graph goes further to the left
			y2 = screenHeight - y1 + 12; // but a bit down in the screen

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
        	var penWidth = (screenHeight>230)?2:1;
        	dc.setPenWidth(penWidth);
        	
        	dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
			text(dc, screenHeight/2, 30, Gfx.FONT_TINY, "Latest " + (nrSamples-1));
			text(dc, screenHeight/2, 50, Gfx.FONT_TINY, "HR measurements");
			
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
			var yScale = (yRange == 0)? 1 : (y2-y1-yOffset)/(1.0*yRange); 
		
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
					//drawSquareAtCenter(dc,x,y);
					drawCirlceAtCenter(dc,x,y, penWidth*2);
					var fontHeight = Gfx.getFontHeight(Gfx.FONT_XTINY);
					var yText = (i%2==0)? y-fontHeight/2 - 2: y+fontHeight/2;//y-10 : y+8;
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
    
    hidden function drawCirlceAtCenter(dc, x, y, radius){
    	dc.setColor(sample_color, Gfx.COLOR_TRANSPARENT);
    	dc.fillCircle(x, y, radius);
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