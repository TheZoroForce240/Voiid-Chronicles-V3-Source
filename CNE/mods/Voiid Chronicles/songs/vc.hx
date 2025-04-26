import flixel.tweens.FlxTween;
import flixel.FlxSprite;
#if ENCRYPTED_FILES
import voiid.FileEncrypt;
#end
import funkin.backend.scripting.Script;
import lime.utils.Assets;
import funkin.backend.assets.Paths;

public var crochet = Conductor.stepCrochet;

public static var songSpeed:Float = 1.0;

function create() {
	if (Script.staticVariables.exists("SONG_SPEED")) {
		songSpeed = SONG_SPEED;
	} else {
		songSpeed = 1.0;
	}
	
	allowGitaroo = false; //kys
	importScript("data/scripts/multikey.hx");
	if (songSpeed != 1.0) scrollSpeed /= songSpeed;
}

function loadLEEvents() {
	var path = 'songs/'+SONG.meta.name.toLowerCase()+'/LE_events.json';
	if (Assets.exists(Paths.getPath('songs/'+SONG.meta.name.toLowerCase()+'/LE_events-' + PlayState.difficulty + '.json'))) {
		path = 'songs/'+SONG.meta.name.toLowerCase()+'/LE_events-' + PlayState.difficulty + '.json';
	}
	if (Assets.exists(Paths.getPath(path))) {

		#if ENCRYPTED_FILES
		var t = FileEncrypt.decryptString(Paths.getPath(path));
		#else 
		var t = Assets.getText(Paths.getPath(path));
		#end
		var eventsJson = Json.parse(t);
		for (e in eventsJson.song.events) {
			var cneEvent = {
				name: e[0],
				time: e[1],
				params: []
			};

			switch(e[0].toLowerCase()) {

				case "add camera zoom":
					cneEvent.name = "Add Camera Zoom";
					cneEvent.params = [Std.parseFloat(e[2]), "camGame"];
					var hudEvent = {
						name: "Add Camera Zoom",
						time: e[1],
						params: [Std.parseFloat(e[3]), "camHUD"]
					};
					events.push(hudEvent);
				case "camera flash":
					cneEvent.name = "LE Camera Flash";
					cneEvent.params = [e[2], Std.parseFloat(e[3])];
				case "set camera zoom":
					cneEvent.name = "Set Camera Zoom";
					cneEvent.params = [Std.parseFloat(e[2]), Std.parseFloat(e[3])];
				case "uno" | "dos" | "tres" | "cuatro":
					cneEvent.name = e[0].toLowerCase();
					cneEvent.params = [e[2], e[3]];
				case "colorfill" | 'black bars':
					cneEvent.name = e[0].toLowerCase();
					cneEvent.params = [e[2], e[3]];
				case "change character":
					cneEvent.name = "Change Characters";
					cneEvent.params = [e[2], e[3]];
					scripts.call("onCharactersPreload", [e[2], e[3]]);
				case "change stage":
					cneEvent.name = "Change Stage";
					cneEvent.params = [e[2]];
					scripts.call("onStagePreload", [e[2]]);
				case "change ui skin":
					cneEvent.name = "not ui skin change";
				case "punch" | "slash":
					var count = Std.parseInt(e[2]);
					var beats = Std.parseFloat(e[3]);
					var time = e[1];
					scripts.call("onPunchLoaded", [time, count, beats, e[0].toLowerCase()]);
				case "change block state" | "toggle matt echo trail" | "flip echo direction": //ignored

				default:
					trace(e[0]); //needs to be implemented
			}

			events.push(cneEvent);
		}
	}
	events.sort(function(a, b) {
		if(a.time < b.time) return 1;
		else if(a.time > b.time) return -1;
		else return 0;
	 });
}

var colorFillBG = null;
var topBar = null;
var botBar = null;

