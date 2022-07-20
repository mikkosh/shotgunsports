using Toybox.WatchUi;
using Toybox.Attention;


class ShotgunLapInputDelegate extends WatchUi.BehaviorDelegate
{
	private var model;
	private var lastLapReminderGiven;
	
    public function initialize(m) {
        BehaviorDelegate.initialize();
        model = m;
        lastLapReminderGiven = false;

    }

    public function onSelect() {
    	model.selectNextItem();
    	WatchUi.requestUpdate();
        return true; 
    }
    
    public function onPreviousPage() {
    	model.increaseSelected();
    	WatchUi.requestUpdate();
    	return true;
    }
    
    public function onNextPage() {
    	model.decreaseSelected();
    	WatchUi.requestUpdate();
    	return true;
    }

	/*
		What happens below is:
		I am grabbing esc button and right (and left) swipes so they would not 
		trigger onBack behavior and execute onNextRoundMenu instead when esc-button
		is pressed. Swiping sideways should not do anything.
	*/
	// handle esc button and open menu with it
	public function onKey(keyEvent) {
		if(keyEvent.getKey() == KEY_ESC) {
			System.println("got esc");
			onNextRoundMenu();
			return true;
		}
		return false;
	}
	// prevent left and right swipes, allow up/down
	public function onSwipe(swp) {
		if(swp.getDirection() == SWIPE_RIGHT ||swp.getDirection() == SWIPE_LEFT) {
			return true;
		}
		return false;
	}


	// open the menu that the user can access to go to next round
    public function onNextRoundMenu() {    
		System.println("next round menu");
    	var igMenu = new InGameMenu(model);
    	if(model.getLap() == model.getMaxRounds() && !lastLapReminderGiven) {
    		lastLapReminderGiven = true;
    		igMenu.remindLastRound();
    	} 
    	WatchUi.pushView(igMenu, new InGameMenuInputDelegate(model), WatchUi.SLIDE_IMMEDIATE);
    	
        return true;
    }
    
}

class ShotgunLapView extends WatchUi.View {

	private var model;
	private var lastLap;
	
	var selectableLabels = ["hitsLabel", "missesLabel"];
	
    public function initialize(m) {
    	model = m;
        View.initialize();
        lastLap = 1;
    }
	
	
    public function onLayout(dc) {
    	setLayout( Rez.Layouts.LapInputLayout( dc ) );
    }


    public function onUpdate(dc) {
    	
    	// if the lap has changed
    	if(lastLap != model.getLap()) {
    		if (Attention has :vibrate) {
			    Attention.vibrate([new Attention.VibeProfile(100, 500)]);
			}
			if (Attention has :playTone) {
			   Attention.playTone(Attention.TONE_LAP);
			}
    	}
    	
    	for(var i=0;i<selectableLabels.size();i++) {
    		View.findDrawableById(selectableLabels[i]).setBackgroundColor(Graphics.COLOR_TRANSPARENT);
    		View.findDrawableById(selectableLabels[i]).setColor(Graphics.COLOR_LT_GRAY);
    	}
    	View.findDrawableById(selectableLabels[model.getSelectedItem()]).setBackgroundColor(Graphics.COLOR_DK_GRAY);
    	View.findDrawableById(selectableLabels[model.getSelectedItem()]).setColor(Graphics.COLOR_WHITE);
    	
    	View.findDrawableById("hits").setText(model.getHits()+"");
    	View.findDrawableById("misses").setText(model.getMisses()+"");
    	View.findDrawableById("lap").setText(model.getLap()+"");
    	
    	var roundMaxShots = "--";
    	var maxRounds = "--";
    	
    	if(model.getRoundMaxShots() > 0) {
    		roundMaxShots = model.getRoundMaxShots();
    	}
    	
    	if(model.getMaxRounds() > 0) {
    		maxRounds = model.getMaxRounds();
    	}
    	
    	View.findDrawableById("shots").setText(roundMaxShots+"");
    	View.findDrawableById("maxLapLabel").setText("/"+maxRounds);
    	
    	lastLap = model.getLap();
    	View.onUpdate( dc );
    	
    }
}
