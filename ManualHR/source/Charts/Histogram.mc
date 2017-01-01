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
	
	hidden const line_color = Gfx.COLOR_WHITE;
	
	//! Provide a pointer to a data provider that provides
	//! getDataFor(xValue) and getDataRange();
	function initialize(aDataProvider, aNrOfBins) {
	    nrOfBins = aNrOfBins;
	    binValues = new [nrOfBins];
	    binBorders = new [nrOfBins+1];
	    for (var i = 0; i <nrOfBins ; i++) { binValues[i] = 0; }
	    
		dataProvider = aDataProvider;
		
		var range = dataProvider.getDataRange();
		
		var binSize = (range[1] - range[0])/nrOfBins;
		binBorders[0] = range[0];
		binBorders[nrOfBins] = range[1]+1; //One more than the max value
		for (var n = 1 ; n<nrOfBins ; n++) {
			binBorders[n] = range[0] + n*binSize;
		} 
		
		for (var i = range[0]; i < range[1]; i++) {
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
		//Sys.println("Histogram initialize(dataProvider)");
		//Sys.println(history);
		//Sys.println(range);
		//Sys.println(binBorders);
		//Sys.println(binValues);
	}

	//! function draw(dc) 
	//! Draws the histogram in the specified drawing context (dc) 
	//! using the data provided by the data provider 
	function draw(dc) {
			dc.setColor(line_color, Gfx.COLOR_TRANSPARENT);
            //tick_line(dc, x1, y1, y2, -5, true);
            //tick_line(dc, x2, y1, y2, 5, true);
            //tick_line(dc, y2, x1, x2 + 1, 5, false);
	}
	
	hidden function tick_line(dc, c, end1, end2, tick_size, vert) {
        tick_line0(dc, c, end1, end2, vert);
        for (var n = 1; n <= 3; n++) {
            tick_line0(dc, ((4 - n) * end1 + n * end2) / 4, c, c + tick_size,
                       !vert);
        }
    }
	
	hidden function tick_line0(dc, c, end1, end2, vert) {
        if (vert) {
            dc.drawLine(c, end1, c, end2);
        } else {
            dc.drawLine(end1, c, end2, c);
        }
    }
}