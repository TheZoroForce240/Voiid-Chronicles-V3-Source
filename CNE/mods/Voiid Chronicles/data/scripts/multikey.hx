import funkin.backend.scripting.events.StrumCreationEvent;
import funkin.backend.scripting.events.DirectionAnimEvent;
import funkin.system.FunkinSprite;
import funkin.backend.scripting.events.PlayAnimEvent;
import funkin.backend.scripting.events.AmountEvent;
import funkin.backend.scripting.EventManager;
import flixel.input.keyboard.FlxKey;
import funkin.backend.chart.Chart;
import haxe.Json;
import haxe.xml.Access;
import haxe.xml.Parser;
#if ENCRYPTED_FILES
import voiid.FileEncrypt;
#end
import haxe.xml.Printer;
#if !mobile
import flixel.ui.FlxButton;
#end
import Xml;
import Int; //this is needed for Std.isOfType
import String;
import Array;

public var maniaChanges:Array<Array<Dynamic>> = [];

public var strumLineKeyCounts:Int = [4,4,4];
public var strumLineSwagWidths:Float = [112,112,112];
public var strumLineNoteScales:Float = [0.7,0.7,0.7];

var changingMania = false;
var playFadeIn = true;

var maxKeyCount = 0;

//for each keycount
public var multikeyScales:Array<Float> = [];
public var multikeyWidths:Array<Float> = [];
public var multikeyOffsets:Array<Float> = [];

//for each key of each keycount
public var multikeySingDirs:Array<Array<Int>> = [];
public var multikeySplashIDs:Array<Array<Int>> = [];
public var multikeyStrumAnims:Array<Array<String>> = [];
public var multikeyNoteAnims:Array<Array<String>> = [];

var multikeyMobileHitboxes = [];

public var multikeyXML = null;

function loadMultikeyData()
{
	var xmlPath = Paths.xml('multikeyData');
	if (!Assets.exists(xmlPath))
	{
		trace('multikey data is missing!');
		return;
	}
		
	var plainXML = Assets.getText(xmlPath);
	var mainXML = Xml.parse(plainXML);
	multikeyXML = mainXML;
	
	var kc = 0;
	for (keyData in mainXML.elementsNamed("keyData"))
	{
		for (keyGroup in keyData.elementsNamed("keyGroup"))
		{
			multikeyScales.push(Std.parseFloat(keyGroup.get("scale")));
			multikeyWidths.push(Std.parseFloat(keyGroup.get("gapWidth")));
			multikeyOffsets.push(Std.parseFloat(keyGroup.get("xOffset")));

			multikeySingDirs.push([]);
			multikeySplashIDs.push([]);
			multikeyStrumAnims.push([]);
			multikeyNoteAnims.push([]);
			for (key in keyGroup.elementsNamed("key")) //get key data
			{
				multikeySingDirs[kc].push(Std.parseInt(key.get("singDir")));
				multikeySplashIDs[kc].push(Std.parseInt(key.get("splashID")));
				multikeyStrumAnims[kc].push([key.get("strumStatic"),key.get("strumConfirm"),key.get("strumPress")]);
				multikeyNoteAnims[kc].push([key.get("note"),key.get("noteHold"),key.get("noteHoldEnd")]);
			}
			kc++;
		}
	}
	maxKeyCount = kc;
}
public function getKeyCountIndex(strumlineID:Int)
{
	return getCappedKeyCount(strumlineID)-1;
}
public function getCappedKeyCount(strumlineID:Int)
{
	var kc = strumLineKeyCounts[strumlineID];
	if (kc > multikeyScales.length) //prevent errors and allow for an almost inf amount of keys
		kc = multikeyScales.length;
	return kc;
}

var controlsList:Array<Array<Int>> = [];
var controlsListP2:Array<Array<Int>> = [];

var controlsGamepadList:Array<Array<Int>> = [];
var controlsGamepadListP2:Array<Array<Int>> = [];

