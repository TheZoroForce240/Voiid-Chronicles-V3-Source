import funkin.editors.ui.UISliceSprite;
import funkin.game.HudCamera;
import funkin.menus.FreeplayState;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UIDropDown;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UIFileExplorer;
import funkin.editors.ui.UIWindow;
import funkin.editors.ui.UISprite;
import funkin.editors.ui.UISlider;
import funkin.editors.ui.UIUtil;
import funkin.editors.ui.UITopMenu;
import funkin.editors.ui.UISubstateWindow;
import funkin.backend.utils.SortedArrayUtil;
import flixel.input.keyboard.FlxKey;
import funkin.backend.utils.ShaderResizeFix;
import flixel.addons.display.FlxBackdrop;
import openfl.ui.MouseCursor;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import haxe.xml.Printer;
import funkin.game.Stage;
import Xml;
import ModchartEventObjects;
import UIScrollBarHorizontal;


public static var CURRENT_EVENT:EventObject = null; //event used by edit substate
public static var EVENT_EDIT_CALLBACK:Void->Void = null;
public static var EVENT_EDIT_CANCEL_CALLBACK:Void->Void = null;
public static var EVENT_DELETE_CALLBACK:Void->Void = null;

public static var CURRENT_XML:Xml;

var shaderList:Array<String> = [];
var shaders:Map<String, CustomShader> = [];
var iTimeShaders = [];
var iTimeWithSpeedShaders = [];

var easeMap = ["" => function(t) {return t;}];

var defaultValueList = ["" => null];
var currentValueList = ["" => null];
var eventIndexMap = ["" => 0];
var events = [];
var eventGroup = null;
var eventGroupContainer = null;

var timelineList = [];
var timelineValueTextList = [];

var noteModchart:Bool = false;
var noteModifiers:Array<String> = [];

var conductorSprY:Float = 0.0;
var vocals:FlxSound;

var songPosInfo:UIText;

public var camGame:FlxCamera;
public var camHUD:HudCamera;
public var camOther:FlxCamera;

var camEditor:FlxCamera;
var camEditorTop:FlxCamera;
var camTimelineList:FlxCamera;
var camTimelineValueList:FlxCamera;
var camTimeline:FlxCamera;

var scrollBar:UIScrollBarHorizontal;

var timelineWindow:UIWindow;
var beatSeparator:FlxBackdrop;
var sectionSeparator:FlxBackdrop;

var hoverBox:FlxSprite;

var stage:Stage;
var defaultCamZoom:Float = 1;
var stagePreviewMode = false;

var xml:Xml;

var ROW_SIZE = 20;

var topMenu = [];

var selectionBox:UISliceSprite;
var selectedEvents = [];
var clipboard = [];

public var strumLines = [];
public var downscroll = Options.downscroll;

