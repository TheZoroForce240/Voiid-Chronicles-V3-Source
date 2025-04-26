import Type;
import funkin.backend.MusicBeatState;
import funkin.backend.MusicBeatSubstate;

function update(elapsed:Float)
	if (FlxG.keys.justPressed.F5) {
		var nextState = Type.createInstance(Type.getClass(FlxG.state), []);
		if ((Std.isOfType(FlxG.state, MusicBeatState) || Std.isOfType(FlxG.state, MusicBeatSubstate)) && (Std.isOfType(nextState, MusicBeatState) || Std.isOfType(nextState, MusicBeatSubstate))) {			
			nextState.scriptName = FlxG.state.scriptName;
		}
		FlxG.switchState(nextState);
	}