using Toybox.Application;
using Toybox.Position;
using Toybox.ActivityRecording;

class ShotgunSportsApp extends Application.AppBase {

	private var dataRecorder;
	
    public function initialize() {
        AppBase.initialize();
        dataRecorder = new DataRecorder();
    }

    public function onStart(state) {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    function onStop(state) {
        dataRecorder.stopRecording(true);
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    public function onPosition(info) {
    
    }
    
    public function getInitialView() {
        return [ new SplashScreenView(), new SplashScreenInputDelegate() ];
    }
    
    public function getDataRecorder() {
    	return dataRecorder;
	}


}