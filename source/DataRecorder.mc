class DataRecorder {

	private var session;
    
    private var hitsField,missesField,shotsField,totalHitsField,totalMissesField,totalShotsField,hitPercentField;
    
    const FIELD_ID_TEST = 0;
    const FIELD_ID_HITS = 1;
    const FIELD_ID_MISSES = 2;
    const FIELD_ID_SHOTS = 3;
    const FIELD_ID_HITS_TOTAL = 4;
    const FIELD_ID_MISSES_TOTAL = 5;
    const FIELD_ID_SHOTS_TOTAL = 6;
    const FIELD_ID_HITS_PERCENT = 7;
    
    private var hits, misses, shots, totalHits, totalMisses, totalShots;
    
    const FIT_NATIVE_MSG_LAP_PLAYER_SCORE=83;
	
	public function initialize() {
		
        
	}
	public function startRecording(sportName) {
		if( Toybox has :ActivityRecording ) {
		
			// devices with ciq < 3.0.10 don't have sport_shooting
    		var sportId = ActivityRecording.SPORT_GENERIC;
    		if(ActivityRecording has :SPORT_SHOOTING) {
    			sportId = ActivityRecording.SPORT_SHOOTING;
			}
        	session = ActivityRecording.createSession({:name=>sportName, :sport=>sportId});
            
            hitsField = session.createField("Hits", FIELD_ID_HITS, FitContributor.DATA_TYPE_UINT16, { :mesgType=>FitContributor.MESG_TYPE_LAP, :units=>"H", :nativeNum=>FIT_NATIVE_MSG_LAP_PLAYER_SCORE});
            missesField = session.createField("Misses", FIELD_ID_MISSES, FitContributor.DATA_TYPE_UINT16, { :mesgType=>FitContributor.MESG_TYPE_LAP, :units=>"H" /*, :nativeNum=>FIT_NATIVE_MSG_LAP_PLAYER_SCORE */});
            shotsField = session.createField("Shots", FIELD_ID_SHOTS, FitContributor.DATA_TYPE_UINT16, { :mesgType=>FitContributor.MESG_TYPE_LAP, :units=>"H" /*, :nativeNum=>FIT_NATIVE_MSG_LAP_PLAYER_SCORE */});
            
            hitsField.setData(0);
            missesField.setData(0);
            shotsField.setData(0);
            
            totalHitsField = session.createField("Total hits", FIELD_ID_HITS_TOTAL, FitContributor.DATA_TYPE_UINT16, { :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"H" /*, :nativeNum=>FIT_NATIVE_MSG_LAP_PLAYER_SCORE */});
            totalMissesField = session.createField("Total misses", FIELD_ID_MISSES_TOTAL, FitContributor.DATA_TYPE_UINT16, { :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"H" /*, :nativeNum=>FIT_NATIVE_MSG_LAP_PLAYER_SCORE */});
            totalShotsField = session.createField("Total shots", FIELD_ID_SHOTS_TOTAL, FitContributor.DATA_TYPE_UINT16, { :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"H" /*, :nativeNum=>FIT_NATIVE_MSG_LAP_PLAYER_SCORE */});
            
            totalHitsField.setData(0);
            totalMissesField.setData(0);
            totalShotsField.setData(0);
            
            hitPercentField = session.createField("Hitpercentage", FIELD_ID_HITS_PERCENT, FitContributor.DATA_TYPE_FLOAT, { :mesgType=>FitContributor.MESG_TYPE_SESSION, :units=>"%" /*, :nativeNum=>FIT_NATIVE_MSG_LAP_PLAYER_SCORE */});
            hitPercentField.setData(0);  
        }
		if(session.isRecording() == false ) {
	
	    	hits = 0;
	    	misses = 0;
	    	shots = 0;
	    	totalHits = 0;
	    	totalMisses = 0;
	    	totalShots = 0;
	    	session.start();    
	        System.println("Recording started");
        }
    }
    
    public function stopRecording(saveSession) {
    	if( session != null && session.isRecording() ) {
            session.stop();
            if(saveSession) {
            	session.save();
            	System.println("Saving data");
        	} else {
        		session.discard();
        		System.println("Discarding data");
    		}
            session = null;
            System.println("Recording stopped");
        }
    }
    public function isRecording() {
    	return ( session != null && session.isRecording() );
    }
    
    public function getSession() {
    	return session;
    }
    
    public function recordLapData(hits, misses) {
    	if(isRecording()) {
			hitsField.setData(hits);
			missesField.setData(misses);
			shotsField.setData(hits+misses); 
			
			totalHits = totalHits+hits;
		    totalMisses = totalMisses+misses;
		    totalShots = totalShots+hits+misses;
		    totalHitsField.setData(totalHits);
			totalMissesField.setData(totalMisses);
			totalShotsField.setData(totalShots);
		    if(totalShots > 0) {
		    	hitPercentField.setData(100*(totalHits.toFloat()/totalShots.toFloat()));
	    	} else {
	    		hitPercentField.setData(0);
    		}
	    }
    }
    
    public function addLap() {
    	session.addLap();
    }
}