function postCreate() {

	topMenu = [
		{
			label: "File",
			childs: [
				{
					label: "Save",
					keybind: [FlxKey.CONTROL, FlxKey.S],
					onSelect: _save
				},
				{
					label: "Save (Optimized)",
					onSelect: _save_opt
				},
				null,
				{
					label: "Exit",
					keybind: [FlxKey.ESCAPE],
					onSelect: _exit
				}
			]
		},
		{
			label: "Edit",
			childs: [
				/*{
					label: "Undo",
					keybind: [FlxKey.CONTROL, FlxKey.Z],
					onSelect: _edit_undo
				},
				{
					label: "Redo",
					keybinds: [[FlxKey.CONTROL, FlxKey.Y], [FlxKey.CONTROL, FlxKey.SHIFT, FlxKey.Z]],
					onSelect: _edit_redo
				},
				null,*/
				{
					label: "Copy",
					keybind: [FlxKey.CONTROL, FlxKey.C],
					onSelect: _edit_copy
				},
				{
					label: "Paste",
					keybind: [FlxKey.CONTROL, FlxKey.V],
					onSelect: _edit_paste
				},
				null,
				{
					label: "Cut",
					keybind: [FlxKey.CONTROL, FlxKey.X],
					onSelect: _edit_cut
				},
				{
					label: "Delete",
					keybind: [FlxKey.DELETE],
					onSelect: _edit_delete
				},
				null,
				{
					label: "Shift Selection Left",
					keybind: [FlxKey.SHIFT, FlxKey.LEFT],
					onSelect: _edit_shiftleft
				},
				{
					label: "Shift Selection Right",
					keybind: [FlxKey.SHIFT, FlxKey.RIGHT],
					onSelect: _edit_shiftright
				}
			]
		},
		{
			label: "Modchart",
			childs: [
				{
					label: "Edit Shaders and Modifiers",
					onSelect: _modchart_editshaders
				}
			]
		},
		{
			label: "View",
			childs: [
				{
					label: "Fullscreen",
					keybind: [FlxKey.F],
					onSelect: _view_fullscreen
				},
				{
					label: "Swap Scroll",
					onSelect: _view_downscroll
				}
			]
		},
		{
			label: "Song",
			childs: [
				{
					label: "Go back to the start",
					keybind: [FlxKey.HOME],
					onSelect: _song_start
				},
				{
					label: "Go to the end",
					keybind: [FlxKey.END],
					onSelect: _song_end
				},
				null,
				{
					label: "Mute instrumental",
					onSelect: _song_muteinst
				},
				{
					label: "Mute voices",
					onSelect: _song_mutevoices
				}
			]
		},
		{
			label: "Playback >",
			childs: [
				{
					label: "Play/Pause",
					keybind: [FlxKey.SPACE],
					onSelect: _playback_play
				},
				null,
				{
					label: "↑ Speed 25%",
					onSelect: _playback_speed_raise
				},
				{
					label: "Reset Speed",
					onSelect: _playback_speed_reset
				},
				{
					label: "↓ Speed 25%",
					onSelect: _playback_speed_lower
				},
				null,
				{
					label: "Go back a section",
					keybind: [FlxKey.A],
					onSelect: _playback_back
				},
				{
					label: "Go forward a section",
					keybind: [FlxKey.D],
					onSelect: _playback_forward
				}
			]
		}
	];



	defaultValueList.clear();
	currentValueList.clear();

	camGame = FlxG.camera;

	camHUD = new HudCamera();
	camHUD.bgColor = 0;
	camHUD.downscroll = downscroll;
	FlxG.cameras.add(camHUD);

	camOther = new FlxCamera();
	camOther.bgColor = 0;
	FlxG.cameras.add(camOther);

	camEditor = new FlxCamera();
	camEditor.bgColor = 0;
	FlxG.cameras.add(camEditor);

	camEditorTop = new FlxCamera();
	camEditorTop.bgColor = 0;
	FlxG.cameras.add(camEditorTop);

	var tmSpr = new UITopMenu(topMenu);
	tmSpr.scrollFactor.set(1,1);
	tmSpr.cameras = [camEditorTop];
	add(tmSpr);

	camTimelineList = new FlxCamera(0, 720/2, 200, 720/2);
	camTimelineList.bgColor = 0;
	FlxG.cameras.add(camTimelineList);

	camTimelineValueList = new FlxCamera(200, 720/2, 50, 720/2);
	camTimelineValueList.bgColor = 0;
	FlxG.cameras.add(camTimelineValueList);

	camTimeline = new FlxCamera(250, 720/2, 1280-250, 720/2);
	camTimeline.bgColor = 0;
	FlxG.cameras.add(camTimeline);

	//bg = new FlxSprite();
	//bg.loadGraphic(Paths.image('menus/menuBG'));
	//bg.color = 0xFF777777;
	//add(bg);
	//bg.cameras = [camGame];

	if (PlayState.SONG.stage == null) PlayState.SONG.stage = "stage";
	stage = new Stage(PlayState.SONG.stage);
	for (obj in stage.stageSprites) {
		obj.cameras = [camGame];
	}
	if (stage.stageXML.exists("zoom")) {
		defaultCamZoom = Std.parseFloat(stage.stageXML.get("zoom"));
	}

	FlxG.mouse.visible = true;

	createStrumlines();

	songPosInfo = new UIText(FlxG.width - 30 - 400, 35, 400, "00:00\nBeat: 0\nStep: 0\nMeasure: 0\nBPM: 0\nTime Signature: 4/4");
	songPosInfo.alignment = "right";
	songPosInfo.cameras = [camEditor];
	songPosInfo.scrollFactor.set(0,0);
	if (!stagePreviewMode) add(songPosInfo);

	timelineWindow = new UIWindow(0,720-320, 1280,320, "Timeline");
	timelineWindow.cameras = [camEditor];
	add(timelineWindow);
	
	scrollBar = new UIScrollBarHorizontal();
	scrollBar.newnew(250, timelineWindow.y+5, 1000, 0, 10, 1280-270, 20);
	scrollBar.cameras = [camEditor];
	scrollBar.onChange = function(v) {
		if (!FlxG.sound.music.playing)
			Conductor.songPosition = Conductor.getTimeForStep(v) + Conductor.songOffset;
	}
	add(scrollBar);

	hoverBox = new FlxSprite(-100,0);
	hoverBox.makeGraphic(1,1);
	hoverBox.setGraphicSize(ROW_SIZE,ROW_SIZE);
	hoverBox.updateHitbox();
	hoverBox.cameras = [camTimeline];
	add(hoverBox);


	loadSong();
	loadEvents();
	buildXMLFromEvents();

	

	for (shaderName in shaderList) {
		for (name => val in defaultValueList) {
			if (StringTools.startsWith(name, shaderName+".")) {
				if (!timelineList.contains(name)) {
					timelineList.push(name);
				}
			}
		}
	}



	var valueBG = new FlxSprite(0,0);
	valueBG.makeGraphic(1,1);
	valueBG.setGraphicSize(50,1280);
	valueBG.updateHitbox();
	valueBG.color = 0xff302e32;
	valueBG.cameras = [camTimelineValueList];
	valueBG.scrollFactor.set();
	add(valueBG);
	
	var i = 0;
	for (name in timelineList) {
		var text = new UIText(10, (ROW_SIZE*i),0, name, 15);
		text.cameras = [camTimelineList];
		add(text);
		var line = new FlxSprite(0,(ROW_SIZE*(i+1)));
		line.makeGraphic(1,1);
		line.setGraphicSize(200,2);
		line.updateHitbox();
		line.cameras = [camTimelineList, camTimelineValueList];
		line.alpha = 0.5;
		add(line);

		var line2 = new FlxSprite(0,(ROW_SIZE*(i+1)));
		line2.makeGraphic(1,1);
		line2.setGraphicSize(1280,2);
		line2.updateHitbox();
		line2.cameras = [camTimeline];
		line2.scrollFactor.set(0, 1);
		line2.alpha = 0.5;
		add(line2);

		var valueText = new UIText(10, (ROW_SIZE*i),0, "-", 15);
		valueText.cameras = [camTimelineValueList];
		add(valueText);
		timelineValueTextList.push(valueText);

		i++;
	}

	var line = new FlxSprite(200-2,0);
	line.makeGraphic(1,1);
	line.setGraphicSize(2,1280);
	line.updateHitbox();
	line.cameras = [camTimelineList];
	line.scrollFactor.set();
	add(line);

	var line2 = new FlxSprite(50-2,0);
	line2.makeGraphic(1,1);
	line2.setGraphicSize(2,1280);
	line2.updateHitbox();
	line2.cameras = [camTimelineValueList];
	line2.scrollFactor.set();
	add(line2);

	sectionSeparator = new FlxBackdrop(null, FlxAxes.X, 0, 0);
	sectionSeparator.x = -2;

	beatSeparator = new FlxBackdrop(null, FlxAxes.X, 0, 0);
	beatSeparator.x = -1;

	for(sep in [sectionSeparator, beatSeparator]) {
		sep.makeSolid(1, 1, -1);
		sep.alpha = 0.5;
		sep.scrollFactor.set(1, 0);
		sep.scale.set(sep == sectionSeparator ? 4 : 2, 720/2);
		sep.cameras = [camTimeline];
		sep.updateHitbox();
	}
	add(beatSeparator);
	add(sectionSeparator);

	eventGroup = new EventGroup();
	eventGroup.active = eventGroup.visible = false;
	add(eventGroup);
	eventGroup.cameras = [camTimeline];

	eventGroupContainer = new EventGroupContainer();
	eventGroupContainer.eventGroup = eventGroup;
	add(eventGroupContainer);

	createEventObjects();


	selectionBox = new UISliceSprite(0, 0, 2, 2, 'editors/ui/selection');
	selectionBox.visible = false;
	selectionBox.scrollFactor.set(1, 1);
	selectionBox.incorporeal = true;
	selectionBox.cameras = [camTimeline];
	add(selectionBox);
}



