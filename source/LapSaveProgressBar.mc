using Toybox.WatchUi;
using Toybox.Timer;

class LapSaveProgressBar extends WatchUi.ProgressBar {
	public function initialize() {
		ProgressBar.initialize("", null);
    }
}

class LapSaveProgresssDelegate extends WatchUi.BehaviorDelegate {
	
	private var delay = 2;
	private var lapSaveMsg = "";
	private var timer;
	private var model;
	private var progressBar;
	
    public function initialize(pb, m) {
        BehaviorDelegate.initialize();
        lapSaveMsg = WatchUi.loadResource(Rez.Strings.saving_turn_data);
        model = m;
        progressBar = pb;
        progressBar.setDisplayString(lapSaveMsg+delay);
        
    	timer = new Timer.Timer();
    	timer.start(method(:timerCallback), 1000, true);
    }
    
	public function timerCallback() {
		delay--;
		progressBar.setDisplayString(lapSaveMsg+delay);
		if(delay < 1) {
			timer.stop();
			model.nextRound();
			WatchUi.popView(WatchUi.SLIDE_LEFT);
		}
	}
    public function onBack() {
    	timer.stop();
        return true;
    }
}