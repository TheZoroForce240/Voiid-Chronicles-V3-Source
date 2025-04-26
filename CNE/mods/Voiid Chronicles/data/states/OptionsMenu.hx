import funkin.options.type.TextOption;
import funkin.options.OptionsScreen;
import funkin.options.keybinds.ChangeKeybindSubState;
import flixel.input.gamepad.FlxGamepadInputID;
import funkin.backend.MusicBeatSubstate;
import flixel.input.keyboard.FlxKey;
import haxe.io.Path;
import funkin.backend.scripting.Script;
import haxe.xml.Access;
import haxe.xml.Parser;
import haxe.xml.Printer;
import Xml;

public static var multikeyControlsCallback = null;
public static var multikeyControlsCancelCallback = null;
public static var multikeyRebindController = false;

function create()
{
	importScript("data/scripts/controlsCheck.hx");
}
var keyCountMenuNames = [];
var keyOptionsData = [];
function postCreate()
{

    //
    //custom menu shits

	var xmlPath = Paths.xml('multikeyData');
	if (!Assets.exists(xmlPath))
	{
		trace('multikey data is missing!');
		return;
	}
	var plainXML = Assets.getText(xmlPath);
	var mainXML = Xml.parse(plainXML);



	var kc = 0;
	//get menu data
	for (keyData in mainXML.elementsNamed("defaultBinds"))
	{
		for (keyGroup in keyData.elementsNamed("keyGroup"))
		{
			var knum = 0;
			keyCountMenuNames.push(keyGroup.get("name"));
			keyOptionsData.push([]);
			for (key in keyGroup.elementsNamed("key")) //get key data
			{
				keyOptionsData[kc].push([key.get("name"), (kc+1)+"k"+knum]);
				knum++;
			}
			kc++;
		}
	}
	kc = 0; 
	//now need to get the note anim
	for (keyData in mainXML.elementsNamed("keyData"))
	{
		for (keyGroup in keyData.elementsNamed("keyGroup"))
		{
			var knum = 0;
			for (key in keyGroup.elementsNamed("key")) //get key data
			{
				keyOptionsData[kc][knum].push(key.get("note"));
				knum++;
			}
			kc++;
		}
	}

	main.add(new TextOption("Multikey Controls >", "", function() {
		var menu = new OptionsScreen("Multikey Controls", "", [
			new TextOption("Keyboard >", "", function() {
				var keyCountMenus = [];
				var i = 0;
				for (menuData in keyOptionsData)
				{
					var menuName = keyCountMenuNames[i];
					if (i != 3) //ignore 4k
					{
						//submenu for each key count
						var option = new TextOption(menuName, "", function()
						{
							//create options
							var subOptions = [];
							for (optionData in menuData)
								subOptions.push(setupOption(optionData[0], optionData[1], optionData[2]));
							for (optionData in menuData)
								subOptions.push(setupOption(optionData[0] + " P2", optionData[1]+"p2", optionData[2]));
			
							var subMenu = new OptionsScreen(menuName, "", subOptions);
							optionsTree.add(subMenu);
						});
						keyCountMenus.push(option);
					}
					i++;
				}

				var menu = new OptionsScreen("Keyboard", "", keyCountMenus);
				optionsTree.add(menu);
			}),
			new TextOption("Gamepad >", "", function() {

				var keyCountMenus = [];
				var i = 0;
				for (menuData in keyOptionsData)
				{
					var menuName = keyCountMenuNames[i];
					var option = new TextOption(menuName, "", function()
					{
						var subOptions = [];
						for (optionData in menuData)
							subOptions.push(setupOptionGamepad(optionData[0], optionData[1]+"gamepad", optionData[2]));
						for (optionData in menuData)
							subOptions.push(setupOptionGamepad(optionData[0] + " P2", optionData[1]+"gamepadP2", optionData[2]));
		
						var subMenu = new OptionsScreen(menuName, "", subOptions);
						optionsTree.add(subMenu);
					});
					keyCountMenus.push(option);
					i++;
				}

				var menu = new OptionsScreen("Gamepad", "", keyCountMenus);
				optionsTree.add(menu);

			})
		]);
        optionsTree.add(menu);
	}));

}

function setupOption(name:String, savePath:String, arrow:String)
{
    var option:TextOption;
    option = new TextOption("", "", function()
    {
        openKeybindMenu(option, name, savePath, false);
    });
    option.__text.isBold = false;
    option.text = name + ": " + CoolUtil.keyToString(Reflect.getProperty(FlxG.save.data, savePath));
    option.__text.y -= 65;

    //arrow icon
    var icon = new FlxSprite();
    icon.frames = Paths.getFrames("game/notes/default");
    icon.antialiasing = true;
    icon.animation.addByPrefix('icon', arrow + "0", 24, true);
    icon.animation.play('icon');
    icon.setGraphicSize(75, 75);
    icon.updateHitbox();
    var min = Math.min(icon.scale.x, icon.scale.y);
    icon.scale.set(min, min);
    option.add(icon);

    return option;
}

function setupOptionGamepad(name:String, savePath:String, arrow:String)
{
	var option:TextOption;
	option = new TextOption("", "", function()
	{
		openKeybindMenu(option, name, savePath, true);
	});
	option.__text.isBold = false;
	var bind = FlxGamepadInputID.toStringMap.get(Reflect.getProperty(FlxG.save.data, savePath));
	option.text = name + ": " + (bind == null ? "---" : bind);
	option.__text.y -= 65;

	//arrow icon
	var icon = new FlxSprite();
	icon.frames = Paths.getFrames("game/notes/default");
	icon.antialiasing = true;
	icon.animation.addByPrefix('icon', arrow + "0", 24, true);
	icon.animation.play('icon');
	icon.setGraphicSize(75, 75);
	icon.updateHitbox();
	var min = Math.min(icon.scale.x, icon.scale.y);
	icon.scale.set(min, min);
	option.add(icon);

	return option;
}

function openKeybindMenu(option:TextOption, name:String, savePath:String, gamepad:Bool)
{
    persistentUpdate = false;
	multikeyRebindController = gamepad;

	var s = new MusicBeatSubstate(true, "MultikeyChangeBindSubstate");
	openSubState(s);
	

	multikeyControlsCallback = function(key:FlxKey)
	{
		Reflect.setProperty(FlxG.save.data, savePath, key);
        FlxG.save.flush();
		if (gamepad)
		{
			var bind = FlxGamepadInputID.toStringMap.get(Reflect.getProperty(FlxG.save.data, savePath));
			option.text = name + ": " + (bind == null ? "---" : bind);
		}
		else
		{
			option.text = name + ": " + CoolUtil.keyToString(Reflect.getProperty(FlxG.save.data, savePath));
		}
		multikeyControlsCallback = null;
		multikeyControlsCancelCallback = null;
	};
	multikeyControlsCancelCallback = function()
	{
        Reflect.setProperty(FlxG.save.data, savePath, 0);
        FlxG.save.flush();
		if (gamepad)
		{
			var bind = FlxGamepadInputID.toStringMap.get(Reflect.getProperty(FlxG.save.data, savePath));
			option.text = name + ": " + (bind == null ? "---" : bind);
		}
		else
		{
			option.text = name + ": " + CoolUtil.keyToString(Reflect.getProperty(FlxG.save.data, savePath));
		}
		multikeyControlsCallback = null;
		multikeyControlsCancelCallback = null;
	};
}