function createStrumlines() {
	for(i=>strumLine in PlayState.SONG.strumLines) {
		if (strumLine == null) continue;


		var strOffset:Float = strumLine.strumLinePos == null ? (strumLine.type == 1 ? 0.75 : 0.25) : strumLine.strumLinePos;
		var startingPos:FlxPoint = strumLine.strumPos == null ?
			FlxPoint.get((FlxG.width * strOffset) - ((Note.swagWidth * (strumLine.strumScale == null ? 1 : strumLine.strumScale)) * 2), 50) :
			FlxPoint.get(strumLine.strumPos[0] == 0 ? ((FlxG.width * strOffset) - ((Note.swagWidth * (strumLine.strumScale == null ? 1 : strumLine.strumScale)) * 2)) : strumLine.strumPos[0], strumLine.strumPos[1]);

		var strumScale = (strumLine.strumScale == null ? 1 : strumLine.strumScale);

		strumLines.push([]);

		if (strumLine.visible != false) {
			var dirs = ["left", "down", "up", "right"];
			for (dir in 0...4) {
				var babyArrow = new FlxSprite(startingPos.x + (Note.swagWidth * strumScale * dir), startingPos.y);
				babyArrow.frames = Paths.getFrames("game/voiid/notes/default");
				babyArrow.animation.addByPrefix('static', dirs[dir] + " static");
				babyArrow.animation.play("static");
				babyArrow.setGraphicSize(Std.int((babyArrow.width * 0.7) * strumScale));
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();
				babyArrow.cameras = [camHUD];
				babyArrow.ID = dir;
				if (!stagePreviewMode) add(babyArrow);
				strumLines[i].push(babyArrow);
			}
		}
	}
}

var _fullscreen = false;
var _timelineScrollY = 0;
var __crochet:Float = 0;
var __firstFrame:Bool = true;
function update(elapsed) {

	if (FlxG.sound.music.playing || __firstFrame) {
		conductorSprY = curStepFloat * ROW_SIZE;
	} else {
		conductorSprY = CoolUtil.fpsLerp(conductorSprY, curStepFloat * ROW_SIZE, __firstFrame ? 1 : 1/3);
	}
	eventGroup.conductorPos = conductorSprY/ROW_SIZE;

	updateUI();

	updateInputs();

	__crochet = ((60 / Conductor.bpm) * 1000);
	if (timelineWindow.hovered) {
		_timelineScrollY += (FlxG.keys.pressed.SHIFT ? 8.0 : 1.0) * -FlxG.mouse.wheel * ROW_SIZE;
		_timelineScrollY = FlxMath.bound(_timelineScrollY, 0, Math.max(0, 30 + (ROW_SIZE*timelineList.length) - 720/2.25));
		camTimelineValueList.scroll.y = camTimeline.scroll.y = camTimelineList.scroll.y = CoolUtil.fpsLerp(camTimelineList.scroll.y, _timelineScrollY, 0.15);
	} else {
		if (!FlxG.sound.music.playing) {
			Conductor.songPosition -= (__crochet*0.25 * (FlxG.keys.pressed.SHIFT ? 8.0 : 1.0) * FlxG.mouse.wheel) - Conductor.songOffset;
		}
	}

	//if (stagePreviewMode) {
		if (FlxG.mouse.pressedRight) {
			camGame.scroll.x -= FlxG.mouse.deltaX;
			camGame.scroll.y -= FlxG.mouse.deltaY;
		}
	//}


	var songLength = FlxG.sound.music.length;
	Conductor.songPosition = FlxMath.bound(Conductor.songPosition + Conductor.songOffset, 0, songLength);
	if (Conductor.songPosition >= songLength - Conductor.songOffset) {
		FlxG.sound.music.pause();
		vocals.pause();
		//for (strumLine in strumLines.members) strumLine.vocals.pause();
	}

	songPosInfo.text = CoolUtil.timeToStr(Conductor.songPosition) + '/' + CoolUtil.timeToStr(songLength)
		+ '\nStep: ' + curStep
		+ '\nBeat: ' + curBeat
		+ '\nMeasure: ' + curMeasure
		+ '\nBPM: ' + Conductor.bpm;


	camGame.zoom = CoolUtil.fpsLerp(camGame.zoom, defaultCamZoom, 0.05);
	camHUD.zoom = CoolUtil.fpsLerp(camHUD.zoom, 1, 0.05);

	updateEvents();
}

