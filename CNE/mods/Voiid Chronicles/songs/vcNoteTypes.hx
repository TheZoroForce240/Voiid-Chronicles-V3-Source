

public var noteTypeData = [
	"none" => null
];

function create() {
	scripts.call("registerNoteTypes", []);
	//canDie = false;
	//downscroll = false;
}


function getNoteTypeWithoutCharacter(noteType) {
	if (!StringTools.contains(noteType, "char[")) return noteType;
	return noteType.substring(0, noteType.indexOf("char["));
}

function onNoteCreation(event) {
	var noteType = getNoteTypeWithoutCharacter(event.noteType);
	if (noteTypeData.exists(noteType)) {
		var data = noteTypeData.get(noteType);

		event.noteSprite = "game/voiid/notes/"+data.skin;

		if (!data.mustPress) {
			event.note.earlyPressWindow = 0.2;
			event.note.latePressWindow = 0.2;
			event.note.avoid = true;
		}

		if (data.echo != null && data.echo != "" && event.note.strumLine.ID == 1) {
			scripts.call("onEchoCreate", [event.note.strumTime, data.echo]);
		}
	}
}
function onNoteHit(event) 
{
	var noteType = getNoteTypeWithoutCharacter(event.noteType);
	if (noteTypeData.exists(noteType)) {
		var data = noteTypeData.get(noteType);
		if (!data.mustPress) {
			event.healthGain = -data.health;
		}

		if (data.animSuffix != null) {
			event.animSuffix = data.animSuffix;
		}
	}
}
function onPlayerMiss(event)
{
	var noteType = getNoteTypeWithoutCharacter(event.noteType);
	if (noteTypeData.exists(noteType)) {
		var data = noteTypeData.get(noteType);
		if (!data.mustPress) {
			event.cancel();
			event.animCancelled = true;
			strumLines.members[event.playerID].deleteNote(event.note);
		} else {
			event.healthGain = -data.health;
			applyEffect(data.effect);
		}
	}
}

var blurShaderV:CustomShader = null;
var blurShaderH:CustomShader = null;
var bleedShader:CustomShader = null;
function postCreate() {
	bleedShader = new CustomShader("VignetteEffect");
	bleedShader.strength = 25;
	bleedShader.size = 0;
	bleedShader.red = 200;
	camOther.addShader(bleedShader);

	blurShaderV = new CustomShader("blur");
    blurShaderV.strength = 3;
    blurShaderV.dirX = 0.0;
    blurShaderV.dirY = 1.0;
    FlxG.game.addShader(blurShaderV);

    blurShaderH = new CustomShader("blur");
    blurShaderH.strength = 3;
    blurShaderH.dirX = 1.0;
    blurShaderH.dirY = 0.0;
	FlxG.game.addShader(blurShaderH);

	graphicCache.cache(Paths.image("glasscrack"));
}
function destroy() {
	FlxG.game.removeShader(blurShaderV);
	FlxG.game.removeShader(blurShaderH);
}

public var drainHPBar:FlxSprite;
public var lostHPBar:FlxSprite;
function onPostChangeHealthBar(t) {
	maxHealth = actualMaxHealth-lostHealth;
	healthBar.setRange(healthBar.min, actualMaxHealth);

	if (drainHPBar == null) {
		drainHPBar = new FlxSprite();
		drainHPBar.makeGraphic(1,1,0xFFFF0000);
		drainHPBar.cameras = [camHUD];
	} else {
		remove(drainHPBar);
	}
	if (lostHPBar == null) {
		lostHPBar = new FlxSprite();
		lostHPBar.makeGraphic(1,1,0xFF000000);
		lostHPBar.cameras = [camHUD];
	} else {
		remove(lostHPBar);
	}

	insert(members.indexOf(healthBar)+1, drainHPBar);
	insert(members.indexOf(healthBar)+1, lostHPBar);

	lostHPBar.x = drainHPBar.x = healthBar.x;
	lostHPBar.y = drainHPBar.y = healthBar.y;
	
	drainHPBar.setGraphicSize(healthBar.width, healthBar.height);
	drainHPBar.updateHitbox();

	lostHPBar.setGraphicSize(healthBar.width, healthBar.height);
	lostHPBar.updateHitbox();

	if (t == "voiid/") {
		if (!downscroll) {
			drainHPBar.offset.y += 15;
			lostHPBar.offset.y += 15;
		} else {
			drainHPBar.offset.y -= 18;
			lostHPBar.offset.y -= 18;
		}
	}

	drainHPBar.scale.x = 0;

	scripts.call("onPostChangeMechanicBars", [t]);
}