function onPreGenerateStrums(event)
{
    //event.amount = keyCount;
	event.cancel();
	for(p in 0...strumLines.members.length)
		strumLines.members[p].generateStrums(strumLineKeyCounts[p]);


	scripts.event("onPostGenerateStrums", event);
}

function onStrumCreation(event) 
{

    event.cancel();

	var kc = getKeyCountIndex(event.player);

    var strum = event.strum;
    strum.frames = Paths.getFrames(event.sprite);
    strum.antialiasing = true;
    strum.setGraphicSize(Std.int((strum.width * strumLineNoteScales[event.player] * strumLines.members[event.player].strumScale)));

    strum.animation.addByPrefix('static', multikeyStrumAnims[kc][strum.ID][0]);
    strum.animation.addByPrefix('pressed', multikeyStrumAnims[kc][strum.ID][2], 24, false);
    strum.animation.addByPrefix('confirm', multikeyStrumAnims[kc][strum.ID][1], 24, false);

	//reposition strum
	strum.x = strumLines.members[event.player].startingPos.x + ((strumLineSwagWidths[event.player] * strumLines.members[event.player].strumScale) * strum.ID);
    strum.x += multikeyOffsets[kc];
    strum.updateHitbox();

	//strum.y += 112*0.5; //move down to center for 4k
	//strum.y -= 160*strumLineNoteScales[event.player] * strumLines.members[event.player].strumScale*0.5;

    //controls
	var curControls = controlsList[kc];
	var curControlsP2 = controlsListP2[kc];
	var curControlsGamepad = controlsGamepadList[kc];
	var curControlsGamepadP2 = controlsGamepadListP2[kc];
	if (PlayState.coopMode)
	{
		var controlGroup = curControls;
		if (event.player == 0)
			controlGroup = curControlsP2;
		strum.getPressed = function(strumline:StrumLine)
		{
			return FlxG.keys.anyPressed([controlGroup[strum.ID%controlGroup.length]]);
		}
		strum.getJustPressed = function(strumline:StrumLine)
		{
			return FlxG.keys.anyJustPressed([controlGroup[strum.ID%controlGroup.length]]);
		}
		strum.getJustReleased = function(strumline:StrumLine)
		{
			return FlxG.keys.anyJustReleased([controlGroup[strum.ID%controlGroup.length]]);
		}
	}  
	else 
	{
		//input for keyboard, gamepad and mobile
		strum.getPressed = function(strumline:StrumLine)
		{
			var gamepadPress = false;
			var gamepad = FlxG.gamepads.getFirstActiveGamepad();
			if (gamepad != null && gamepad.anyPressed([curControlsGamepad[strum.ID%curControlsGamepad.length], curControlsGamepadP2[strum.ID%curControlsGamepad.length]]))
				gamepadPress = true;
				
			return FlxG.keys.anyPressed([curControls[strum.ID%curControls.length], curControlsP2[strum.ID%curControlsP2.length]]) || gamepadPress #if mobile || multikeyMobileHitboxes[strum.ID % multikeyMobileHitboxes.length].pressed #end;
		}
		strum.getJustPressed = function(strumline:StrumLine)
		{
			var gamepadPress = false;
			var gamepad = FlxG.gamepads.getFirstActiveGamepad();
			if (gamepad != null && gamepad.anyJustPressed([curControlsGamepad[strum.ID%curControlsGamepad.length], curControlsGamepadP2[strum.ID%curControlsGamepad.length]]))
				gamepadPress = true;

			return FlxG.keys.anyJustPressed([curControls[strum.ID%curControls.length], curControlsP2[strum.ID%curControlsP2.length]]) || gamepadPress #if mobile || multikeyMobileHitboxes[strum.ID % multikeyMobileHitboxes.length].justPressed #end;
		}
		strum.getJustReleased = function(strumline:StrumLine)
		{
			var gamepadPress = false;
			var gamepad = FlxG.gamepads.getFirstActiveGamepad();
			if (gamepad != null && gamepad.anyJustReleased([curControlsGamepad[strum.ID%curControlsGamepad.length], curControlsGamepadP2[strum.ID%curControlsGamepad.length]]))
				gamepadPress = true;

			return FlxG.keys.anyJustReleased([curControls[strum.ID%curControls.length], curControlsP2[strum.ID%curControlsP2.length]]) || gamepadPress #if mobile || multikeyMobileHitboxes[strum.ID % multikeyMobileHitboxes.length].justReleased #end;
		}
	}

    if (changingMania)
    {
        event.__doAnimation = playFadeIn;
    }
}