function updateUI() {
	camTimeline.scroll.x = conductorSprY;
	sectionSeparator.spacing.x = ((ROW_SIZE/4) * Conductor.beatsPerMeasure * Conductor.stepsPerBeat) - 1;
	beatSeparator.spacing.x = ((ROW_SIZE/2) * Conductor.stepsPerBeat) - 1;
	
	var lastCamScale = camGame.flashSprite.scaleX;
	var camScale = _fullscreen ? 1.0 : 0.5;
	var newScale = CoolUtil.fpsLerp(camGame.flashSprite.scaleX, camScale, 0.15);
	if (Math.abs(camScale-newScale) < 0.01) newScale = camScale;
	camGame.flashSprite.scaleX = camGame.flashSprite.scaleY = camOther.flashSprite.scaleX = camOther.flashSprite.scaleY = camHUD.flashSprite.scaleX = camHUD.flashSprite.scaleY = newScale;
	

	if (camGame.flashSprite.scaleX != lastCamScale) {
		ShaderResizeFix.fixSpriteShaderSize(camGame.flashSprite);
		ShaderResizeFix.fixSpriteShaderSize(camHUD.flashSprite);
		ShaderResizeFix.fixSpriteShaderSize(camOther.flashSprite);
	}

	camGame.y = camHUD.y = camOther.y = ((-720/4)+32) * (-((camGame.flashSprite.scaleX-0.5)*2)+1);
	camEditor.scroll.y = CoolUtil.fpsLerp(camEditor.scroll.y, _fullscreen ? -720/2 : 0, 0.15);
	camEditorTop.scroll.y = CoolUtil.fpsLerp(camEditorTop.scroll.y, _fullscreen ? 100 : 0, 0.15);
	camTimelineValueList.y = camTimelineList.y = camTimeline.y = ((-camEditor.scroll.y) + 720/2) + 30 + 40;

	scrollBar.size = (1280-250)/ROW_SIZE;
	scrollBar.start = Conductor.curStepFloat - (scrollBar.size / 2);
}
var dragStartPos = null;
var isDragging = false;
function updateInputs() {

	if(FlxG.keys.justPressed.ANY && currentFocus == null)
		UIUtil.processShortcuts(topMenu);

	scrollBar.active = !isDragging;
	

	//if (timelineWindow.hovered) {
		var mousePos = FlxG.mouse.getWorldPosition(camTimeline);
		if (FlxG.mouse.justPressed && timelineWindow.hovered) {
			dragStartPos = FlxG.mouse.getWorldPosition(camTimeline);
			isDragging = false;
		} else if (FlxG.mouse.justReleased) {

			if (isDragging) {
				resetSelection();
				for(i in 0...eventGroup.members.length) {
					var obj = eventGroup.members[i];
					if (!selectedEvents.contains(obj) && 
						(selectionBox.x + selectionBox.bWidth > obj.x) && (selectionBox.x < obj.x + obj.width) && 
						(selectionBox.y + selectionBox.bHeight > obj.y) && (selectionBox.y < obj.y + obj.height)) {
						selectEvent(obj, false);
					}
				}
			}


			dragStartPos = null;
		}

		hoverBox.x = Math.floor(mousePos.x / ROW_SIZE) * ROW_SIZE;
		hoverBox.y = Math.floor(mousePos.y / ROW_SIZE) * ROW_SIZE;

		selectionBox.visible = false;

		if (dragStartPos != null) {
			if (FlxG.mouse.pressed && (Math.abs(mousePos.x - dragStartPos.x) > 20 || Math.abs(mousePos.y - dragStartPos.y) > 20)) {
				isDragging = true;
			}
		}
		if (FlxG.mouse.pressed && dragStartPos != null && isDragging) {
			selectionBox.visible = true;
			selectionBox.x = Math.min(mousePos.x, dragStartPos.x);
			selectionBox.y = Math.min(mousePos.y, dragStartPos.y);
			selectionBox.bWidth = Std.int(Math.abs(mousePos.x - dragStartPos.x));
			selectionBox.bHeight = Std.int(Math.abs(mousePos.y - dragStartPos.y));
		}


		if (FlxG.mouse.justReleased && !isDragging && timelineWindow.hovered) {
			var clickedEvent:EventObject = null;
			for(i in eventGroup.getVisibleStartIndex()...eventGroup.getVisibleEndIndex()) {
				var obj = eventGroup.members[i];
				if (obj.overlapsPoint(mousePos, true)) {
					if (clickedEvent == null) {
						
						clickedEvent = obj;
					}
					break;
				}
			}

			if (FlxG.keys.pressed.CONTROL) {
				if (clickedEvent != null)
					selectEvent(clickedEvent, false);

			} else {
				if (clickedEvent == null) {
					addEvent(Math.floor((mousePos.x)/ROW_SIZE), timelineList[Math.floor(mousePos.y / ROW_SIZE)]);
				} else {
					editEvent(clickedEvent, false);
				}
			}
		}

		if (FlxG.mouse.justReleased) {
			isDragging = false;
		}
	//}

	
}

function addEvent(step, name) {
	updateEvents(step);
	var e = null;
	switch(name) {
		case "addCameraZoom":
			e = {
				"type": "addCameraZoom",
				"step": step,
				"value": 0.01,
				"triggered": false
			};
		case "addHUDZoom":
			e = {
				"type": "addHUDZoom",
				"step": step,
				"value": 0.01,
				"triggered": false
			};
		default:

			if (noteModifiers.contains(name)) {
				e = {
					"type": "tweenModifierValue",
					"step": step,
					"name": name,
					"value": 0,
					"time": 4,
					"ease": "cubeInOut",
					"startValue": currentValueList.get(name),
					"lastValue": 0
				};
			} else {
				var data = name.split(".");

				e = {
					"type": "tweenShaderProperty",
					"step": step,
					"name": data[0],
					"property": data[1],
					"value": 0,
					"time": 4,
					"ease": "cubeInOut",
					"startValue": currentValueList.get(name),
					"lastValue": 0
				};
			}


	}
	if (e != null) {

		SortedArrayUtil.addSorted(events, e, function(n){return n.step;});

		var obj = new EventObject(e);
		obj.x = e.step*ROW_SIZE;
		obj.y = timelineList.indexOf(name)*ROW_SIZE;
		obj.cameras = [camTimeline];
		eventGroup.addSorted(obj); 
		obj.updateEvent();
		refreshEventTimings();

		editEvent(obj, true);
	}
	resetSelection();
}

function editEvent(e:EventObject, justPlaced:Bool) {
	CURRENT_EVENT = e;
	EVENT_EDIT_CALLBACK = function() {
		e.updateEvent();
		refreshEventTimings();
	}
	EVENT_EDIT_CANCEL_CALLBACK = function() {
		if (justPlaced) {
			events.remove(e.event);
			e.event = null;
			eventGroup.members.remove(e);
			e = null;
		} else {
			e.updateEvent();
		}
		
		refreshEventTimings();
	}
	EVENT_DELETE_CALLBACK = function() {
		if (selectedEvents.contains(e)) selectedEvents.remove(e);
		events.remove(e.event);
		e.event = null;
		eventGroup.members.remove(e);
		e = null;
		
		refreshEventTimings();
	}
	var win = new UISubstateWindow(true, 'ModchartEventEditSubstate');
	FlxG.sound.music.pause();
	vocals.pause();
	openSubState(win);

	//selectEvent(e, true);
}

