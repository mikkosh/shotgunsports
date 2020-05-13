using Toybox.WatchUi;
using Toybox.Timer;

class SplashScreenInputDelegate extends WatchUi.BehaviorDelegate
{	
    public function initialize() {
        BehaviorDelegate.initialize();
    }
    
    public function onBack() {
    	System.exit();
    }
    
}

class SplashScreenView extends WatchUi.View {

	private var timer;
	
    public function initialize() {
        View.initialize();
    }

	public function onLayout(dc) {
    	setLayout( Rez.Layouts.SplashLayout( dc ) );
    	timer = new Timer.Timer();
    	timer.start(method(:timerCallback), 1000, true);
    }
	
	public function timerCallback() {
		timer.stop();
		WatchUi.pushView(new ActivityMenu(), new ActivityMenuInputDelegate(), WatchUi.SLIDE_IMMEDIATE);
		return true;
	}

}
