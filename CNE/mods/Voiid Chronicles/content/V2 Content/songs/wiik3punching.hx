var state = {
	bfBlock: true,
	mattBlock: true,

	mattParry: false,

	bfEchoTrail: false,
	mattEchoTrail: false,

	pushTrails: false,

	pushing: false,
};

var mattOnTop = false;

var depth = 0.9;

var pushAmount = 0;
public var pushPower = 10;
public var maxPush = 600;
public var minPush = -600;


var defaultBFX = 0;
var defaultBFY = 0;

var defaultMattX = 0;
var defaultMattY = 0;

var firstFrame = true;

var mattEchoBack:Character;
var bfEchoBack:Character;

var punchingEnabled:Bool = false;

function postCreate() {
	//strumLines.members[0].characters.push(mattEchoBack = new Character(dad.x, dad.y, dad.curCharacter));
	//add(mattEchoBack);

	//strumLines.members[1].characters.push(bfEchoBack = new Character(boyfriend.x, boyfriend.y, boyfriend.curCharacter, true));
	//add(bfEchoBack);

	punchingEnabled = dad.hasAnimation("singLEFT-block");
}
function onStageChanged(name) {
	punchingEnabled = dad.hasAnimation("singLEFT-block");
	defaultBFX = boyfriend.x;
	defaultBFY = boyfriend.y;
	defaultMattX = dad.x;
	defaultMattY = dad.y;
}
function onCharactersChanged(strumlineID, names) {
	punchingEnabled = dad.hasAnimation("singLEFT-block");
	if (strumlineID == 0) {
		defaultMattX = dad.x;
		defaultMattY = dad.y;
	} else if (strumlineID == 1) {
		defaultBFX = boyfriend.x;
		defaultBFY = boyfriend.y;
	}
}

function update(elapsed) {
	if (!punchingEnabled) {
		return;
	}
	if (firstFrame) {
		defaultBFX = boyfriend.x;
		defaultBFY = boyfriend.y;
		defaultMattX = dad.x;
		defaultMattY = dad.y;
		firstFrame = false;
	}
	boyfriend.scale.x = boyfriend.scale.y = depth;
	dad.scale.x = dad.scale.y = depth;

	boyfriend.y = defaultBFY + ((depth-1)*150);
	dad.y = defaultMattY + ((depth-1)*150);

}

function onNoteHit(e) {
	if (!punchingEnabled) {
		return;
	}

	if (e.note.strumLine.ID == 0) {
		mattHit(e);
	} else if (e.note.strumLine.ID == 1) {
		bfHit(e);
	}
}

function bfHit(e) {
	if (state.mattParry) {
		dad.playSingAnim(e.direction, "-parry");
		return;
	}
	if (state.mattBlock) {
		dad.playSingAnim(e.direction, "-block");

		if (state.pushing) {
			if (pushAmount > minPush) {
				pushAmount -= pushPower;
				boyfriend.x -= pushPower;
				dad.x -= pushPower;
			}

			if (state.pushTrails) {
				makePushTrail(boyfriend);
			}
		}

	}
	if (mattOnTop) {
		remove(dad);
		insert(members.indexOf(boyfriend), dad);
		mattOnTop = false;
	}
}
function mattHit(e) {
	if (state.bfBlock && !StringTools.endsWith(boyfriend.getAnimName(), "-dodge")) {
		boyfriend.playSingAnim(e.direction, "-block");

		if (state.pushing) {
			if (pushAmount < maxPush) {
				pushAmount += pushPower;
				boyfriend.x += pushPower;
				dad.x += pushPower;
			}
			if (state.pushTrails) {
				makePushTrail(dad);
			}
		}
	}
	if (!mattOnTop) {
		remove(boyfriend);
		insert(members.indexOf(dad), boyfriend);
		mattOnTop = true;
	}
}

var echoShader = new CustomShader("EchoEffect");

function makeTrail(char) {
	var spr = FunkinSprite.copyFrom(char);
	spr.x += char.globalOffset.x;
	spr.y += char.globalOffset.y;
	insert(members.indexOf(char)-1, spr);
	return spr;
}

function makePushTrail(char) {
	var spr = makeTrail(char);

	//spr.colorTransform.redMultiplier = spr.colorTransform.blueMultiplier = spr.colorTransform.greenMultiplier = 0;

	//spr.alpha = 0.5;

	spr.shader = echoShader;

	FlxTween.tween(spr, {alpha: 0}, Conductor.crochet*0.001*2, {ease:FlxEase.expoInOut, onComplete: function(twn)
	{
		remove(spr);
	}});
}