function loadSong() {
	Conductor.setupSong(PlayState.SONG);

	updateFolderFromSong(PlayState.SONG.meta.name);

	CoolUtil.setMusic(FlxG.sound, FlxG.sound.load(Paths.inst(PlayState.SONG.meta.name, PlayState.difficulty)));
	if (PlayState.SONG.meta.needsVoices != false) // null or true
		vocals = FlxG.sound.load(Paths.voices(PlayState.SONG.meta.name, PlayState.difficulty));
	else
		vocals = new FlxSound();
	vocals.group = FlxG.sound.defaultMusicGroup;

	scrollBar.length = Conductor.getStepForTime(FlxG.sound.music.length);
}

function loadDefaults() {
	var colorswapShader = new CustomShader("colorswap");
	shaders["colorswap"] = colorswapShader;
	shaderList.push("colorswap");
	defaultValueList.set("colorswap.hue", 0);
	for (obj in stage.stageSprites) {
		obj.shader = colorswapShader;
	}

	timelineList.push("addCameraZoom");
	timelineList.push("addHUDZoom");
}



function loadEvents() {
	loadDefaults();

	var xmlPath = Paths.getPath("songs/"+PlayState.SONG.meta.name+"/modchart.xml");
	if (Assets.exists(Paths.getPath("songs/"+PlayState.SONG.meta.name+"/modchart-" + PlayState.difficulty + ".xml"))) {
		xmlPath = Paths.getPath("songs/"+PlayState.SONG.meta.name+"/modchart-" + PlayState.difficulty + ".xml");
	}
	if (!Assets.exists(xmlPath)) return;

	xml = Xml.parse(Assets.getText(xmlPath)).firstElement();

	if (xml.get("noteModchart") == "true") {
		noteModchart = true;
		importScript("data/scripts/modchartManager.hx");
	}


	for (list in xml.elementsNamed("Init")) {
		for (event in list.elementsNamed("Event")) {
			switch(event.get("type")) {
				case "initShader":
					var path = event.get("shader");

					var s = new CustomShader(path);
					shaders[event.get("name")] = s;
					shaderList.push(event.get("name"));
					
					if (Assets.exists("shaders/"+path+".txt")) {
						var data = Assets.getText("shaders/"+path+".txt");
						for (vari in data.split("\n")) {
							var d = vari.split(" ");

							var n = event.get("name") + "." + d[0];
							if (!defaultValueList.exists(n)) {
								defaultValueList.set(n, Std.parseFloat(d[1]));
							}
							s.hset(d[0], Std.parseFloat(d[1]));

							if (d[0] == 'iTime') {
								iTimeShaders.push(s);
								s.iTime = 0;
							}
							if (d[0] == "speed") {
								iTimeWithSpeedShaders.push(s);
							}
						}
					}
				case "setCameraShader":

					var s = shaders.get(event.get("name"));
					var camName = event.get("camera");

					var cam:FlxCamera = camGame;
					if (camName == "hud" || camName == "camHUD") {
						cam = camHUD;
					} else if (camName == "other") {
						cam = camOther;
					}

					if (s != null) {
						cam.addShader(s);
					}
						

				case "setShaderProperty":
					var n = event.get("name") + "." + event.get("property");
					//if (!defaultValueList.exists(n)) {
						defaultValueList.set(n, Std.parseFloat(event.get("value")));
					//}

				case "initModifier":
					var n = event.get("name");
					var v = Std.parseFloat(event.get("value"));

					defaultValueList.set(n, v);

					if (!noteModifiers.contains(n)) noteModifiers.push(n);
					if (!timelineList.contains(n)) timelineList.push(n);

					createModifier(n, 
						v, 
						event.get("code"), 
						event.exists("strumLineID") ? Std.parseInt(event.get("strumLineID")) : -1, 
						event.exists("strumID") ? Std.parseInt(event.get("strumID")) : -1, 
						event.exists("defaultValue") ? Std.parseFloat(event.get("defaultValue")) : 0.0, 
						event.exists("autoDisable") ? event.get("autoDisable") == "true" : false
					);
			}
		}
	}
	for (name => val in defaultValueList) {
		currentValueList.set(name, val);
	}
	for (list in xml.elementsNamed("Events")) {
		for (event in list.elementsNamed("Event")) {
			switch(event.get("type")) {
				case "setShaderProperty":
					var n = event.get("name") + "." + event.get("property");
					if (!defaultValueList.exists(n)) {
						defaultValueList.set(n, Std.parseFloat(event.get("value")));
						currentValueList.set(n, Std.parseFloat(event.get("value")));
					}
					events.push({
						"type": event.get("type"),
						"step": Std.parseFloat(event.get("step")),
						"name": event.get("name"),
						"property": event.get("property"),
						"value": Std.parseFloat(event.get("value")),
						"lastValue": currentValueList.get(n)
					});

					currentValueList.set(n, Std.parseFloat(event.get("value")));

				case "tweenShaderProperty":
					var n = event.get("name") + "." + event.get("property");
					if (!defaultValueList.exists(n)) {
						defaultValueList.set(n, 0); //assume its 0???
						currentValueList.set(n, 0);
					}

					
					events.push({
						"type": event.get("type"),
						"step": Std.parseFloat(event.get("step")),
						"name": event.get("name"),
						"property": event.get("property"),
						"value": Std.parseFloat(event.get("value")),
						"time": Std.parseFloat(event.get("time")),
						"ease": event.get("ease"),
						"startValue": event.exists("startValue") ? Std.parseFloat(event.get("startValue")) : currentValueList.get(n),
						"lastValue": currentValueList.get(n)
					});

					//DI = Downscroll Inverse
					if (event.exists("DI_startValue")) {
						events[events.length-1].DI_startValue = event.get("DI_startValue") == "true";
					}
					if (event.exists("DI_value")) {
						events[events.length-1].DI_value = event.get("DI_value") == "true";
					}

					if (events[events.length-1].step <= -1) {
						events[events.length-1].step = 0;
					}

					currentValueList.set(n, Std.parseFloat(event.get("value")));

				case "addCameraZoom" | "addHUDZoom":
					events.push({
						"type": event.get("type"),
						"step": Std.parseFloat(event.get("step")),
						"value": Std.parseFloat(event.get("value")),
						"triggered": false
					});

				

				case "setModifierValue":
					var n = event.get("name");
					if (!defaultValueList.exists(n)) {
						defaultValueList.set(n, Std.parseFloat(event.get("value")));
						currentValueList.set(n, Std.parseFloat(event.get("value")));
					}
					events.push({
						"type": event.get("type"),
						"step": Std.parseFloat(event.get("step")),
						"name": event.get("name"),
						"value": Std.parseFloat(event.get("value")),
						"lastValue": currentValueList.get(n)
					});

					currentValueList.set(n, Std.parseFloat(event.get("value")));

				case "tweenModifierValue":
					var n = event.get("name");
					if (!defaultValueList.exists(n)) {
						defaultValueList.set(n, 0); //assume its 0???
						currentValueList.set(n, 0);
					}

					events.push({
						"type": event.get("type"),
						"step": Std.parseFloat(event.get("step")),
						"name": event.get("name"),
						"value": Std.parseFloat(event.get("value")),
						"time": Std.parseFloat(event.get("time")),
						"ease": event.get("ease"),
						"startValue": event.exists("startValue") ? Std.parseFloat(event.get("startValue")) : currentValueList.get(n),
						"lastValue": currentValueList.get(n)
					});

					if (events[events.length-1].step <= -1) {
						events[events.length-1].step = 0;
					}

					currentValueList.set(n, Std.parseFloat(event.get("value")));
			}
		}
	}
	if (noteModchart) initModchart();
	resetValuesToDefault();
	refreshEventTimings();
}

