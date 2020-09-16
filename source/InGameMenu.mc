using Toybox.WatchUi;

class InGameMenu extends WatchUi.Menu2 {
	
	public function initialize() {
		Menu2.initialize({:title=>"Options"});
		populate();
	}
	
	public function remindLastRound() {
		setFocus(2);
	}
	private function populate() {
		
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.options_nextround_title,
			Rez.Strings.options_nextround_description,
			:NextRound,
			{}
			)
		);
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.options_continue_title,
			Rez.Strings.options_continue_description,
			:BackToGame,
			{}
			)
		);
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.options_finishsave_title,
			Rez.Strings.options_finishsave_description,
			:EndSave,
			{}
			)
		);

		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.options_finishdiscard_title,
			Rez.Strings.options_finishdiscard_description,
			:EndDiscard,
			{}
			)
		);
		
	}
}

class InGameMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    
    private var model;
    
    public function initialize(m) {
        Menu2InputDelegate.initialize();
        model = m;
    }

    function onSelect(item) {
       
        if(item.getId() == :NextRound) {
        	model.nextRound();
			WatchUi.popView(WatchUi.SLIDE_LEFT);
			return true;
        } else if(item.getId() == :BackToGame) {
        	WatchUi.popView(WatchUi.SLIDE_LEFT);
        	return true;
        } else if(item.getId() == :EndSave) {
        	model.endGame(true);
        } else if(item.getId() == :EndDiscard) {
        	model.endGame(false);
        }
        var view = new ResultView(model, 0);
    	WatchUi.switchToView(view, new ResultInputDelegate(model), WatchUi.SLIDE_LEFT);
        return true;
    }
}