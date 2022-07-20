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
    	/*setLayout( Rez.Layouts.SplashLayout( dc ) );
    	timer = new Timer.Timer();
    	timer.start(method(:timerCallback), 1000, true);
		*/
		System.println("SplashScreen Timer");
    	timer = new Timer.Timer();
		_setTimer();
    }
	private function _setTimer() {
    	timer.start(method(:timerCallback), 2000, false);
	}
	
	public function timerCallback() as Void {
		timer.stop();
		timer = null;
		WatchUi.pushView(new ActivityMenu(), new ActivityMenuInputDelegate(), WatchUi.SLIDE_IMMEDIATE);
	}
	public function onUpdate(dc) {
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		var xCenter = dc.getWidth() / 2;
		var yCenter = dc.getHeight() / 2;
		var splashImg = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.splash_screen,
            :locX=>xCenter,
            :locY=>yCenter
        });
    	splashImg.setLocation(xCenter - (splashImg.width / 2), yCenter - (splashImg.height/2));  
		splashImg.draw(dc);
	}
}