function resetValuesToDefault() {
	for (obj => value in defaultValueList) {
		var data = obj.split(".");

		var s = shaders.get(data[0]);
		if (s != null) {
			s.hset(data[1], value);
		}
	}
	for (name => val in defaultValueList) {
		currentValueList.set(name, val);
	}
}



function refreshEventTimings() {
	eventIndexMap.clear();

	for (name => val in defaultValueList) {
		currentValueList.set(name, val);
	}

	for (i in 0...events.length) {
		var e = events[i];
		e.lastIndex = -1;
		e.nextIndex = -1;
		
		var n = e.type;
		switch(e.type) {
			case "setShaderProperty" | "tweenShaderProperty":
				n = e.name + "." + e.property;
			case "setModifierValue" | "tweenModifierValue":
				n = e.name;
		}
		e.lastValue = currentValueList.get(n);

		if (!eventIndexMap.exists(n)) {
			eventIndexMap.set(n, i);
		} else {
			var lastIndex = eventIndexMap.get(n);

			events[lastIndex].nextIndex = i;
			e.lastIndex = lastIndex;
			e.lastValue = events[lastIndex].value;
			if (events[lastIndex].DI_value != null && events[lastIndex].DI_value)
				e.lastValue = -e.lastValue;

			eventIndexMap.set(n, i);
		}
	}
}
function createEventObjects() {
	for (i in 0...events.length) {
		var e = events[i];
		var n = e.type;
		switch(e.type) {
			case "setShaderProperty" | "tweenShaderProperty":
				n = e.name + "." + e.property;
			case "setModifierValue" | "tweenModifierValue":
				n = e.name;
		}

		var obj = new EventObject(e);
		obj.x = e.step*ROW_SIZE;
		obj.y = timelineList.indexOf(n)*ROW_SIZE;
		obj.cameras = [camTimeline];
		eventGroup.addSorted(obj);
		obj.updateEvent();
	}
}

function updateEvents(?forceStep:Float = null) {

	for (name => val in defaultValueList) {
		currentValueList.set(name, val);
	}

	var currentStep = curStepFloat;
	if (!FlxG.sound.music.playing) {
		currentStep = conductorSprY / ROW_SIZE;
	}
	if (forceStep != null) currentStep = forceStep;

	for (name => index in eventIndexMap) {
		var i = index;

		//check for next event
		while(true) {
			if (events[i].nextIndex == -1) {
				break;
			}
			var nextIndex = events[i].nextIndex;
			if (currentStep >= events[nextIndex].step) {
				i = nextIndex;
			} else {
				break;
			}
		}

		//check for last (for rewinding)
		while(true) {
			if (events[i].lastIndex == -1) {
				break;
			}
			var lastIndex = events[i].lastIndex;
			if (currentStep < events[lastIndex].step + (events[lastIndex].time != null ? events[lastIndex].time : 0.0)) {
				i = lastIndex;
			} else {
				break;
			}
		}


		if (i != index) {
			eventIndexMap.set(name, i); //remember
		}



		var e = events[i];
		if (currentStep >= e.step) {
			switch(e.type) {
				case "setShaderProperty" | "setModifierValue":
					currentValueList.set(name, e.value);
					
				case "tweenShaderProperty" | "tweenModifierValue":


					if (currentStep < e.step + e.time) {
						if (!easeMap.exists(e.ease)) {
							easeMap.set(e.ease, CoolUtil.flxeaseFromString(e.ease, ""));
						}
						var easeFunc:Float->Float = easeMap.get(e.ease);

						var startVMult:Float = (e.DI_startValue != null && e.DI_startValue && downscroll) ? -1.0 : 1.0;
						var vMult:Float = (e.DI_value != null && e.DI_value && downscroll) ? -1.0 : 1.0;
		
						var l = 0 + (currentStep - e.step) * ((1 - 0) / ((e.step+e.time) - e.step));
						var newValue = FlxMath.lerp(e.startValue*startVMult, e.value*vMult, easeFunc(l));
		
						currentValueList.set(name, newValue);
					} else {
						var vMult:Float = (e.DI_value != null && e.DI_value && downscroll) ? -1.0 : 1.0;
						currentValueList.set(name, e.value*vMult);
					}

				case "addCameraZoom":
					if (!e.triggered && Math.floor(currentStep) == Math.floor(e.step)) {
						camGame.zoom += e.value;
						e.triggered = true;
						
					}
					if (Math.floor(currentStep) != Math.floor(e.step)) {
						e.triggered = false; //reset once the step has changed
					}
				case "addHUDZoom":
					if (!e.triggered && Math.floor(currentStep) == Math.floor(e.step)) {
						camHUD.zoom += e.value;
						e.triggered = true;
						
					}
					if (Math.floor(currentStep) != Math.floor(e.step)) {
						e.triggered = false; //reset once the step has changed
					}
			}
		} else {
			currentValueList.set(name, e.lastValue);
		}
	}

	for (obj => value in currentValueList) {
		if (noteModifiers.contains(obj)) {

			var mod = null;
			for (m in modifiers)
				if (m[MOD_NAME] == obj)
					mod = m;

			if (mod != null) {
				mod[MOD_VALUE] = value;
			}

			var text = timelineValueTextList[timelineList.indexOf(obj)];
			if (text != null) {
				text.text = Std.string(FlxMath.roundDecimal(value, 2));
			}
		} else {
			var data = obj.split(".");

			var s = shaders.get(data[0]);
			if (s != null && data[1] != "iTime") {
				s.hset(data[1], value);
			}
	
			var text = timelineValueTextList[timelineList.indexOf(obj)];
			if (text != null && data[1] != "iTime") {
				text.text = Std.string(FlxMath.roundDecimal(value, 2));
			}
		}		
	}

	for (shader in iTimeShaders) {
		if (iTimeWithSpeedShaders.contains(shader)) {
			if (FlxG.sound.music.playing)
				shader.iTime += FlxG.elapsed * shader.speed;
		} else {
			shader.iTime = Conductor.songPosition*0.001;
		}
	}
}


