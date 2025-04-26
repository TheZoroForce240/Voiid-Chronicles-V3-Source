package debuggers;

import flixel.addons.ui.FlxUICheckBox;
import haxe.Json;
import flixel.math.FlxMath;
import game.StageGroup;
import flixel.addons.ui.FlxSlider;
import shaders.Shaders.RTXEffect;
import shaders.Shaders.RTXShader;
import flixel.ui.FlxButton;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import ui.FlxUIDropDownMenuCustom;
import states.MusicBeatState;
import states.VoiidMainMenuState;
import states.PlayState;
import utilities.CoolUtil;
import game.Character;
import game.Boyfriend;
import flixel.system.FlxSound;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;
/**
	*DEBUG MODE
 */
class RTXDebug extends MusicBeatState
{
	var rtxShader:RTXEffect = new RTXEffect();
	var stageGroup:StageGroup;
	var char:Character;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	var characters:Map<String, Array<String>> = [
		"default" => ["bf", "gf"]
	];

	var modListLmao:Array<String> = ["default"];
	var curCharList:Array<String>;
	var curStageList:Array<String>;

	var offset_Button:FlxButton;
	var charDropDown:FlxUIDropDownMenuCustom;
	var stageDropDown:FlxUIDropDownMenuCustom;
	var modDropDown:FlxUIDropDownMenuCustom;

	/* CAMERA */
	var gridCam:FlxCamera;
	var charCam:FlxCamera;
	var camHUD:FlxCamera;


	var overlayR:Float = 0;
	var overlayG:Float = 0;
	var overlayB:Float = 0;
	var overlayA:Float = 0;
	var overlaySpr:FlxSprite;
	var overlayTxt:FlxText;

	var satinR:Float = 0;
	var satinG:Float = 0;
	var satinB:Float = 0;
	var satinA:Float = 0;
	var satinSpr:FlxSprite;
	var satinTxt:FlxText;

	var innerR:Float = 0;
	var innerG:Float = 0;
	var innerB:Float = 0;
	var innerA:Float = 0;
	var innerSpr:FlxSprite;
	var innerTxt:FlxText;

	var fakeChar = new Character(0, 0, "");

	var hueSlider:FixedSlider;

	var light:FlxSprite = new FlxSprite();
	var lightCheckBox:FlxUICheckBox;

	override function create()
	{
		FlxG.mouse.visible = true;

		gridCam = new FlxCamera();
		charCam = new FlxCamera();
		charCam.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset();
		FlxG.cameras.add(gridCam, false);
		FlxG.cameras.add(charCam, true);
		FlxG.cameras.add(camHUD, false);

		FlxG.cameras.setDefaultDrawTarget(charCam, true);

		FlxG.camera = charCam;

		if(FlxG.sound.music.active)
			FlxG.sound.music.stop();

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0, 0);
		gridBG.cameras = [gridCam];
		add(gridBG);

		char = new Character(0, 0, daAnim);
		char.debugMode = true;
		char.shader = rtxShader.shader;
		rtxShader.parentSprite = char;
		char.rtxShader = rtxShader;
		add(char);

		var moveText = new FlxText(2, 2, 0, "Use IJKL to move the camera\nE and Q to zoom the camera\nSHIFT for faster moving offset or camera\n", 20);
		moveText.x = FlxG.width - moveText.width;
		moveText.scrollFactor.set();
		moveText.color = FlxColor.BLUE;
		moveText.alignment = RIGHT;
		moveText.cameras = [camHUD];
		add(moveText);

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.sound.playMusic(Paths.music('breakfast'));
		
		charCam.follow(camFollow);

