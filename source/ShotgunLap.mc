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
    
    public function onBack() {    
    
    	if(model.getLap() == model.getMaxRounds() && !lastLapReminderGiven) {
    		lastLapReminderGiven = true;
    		WatchUi.pushView(new InGameMenu(), new InGameMenuInputDelegate(model), WatchUi.SLIDE_IMMEDIATE);
    	} else {
	    	var progressBar = new LapSaveProgressBar();
	        WatchUi.pushView(
	            progressBar,
	            new LapSaveProgresssDelegate(progressBar, model),
	            WatchUi.SLIDE_RIGHT
	        );
        }
        return true;
    }
    
    public function onMenu() {
    	WatchUi.pushView(new InGameMenu(), new InGameMenuInputDelegate(model), WatchUi.SLIDE_IMMEDIATE);
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