function buildXMLFromEvents() {
	var newXml = Xml.createElement("Modchart");
	var initEvents = Xml.createElement("Init");
	var shaderEvents = Xml.createElement("Events");
	
	//copy init events
	if (xml != null) {
		for (list in xml.elementsNamed("Init")) {
			for (e in list.elementsNamed("Event")) {
				var event = Xml.createElement("Event");
				for (att in e.attributes()) {
					event.set(att, e.get(att));
				}
				initEvents.addChild(event);
			}
		}
	}
	if (xml.exists("noteModchart")) newXml.set("noteModchart", xml.get("noteModchart"));


	//clear up any sets on the same step as a tween to remove stacked events (makes it smaller and easier to edit)
	var eventsToRemove = [];
	var eventsMap = ["" => -1];
	eventsMap.clear();
	for (i in 0...events.length) {
		var e = events[i];
		var n = e.type;
		switch(e.type) {
			case "setShaderProperty" | "tweenShaderProperty":
				n = e.name + "." + e.property;
			case "setModifierValue" | "tweenModifierValue":
				n = e.name;
		}

		if (e.type == "setShaderProperty") {
			eventsMap.set(n, i);
		} else if (e.type == "tweenShaderProperty") {
			if (eventsMap.exists(n)) {
				var lastEvent = events[eventsMap.get(n)];
				if (lastEvent.type == "setShaderProperty" && lastEvent.value == e.startValue && lastEvent.step == e.step) {
					eventsToRemove.push(lastEvent);
				}
			}
			eventsMap.set(n, i);
		}
	}
	for (e in eventsToRemove) {
		events.remove(e);
	}

	for (i in 0...events.length) {
		var e = events[i];
		var node = Xml.createElement("Event");
		node.set("type", e.type);
		node.set("step", e.step);

		switch(e.type) {
			case "initShader":
				node.set("name", e.name);
				node.set("shader", e.shader);
			case "setCameraShader":
				node.set("name", e.name);
				node.set("camera", e.camera);
			case "setShaderProperty":
				node.set("name", e.name);
				node.set("property", e.property);
				node.set("value", e.value);
			case "tweenShaderProperty":
				node.set("name", e.name);
				node.set("property", e.property);
				node.set("value", e.value);
				node.set("time", e.time);
				node.set("ease", e.ease);
				node.set("startValue", e.startValue);
				
				if (e.DI_startValue != null && e.DI_startValue) {
					node.set("DI_startValue", e.DI_startValue);
				}
				if (e.DI_value != null && e.DI_value) {
					node.set("DI_value", e.DI_value);
				}
			case "addCameraZoom" | "addHUDZoom":
				node.set("value", e.value);

			case "setModifierValue":
				node.set("name", e.name);
				node.set("value", e.value);
			case "tweenModifierValue":
				node.set("name", e.name);
				node.set("value", e.value);
				node.set("time", e.time);
				node.set("ease", e.ease);
				node.set("startValue", e.startValue);
		}

		shaderEvents.addChild(node);
	}


	newXml.addChild(initEvents);
    newXml.addChild(shaderEvents);
	//trace(Printer.print(newXml, true));

	//File.saveContent("modchart.xml", Printer.print(xml, true));

	refreshEventTimings();

	return newXml;
}



function _save() {
	xml = buildXMLFromEvents();
	var path = Paths.getAssetsRoot() + '/songs/'+PlayState.SONG.meta.name+'/modchart.xml';
	if (Assets.exists(Paths.getPath("songs/"+PlayState.SONG.meta.name+"/modchart-" + PlayState.difficulty + ".xml"))) {
		path = Paths.getAssetsRoot() + '/songs/'+PlayState.SONG.meta.name+"/modchart-" + PlayState.difficulty + ".xml";
	}
	CoolUtil.safeSaveFile(path, Printer.print(xml, true));
}
function _save_opt() {
	xml = buildXMLFromEvents();
	var path = Paths.getAssetsRoot() + '/songs/'+PlayState.SONG.meta.name+'/modchart.xml';
	if (Assets.exists(Paths.getPath("songs/"+PlayState.SONG.meta.name+"/modchart-" + PlayState.difficulty + ".xml"))) {
		path = Paths.getAssetsRoot() + '/songs/'+PlayState.SONG.meta.name+"/modchart-" + PlayState.difficulty + ".xml";
	}
	CoolUtil.safeSaveFile(path, Printer.print(xml, false));
}
function _exit() {
	FlxG.switchState(new FreeplayState());
}
function _modchart_editshaders() {
	CURRENT_XML = xml;
	var win = new UISubstateWindow(true, 'ModchartEditDataSubstate');
	FlxG.sound.music.pause();
	vocals.pause();
	openSubState(win);
}

function _view_fullscreen() {
	_fullscreen = !_fullscreen;
}
function _view_downscroll() {
	downscroll = !downscroll;
	camHUD.downscroll = downscroll;
	refreshEventTimings();
}

function _song_start(_) {
	if (FlxG.sound.music.playing) return;
	Conductor.songPosition = 0;
}
function _song_end(_) {
	if (FlxG.sound.music.playing) return;
	Conductor.songPosition = FlxG.sound.music.length;
}