		var characterData:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));

		char.screenCenter();

		for(item in characterData)
		{
			var characterDataVal:Array<String> = item.split(":");

			var charName:String = characterDataVal[0];
			var charMod:String = characterDataVal[1];

			var charsLmao:Array<String> = [];

			if(characters.exists(charMod))
				charsLmao = characters.get(charMod);
			else
				modListLmao.push(charMod);

			charsLmao.push(charName);
			characters.set(charMod, charsLmao);
		}

		curCharList = characters.get("default");
		curStageList = CoolUtil.coolTextFile(Paths.txt('stageList'));

		charDropDown = new FlxUIDropDownMenuCustom(10, 500, FlxUIDropDownMenu.makeStrIdLabelArray(curCharList, true), function(character:String)
		{
			remove(char);
			char.kill();
			char.destroy();

			daAnim = curCharList[Std.parseInt(character)];
			char = new Character(0, 0, daAnim, FlxG.keys.pressed.SHIFT);
			char.debugMode = true;
			char.shader = rtxShader.shader;
			rtxShader.parentSprite = char;
			char.rtxShader = rtxShader;
			add(char);
			char.screenCenter();

			if (FlxG.keys.pressed.SHIFT)
				stageGroup.setCharOffsets(char, fakeChar, fakeChar);
			else 
				stageGroup.setCharOffsets(fakeChar, fakeChar, char);
			
			camFollow.setPosition(char.getGraphicMidpoint().x, char.getGraphicMidpoint().y);
		});

		charDropDown.selectedLabel = daAnim;
		charDropDown.scrollFactor.set();
		charDropDown.cameras = [camHUD];
		add(charDropDown);





		modDropDown = new FlxUIDropDownMenuCustom(charDropDown.x + charDropDown.width + 1, charDropDown.y, FlxUIDropDownMenu.makeStrIdLabelArray(modListLmao, true), function(modID:String)
		{
			var mod:String = modListLmao[Std.parseInt(modID)];

			if(characters.exists(mod))
			{
				curCharList = characters.get(mod);
				charDropDown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(curCharList, true));
				charDropDown.selectedLabel = curCharList[0];

				remove(char);
				char.kill();
				char.destroy();

				daAnim = curCharList[0];
				char = new Character(0, 0, daAnim);
				char.debugMode = true;
				char.shader = rtxShader.shader;
				rtxShader.parentSprite = char;
				char.rtxShader = rtxShader;
				add(char);
				char.screenCenter();

				stageGroup.setCharOffsets(char, fakeChar, fakeChar);
				camFollow.setPosition(char.getGraphicMidpoint().x, char.getGraphicMidpoint().y);
			}
		});

		light = new FlxSprite().makeGraphic(20, 20);
		add(light);

		

		modDropDown.selectedLabel = "default";
		modDropDown.scrollFactor.set();
		modDropDown.cameras = [camHUD];
		add(modDropDown);

		stageGroup = new StageGroup("stage");
		insert(0, stageGroup);

		stageDropDown = new FlxUIDropDownMenuCustom(modDropDown.x + modDropDown.width + 1, modDropDown.y, FlxUIDropDownMenu.makeStrIdLabelArray(curStageList, true), function(stage:String)
		{
			remove(stageGroup);
			stageGroup.kill();
			stageGroup.destroy();

			stageGroup = new StageGroup(curStageList[Std.parseInt(stage)]);
			insert(0, stageGroup);

			@:privateAccess
			hueSlider._object = stageGroup.colorSwap;

			stageGroup.setCharOffsets(char, fakeChar, fakeChar);
			camFollow.setPosition(char.getGraphicMidpoint().x, char.getGraphicMidpoint().y);
		});

		stageDropDown.selectedLabel = "stage";
		stageDropDown.scrollFactor.set();
		stageDropDown.cameras = [camHUD];
		add(stageDropDown);



		var overlayRSlider = new FixedSlider(this, "overlayR", 10, 10, 0, 1, 100, 15, 3, 0xFFFF0000);
		overlayRSlider.scrollFactor.set();
		overlayRSlider.cameras = [camHUD];
		add(overlayRSlider);

		var overlayGSlider = new FixedSlider(this, "overlayG", 10, 10+40, 0, 1, 100, 15, 3, 0xFF00FF00);
		overlayGSlider.scrollFactor.set();
		overlayGSlider.cameras = [camHUD];
		add(overlayGSlider);

		var overlayBSlider = new FixedSlider(this, "overlayB", 10, 10+80, 0, 1, 100, 15, 3, 0xFF0000FF);
		overlayBSlider.scrollFactor.set();
		overlayBSlider.cameras = [camHUD];
		add(overlayBSlider);

		var overlayASlider = new FixedSlider(this, "overlayA", 10, 10+120, 0, 1, 100, 15, 3, 0xFF000000);
		overlayASlider.scrollFactor.set();
		overlayASlider.cameras = [camHUD];
		add(overlayASlider);

		overlaySpr = new FlxSprite(overlayASlider.x+10, overlayASlider.y+60).makeGraphic(100, 100);
		overlaySpr.scrollFactor.set();
		overlaySpr.cameras = [camHUD];
		add(overlaySpr);

		overlayTxt = new FlxText(overlayASlider.x+10, overlaySpr.y+110,0, "", 16);
		overlayTxt.color = FlxColor.BLUE;
		overlayTxt.scrollFactor.set();
		overlayTxt.cameras = [camHUD];
		add(overlayTxt);

		var satinRSlider = new FixedSlider(this, "satinR", 160, 10, 0, 1, 100, 15, 3, 0xFFFF0000);
		satinRSlider.scrollFactor.set();
		satinRSlider.cameras = [camHUD];
		add(satinRSlider);

		var satinGSlider = new FixedSlider(this, "satinG", 160, 10+40, 0, 1, 100, 15, 3, 0xFF00FF00);
		satinGSlider.scrollFactor.set();
		satinGSlider.cameras = [camHUD];
		add(satinGSlider);

		var satinBSlider = new FixedSlider(this, "satinB", 160, 10+80, 0, 1, 100, 15, 3, 0xFF0000FF);
		satinBSlider.scrollFactor.set();
		satinBSlider.cameras = [camHUD];
		add(satinBSlider);

		var satinASlider = new FixedSlider(this, "satinA", 160, 10+120, 0, 1, 100, 15, 3, 0xFF000000);
		satinASlider.scrollFactor.set();
		satinASlider.cameras = [camHUD];
		add(satinASlider);

		satinSpr = new FlxSprite(satinASlider.x+10, satinASlider.y+60).makeGraphic(100, 100);
		satinSpr.scrollFactor.set();
		satinSpr.cameras = [camHUD];
		add(satinSpr);

		satinTxt = new FlxText(satinASlider.x+10, satinSpr.y+110,0, "", 16);
		satinTxt.color = FlxColor.BLUE;
		satinTxt.scrollFactor.set();
		satinTxt.cameras = [camHUD];
		add(satinTxt);


		var innerRSlider = new FixedSlider(this, "innerR", 310, 10, 0, 1, 100, 15, 3, 0xFFFF0000);
		innerRSlider.scrollFactor.set();
		innerRSlider.cameras = [camHUD];
		add(innerRSlider);

		var innerGSlider = new FixedSlider(this, "innerG", 310, 10+40, 0, 1, 100, 15, 3, 0xFF00FF00);
		innerGSlider.scrollFactor.set();
		innerGSlider.cameras = [camHUD];
		add(innerGSlider);

		var innerBSlider = new FixedSlider(this, "innerB", 310, 10+80, 0, 1, 100, 15, 3, 0xFF0000FF);
		innerBSlider.scrollFactor.set();
		innerBSlider.cameras = [camHUD];
		add(innerBSlider);

		var innerASlider = new FixedSlider(this, "innerA", 310, 10+120, 0, 1, 100, 15, 3, 0xFF000000);
		innerASlider.scrollFactor.set();
		innerASlider.cameras = [camHUD];
		add(innerASlider);

		innerSpr = new FlxSprite(innerASlider.x+10, innerASlider.y+60).makeGraphic(100, 100);
		innerSpr.scrollFactor.set();
		innerSpr.cameras = [camHUD];
		add(innerSpr);

		innerTxt = new FlxText(innerASlider.x+10, innerSpr.y+110,0, "", 16);
		innerTxt.color = FlxColor.BLUE;
		innerTxt.scrollFactor.set();
		innerTxt.cameras = [camHUD];
		add(innerTxt);


		var angleSlider = new FixedSlider(rtxShader, "innerShadowAngle", 460, 10, 0, 360, 100, 15, 3, 0xFF000000);
		angleSlider.scrollFactor.set();
		angleSlider.cameras = [camHUD];
		add(angleSlider);

		var distanceSlider = new FixedSlider(rtxShader, "innerShadowDistance", 460, 10+40, 0, 30, 100, 15, 3, 0xFF000000);
		distanceSlider.scrollFactor.set();
		distanceSlider.cameras = [camHUD];
		add(distanceSlider);

		hueSlider = new FixedSlider(stageGroup.colorSwap, "hue", 460, 10+120, 0, 1, 100, 15, 3, 0xFF000000);
		hueSlider.scrollFactor.set();
		hueSlider.cameras = [camHUD];
		add(hueSlider);

		lightCheckBox = new FlxUICheckBox(charDropDown.x, charDropDown.y - 150, null, null, "Point Light", 100);
		lightCheckBox.scrollFactor.set();
		lightCheckBox.cameras = [camHUD];
		add(lightCheckBox);


		var saveButton = new FlxButton(charDropDown.x, charDropDown.y - 100, "Save", function() {saveLevel();});
		saveButton.scrollFactor.set();
		saveButton.cameras = [camHUD];
		add(saveButton);

		var loadRTXButton = new FlxButton(saveButton.x, saveButton.y + 25, "Load from stage", function() 
		{
			@:privateAccess
			var rtxData = stageGroup.stage_Data.rtxData;

			if (rtxData == null) //doesnt exist to ignore
				return;

			//load in data

			var overlay = FlxColor.fromString(rtxData.overlay);
			var satin = FlxColor.fromString(rtxData.satin);
			var inner = FlxColor.fromString(rtxData.inner);

			overlayR = overlay.redFloat;
			overlayG = overlay.greenFloat;
			overlayB = overlay.blueFloat;
			overlayA = rtxData.overlayAlpha;

			satinR = satin.redFloat;
			satinG = satin.greenFloat;
			satinB = satin.blueFloat;
			satinA = rtxData.satinAlpha;

			innerR = inner.redFloat;
			innerG = inner.greenFloat;
			innerB = inner.blueFloat;
			innerA = rtxData.innerAlpha;

			rtxShader.innerShadowAngle = rtxData.innerAngle;
			rtxShader.innerShadowDistance = rtxData.innerDistance;

			if (rtxData.pointLight != null)
			{
				lightCheckBox.checked = rtxData.pointLight;
				light.x = rtxData.lightX;
				light.y = rtxData.lightY;
			}
			


		});
		loadRTXButton.scrollFactor.set();
		loadRTXButton.cameras = [camHUD];
		add(loadRTXButton);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.E)
			charCam.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			charCam.zoom -= 0.25;

		var shiftThing:Int = FlxG.keys.pressed.SHIFT ? 5 : 1;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90 * shiftThing;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90 * shiftThing;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90 * shiftThing;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90 * shiftThing;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.pressed.LEFT)
			light.x -= 100*elapsed*shiftThing;
		if (FlxG.keys.pressed.RIGHT)
			light.x += 100*elapsed*shiftThing;
		if (FlxG.keys.pressed.UP)
			light.y -= 100*elapsed*shiftThing;
		if (FlxG.keys.pressed.DOWN)
			light.y += 100*elapsed*shiftThing;


		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new VoiidMainMenuState());

		rtxShader.overlayColor.setRGBFloat(overlayR, overlayG, overlayB, overlayA);
		overlaySpr.color = rtxShader.overlayColor;
		overlayTxt.text = rtxShader.overlayColor.toHexString(false);
		rtxShader.satinColor.setRGBFloat(satinR, satinG, satinB, satinA);
		satinSpr.color = rtxShader.satinColor;
		satinTxt.text = rtxShader.satinColor.toHexString(false);
		rtxShader.innerShadowColor.setRGBFloat(innerR, innerG, innerB, innerA);
		innerSpr.color = rtxShader.innerShadowColor;
		innerTxt.text = rtxShader.innerShadowColor.toHexString(false);
		//rtxShader.update(elapsed);

		rtxShader.lightX = light.x;
		rtxShader.lightY = light.y;
		rtxShader.pointLight = lightCheckBox.checked;

		rtxShader.hue = stageGroup.colorSwap.hue;
		rtxShader.updateColorShift(); //always update here
		
		super.update(elapsed);
	}


	var _file:FileReference;
	private function saveLevel()
	{	

		var rtxData:RTXData = {
			overlay: rtxShader.overlayColor.toHexString(false),
			overlayAlpha: overlayA,
			satin: rtxShader.satinColor.toHexString(false),
			satinAlpha: satinA,
			inner: rtxShader.innerShadowColor.toHexString(false),
			innerAlpha: innerA,
			innerDistance: rtxShader.innerShadowDistance,
			innerAngle: rtxShader.innerShadowAngle,
			pointLight: rtxShader.pointLight,
			lightX: rtxShader.lightX,
			lightY: rtxShader.lightY,
		};

		trace(rtxData);

		@:privateAccess
		{
			stageGroup.stage_Data.rtxData = rtxData; //save rtx data
			var data:String = Json.stringify(stageGroup.stage_Data, null, "\t");

			if ((data != null) && (data.length > 0))
			{
				_file = new FileReference();
				_file.addEventListener(Event.COMPLETE, onSaveComplete);
				_file.addEventListener(Event.CANCEL, onSaveCancel);
				_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
	
				_file.save(data.trim(), stageDropDown.selectedLabel + ".json");
			}
		}
		


	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	/**
		* Called when the save file dialog is cancelled.
		*/
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
		* Called if there is an error while saving the gameplay recording.
		*/
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}
}