function onNoteCreation(event) {

	event.cancel();

	if (maniaChanges[event.strumLineID].length > 0)
	{
		for (mc in maniaChanges[event.strumLineID])
		{
			if (event.note.strumTime > mc[0])
			{
				strumLineKeyCounts[event.strumLineID] = mc[1]; //set while creating note
			}
		}
	}

	var kc = getKeyCountIndex(event.strumLineID);

	var note = event.note;
	note.frames = Paths.getFrames(event.noteSprite);

	var strumScale = strumLines.members[event.strumLineID].strumScale;

	note.noteData = note.noteData % strumLineKeyCounts[event.strumLineID];

    note.animation.addByPrefix('scroll', multikeyNoteAnims[kc][note.noteData][0]);
    note.animation.addByPrefix('hold', multikeyNoteAnims[kc][note.noteData][1]);
    note.animation.addByPrefix('holdend', multikeyNoteAnims[kc][note.noteData][2]);
    if (note.isSustainNote)
		note.scale.set(multikeyScales[kc]*strumScale, event.noteScale);
    else 
        note.scale.set(multikeyScales[kc]*strumScale, multikeyScales[kc]*strumScale);

	note.updateHitbox();

    if (maniaChanges[event.strumLineID] != null && maniaChanges[event.strumLineID].length > 0)
        strumLineKeyCounts[event.strumLineID] = maniaChanges[event.strumLineID][0][1]; //reset to default
}