function _song_muteinst(t) {
	FlxG.sound.music.volume = FlxG.sound.music.volume > 0 ? 0 : 1;
	t.icon = 1 - Std.int(Math.ceil(FlxG.sound.music.volume));
}
function _song_mutevoices(t) {
	vocals.volume = vocals.volume > 0 ? 0 : 1;
	//for (strumLine in strumLines.members) strumLine.vocals.volume = strumLine.vocals.volume > 0 ? 0 : 1;
	t.icon = 1 - Std.int(Math.ceil(vocals.volume));
}

function _playback_speed_change(change) {
	var v = FlxG.sound.music.pitch + change;
	if (v < 0.25) v = 0.25;
	if (v > 2.0) v = 2.0;
	FlxG.sound.music.pitch = vocals.pitch = v;
}

function _playback_speed_raise(_) _playback_speed_change(0.25);
function _playback_speed_reset(_) FlxG.sound.music.pitch = vocals.pitch = 1;
function _playback_speed_lower(_) _playback_speed_change(-0.25);

function _playback_play() {
	if (Conductor.songPosition >= FlxG.sound.music.length - Conductor.songOffset) return;

	if (FlxG.sound.music.playing) {
		FlxG.sound.music.pause();
		vocals.pause();
		//for (strumLine in strumLines.members) strumLine.vocals.pause();
	} else {
		FlxG.sound.music.play();
		vocals.play();
		vocals.time = FlxG.sound.music.time = Conductor.songPosition + Conductor.songOffset * 2;
		//for (strumLine in strumLines.members) {
		//	strumLine.vocals.play();
		//	strumLine.vocals.time = vocals.time;
		//}
	}
}
function _playback_back(_) {
	if (FlxG.sound.music.playing) return;
	Conductor.songPosition -= (Conductor.beatsPerMeasure * __crochet);
}
function _playback_forward(_) {
	if (FlxG.sound.music.playing) return;
	Conductor.songPosition += (Conductor.beatsPerMeasure * __crochet);
}



function copyEvent(e) {
	var newEvent = null;
	switch(e.type) {
		case "addCameraZoom" | "addHUDZoom":
			newEvent = {
				"type": e.type,
				"step": e.step,
				"value": e.value,
				"triggered": false
			};
		case "setShaderProperty":
			newEvent = {
				"type": e.type,
				"step": e.step,
				"name": e.name,
				"property": e.property,
				"value": e.value,
				"lastValue": e.lastValue
			};
		case "tweenShaderProperty":
			newEvent = {
				"type": e.type,
				"step": e.step,
				"name": e.name,
				"property": e.property,
				"value": e.value,
				"time": e.time,
				"ease": e.ease,
				"startValue": e.startValue,
				"lastValue": e.lastValue,
				"DI_value": e.DI_value,
				"DI_startValue": e.DI_startValue
			};
		case "setModifierValue":
			newEvent = {
				"type": e.type,
				"step": e.step,
				"name": e.name,
				"value": e.value,
				"lastValue": e.lastValue
			};
		case "tweenModifierValue":
			newEvent = {
				"type": e.type,
				"step": e.step,
				"name": e.name,
				"value": e.value,
				"time": e.time,
				"ease": e.ease,
				"startValue": e.startValue,
				"lastValue": e.lastValue
			};
	}
	return newEvent;
}

function selectEvent(e:EventObject, reset:Bool) {
	if (reset) {
		resetSelection();
	}
	SortedArrayUtil.addSorted(selectedEvents, e, function(n){return n.step;});
	e.selected = true;
	e.updateEvent();
}
function resetSelection() {
	for (event in selectedEvents) {
		event.selected = false;
		event.updateEvent();
	}
	selectedEvents = [];
}


function _edit_undo() {

}
function _edit_redo() {

}
function _edit_copy() {
	clipboard = [];
	for (event in selectedEvents) {
		clipboard.push(copyEvent(event.event));
	}
	clipboard.sort(function(a, b) {
		if(a.step < b.step) return -1;
		else if(a.step > b.step) return 1;
		else return 0;
	});
}
function _edit_paste() {
	resetSelection();
	if (clipboard.length > 0) {
		var diff = curStep - clipboard[0].step;

		trace(clipboard[0].step);
		trace(diff);

		for (event in clipboard) {
			var e = copyEvent(event);
			var n = e.type;
			switch(e.type) {
				case "setShaderProperty" | "tweenShaderProperty":
					n = e.name + "." + e.property;
				case "setModifierValue" | "tweenModifierValue":
					n = e.name;
			}

			e.step += diff;

			SortedArrayUtil.addSorted(events, e, function(n){return n.step;});
			var obj = new EventObject(e);
			obj.x = e.step*ROW_SIZE;
			obj.y = timelineList.indexOf(n)*ROW_SIZE;
			obj.cameras = [camTimeline];
			eventGroup.addSorted(obj); 
			selectEvent(obj, false);
		}

		refreshEventTimings();
	}
}
function _edit_cut() {
	_edit_copy();
	_edit_delete();
}
function _edit_delete() {
	for (e in selectedEvents) {
		events.remove(e.event);
		e.event = null;
		eventGroup.members.remove(e);
	}
	selectedEvents = [];
	refreshEventTimings();
}
function _edit_shiftleft() {
	for (event in selectedEvents) {
		event.event.step -= 1;
		if (event.event.step < 0) event.event.step = 0;
		event.x = event.event.step*ROW_SIZE;
		event.updateEvent();
	}
	sortAllEvents();
	refreshEventTimings();
}
function _edit_shiftright() {
	for (event in selectedEvents) {
		event.event.step += 1;
		event.x = event.event.step*ROW_SIZE;
		event.updateEvent();
	}
	sortAllEvents();
	refreshEventTimings();
}

function sortAllEvents() {
	events.sort(function(a, b) {
		if(a.step < b.step) return -1;
		else if(a.step > b.step) return 1;
		else return 0;
	});
	eventGroup.members.sort(function(a, b) {
		if(a.event.step < b.event.step) return -1;
		else if(a.event.step > b.event.step) return 1;
		else return 0;
	});
}