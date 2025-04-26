import flixel.input.keyboard.FlxKey;
import funkin.backend.assets.ModsFolder;
import haxe.xml.Access;
import haxe.xml.Parser;
import flixel.input.gamepad.FlxGamepadInputID;
import haxe.xml.Printer;
import Xml;

/*var defaultKeyBinds:Array<Dynamic> = [
    ["SPACE"],
    ["D", "K"],
    ["D", "SPACE", "K"],
    ["D", "F", "J", "K"], //ignored
    ["D", "F", "SPACE", "J", "K"],
    ["S", "D", "F", "J", "K", "L"],
    ["S", "D", "F", "SPACE", "J", "K", "L"],
    ["A", "S", "D", "F", "H", "J", "K", "L"],
    ["A", "S", "D", "F", "SPACE", "H", "J", "K", "L"]
];
var defaultAltKeyBinds:Array<Dynamic> = [
    [""],
    ["LEFT", "RIGHT"],
    ["LEFT", "", "RIGHT"],
    ["LEFT", "DOWN", "UP", "RIGHT"], //ignored
    ["LEFT", "DOWN", "", "UP", "RIGHT"],
    ["", "", "", "LEFT", "DOWN", "RIGHT"],
    ["", "", "", "", "LEFT", "DOWN", "RIGHT"],
    ["", "", "", "", "LEFT", "DOWN", "UP", "RIGHT"],
    ["", "", "", "", "", "LEFT", "DOWN", "UP", "RIGHT"]
];*/

function create()
{	
	loadBinds();
}

public function loadBinds()
{
	//trace('checking controls');
	//load multikey binds
	var xmlPath = Paths.xml('multikeyData');
	if (!Assets.exists(xmlPath))
	{
		trace('multikey data is missing!');
		return;
	}
	var plainXML = Assets.getText(xmlPath);
	var mainXML = Xml.parse(plainXML);

	var kc = 0;
	for (keyData in mainXML.elementsNamed("defaultBinds"))
	{
		for (keyGroup in keyData.elementsNamed("keyGroup"))
		{
			var knum = 0;
			for (key in keyGroup.elementsNamed("key")) //get key data
			{
				if (Reflect.getProperty(FlxG.save.data, (kc+1)+"k"+knum) == null) //check if it doesnt exist already
				{
					if (key.get("bind") != "")
						Reflect.setProperty(FlxG.save.data, (kc+1)+"k"+knum, FlxKey.fromString(key.get("bind")));	
					else
						Reflect.setProperty(FlxG.save.data, (kc+1)+"k"+knum, 0);			
				}

				if (Reflect.getProperty(FlxG.save.data, (kc+1)+"k"+knum+"p2") == null)
				{
					if (key.get("bindP2") != "")
						Reflect.setProperty(FlxG.save.data, (kc+1)+"k"+knum+"p2", FlxKey.fromString(key.get("bindP2")));
					else 
						Reflect.setProperty(FlxG.save.data, (kc+1)+"k"+knum+"p2", 0);
				}

				if (Reflect.getProperty(FlxG.save.data, (kc+1)+"k"+knum+"gamepad") == null)
				{
					if (key.get("gamepadBind") != "")
						Reflect.setProperty(FlxG.save.data, (kc+1)+"k"+knum+"gamepad", FlxGamepadInputID.fromString(key.get("gamepadBind")));
					else 
						Reflect.setProperty(FlxG.save.data, (kc+1)+"k"+knum+"gamepad", -1);
				}
				if (Reflect.getProperty(FlxG.save.data, (kc+1)+"k"+knum+"gamepadP2") == null)
				{
					if (key.get("gamepadBindP2") != "")
						Reflect.setProperty(FlxG.save.data, (kc+1)+"k"+knum+"gamepadP2", FlxGamepadInputID.fromString(key.get("gamepadBindP2")));
					else 
						Reflect.setProperty(FlxG.save.data, (kc+1)+"k"+knum+"gamepadP2", -1);
				}

				knum++;
			}
			kc++;
		}
	}
}

public function resetBindsForKeyCount(kc:Int)
{
	for (i in 0...kc)
	{
		Reflect.setProperty(FlxG.save.data, (kc)+"k"+i, null);
		Reflect.setProperty(FlxG.save.data, (kc)+"k"+i+"p2", null);
	}
	loadBinds();
}