class FixedSlider extends FlxSlider
{
	var boundsObject = new FlxObject();
	override public function update(elapsed:Float):Void
	{
		boundsObject.setPosition(_bounds.x, _bounds.y);
		boundsObject.setSize(_bounds.width, _bounds.height);
		//_bounds.overlaps()
		var mousePos = FlxG.mouse.getWorldPosition(camera);
		// Clicking and sound logic
		if (boundsObject.overlapsPoint(mousePos, false, camera))
		{
			if (hoverAlpha != 1)
			{
				alpha = hoverAlpha;
			}

			#if FLX_SOUND_SYSTEM
			if (hoverSound != null && !_justHovered)
			{
				FlxG.sound.play(hoverSound);
			}
			#end

			_justHovered = true;

			if (FlxG.mouse.pressed)
			{
				handle.x = mousePos.x;
				updateValue();

				#if FLX_SOUND_SYSTEM
				if (clickSound != null && !_justClicked)
				{
					FlxG.sound.play(clickSound);
					_justClicked = true;
				}
				#end
			}
			if (!FlxG.mouse.pressed)
			{
				_justClicked = false;
			}
		}
		else
		{
			if (hoverAlpha != 1)
			{
				alpha = 1;
			}

			_justHovered = false;
		}

		// Update the target value whenever the slider is being used
		if ((FlxG.mouse.pressed) && (FlxMath.mouseInFlxRect(true, _bounds)))
		{
			updateValue();
		}

		// Update the value variable
		if ((varString != null) && (Reflect.getProperty(_object, varString) != null))
		{
			value = Reflect.getProperty(_object, varString);
		}

		// Changes to value from outside update the handle pos
		if (handle.x != expectedPos)
		{
			handle.x = expectedPos;
		}

		// Finally, update the valueLabel
		valueLabel.text = Std.string(FlxMath.roundDecimal(value, decimals));

		//super.update(elapsed);
		group.update(elapsed);

		if (moves)
			updateMotion(elapsed);
	}
}