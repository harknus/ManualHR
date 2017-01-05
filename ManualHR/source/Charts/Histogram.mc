using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

//! Class Histogram
//! For use in a drawing context to draw a histogram using a 
//! data provider, specified in the constructor.
class Histogram {
	hidden var dataProvider;
	hidden var nrOfBins;
	hidden var binValues;
	hidden var binBorders;
	hidden var restHR;
	
	hidden const line_color = Gfx.COLOR_WHITE;
	hidden const bin_color1 = Gfx.COLOR_GREEN;
	hidden const bin_color2 = Gfx.COLOR_DK_GREEN;
	hidden const text_color = Gfx.COLOR_WHITE; 
	hidden const bg_color = Gfx.COLOR_BLACK;
	
	//! Provide a pointer to a data provider that provides
	//! getDataFor(xValue) and getDataRange();
	function initialize(aDataProvider, aNrOfBins) {
	    nrOfBins = aNrOfBins;
	    binValues = new [nrOfBins];
	    binBorders = new [nrOfBins+1];
	    for (var i = 0; i <nrOfBins ; i++) { binValues[i] = 0; }
	    
		dataProvider = aDataProvider;
		
		var range = dataProvider.getDataRange();
		
		restHR = range[0];
		
		var binSize = (range[1] - range[0])/(1.0*nrOfBins);
		binBorders[0] = range[0];
		binBorders[nrOfBins] = range[1]+1; //One more than the max value
		for (var n = 1 ; n<nrOfBins ; n++) {
			binBorders[n] = range[0] + n*binSize;
		} 
		
		for (var i = range[0]; i <= range[1]; i++) {
			var value = dataProvider.getDataFor(i);
			if (value > 0) {
				for (var j = 0; j<nrOfBins ; j++) {
					if (binBorders[j] <= i && i < binBorders[j+1]) {
						binValues[j] += value;
						//Sys.println(value + " samples of HR:" + i + " put in bin: " + j);
						break;
					} 
				}
			}
		} 
		//Debug test
		//Sys.println("History" + history);
		//Sys.println("Range " + range);
		//Sys.println("Non zero range: " + dataProvider.getNonZeroRange());
		//Sys.println("Bin borders: " + binBorders);
		//Sys.println("Bin values:  " + binValues);
	}

	hidden function getMaxCount(){
		var maxValue = 0;
		for (var i=0; i<nrOfBins; i++) {
			if ( binValues[i] > maxValue ) { maxValue = binValues[i]; }
		}
		return maxValue;
	}

