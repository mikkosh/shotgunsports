class ShotgunsportModel
{
	// recorder handles fit file logging
	private var dataRecorder;
	
	// round hits
	private var hits;
	
	// round misses
	private var misses;
	
	// lap/round number
	private var lap;
	
	// selected item position (see ID_* constants)
	private var selectedPos;
	
	// key-val for storing game statistics
	private var gameStats = {};
	
	private var hasEnded = false;
	
	private var sportName = "";
	
	// identifiers for hits and misses
	const ID_HITS = 0;
	const ID_MISSES = 1;

	
	public function initialize(drecorder) {
		dataRecorder = drecorder;
		
		hits = 0;
		misses = 0;
		lap = 1;
		
		selectedPos = ID_HITS;
		
		setSportName(WatchUi.loadResource(Rez.Strings.game_freetraining_title));
	}
	protected function setSportName(name) {
		sportName = name;
	}
	public function getSportName() {
		return sportName;
	}
	public function getSelectedItem() {
		return selectedPos;
	}
	public function selectNextItem() {
		selectedPos++;
		if(selectedPos > ID_MISSES) {
			selectedPos = ID_HITS;
		}
	}
	// @return shouldContinue
	public function increaseSelected() {
		if(getSelectedItem() == ID_HITS) {
			addHit();
		} else if(getSelectedItem() == ID_MISSES) {
			addMiss();
    	}
    	return true;
	}
	
	public function nextRound() {
		dataRecorder.recordLapData(getHits(), getMisses());
    	logLapStats(lap, hits, misses);
    	nextLap();
    	dataRecorder.addLap();
	}
	
	public function decreaseSelected() {
		if(getSelectedItem() == ID_HITS) {
			removeHit();
		} else if(getSelectedItem() == ID_MISSES) {
			removeMiss();
    	}
	}
	
	
	public function addHit() {
		hits++;
	}
	
	public function removeHit() {
		hits--;
		if(hits < 0) {
			hits = 0;
		}
	}
	
	public function addMiss() {
		misses++;
	}
	
	public function removeMiss() {
		misses--;
		if(misses < 0) {
			misses = 0;
		}
	}
	
	public function getHits() {
		return hits;
	}
	
	public function getMisses() {
		return misses;
	}
	//@todo: should be "reset ui" etc rather than nextLap
	public function nextLap() {
		hits = 0;
		misses = 0;
		lap++;
		selectedPos = ID_HITS;
	}
	
	public function getLap() {
		return lap;
	}
	public function startGame() {
		hasEnded = false;
		dataRecorder.startRecording(sportName);
	}
	//@param saveData boolean should the data be saved (or discarded on false)
	public function endGame(saveData) {
		dataRecorder.recordLapData(getHits(), getMisses());
		logLapStats(lap, hits, misses);
		dataRecorder.stopRecording(saveData);
		hasEnded = true;
	}
	
	public function hasGameEnded() {
		return hasEnded;
	}

	// @todo: define whether returns a number (like child classes) or a string
	public function getRoundMaxShots() {
		return 0;
	}
	
	// @todo: define whether returns a number (like child classes) or a string
	public function getMaxRounds(){
		return 0;
	}
	
	protected function setHits(numHits) {
		hits = numHits;
	}
	
	protected function setMisses(numMisses) {
		misses = numMisses;
	}
	
	protected function logLapStats(lapnro, hits, misses) {
		gameStats[lapnro] = {"hits" => hits, "misses" => misses};
		
		if(!gameStats.hasKey("totals")) {
			gameStats["totals"] = {"hits" => 0, "misses" => 0};
		}
		gameStats["totals"]["hits"] += hits;
		gameStats["totals"]["misses"] += misses;
	}
	
	public function getGameStats() {
		return gameStats;
	}
}

// model for simple skeet (bush skeet rules)
class BushSkeetModel extends ShotgunsportModel {


	public function initialize(drec) {
		ShotgunsportModel.initialize(drec);
		setSportName(WatchUi.loadResource(Rez.Strings.game_bushskeet_title));
		setMisses(getRoundMaxShots()-getHits());
	}
	
