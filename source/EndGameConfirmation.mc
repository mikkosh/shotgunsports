using Toybox.WatchUi;
using Toybox.System;

/**
 * EndGameConfirmationDelegate is used when the used ends the round of shooting and is asked if the session data should be saved
 */
class EndGameConfirmationDelegate extends WatchUi.ConfirmationDelegate {

    private var model = null;

    function initialize(_model) {
        ConfirmationDelegate.initialize();
        model = _model;
    }

    function onResponse(response) {
        if (response == WatchUi.CONFIRM_NO) {
            // do not save the session data
            model.endGame(false);
        } else {
            // save the session data
            model.endGame(true);
        }
        return true;
    }
}