function onEvent(e) {
	var event = e.event;

	switch(event.name) {
		case "LE Camera Flash":
			
			if (stage.stagePath == "assets/data/stages/VoiidArenaNew.xml") {
				camScreen.flash(FlxColor.fromString(event.params[0].toLowerCase()), event.params[1]);
			} else {
				camGame.flash(FlxColor.fromString(event.params[0].toLowerCase()), event.params[1]);
			}
		case "Set Camera Zoom":
			defaultCamZoom = event.params[0];
			//defaultHudZoom = event.params[1];
		case "uno" | "dos" | "tres" | "cuatro":
			flashImage(event.name + (event.params[0] == '1' ? '-god' : ''), Conductor.stepCrochet/250);
		case "colorfill":
			var charData = event.params[0].split(',');
			var easeData = event.params[1].split(',');

			var easeFunc = CoolUtil.flxeaseFromString(easeData[1], "");
			var time = Std.parseFloat(easeData[0]);

			for (s in strumLines) {
				for (char in s.characters) {
					if (colorFillBG.alpha == 0) {
						FlxTween.tween(char.colorTransform, {redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0}, time, {ease:easeFunc});
					} else {
						FlxTween.tween(char.colorTransform, {redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1}, time, {ease:easeFunc});
					}
				}
			}
			if (colorFillBG.alpha == 0) {
				FlxTween.tween(colorFillBG, {alpha: 1}, time, {ease:easeFunc});
				FlxTween.tween(colorFillBG.colorTransform, {redMultiplier: Std.parseFloat(charData[3]), greenMultiplier: Std.parseFloat(charData[4]), blueMultiplier: Std.parseFloat(charData[5])}, time, {ease:easeFunc});
			} else {
				FlxTween.tween(colorFillBG, {alpha: 0}, time, {ease:easeFunc});
			}
		case "black bars":
			var height = Std.parseFloat(event.params[0]);
			FlxTween.tween(topBar, {y: height-720}, 0.5);
			FlxTween.tween(botBar, {y: -height+720}, 0.5);
			switch(event.params[1]) {
				default:
					remove(topBar);
					remove(botBar);
					add(topBar);
					add(botBar);
				case "2":
					remove(topBar);
					remove(botBar);
					insert(0,topBar);
					insert(0,botBar);
				case "1":
					remove(topBar);
					remove(botBar);
					add(topBar);
					add(botBar);
			}
		case "Camera Shake":
			camGame.shake(event.params[0], event.params[1] * Conductor.stepCrochet * 0.001);
			if (event.params[2]) {
				camHUD.shake(event.params[0], event.params[1] * Conductor.stepCrochet * 0.001);
			}
	}
}

function postCreate() {
	loadLEEvents();

	colorFillBG = new FlxSprite();
	colorFillBG.makeGraphic(1,1);
	colorFillBG.setGraphicSize(2000/camGame.zoom,2000/camGame.zoom);
	colorFillBG.updateHitbox();
	colorFillBG.screenCenter();
	colorFillBG.scrollFactor.set();
	insert(members.indexOf(gf), colorFillBG);
	colorFillBG.alpha = 0;


	topBar = new FlxSprite(0, -720);
	topBar.makeGraphic(1,1,0xFF000000);
	topBar.setGraphicSize(4000,720);
	topBar.updateHitbox();
	topBar.cameras = [camHUD];
	topBar.screenCenter(FlxAxes.X);
	add(topBar);

	botBar = new FlxSprite(0, 720);
	botBar.makeGraphic(1,1,0xFF000000);
	botBar.setGraphicSize(4000,720);
	botBar.updateHitbox();
	botBar.cameras = [camHUD];
	botBar.screenCenter(FlxAxes.X);
	add(botBar);


	for (s in strumLines) {
		for (char in s.characters) { //match le offsets
			char.globalOffset.x -= (char.frameWidth*char.scale.x)/2;
			char.globalOffset.y -= (char.frameHeight*char.scale.y);
			char.dance();
		}
	}
}


public function flashImage(path, time) {
	var image = new FlxSprite();
	image.loadGraphic(Paths.image(path));
	image.cameras = [camHUD];
	image.screenCenter();
	insert(0, image);

	FlxTween.tween(image, {alpha: 0}, time, {ease:FlxEase.cubeInOut, onComplete:function(twn) {
		image.destroy();
		remove(image);
	}});
}



function onNoteHit(event) {
	var strumlineID = event.note.strumLine.ID;
	if (StringTools.contains(event.noteType, "char[")) {
		var charsIndex = event.noteType.indexOf("char[")+5;
		var list = event.noteType.substring(charsIndex, event.noteType.length-1);
		var characterIndexes = list.split(",");
		event.characters = [];
		for (id in characterIndexes) {
			var index = Std.parseInt(id) % strumLines.members[strumlineID].characters.length;
			if (strumLines.members[strumlineID].characters[index] != null)
				event.characters.push(strumLines.members[strumlineID].characters[index]);
		}
	} else {
		event.characters = [strumLines.members[strumlineID].characters[0]];
	}
}

function onStartSong() {
	onVocalsResync();
}

function onVocalsResync() {
	if (songSpeed != 1.0) {
		FlxG.timeScale = songSpeed;
		inst.pitch = songSpeed;
		vocals.pitch = songSpeed;
		for (strumLine in strumLines.members) {
			strumLine.vocals.pitch = songSpeed;
		}
	}
}
function destroy() {
	FlxG.timeScale = 1.0;
}