var drainTime:Float = 0.0;
var blurTime:Float = 0.0;
var lostHealth:Float = 0.0;
var blurStrength:Float = 0.0;
public var actualMaxHealth:Float = 2;
public function applyEffect(effect) {
	switch(effect) {
		case "blur":
			blurStrength = 6;
			camGame.shake(0.03, 0.1);
			camHUD.shake(0.03, 0.1);

			var crack = new FlxSprite(0,0);
			crack.loadGraphic(Paths.image("glasscrack"));
			crack.antialiasing = true;
			crack.scale.set(0.6,0.6);
			crack.updateHitbox();
			crack.screenCenter();
			crack.alpha = 0.7;
			crack.x += FlxG.random.float(-200, 200);
			crack.y += FlxG.random.float(-200, 200);
			crack.angle += FlxG.random.float(-360, 360);
			crack.colorTransform.blueOffset = crack.colorTransform.greenOffset = crack.colorTransform.redOffset = 255;

			FlxG.sound.play(Paths.sound("glass"+FlxG.random.int(0,3)), 0.6);

			crack.cameras = [camOther];
			add(crack);
			new FlxTimer().start(3.0, function(tmr){
				FlxTween.tween(crack, {alpha: 0.0}, 1.0, {ease:FlxEase.cubeOut, onComplete:function(twn) {
					remove(crack);
				}});
			});
		case "blurSmall":
			blurStrength = 2;
		case "maxHealth":
			lostHealth += 0.25;
			maxHealth = actualMaxHealth-lostHealth;
			healthBar.setRange(healthBar.min, actualMaxHealth);
		case "drain":
			drainTime = 5.0;
	}
}
function updateEffects(elapsed) {
	if (drainTime > 0.0) {
		bleedShader.size = CoolUtil.fpsLerp(bleedShader.size, FlxMath.bound(drainTime, 0, 0.3), 0.1);
		drainTime -= elapsed;
		drainHPBar.scale.x = (drainTime/3)*drainHPBar.width;
		if (drainHPBar.scale.x >= healthBar.width * FlxMath.remapToRange(healthBar.percent, 0, 100, 0, 1))
			drainHPBar.scale.x = healthBar.width * FlxMath.remapToRange(healthBar.percent, 0, 100, 0, 1);

		drainHPBar.x = (healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0)) + (drainHPBar.scale.x/2) - (drainHPBar.width/2);

		if (health > elapsed)
			health -= elapsed/3;
	} else {
		drainTime = 0.0;
		bleedShader.size = 0;
		drainHPBar.scale.x = 0;
	}
	lostHPBar.scale.x = FlxMath.remapToRange(lostHealth, 0, actualMaxHealth, 0, lostHPBar.width);
	lostHPBar.x = healthBar.x + (lostHPBar.scale.x/2) - (lostHPBar.width/2);
	blurShaderH.strength = blurStrength = CoolUtil.fpsLerp(blurStrength, 0, 0.02);
	blurShaderV.strength = blurStrength;
}
function postUpdate(elapsed)
{

	updateEffects(elapsed);

	for(p in strumLines) {
		p.notes.forEach(function(note) {
			var noteType = getNoteTypeWithoutCharacter(note.noteType);
			if (noteTypeData.exists(noteType)) {
				var data = noteTypeData.get(noteType);
				
				var dir = multikeySingDirs[getKeyCountIndex(note.strumLine.ID)][note.strumID];
				
				if (!note.isSustainNote) {
					/*if (data.flipUS != null && data.flipUS && !downscroll) {
						note.flipY = true;
					}*/
					if (data.offsetsX != null) {
						note.x += data.offsetsX[dir]*1.4285*note.scale.x;
					}
					if (data.offsetsY != null && data.offsetsYDS != null) {
						note.y += (downscroll ? data.offsetsYDS[dir] : data.offsetsY[dir])*1.4285*note.scale.y;
					}
				}

			}
		});
	}

}