using Toybox.WatchUi;

using Toybox.Attention;

class InGameMenu extends WatchUi.Menu2 {
	
	private var _model;
	public function initialize(model) {
		Menu2.initialize({:title=>"Options"});
		populate();
		_model = model;
	}
	
	public function remindLastRound() {
		setFocus(2);
	}
	
	public function onShow() {
		Menu2.onShow();
		if(_model.hasGameEnded()) {
			// do something
			var view = new ResultView(_model, 0);
    		WatchUi.switchToView(view, new ResultInputDelegate(_model), WatchUi.SLIDE_LEFT);
		}
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
			Rez.Strings.options_finish_title,
			Rez.Strings.options_finish_description,
			:EndGame,
			{}
			)
		);
		/*
		addItem(
			new WatchUi.MenuItem(
			Rez.Strings.options_finishdiscard_title,
			Rez.Strings.options_finishdiscard_description,
			:EndDiscard,
			{}
			)
		);
		*/
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
        } else if(item.getId() == :EndGame) {
			
			if (Attention has :vibrate) {
			    Attention.vibrate([new Attention.VibeProfile(100, 500)] as Array<Toybox.Attention.VibeProfile>);
			}

			var dialog = new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.endgame_confirmation_shouldsave));
			WatchUi.pushView(
				dialog,
				new EndGameConfirmationDelegate(model),
				WatchUi.SLIDE_IMMEDIATE
			);
			return true;
        	//model.endGame(true);
        }/*else if(item.getId() == :EndDiscard) {
        	model.endGame(false);
        }*/
        var view = new ResultView(model, 0);
    	WatchUi.switchToView(view, new ResultInputDelegate(model), WatchUi.SLIDE_LEFT);
        return true;
    }
}