import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
var skinChanges:Array<Dynamic> = [];
public var uiPath:String = "game/";
public var uiSkinPrefix:String = "voiid/";
public var noteSkinPrefix:String = "voiid/";
public var healthBarPrefix:String = "voiid/";

function create() {
	for (event in events)
	{
		if (event.name == "Change UI Skin") 
		{
			skinChanges.push({
				time: event.time,
				uiSkinPrefix: event.params[0],
				noteSkinPrefix: event.params[1],
				healthBarPrefix: event.params[2]
			});
		}
	}
	if (skinChanges.length > 0) {
		skinChanges.sort(function(a, b) {
			if(a.time < b.time) return -1;
			else if(a.time > b.time) return 1;
			else return 0;
		});

		uiSkinPrefix = skinChanges[0].uiSkinPrefix;
		noteSkinPrefix = skinChanges[0].noteSkinPrefix;
		healthBarPrefix = skinChanges[0].healthBarPrefix;
	}
}


function postCreate() {
	updateUI();
	scripts.call("onChangeHealthBar", [healthBarPrefix]);
	scripts.call("onPostChangeHealthBar", [healthBarPrefix]);
}
function onStrumCreation(event) {
	event.sprite = uiPath+noteSkinPrefix+"notes/default";
}
function onNoteHit(event) {
	event.ratingPrefix = uiPath+uiSkinPrefix+"score/";
}
function onNoteCreation(event) {
	if (skinChanges.length == 0) {
		if (event.noteSprite == 'game/notes/default') event.noteSprite = uiPath+noteSkinPrefix+"notes/default";
	} else {
		var change = skinChanges[0];
		for (c in skinChanges) {
			if (event.note.strumTime > c.time) {
				change = c;
			} else {
				break;
			}
		}
		if (event.noteSprite == 'game/notes/default') event.noteSprite = uiPath+change.noteSkinPrefix+"notes/default";
	}
}

function updateUI() {
	introSprites = [null, uiPath+uiSkinPrefix+'ready', uiPath+uiSkinPrefix+"set", uiPath+uiSkinPrefix+"go"];
	introSounds = [uiSkinPrefix+'intro3', uiSkinPrefix+'intro2', uiSkinPrefix+"intro1", uiSkinPrefix+"introGo"];
}
function updateNoteSkin() {
	for (strumLine in strumLines.members) {
		for (strum in strumLine.members) {
			var kc = getKeyCountIndex(strumLine.ID);
			strum.frames = Paths.getFrames(uiPath+noteSkinPrefix+"notes/default");
			strum.antialiasing = true;
			strum.setGraphicSize(Std.int((strum.width * strumLineNoteScales[strumLine.ID] * strumLines.members[strumLine.ID].strumScale)));

			strum.animation.addByPrefix('static', multikeyStrumAnims[kc][strum.ID][0]);
			strum.animation.addByPrefix('pressed', multikeyStrumAnims[kc][strum.ID][2], 24, false);
			strum.animation.addByPrefix('confirm', multikeyStrumAnims[kc][strum.ID][1], 24, false);
			strum.updateHitbox();
			strum.animation.play("static");
			
		}
	}
}

function onChangeHealthBar(prefix) {
	if (prefix == "") {
		healthBarBG.loadGraphic(Paths.image('game/healthBar'));
		healthBarBG.screenCenter(FlxAxes.X);
		healthBarBG.updateHitbox();
		remove(healthBar);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, 
			FlxBarFillDirection.RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), 
			PlayState.instance, 'health', 0, maxHealth);

		healthBar.scrollFactor.set();
		healthBar.updateHitbox();

		var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
		var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
		healthBar.createFilledBar(leftColor, rightColor);
		healthBar.cameras = [camHUD];

		insert(members.indexOf(healthBarBG)+1, healthBar);
	} else if (prefix == "voiid/") {

		healthBarBG.loadGraphic(Paths.image('game/voiid/healthBar'));
		healthBarBG.updateHitbox();
		healthBarBG.screenCenter(FlxAxes.X);
		remove(healthBar);

		healthBar = new FlxBar(healthBarBG.x + 13, healthBarBG.y + 15, 
			FlxBarFillDirection.RIGHT_TO_LEFT, Std.int(healthBarBG.width - 25), 23, 
			PlayState.instance, 'health', 0, maxHealth);

		healthBar.scrollFactor.set();
		healthBar.updateHitbox();
		

		if (!downscroll) {
			healthBar.offset.y += 15;
			healthBarBG.offset.y += 15;
		} else {
			healthBar.offset.y -= 18;
			healthBarBG.offset.y -= 18;
			healthBarBG.offset.y -= 15;
		}


		var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
		var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
		healthBar.createFilledBar(leftColor, rightColor);
		healthBar.cameras = [camHUD];

		insert(members.indexOf(healthBarBG)-1, healthBar);

	}
}
function onCharactersChanged(id, chars) {
	if (id == 0) {
		iconP2.setIcon(dad.getIcon());
	} else if (id == 1) {
		iconP1.setIcon(boyfriend.getIcon());
	}
	var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
	healthBar.createFilledBar(leftColor, rightColor);
}

function onEvent(e) {
	var event = e.event;
	if (event.name == "Change UI Skin") {
		if (event.params[0] != uiSkinPrefix) {
			uiSkinPrefix = event.params[0];
			updateUI();
		}
		if (event.params[1] != noteSkinPrefix) {
			noteSkinPrefix = event.params[1];
			updateNoteSkin();
		}
		if (event.params[2] != healthBarPrefix) {
			healthBarPrefix = event.params[2];
			scripts.call("onChangeHealthBar", [healthBarPrefix]);
			scripts.call("onPostChangeHealthBar", [healthBarPrefix]);
		}
	}
}