	public function nextLap() {
		ShotgunsportModel.nextLap();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	
	public function getRoundMaxShots() {
		var lap = getLap();
		if(lap == 8) { 
			return 5;
		} else if(lap > 2 && lap < 6) {
			return 4;
		} else if(lap<9) {
			return 2;
		} else {
			return 0;
		}
	}
	
	public function getMaxRounds(){
		return 8;
	}
	
	public function addHit() {
		ShotgunsportModel.addHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	public function removeHit() {
		ShotgunsportModel.removeHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
}

// model for simple trap
class TrapModel extends ShotgunsportModel {

	
	public function initialize(drec) {
		ShotgunsportModel.initialize(drec);
		setSportName(WatchUi.loadResource(Rez.Strings.game_trap_title));
		setMisses(getRoundMaxShots()-getHits());
	}
	
	public function nextLap() {
		ShotgunsportModel.nextLap();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses()<0) {
			setMisses(0);
		}
	}
	
	public function getRoundMaxShots() {
		if(getLap() < 26) {
			return 1;
		} else {
			return 0;
		}
	}
	
	public function getMaxRounds(){
		return 25;
	}
	
	public function addHit() {
		ShotgunsportModel.addHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	public function removeHit() {
		ShotgunsportModel.removeHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
}
class DoubleTrapModel extends ShotgunsportModel {

	
	public function initialize(drec) {
		ShotgunsportModel.initialize(drec);
		setSportName(WatchUi.loadResource(Rez.Strings.game_dbltrap_title));
		setMisses(getRoundMaxShots()-getHits());
	}
	
	public function nextLap() {
		ShotgunsportModel.nextLap();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses()<0) {
			setMisses(0);
		}
	}
	
	public function getRoundMaxShots() {
		if(getLap() < 16) {
			return 2;
		} else {
			return 0;
		}
	}
	
	public function getMaxRounds(){
		return 15;
	}
	
	public function addHit() {
		ShotgunsportModel.addHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	public function removeHit() {
		ShotgunsportModel.removeHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
}
// model for skeet (simple skeet rules)
class SkeetModel extends ShotgunsportModel {


	public function initialize(drec) {
		ShotgunsportModel.initialize(drec);
		setSportName(WatchUi.loadResource(Rez.Strings.game_skeet_title));
		setMisses(getRoundMaxShots()-getHits());
	}
	
	public function nextLap() {
		ShotgunsportModel.nextLap();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	
	public function getRoundMaxShots() {
		var lap = getLap();
		if(lap < 4) { 
			return 3;
		} else if(lap == 4) {
			return 2;
		} else if(lap == 5 || lap == 6) {
			return 3;
		} else if(lap == 7) {
			return 2;
		} else if(lap == 8) {
			return 4;
		} else if(lap == 9) {
			return 2;
		} else {
			return 0;
		}
	}
	
	public function getMaxRounds(){
		return 9;
	}
	
	public function addHit() {
		ShotgunsportModel.addHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	public function removeHit() {
		ShotgunsportModel.removeHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
}

// model for American skeet (American skeet rules)
class AmSkeetModel extends ShotgunsportModel {


	public function initialize(drec) {
		ShotgunsportModel.initialize(drec);
		setSportName(WatchUi.loadResource(Rez.Strings.game_amskeet_title));
		setMisses(getRoundMaxShots()-getHits());
	}
	
	public function nextLap() {
		ShotgunsportModel.nextLap();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	
	public function getRoundMaxShots() {
		var lap = getLap();
		if(lap > 2 && lap < 6) { 
			return 2;
		} else if(lap == 8) {
			return 2;
		} else if(lap == 1 || lap == 2) {
			return 4;
		} else if(lap == 6 || lap == 7) {
			return 4;
		} else {
			return 0;
		}
	}
	
	public function getMaxRounds(){
		return 8;
	}
	
	public function addHit() {
		ShotgunsportModel.addHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	public function removeHit() {
		ShotgunsportModel.removeHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
}
// model for 5 stand trap
class FiveStandModel extends ShotgunsportModel {

	
	public function initialize(drec) {
		ShotgunsportModel.initialize(drec);
		setSportName(WatchUi.loadResource(Rez.Strings.game_5stand_title));
		setMisses(getRoundMaxShots()-getHits());
	}
	
	public function nextLap() {
		ShotgunsportModel.nextLap();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses()<0) {
			setMisses(0);
		}
	}
	
	public function getRoundMaxShots() {
		if(getLap() < 6) {
			return 5;
		} else {
			return 0;
		}
	}
	
	public function getMaxRounds(){
		return 5;
	}
	
	public function addHit() {
		ShotgunsportModel.addHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
	public function removeHit() {
		ShotgunsportModel.removeHit();
		setMisses(getRoundMaxShots()-getHits());
		if(getMisses() < 0) {
			setMisses(0);
		}
	}
}