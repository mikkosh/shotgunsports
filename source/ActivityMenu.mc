using Toybox.WatchUi;
// "start menu" for selecting the subsport
class ActivityMenu extends WatchUi.Menu2 {
	public function initialize() {
		Menu2.initialize({:title=>Rez.Strings.AppName});
		populate();
	}
	private function populate() {
		
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.game_freetraining_title,
			Rez.Strings.game_freetraining_description,
			:ShotgunsportModel,
			{}
			)
		);
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.game_skeet_title,
			Rez.Strings.game_skeet_description,
			:SkeetModel,
			{}
			)
		);
		
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.game_trap_title,
			Rez.Strings.game_trap_description,
			:BushTrapModel,
			{}
			)
		);
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.game_bushskeet_title,
			Rez.Strings.game_bushskeet_description,
			:BushSkeetModel,
			{}
			)
		);
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.game_dbltrap_title,
			Rez.Strings.game_dbltrap_description,
			:DoubleTrapModel,
			{}
			)
		);
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.menu_about_application,
			null,
			:AboutApp,
			{}
			)
		);
	}
}

class ActivityMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item) {
        System.println(item.getId());
        
        if(item.getId() == :AboutApp) {
        	WatchUi.pushView(new AboutView(), new AboutInputDelegate(),WatchUi.SLIDE_LEFT);
        	return true;
        }
        
        var dataRecorder = Toybox.Application.getApp().getDataRecorder();
        // default to free training
        var model = new ShotgunsportModel(dataRecorder);
        if(item.getId() == :BushSkeetModel) {
        	model = new BushSkeetModel(dataRecorder);
        } else if(item.getId() == :BushTrapModel) {
        	model = new TrapModel(dataRecorder);
        } else if(item.getId() == :SkeetModel) {
        	model = new SkeetModel(dataRecorder);
        } else if(item.getId() == :DoubleTrapModel) {
        	model = new DoubleTrapModel(dataRecorder);
        }
        
    	model.startGame();
        WatchUi.switchToView(new ShotgunLapView(model), new ShotgunLapInputDelegate(model),WatchUi.SLIDE_LEFT);
        WatchUi.requestUpdate();
        return true;
    }
    public function onBack() {
    	System.exit();
    }
}