package ui;

import flixel.math.FlxMath;
import game.Conductor;
import states.PlayState;
import flixel.FlxCamera;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import substates.BloomMenu;
import substates.ImportHighscoresSubstate;
import game.Highscore;
import openfl.events.FullScreenEvent;
import substates.ScrollSpeedMenu;
import substates.NoteColorSubstate;
import substates.NoteBGAlphaMenu;
#if discord_rpc
import utilities.Discord.DiscordClient;
#end

import substates.JudgementMenu;
import substates.MaxFPSMenu;
import modding.ModList;
import substates.SongOffsetMenu;
import flixel.FlxSprite;
import substates.UISkinSelect;
import substates.ControlMenuSubstate;
import flixel.FlxState;
import states.OptionsMenu;
import flixel.FlxG;
import flixel.group.FlxGroup;

/**
 * The base option class that all options inherit from.
 */
class Option extends FlxTypedGroup<FlxSprite>
{
	// variables //
	public var Alphabet_Text:Alphabet;

	// options //
	public var Option_Row:Int = 0;

	public var Option_Name:String = "";
	public var Option_Value:String = "downscroll";

	public var enabled:Bool = true;
	
	public function new(_Option_Name:String = "", _Option_Value:String = "downscroll", _Option_Row:Int = 0)
	{
		super();

		// SETTING VALUES //
		this.Option_Name = _Option_Name;
		this.Option_Value = _Option_Value;
		this.Option_Row = _Option_Row;

		var scaleShit = (20 / Option_Name.length);
		if (Option_Name.length <= 20)
			scaleShit = 1;

		// CREATING OTHER OBJECTS //
		Alphabet_Text = new Alphabet(20, 20 + (Option_Row * 100), Option_Name, true, false, scaleShit);
		Alphabet_Text.isMenuItem = true;
		Alphabet_Text.targetY = Option_Row;
		add(Alphabet_Text);
	}

	public function getAlphabetWidth()
	{
		return Alphabet_Text.width;
	}
	public function isSelected()
	{
		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				if (Std.int(Alphabet_Text.targetY) == 0)
				{
					var cam:FlxCamera = FlxG.camera;
					if (PlayState.instance != null && FlxG.state == PlayState.instance)
						cam = PlayState.instance.camHUD;
					if (MobileControls.checkTouchOverlap(touch, Alphabet_Text.x, Alphabet_Text.y, getAlphabetWidth(), Alphabet_Text.height, cam))
					{
						return true;
					}
				}
			}
		}
		#end
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		if (gamepad != null)
		{
			if (gamepad.anyJustPressed([FlxGamepadInputID.A, FlxGamepadInputID.START]))
			{
				return true;
			}
		}
		return FlxG.keys.justPressed.ENTER;
	}
}

/**
 * Simple Option with a checkbox that changes a bool value.
 */
class BoolOption extends Option
{
	// variables //
	var Checkbox_Object:Checkbox;

	// options //
	public var Option_Checked:Bool = false;

	override public function new(_Option_Name:String = "", _Option_Value:String = "downscroll", _Option_Row:Int = 0)
	{
		super(_Option_Name, _Option_Value, _Option_Row);

		// SETTING VALUES //
		this.Option_Checked = GetObjectValue();

		// CREATING OTHER OBJECTS //
		Checkbox_Object = new Checkbox(Alphabet_Text);
		Checkbox_Object.checked = GetObjectValue();
		add(Checkbox_Object);
	}

	public function GetObjectValue():Bool { return utilities.Options.getData(Option_Value); }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
            ChangeValue();
    }
	override public function getAlphabetWidth()
	{
		return Alphabet_Text.width + Checkbox_Object.width + 5;
	}

    public function ChangeValue()
    {
		utilities.Options.setData(!Option_Checked, Option_Value);

		Option_Checked = !Option_Checked;
        Checkbox_Object.checked = Option_Checked;
		
		switch(Option_Value) // extra special cases
		{
			case "fpsCounter":
				Main.toggleFPS(Option_Checked);
			case "memoryCounter":
				Main.toggleMem(Option_Checked);
			#if discord_rpc
			case "discordRPC":
				if(Option_Checked && !DiscordClient.active)
					DiscordClient.initialize();
				else if(!Option_Checked && DiscordClient.active)
					DiscordClient.shutdown();
			#end
			case "versionDisplay":
				Main.toggleVers(Option_Checked);
		}
    }
}

/**
* Very simple option that transfers you to a different page when selecting it.
*/
class PageOption extends Option
{
    // OPTIONS //
    public var Page_Name:String = "Categories";

