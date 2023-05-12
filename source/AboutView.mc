import Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.System;
using Toybox.Communications;

class AboutInputDelegate extends WatchUi.BehaviorDelegate
{	
    private var view;
    public function initialize(view) {
        BehaviorDelegate.initialize();
        self.view = view;
    }

    public function onNextPage() {
        view.forward(25);
    }
    public function onPreviousPage() {
        view.backward(25);
    }
    public function onSelect() {
        
        Communications.openWebPage(
            "https://apps.garmin.com/en-US/apps/21b1d0cd-dd14-47e2-9b97-a46b5c933eff",
            {},
            null
        );
    }

}

class AboutView extends WatchUi.View {
    
    private var timer;
    private var scrollPos = 0;
    private var origY = null;
    
    public function initialize() {
        View.initialize();
    }
   
    //! Load your resources here
    public function onLayout(dc) {
		setLayout( Rez.Layouts.AboutLayout( dc ) );
	}

    public function onHide() {
    	timer.stop();
        timer = null;
    }

    public function onShow() {
        System.println("AboutView Timer");
        timer = new Timer.Timer();
    	timer.start(method(:timerCallback), 100, true);

    }
    
    public function timerCallback() as Void{
    	forward(1);
    	WatchUi.requestUpdate();
    }

   public function onUpdate(dc) {
    	var container = View.findDrawableById("about_text");
    	if(origY == null) {
    		origY = container.locY;
		}
    	container.setLocation(container.locX, (origY-scrollPos));
    	
    	View.onUpdate( dc );
    }

    public function forward(amount as Number)  as Void {
        scrollPos = scrollPos+amount;
        var container = View.findDrawableById("about_text");
        if(scrollPos > (container.height+50)) {
    		scrollPos = 0;
		}
    }
    public function backward(amount as Number) as Void {
        scrollPos = scrollPos-amount;
        if(scrollPos < 0) {
            scrollPos = 0;
        }
    }
}