function create()
{
	loadMultikeyData();
    strumLineKeyCounts = [];
	maniaChanges = [];
	for (i in 0...strumLines.members.length)
	{
		strumLineKeyCounts.push(4);
		maniaChanges.push([]);
	}
    
	var chartPath = Paths.chart(PlayState.SONG.meta.name, PlayState.difficulty);
	var data:SwagSong = null;
	if (Assets.exists(chartPath))
	{
		#if ENCRYPTED_FILES
		var t = FileEncrypt.decryptString(chartPath);
		#else 
		var t = Assets.getText(chartPath);
		#end
		data = Json.parse(t);
	}

	var doParse = true;
	if (data.codenameChart != null && data.codenameChart)
	{
		doParse = false; //its a codename chart so ignore
	}

	if (PlayState.SONG.meta.customValues != null)
	{
		//back compat with old system because im too lazy
		if (Reflect.getProperty(PlayState.SONG.meta.customValues, PlayState.difficulty + "_keyCount") != null)
		{
			var kc = Std.parseInt(Reflect.getProperty(PlayState.SONG.meta.customValues, PlayState.difficulty + "_keyCount")); //set keycount from metadata

			for (i in 0...strumLines.members.length)
			{
				maniaChanges[i].push([-10000, kc]); //effect all strumlines
			}
		}
	}

	//setup keycount and mania changes
	for (event in events)
	{
		if (event.name == "Set Key Count" || event.name == "Change Key Count") 
		{
			if (event.name == "Change Key Count" || event.params[2])
			{
				for (i in 0...strumLines.members.length)
				{
					maniaChanges[i].push([event.time, event.params[0]]); //effect all strumlines
				}
			}
			else
			{
				maniaChanges[event.params[3]].push([event.time, event.params[0]]);
			}
		}
	}

	if (maniaChanges.length > 0)
	{
		for (i in 0...maniaChanges.length)
		{
			if (maniaChanges[i].length > 0)
			{
				//make sure the changes are sorted
				maniaChanges[i].sort(function(a, b) {
					if(a[0] < b[0]) return -1;
					else if(a[0] > b[0]) return 1;
					else return 0;
				});
				strumLineKeyCounts[i] = maniaChanges[i][0][1]; //set to the first change in list
				maniaChanges[i][0][0] = -10000;
			}
		}
	}


	if (doParse) //need to reparse chart to allow for noteData over 4
	{
		//trace('Parsing Multikey chart: ' + keyCount);
		for (str in PlayState.SONG.strumLines) //clear existing notes
		{
			while(str.notes.length > 0)
				str.notes.remove(str.notes[0]);
		}
			
		
		if (data.song.notes != null)
		{
			for (section in data.song.notes)
			{
				if (section != null)
				{
					for(note in section.sectionNotes)
					{
						//if (note[1] < 0) continue;

						var daStrumTime:Float = note[0];

						var keyCount = 4;
						var playerKeyCount = 4;
						if (maniaChanges[0].length > 0) //just parse using the first keycount in the changes
						{
							for (mc in maniaChanges[0])
							{
								if (daStrumTime > mc[0])
								{
									keyCount = mc[1];
								}
							}
						}
						if (maniaChanges[1].length > 0) //just parse using the first keycount in the changes
						{
							for (mc in maniaChanges[1])
							{
								if (daStrumTime > mc[0])
								{
									playerKeyCount = mc[1];
								}
							}
						}

						var daNoteData:Int = Std.int(note[1] % (keyCount+playerKeyCount));

						if (section.mustHitSection && daNoteData >= playerKeyCount)
						{
							daNoteData -= playerKeyCount;
							daNoteData %= keyCount;
						}
						else if (!section.mustHitSection && daNoteData >= keyCount)
						{
							daNoteData -= keyCount;
							daNoteData %= playerKeyCount;
						}

						var daNoteType:Int = 0;
						var gottaHitNote:Bool = section.mustHitSection;
						if(note[1] >= (!gottaHitNote ? keyCount : playerKeyCount))
							gottaHitNote = !section.mustHitSection;

						var noteTypeSuffix:String = "";
		
						if (note.length > 2) {
							if (Std.isOfType(note[3], Int)) {
								noteTypeSuffix = "char["+Std.string(note[3])+"]";
								daNoteType = Chart.addNoteType(PlayState.SONG, noteTypeSuffix);
							} else if (Std.isOfType(note[3], String)) {
								daNoteType = Chart.addNoteType(PlayState.SONG, note[3]);
							} else if (Std.isOfType(note[3], Array)) {
								noteTypeSuffix = "char"+Std.string(note[3]);
								daNoteType = Chart.addNoteType(PlayState.SONG, noteTypeSuffix);
							}
						} else {
							if(data.noteTypes != null)
								daNoteType = Chart.addNoteType(PlayState.SONG, data.noteTypes[daNoteType-1]);
						}
						if (note[4] != null && note[4] != "default") {
							daNoteType = Chart.addNoteType(PlayState.SONG, note[4]+noteTypeSuffix);
						}
		
						PlayState.SONG.strumLines[gottaHitNote ? 1 : 0].notes.push({
							time: daStrumTime,
							id: daNoteData,
							type: daNoteType,
							sLen: note[2]
						});
					}
				}
			}
		}     
	}

	for (i in 0...maniaChanges.length)
	{
		if (maniaChanges[i].length > 0)
		{
			strumLineKeyCounts[i] = maniaChanges[i][0][1]; //set to first keycount
		}
	}
		
	controlsList = []; 
	controlsListP2 = [];
	controlsGamepadList = []; 
	controlsGamepadListP2 = [];
	//load controls
	importScript("data/scripts/controlsCheck.hx");
	for (kc in 0...maxKeyCount)
	{
		controlsList.push([]);
		controlsListP2.push([]);
		controlsGamepadList.push([]);
		controlsGamepadListP2.push([]);
        
        for (i in 0...(kc+1))
        {
			if (kc == 3) //use regular controls for 4k keyboard
			{
				switch(i)
				{
					case 0:
						controlsList[kc].push(Options.P1_NOTE_LEFT[0]);
						controlsListP2[kc].push(Options.P2_NOTE_LEFT[0]);
					case 1:
						controlsList[kc].push(Options.P1_NOTE_DOWN[0]);
						controlsListP2[kc].push(Options.P2_NOTE_DOWN[0]);
					case 2:
						controlsList[kc].push(Options.P1_NOTE_UP[0]);
						controlsListP2[kc].push(Options.P2_NOTE_UP[0]);
					case 3:
						controlsList[kc].push(Options.P1_NOTE_RIGHT[0]);
						controlsListP2[kc].push(Options.P2_NOTE_RIGHT[0]);
				}
			}
			else
			{
				var k = Reflect.getProperty(FlxG.save.data, (kc+1) + "k" + i);
				controlsList[kc].push(k);
				var kp2 = Reflect.getProperty(FlxG.save.data, (kc+1) + "k" + i + "p2");
				controlsListP2[kc].push(kp2);
			}


			var kg = Reflect.getProperty(FlxG.save.data, (kc+1) + "k" + i + "gamepad");
			if (kg == -1)
				kg = -100;
            controlsGamepadList[kc].push(kg);
            var kgp2 = Reflect.getProperty(FlxG.save.data, (kc+1) + "k" + i + "gamepadP2");
			if (kgp2 == -1)
				kgp2 = -100;
            controlsGamepadListP2[kc].push(kgp2);
        }
	}
	
	//store widths and scales for later
    strumLineSwagWidths = [];
	strumLineNoteScales = [];
	for (i in 0...strumLineKeyCounts.length)
	{
		strumLineSwagWidths.push(multikeyWidths[getKeyCountIndex(i)] * 0.7);
		strumLineNoteScales.push(multikeyScales[getKeyCountIndex(i)]);
	}
}
function postCreate()
{
	#if mobile
	for (i in 0...strumLineKeyCounts.length)
		if (!strumLines.members[i].cpu)
			loadMobileHitboxes(strumLineKeyCounts[i]);
	#end
}