    override public function new(_Option_Name:String = "", _Option_Row:Int = 0, _Page_Name:String = "Categories")
    {
        super(_Option_Name, _Page_Name, _Option_Row);

        // SETTING VALUES //
        this.Page_Name = _Page_Name;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Std.int(Alphabet_Text.targetY) == 0 && !OptionsMenu.inMenu && enabled)
            OptionsMenu.LoadPage(Page_Name);
    }
}

/**
* Option that opens the control menu when selected.
*/
class ControlMenuSubStateOption extends Option
{
    public function new(_Option_Name:String = "", _Option_Row:Int = 0)
    {
        super(_Option_Name, null, _Option_Row);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new ControlMenuSubstate());
    }
}

/**
* Option that opens the ui skin menu when selected.
*/
class UISkinSelectOption extends Option
{
    public function new(_Option_Name:String = "", _Option_Row:Int = 0)
    {
        super(_Option_Name, null, Option_Row);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled && !OptionsMenu.inMenu)
			FlxG.state.openSubState(new UISkinSelect());
    }
}

/**
* Option that opens the song offset menu when selected.
*/
class SongOffsetOption extends Option
{
    public function new(_Option_Name:String = "", _Option_Row:Int = 0)
    {
        super(_Option_Name, null, _Option_Row);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new SongOffsetMenu());
    }
}

/**
* Very simple option that transfers you to a different game-state when selecting it.
*/
class GameStateOption extends Option
{
    // OPTIONS //
    public var Game_State:FlxState;

    public function new(_Option_Name:String = "", _Option_Row:Int = 0, _Game_State:Dynamic)
    {
        super(_Option_Name, null, _Option_Row);

        // SETTING VALUES //
        this.Game_State = _Game_State;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.switchState(Game_State);
    }
}

#if sys
/**
 * Option for enabling and disabling mods.
 */
 class ModOption extends FlxTypedGroup<FlxSprite>
 {
	// variables //
	public var Alphabet_Text:Alphabet;
	public var Mod_Icon:ModIcon;

	public var Mod_Enabled:Bool = false;

	// options //
	public var Option_Row:Int = 0;

	public var Option_Name:String = "";
	public var Option_Value:String = "Template Mod";
	
	public function new(_Option_Name:String = "", _Option_Value:String = "Template Mod", _Option_Row:Int = 0)
	{
		super();

		// SETTING VALUES //
		this.Option_Name = _Option_Name;
		this.Option_Value = _Option_Value;
		this.Option_Row = _Option_Row;

		// CREATING OTHER OBJECTS //
		Alphabet_Text = new Alphabet(20, 20 + (Option_Row * 100), Option_Name, true);
		Alphabet_Text.isMenuItem = true;
		Alphabet_Text.targetY = Option_Row;
		add(Alphabet_Text);

		Mod_Icon = new ModIcon(Option_Value);
		Mod_Icon.sprTracker = Alphabet_Text;
		add(Mod_Icon);

		Mod_Enabled = ModList.modList.get(Option_Value);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(FlxG.keys.justPressed.ENTER && Alphabet_Text.targetY == 0)
		{
			Mod_Enabled = !Mod_Enabled;
			ModList.setModEnabled(Option_Value, Mod_Enabled);
		}

		if(Mod_Enabled)
		{
			Alphabet_Text.alpha = 1;
			Mod_Icon.alpha = 1;
		}
		else
		{
			Alphabet_Text.alpha = 0.6;
			Mod_Icon.alpha = 0.6;
		}
	}
}
#end

/**
* Option that opens the max fps menu when selected.
*/
class MaxFPSOption extends Option
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new MaxFPSMenu());
    }
}

/**
* Option that opens the judgement menu when selected.
*/
class JudgementMenuOption extends Option
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new JudgementMenu());
    }
}

class BloomMenuOption extends Option
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new BloomMenu());
    }
}


/**
* Option that opens the note bg alpha menu when selected.
*/
class NoteBGAlphaMenuOption extends Option
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new NoteBGAlphaMenu());
    }
}

/**
* Option that opens the note color menu when selected.
*/
class NoteColorMenuOption extends Option
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new NoteColorSubstate());
    }
}

/**
* Option that opens the scroll speed menu when selected.
*/
class ScrollSpeedMenuOption extends Option
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new ScrollSpeedMenu());
    }
}

/**
* Option that opens the ImportOldHighscore menu when selected.
*/
class ImportOldHighscoreOption extends Option
{
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Alphabet_Text.targetY == 0 && enabled)
			FlxG.state.openSubState(new ImportHighscoresSubstate());
    }
}

