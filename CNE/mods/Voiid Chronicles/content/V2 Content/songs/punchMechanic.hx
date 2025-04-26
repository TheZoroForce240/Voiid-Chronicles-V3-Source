public var songHasPunches = false;

var punches = [];
var punchEarlyHitTiming = 160; //anim time = 666ms
var punchLateHitTiming = 160;
var dodging = false;
var dodgeCooldown = 0;
var canBeDodged = false;
var punchAlphas = [0,0,0];
var punchAlphaLerpSpeed = 0.1;

var fadeOutDelay = 0.0;

var punchSprites = [];
var msText:FunkinText;
var punchesLeftText:FunkinText;

function setupPunches() {
	for (i in 0...3) {
		var spr = new FlxSprite();
		spr.frames = Paths.getSparrowAtlas("punch"+(i+1));
		spr.cameras = [camHUD];
		spr.animation.addByPrefix("punch", "punch"+(i+1), 24, false);
		spr.animation.play("punch");
		spr.screenCenter();
		spr.alpha = 0;
		add(spr);
		punchSprites.push(spr);
	}

	msText = new FunkinText();
	msText.size = 32;
	msText.text = "";
	msText.cameras = [camHUD];
	msText.screenCenter();
	add(msText);

	msText.y = getY(450, 32);

	punchesLeftText = new FunkinText();
	punchesLeftText.size = 48;
	punchesLeftText.text = "";
	punchesLeftText.cameras = [camHUD];
	punchesLeftText.screenCenter();
	add(punchesLeftText);

	punchesLeftText.y = getY(300, 48);
}
function getY(y, objHeight) {
	if (!downscroll) return y;

	return -y + FlxG.height - objHeight;
}

function updatePosition() {
	var pos = strumLines.members[1].members[0].x;
	var width = (strumLines.members[1].members[strumLines.members[1].members.length-1].x + strumLines.members[1].members[strumLines.members[1].members.length-1].width) - pos;

	for (i in 0...3) {
		punchSprites[i].x = pos + (width*0.5) - (punchSprites[i].width*0.5);
	}
	msText.x = pos + (width*0.5) - (msText.width*0.5);
	punchesLeftText.x = pos + (width*0.5) - (punchesLeftText.width*0.5);
}

function create() {
	for (event in events) {
		switch(event.name) {
			case "Punch" | "Slash":
				onPunchLoaded(event.time, event.params[0], event.params[1], event.name.toLowerCase());
		}
	}
}

function onPunchLoaded(time, count, beats, type) {
	if (!songHasPunches) {
		songHasPunches = true;
		setupPunches();
	}
	
	punches.push({
		time: time,
		count: count,
		beatTiming: beats,
		started: false,
		punchesLeft: count,
		punchesHit: 0,
		punchTime: time,
		type: type
	});

	for (i in 0...count) {

		var bpmChange = {
			stepTime: 0,
			songTime: 0,
			bpm: Conductor.bpm
		};

		for(change in Conductor.bpmChangeMap)
			if (change.songTime < time && change.songTime >= bpmChange.songTime)
				bpmChange = change;

		var croch = ((60 / bpmChange.bpm) * 1000);

		var t = time + (i * beats * croch);

		scripts.call("onEchoCreate", [t, "Wiik3White"]);
	}
}
var firstFrame = true;
function postUpdate(elapsed) {
	if (songHasPunches) {
		if (firstFrame) {
			firstFrame = false;
			punches.sort(function(a, b) {
				if(a.time < b.time) return -1;
				else if(a.time > b.time) return 1;
				else return 0;
			 });
		}
		updateLogic(elapsed);
		updatePosition();
	}
}
function getIndex(count) {if (count > 3) count = 3; return count-1;}

function updateLogic(elapsed) {
	canBeDodged = false;

	if (punches.length > 0) {
		var p = punches[0];
		var beatTiming = p.beatTiming * Conductor.crochet;

        if (p.time-800 < Conductor.songPosition) {
			punchAlphas[getIndex(p.count)] = 1;
		}
		if (p.time - beatTiming < Conductor.songPosition) {
			punchAlphas[getIndex(p.count)] = 1;
			punchAlphaLerpSpeed = 0.1;
			fadeOutDelay = 0;
            p.punchTime = p.time + (p.punchesHit*beatTiming);

			punchesLeftText.text = p.punchesLeft;
			punchesLeftText.color = 0xFFFFFFFF;

			if (p.punchTime - punchEarlyHitTiming < Conductor.songPosition && Conductor.songPosition < p.punchTime + punchLateHitTiming) {
				punchesLeftText.color = 0xFFFF0000;
				canBeDodged = true;

				if (!p.started && p.punchTime-100 <= Conductor.songPosition) {
					p.started = true;
					punchSprites[getIndex(p.count)].animation.play("punch", true);
				}

				if (p.punchTime <= Conductor.songPosition) {
					if (strumLines.members[1].cpu) {
						tryDodge(true);
					}
				}
			}

			if (Conductor.songPosition > p.punchTime+punchLateHitTiming) {
				onMissPunch();
			}
		}
	}

	if (!dodging) {
		if (FlxG.keys.justPressed.SPACE && !strumLines.members[1].cpu) {
			tryDodge(false);
		}
	} else {
		dodgeCooldown -= 1000*elapsed;
		if (dodgeCooldown <= 0) {
			dodgeCooldown = 0;
			dodging = false;
		}
	}

    if (fadeOutDelay > 0) {
		fadeOutDelay -= 1000*elapsed;
	} else {
		for (i in 0...3) {
			punchSprites[i].alpha = CoolUtil.fpsLerp(punchSprites[i].alpha, punchAlphas[i], punchAlphaLerpSpeed);
		}
	}
    
	msText.alpha = CoolUtil.fpsLerp(msText.alpha, 0, 0.1);
}
function onMissPunch() {
	switch(punches[0].type) {
		case "punch":
			health -= 1.0;
			applyEffect("blur");
		case "slash":
			health -= 0.35;
			applyEffect("maxHealth");
	}
	
	msText.text = "miss";
	msText.color = 0xFFFF0000;
	punchRemove();
}
function tryDodge(cpu) {
	dodging = true;
    dodgeCooldown = 500;
    playDodge();
    if (canBeDodged) {
		dodging = false;
        dodgeCooldown = 0;

		var ms = -Math.floor(punches[0].punchTime-Conductor.songPosition);
		if (cpu)
			msText.text = "";
		else
			msText.text = ms + "ms";

		msText.alpha = 1;
		msText.color = 0xFFFFFFFF;

		punchRemove();
	}
}
function playDodge() {
	boyfriend.playSingAnim(FlxG.random.int(0, 3), "-dodge");
}
function punchRemove() {
	punches[0].punchesLeft -= 1;
	punches[0].punchesHit += 1;
    
    if (punches[0].punchesLeft <= 0) { 
        punchesLeftText.text = "";
        fadeOutDelay = 500;
        punchAlphas[getIndex(punches[0].count)] = 0;
        punches.remove(punches[0]);
        return true;
	} else {
		punches[0].started = false;
	}
    return false;
}
function onNoteHit(e) {
	if (e.note.strumLine.ID == 1) dodgeCooldown = 0;
}