var splashScaleMult = 1.428; // 1 / 0.7, to match with note scale
var splashScales:Map<String, Float> = [];

function onNoteHit(event)
{
    var index = event.note.strumID;
    event.direction = multikeySingDirs[getKeyCountIndex(event.note.strumLine.ID)][index]; //fix sing anims

    if (event.direction == 4) //space note
    {
        var char = event.characters[0];
		event.direction = 2;
        if (char.animation.getByName("singUP-SPACE") != null)
        {
            event.animSuffix = "-SPACE";
        }        
    }

    //splashes
    if (event.showSplash)
    {
        event.showSplash = false;

		//
        event.note.__strum.ID = multikeySplashIDs[getKeyCountIndex(event.note.strumLine.ID)][index]; //need to set id to play correct anim
        //splashHandler.showSplash(event.note.splash, event.note.__strum);

		//show splash func (but we need to keep the splash sprite for after)
		splashHandler.__grp = splashHandler.getSplashGroup(event.note.splash);
		var splash = splashHandler.__grp.showOnStrum(event.note.__strum);
		splashHandler.add(splash);
		// max 8 rendered splashes
		while(splashHandler.members.length > 8)
			splashHandler.remove(splashHandler.members[0], true);

		event.note.__strum.ID = event.note.strumID; //now set id back

		
		if (!splashScales.exists(event.note.splash))
		{
			splashScales.set(event.note.splash, splash.scale.x); //store scale in case it needs it
		}
		var scale:Float = splashScales.get(event.note.splash);
		
		splash.shader = event.note.__strum.shader;

		//set splash scale and position properly
		splash.scale.set(
			strumLineNoteScales[event.note.strumLine.ID]*splashScaleMult*scale, 
			strumLineNoteScales[event.note.strumLine.ID]*splashScaleMult*scale);
		splash.updateHitbox();
		splash.setPosition(
			event.note.__strum.x + ((event.note.__strum.width - splash.width) / 2), 
			event.note.__strum.y + ((event.note.__strum.height - splash.height) / 2));
    }
}
function onPlayerMiss(event)
{
	if (event.animCancelled)
		return;
	
    event.animCancelled = true;
	var directionID = multikeySingDirs[getKeyCountIndex(event.playerID)][event.direction];
    for(char in event.characters) {
        if (char == null) continue;

        if(event.stunned) char.stunned = true;
        char.playSingAnim(directionID, event.animSuffix, 1, event.forceAnim);
    }
}

