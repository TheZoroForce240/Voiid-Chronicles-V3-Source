
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;

var stillPressed:Bool = true;

function create()
{
}

function postUpdate(elapsed:Float) 
{
	if (stillPressed && controls.ACCEPT)
		return;
	
	stillPressed = false;

	if (multikeyRebindController)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			multikeyControlsCancelCallback();
			close();
			return;
		}
		var gamepad = FlxG.gamepads.getFirstActiveGamepad();
		if (gamepad == null) return;

		var key = gamepad.firstJustPressedID();
		if (key <= 0) return;

		multikeyControlsCallback(key);
		close();
	}
	else
	{
		var key = FlxG.keys.firstJustPressed();
		if (key <= 0) return;
	
		if (key == FlxKey.ESCAPE && !FlxG.keys.pressed.SHIFT) {
			multikeyControlsCancelCallback();
			close();
			return;
		}
		multikeyControlsCallback(key);
		close();
	}
}