/**
* A Option for save data that is saved a string with multiple pre-defined states (aka like accuracy option or cutscene option)
*/
class StringSaveOption extends Option
{
	// VARIABLES //
	var Current_Mode:String = "option 2";
	var Modes:Array<String> = ["option 1", "option 2", "option 3"];
	var Cool_Name:String;
	var Save_Data_Name:String;

	var addSaveString:Bool = true;
    override public function new(_Option_Name:String = "String Switcher", _Modes:Array<String>, _Option_Row:Int = 0, _Save_Data_Name:String = "hitsound", addSaveString:Bool = true)
    {
        super(_Option_Name, null, _Option_Row);

        // SETTING VALUES //
		this.Modes = _Modes;
		this.Save_Data_Name = _Save_Data_Name;
		this.Current_Mode = utilities.Options.getData(Save_Data_Name);
		this.Cool_Name = _Option_Name;
		this.addSaveString = addSaveString;
		if (addSaveString)
		{
			this.Option_Name = Cool_Name + " " + Current_Mode;
		}
		else 
		{
			this.Option_Name = Cool_Name;
		}

		var scaleShit = (20 / Option_Name.length);
		if (Option_Name.length <= 20)
			scaleShit = 1;
		Alphabet_Text.scaleMult = scaleShit;
        // CREATING OTHER OBJECTS //
		Alphabet_Text.setText(Option_Name);
		Alphabet_Text.xAdd = -20;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(isSelected() && Std.int(Alphabet_Text.targetY) == 0 && !OptionsMenu.inMenu && enabled)
        {
			var prevIndex = Modes.indexOf(Current_Mode);

			if(prevIndex != -1)
			{
				if(prevIndex + 1 > Modes.length - 1)
					prevIndex = 0;
				else
					prevIndex++;
			}
			else
				prevIndex = 0;

			Current_Mode = Modes[prevIndex];

			if (addSaveString)
			{
				this.Option_Name = Cool_Name + " " + Current_Mode;
			}
			else 
			{
				this.Option_Name = Cool_Name;
			}

			var scaleShit = (20 / Option_Name.length);
			if (Option_Name.length <= 20)
				scaleShit = 1;
			Alphabet_Text.scaleMult = scaleShit;
			Alphabet_Text.setText(Option_Name);

			SetDataIGuess();
		}
    }

	function SetDataIGuess()
	{
		utilities.Options.setData(Current_Mode, Save_Data_Name);
	}
}
class LanguageOption extends StringSaveOption
{
	var langText:FlxText;
	override public function new(_Option_Name:String = "String Switcher", _Modes:Array<String>, _Option_Row:Int = 0, _Save_Data_Name:String = "hitsound", addSaveString:Bool = true)
	{
		super(_Option_Name, _Modes, _Option_Row, _Save_Data_Name, addSaveString);
		langText = new FlxText(0,0,0, ""+Current_Mode);
		langText.setFormat(Paths.font("Contb___.ttf"), 64, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(langText);
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		langText.text = Current_Mode+"";
		langText.x = Alphabet_Text.x+(Alphabet_Text.width)+40;
		langText.y = Alphabet_Text.y+(Alphabet_Text.height*0.5)-(langText.height*0.5);
	}
	override public function getAlphabetWidth()
	{
		return Alphabet_Text.width + langText.width + 40;
	}
}

class TimeSkipOption extends Option
{
	public static var curTime:Float = 0;
	override public function new()
	{
		super("Time Skip", "", 0);
		curTime = Conductor.songPosition;
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (Std.int(Alphabet_Text.targetY) == 0)
		{
			var shiftMult = 1.0;
			if (FlxG.keys.pressed.SHIFT)
				shiftMult = 10.0;
			if (FlxG.keys.justPressed.LEFT)
				curTime -= 1000*shiftMult;
			else if (FlxG.keys.justPressed.RIGHT)
				curTime += 1000*shiftMult;
	
			curTime = FlxMath.bound(curTime, Conductor.songPosition, FlxG.sound.music.length);
			Alphabet_Text.setText("Skip To Time: " + flixel.util.FlxStringUtil.formatTime(curTime/1000, false));
		}


		if(isSelected() && Std.int(Alphabet_Text.targetY) == 0 && enabled)
		{
			//PlayState.instance.closeSubState();
			//PlayState.instance.noteTimer.skipped = false;
			//PlayState.instance.noteTimer.skipToTime(curTime);
			//enabled = false;
		}
	}
}


class DisplayFontOption extends StringSaveOption { override function SetDataIGuess() { super.SetDataIGuess(); Main.changeFont(utilities.Options.getData("infoDisplayFont")); } }