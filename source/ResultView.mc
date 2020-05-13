using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;

class ResultInputDelegate extends WatchUi.BehaviorDelegate
{	
	private var model;
	private var page;
	private var stats;
	private var timer;
	
    public function initialize(m) {
        BehaviorDelegate.initialize();
        model = m;
        page = 0;
        stats = model.getGameStats();
        timer = new Timer.Timer();
        timer.start(method(:timerCallback), 5000, true);
    }
    private function restartTimer() {
    	timer.stop();
    	timer.start(method(:timerCallback), 5000, true);
    }
    public function timerCallback(){
    	restartTimer();
    	onNextPage();
    }
    
    public function onPreviousPage() {
    	restartTimer();
    	page--;
		if(page < 0) {
			page = stats.size()-1;
		}
		
    	WatchUi.switchToView(new ResultView(model, page), self, WatchUi.SLIDE_DOWN);
    }
    
    public function onNextPage() {
    	restartTimer();
    	page++;
		var totalPages = stats.size();
		if(page >= totalPages) {
			page = 0;
		}
    	WatchUi.switchToView(new ResultView(model, page), self, WatchUi.SLIDE_UP);
    }
    
    public function onBack() {
    	timer.stop();
    	System.exit();
    }
    
}

class ResultView extends WatchUi.View {
    private var model;
    private var page = 0;
    private var stats;
    
    public function initialize(m, p) {
        View.initialize();
        model = m;
        stats = model.getGameStats();
        page = p;
    }
   
    public function onLayout(dc) {
    	if(page == 0) {
    		setLayout( Rez.Layouts.ResultToltalsLayout( dc ) );
		} else {
			setLayout( Rez.Layouts.ResultLayout( dc ) );
		}
	}


    //! Update the view
    public function onUpdate(dc) {
    	
    	renderPage(dc);
    	View.onUpdate( dc );
    }
    
    private function renderPage(dc) {
    	
    	var s;
    	var keys = stats.keys();
    	var title = "";
    	
    	if(stats.hasKey(page)){
    		s = stats[page];
    		title = WatchUi.loadResource(Rez.Strings.result_title_turn)+" "+page;
    		
    	} else {
    		s = stats["totals"];
    		title = WatchUi.loadResource(Rez.Strings.result_title_totals);
    	} 
    	var shots = s["hits"]+s["misses"];
    	var hitpercent = 0;
    	if(shots > 0) {
    		hitpercent = (s["hits"].toFloat()/shots.toFloat())*100;
		}
    	
    	View.findDrawableById("sportName").setText(model.getSportName());
    	View.findDrawableById("dataTitle").setText(title);
    	View.findDrawableById("hits").setText(s["hits"]+"");
    	View.findDrawableById("misses").setText(s["misses"]+"");
    	View.findDrawableById("shots").setText(shots.toString());
    	View.findDrawableById("hitpercent").setText(hitpercent.format("%.2d")+"%");	    	
    }
}