	//! function draw(dc) 
	//! Draws the histogram in the specified drawing context (dc) 
	//! using the data provided by the data provider 
	function draw(dc) {
		
		dc.setPenWidth(1);
		
		//Parameters for Fenix3
		var x1 = 25;
		var y1 = 70;
		var x2 = 195;
		var y2 = 160;
		
		var maxValue = getMaxCount();
		var yScale = (maxValue == 0)? 1 : (y2-y1)/maxValue;
		
		var ticSize = 2;
		
		var xOffsetL = 4;
		var binWidth = (x2-x1-2*xOffsetL) / nrOfBins;
		var recidue = (x2-x1-2*xOffsetL) % nrOfBins;
		//Sys.println("Residue: " + recidue); 
		xOffsetL = (2*xOffsetL + recidue)/2;
		var xOffsetR = (2*xOffsetL + recidue) % 2 == 0 ? xOffsetL : xOffsetL+1;
		
		dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
		text(dc, 109, 40, Gfx.FONT_TINY, "Rest HR: " + restHR + " bpm" );

        for (var n=0; n<nrOfBins; n++) {
        	if( n%2 == 0 ) {dc.setColor(bin_color1, Gfx.COLOR_TRANSPARENT);}
        	else {dc.setColor(bin_color2, Gfx.COLOR_TRANSPARENT);}
        	var height = binValues[n]*yScale;
        	var x = xOffsetL + x1 + n*binWidth;
        	var y = y2-height;
        	dc.fillRectangle(x, y, binWidth, height);
        	dc.setColor(line_color, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(x, y+height+1, x, y+height+1+ticSize);
        	if (n == nrOfBins-1) {
        		dc.drawLine(x+binWidth, y+height+1, x+binWidth, y+height+1+ticSize);
        	}
        	
        	if (binValues[n] > 0 && binWidth > dc.getTextWidthInPixels(binBorders[n].format("%.0d"), Gfx.FONT_XTINY)) {
        		dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
        		dc.drawText(x, y2, Gfx.FONT_XTINY, binBorders[n].format("%.0d"), Gfx.TEXT_JUSTIFY_CENTER);
        		if (n < nrOfBins-1) {
        			if(binValues[n+1] == 0 && binWidth > dc.getTextWidthInPixels(binBorders[n+1].format("%.0d"), Gfx.FONT_XTINY)) {
        				dc.drawText(x+binWidth, y2, Gfx.FONT_XTINY, binBorders[n+1].format("%.0d"), Gfx.TEXT_JUSTIFY_CENTER);
        			}
        		}
        	}
        	//Sys.println("Rectangle "+ (n+1) +": [" + x + "," + y + "," + binWidth + "," + height + "]");
        }
        
        //Draw the axes
        dc.setColor(line_color, Gfx.COLOR_TRANSPARENT);
        tick_line(dc, x1, y1, y2, -ticSize, maxValue, true);
        tick_line(dc, x2, y1, y2, ticSize, maxValue, true);
        dc.drawLine(x1, y2, x2, y2); dc.drawPoint(x2,y2);
        
        //Print bin border values, and max count
        dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x1-3, y1, Gfx.FONT_XTINY, maxValue, Gfx.TEXT_JUSTIFY_RIGHT|Gfx.TEXT_JUSTIFY_VCENTER);
        if (binWidth <= dc.getTextWidthInPixels(binBorders[0].format("%.0d"), Gfx.FONT_XTINY)){
        	dc.drawText(x1+xOffsetL, y2, Gfx.FONT_XTINY, binBorders[0].format("%.0d"), Gfx.TEXT_JUSTIFY_CENTER);
        }
        dc.drawText(x2-xOffsetR, y2, Gfx.FONT_XTINY, binBorders[nrOfBins].format("%.0d"), Gfx.TEXT_JUSTIFY_CENTER);
	}
	
    //hidden function text_outline(dc, x, y, fg, bg, font, s) {
    //    dc.setColor(bg, Graphics.COLOR_TRANSPARENT);
    //    dc.drawText(x-2, y, font, s, Graphics.TEXT_JUSTIFY_LEFT);
    //    dc.drawText(x+2, y, font, s, Graphics.TEXT_JUSTIFY_LEFT);
    //    dc.drawText(x, y-2, font, s, Graphics.TEXT_JUSTIFY_LEFT);
    //    dc.drawText(x, y+2, font, s, Graphics.TEXT_JUSTIFY_LEFT);
    //    dc.setColor(fg, Graphics.COLOR_TRANSPARENT);
    //    dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT);
    //}
	
	hidden function tick_line(dc, c, end1, end2, tick_size, maxTicVal, vert) {
        tick_line0(dc, c, end1, end2, vert);
        tick_line0(dc, end1, c, c+tick_size, !vert);
        for (var n = 1; n < maxTicVal; n++) {
            tick_line0(dc, ((maxTicVal - n) * end1 + n * end2) / maxTicVal, c, c + tick_size,
                       !vert);
        }
    }
    
	
	hidden function tick_line0(dc, c, end1, end2, vert) {
        if (vert) {
            dc.drawLine(c, end1, c, end2);
            dc.drawPoint(c, end2);
        } else {
            dc.drawLine(end1, c, end2, c);
            dc.drawPoint(end2, c);
        }
    }
    
    hidden function text(dc, x, y, font, s) {
        dc.drawText(x, y, font, s,
                    Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
    }
}