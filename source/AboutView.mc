using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;

class AboutInputDelegate extends WatchUi.BehaviorDelegate
{	
    public function initialize() {
        BehaviorDelegate.initialize();
    }
}

class AboutView extends WatchUi.View {
    
    private var timer;
    private var scrollPos = 0;
    private var origY = null;
    
    public function initialize() {
        View.initialize();
        timer = new Timer.Timer();
    }
   
    //! Load your resources here
    public function onLayout(dc) {
		setLayout( Rez.Layouts.AboutLayout( dc ) );
	}

    public function onHide() {
    	timer.stop();
    }

    public function onShow() {
    	timer.start(method(:timerCallback), 100, true);
    }
    
    public function timerCallback() {
    	scrollPos++;
    	WatchUi.requestUpdate();
    }

    public function onUpdate(dc) {
    	var container = View.findDrawableById("about_text");
    	if(origY == null) {
    		origY = container.locY;
		}
    	container.setLocation(container.locX, (origY-scrollPos));
    	if(scrollPos > (container.height+10)) {
    		scrollPos = 0;
		}
    	View.onUpdate( dc );
    }
}
