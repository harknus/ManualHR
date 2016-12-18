using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class ManualHRMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
        	var countMenu = new Rez.Menus.NrCountMenu();
        	var title = Ui.loadResource(Rez.Strings.NrCountMenuTitle);
        	countMenu.setTitle(title);
        	Ui.pushView(countMenu, new NrCountMenuDelegate(), Ui.SLIDE_LEFT);
        } else if (item == :item_2) {
            Sys.println("Selected the information page");
        }
    }
}

class NrCountMenuDelegate extends Ui.MenuInputDelegate {

	function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
    	var count = null;
    	if (item == :count5) {count = 5;}
    	if (item == :count10) {count = 10;}
    	if (item == :count15) {count = 15;}
    	if (item == :count20) {count = 20;}
    	if (item == :count25) {count = 25;}
    	if (item == :count30) {count = 30;}
    	if (item == :count35) {count = 35;}
    	if (item == :count40) {count = 40;}
    	if (item == :count45) {count = 45;}
    	if (item == :count50) {count = 50;}
    	if (item == :count55) {count = 55;}
    	if (item == :count60) {count = 60;}
    	
    	HB_count = 1.0*count;
    	App.getApp().setProperty("NR_BEATS_TO_COUNT", count); 
    	Sys.println("Setting nr of heartbeats to count to:" + count);
    }
}