function changeKeyCount(kc, doAnim, strumlineID)
{
	if (strumLineKeyCounts[strumlineID] == kc)
		return;

    strumLineKeyCounts[strumlineID] = kc;
	for (strum in strumLines.members[strumlineID])
	{
		strum.kill();
		strumLines.members[strumlineID].remove(strum, true);
		strum.destroy();
	}
    strumLines.members[strumlineID].clear();

	strumLineSwagWidths[strumlineID] = multikeyWidths[getKeyCountIndex(strumlineID)] * 0.7;
	strumLineNoteScales[strumlineID] = multikeyScales[getKeyCountIndex(strumlineID)];

	if (!strumLines.members[strumlineID].cpu) //player strumline? might break if multiple with different key counts
	{
		#if mobile
		loadMobileHitboxes(strumLineKeyCounts[1]);
		#end
	}
    
    changingMania = true;
    playFadeIn = doAnim;
	strumLines.members[strumlineID].generateStrums(strumLineKeyCounts[strumlineID]);
	scripts.call("onPostManiaChange", [strumlineID]);
}

function onEvent(event)
{
    if (event.event.name == "Set Key Count" || event.event.name == "Change Key Count")
    {
		if (event.event.name == "Change Key Count" || event.event.params[2]) //change all strumlines and back compact with old event
		{
			for (i in 0...strumLines.members.length)
			{
				changeKeyCount(event.event.params[0], event.event.params[1], i);
			}
		}
		else
		{
			changeKeyCount(event.event.params[0], event.event.params[1], event.event.params[3]);
		}
    }
}

function loadMobileHitboxes(targetKc)
{
	#if mobile
	for (i in mobileControls.hitbox)
		mobileControls.hitbox.remove(i);
	#end
	multikeyMobileHitboxes = [];
	var kc = 1;
	for (keyData in multikeyXML.elementsNamed("mobileHitboxes"))
	{
		for (keyGroup in keyData.elementsNamed("keyGroup"))
		{
			if (kc == targetKc)
			{
				for (key in keyGroup.elementsNamed("key")) //get key data
				{
					var x = FlxG.width * Std.parseFloat(key.get("xPercent"));
					var y = FlxG.height * Std.parseFloat(key.get("yPercent"));
					var w = FlxG.width * Std.parseFloat(key.get("widthPercent"));
					var h = FlxG.height * Std.parseFloat(key.get("heightPercent"));
					var color = FlxColor.fromString(key.get("color"));
					
					#if !mobile
					var spr = new FlxButton(x,y);
					spr.makeGraphic(1,1, color);
					spr.setGraphicSize(w, h);
					spr.updateHitbox();
					spr.cameras = [camHUD];
					spr.alpha = 0.5;
					add(spr);
					multikeyMobileHitboxes.push(spr);
					#end

					#if mobile
					var spr = mobileControls.hitbox.createHint(x, y, Std.int(w), Std.int(h), color);
					mobileControls.hitbox.add(spr);
					multikeyMobileHitboxes.push(spr);
					#end
				}
				break;
			}

			kc++;
		}
	}
}