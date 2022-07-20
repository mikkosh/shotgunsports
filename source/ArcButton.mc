using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Math;

/**
 * ArcButton draws a "standard" Garmin button
 * example usage and expected parameters
 * <drawable id="DogRotateButton" class="ArcButton">
 *		<param name="position">@ArcButton.POSITION_ESC_BUTTON</param>
 *		<param name="width">30</param>
 *		<param name="height">30</param>
 *		<param name="behavior">:onBack</param>
 *		<param name="stateDefault">@Drawables.dogrotate</param>
 *		<param name="stateHighlighted">@Drawables.dogrotate</param>
 *		<param name="color">@Graphics.COLOR_BLACK</param>
 *	</drawable>
*/
class ArcButton extends WatchUi.Button {

    const POSITION_SELECT_BUTTON = :selectButton;
    const POSITION_ESC_BUTTON = :escButton;
    const POSITION_DOWN_BUTTON = :downButton;
    const POSITION_UP_BUTTON = :upButton;
    const POSITION_PWR_BUTTON = :pwrButton;

    private const THICKNESS = 4;
    private const SPACING = 5;
    private const ARC_LENGTH = 20;

    private var angle;

    private var arcColor = Graphics.COLOR_WHITE;

    private var imgWidth;
    private var imgHeight;
    private var centerDist;

    public function initialize(settings) {
        
        if(settings.hasKey(:position)) {
            angle = getAngleFromPosition(settings[:position]);
        } else { 
            angle = 0; // angle could be calculated from :locX & Y but why bother as they're really not used
        }

        if(settings.hasKey(:color)) {
            arcColor = settings[:color];
        }

        settings[:stateDefault] = new WatchUi.Bitmap({
            :rezId=>settings[:stateDefault],
            :locX=>0,
            :locY=>0
        });
        settings[:stateHighlighted] = new WatchUi.Bitmap({
            :rezId=>settings[:stateHighlighted],
            :locX=>0,
            :locY=>0
        });
        
        var imgDimensions = settings[:stateHighlighted].getDimensions();
        
        imgWidth = imgDimensions[0];
        imgHeight = imgDimensions[1];
        // calculate the distance to the center of image from it's corner to assist in spacing it later
        centerDist = Math.sqrt(Math.pow(imgDimensions[0]/2,2)+Math.pow(imgDimensions[1]/2,2));
        // use radians in calculations
        var aRad = angle * Math.PI / 180;
        // next calculate the button image (center) location based on the angle and spacing
        // the hypotenuse for the right angle is the screen radius minus spacing
        var hypo = getScreenLength()/2 - SPACING - centerDist;
        // calculate x & y with the angle
        var xx = getScreenLength()/2 + (hypo * Math.cos(aRad));
        var yy = getScreenLength()/2 - (hypo * Math.sin(aRad));
        // transfer the coordinates to top left of the image
        settings[:locX] = xx - imgWidth/2;
        settings[:locY] = yy - imgHeight/2;

        Button.initialize(settings);
    }

    public function draw(dc) {
        // first draw the image using super's draw
        WatchUi.Button.draw(dc);
        
        // then draw the arc
        dc.setColor(arcColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(THICKNESS);
        var aX = getScreenLength()/2;
        var aY = getScreenLength()/2;
        var aR = getScreenLength()/2 - SPACING;
        var angleStart = angle - ARC_LENGTH/2;
        var angleEnd = angle + ARC_LENGTH/2;

        dc.drawArc(aX, aY, aR, Graphics.ARC_CLOCKWISE, angleEnd, angleStart);
    }

    private function getScreenLength() {
        var s = System.getDeviceSettings();
        return s.screenWidth;
    }

    // positions are given as references to device buttons
    private function getAngleFromPosition(position) {
        if(position == POSITION_ESC_BUTTON) {
            return 330;
        } else if(position == POSITION_PWR_BUTTON) {
            return 150;
        } else if(position == POSITION_UP_BUTTON) {
            return 180;
        } else if(position == POSITION_DOWN_BUTTON) {
            return 210;
        } else if(position == POSITION_SELECT_BUTTON) {
            return 30;
        }
        return 0;
    }
}