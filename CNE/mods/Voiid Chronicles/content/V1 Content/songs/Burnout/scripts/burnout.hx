var doNoteTrail = false;
var black = null;
function postCreate() {

	/*
    initShader('greyscale', 'GreyscaleEffect');
    setCameraShader('game', 'greyscale');
    setCameraShader('hud', 'greyscale');
    setShaderProperty('greyscale', 'strength', 1);

    initShader('bloom2', 'BloomEffect');
    setCameraShader('game', 'bloom2');
    setCameraShader('hud', 'bloom2');

	setShaderProperty('bloom2', 'contrast', 1);
    setShaderProperty('bloom2', 'effect', 0);
    setShaderProperty('bloom2', 'strength', 0);

    initShader('pixel', 'MosaicEffect');
    setCameraShader('game', 'pixel');
    
    setShaderProperty('pixel', 'strength', 0);

    initShader('mirror', 'MirrorRepeatEffect');
    initShader('mirror2', 'MirrorRepeatEffect');
	setCameraShader('game', 'mirror');
    setCameraShader('game', 'mirror2');
    if ( modcharts ) { 
        setCameraShader('hud', 'pixel');

        setCameraShader('hud', 'mirror');
        setCameraShader('hud', 'mirror2');
    }
	
    setShaderProperty('mirror', 'zoom', 0.5);
    setShaderProperty('mirror2', 'zoom', 1);
    setShaderProperty('mirror', 'angle', -45);

    initShader('vignette', 'VignetteEffect');
    setCameraShader('hud', 'vignette');
    setCameraShader('game', 'vignette');
    setShaderProperty('vignette', 'strength', 10);
    setShaderProperty('vignette', 'size', 0.5);
	*/
    
	black = new FlxSprite();
	black.cameras = [camHUD];
	black.makeGraphic(1,1,0xFF000000);
	black.setGraphicSize(4000,2000);
	black.updateHitbox();
	black.screenCenter();
	add(black);


	/*importScript("data/scripts/modchartManager.hx");

	createModifier("x", 0, "
		x += x_value;
	");

	createModifier("angleX", 0, "
		angleX += angleX_value;
	");
	createModifier("angleY", 0, "
		angleY += angleY_value;
	");
	createModifier("angleZ", 0, "
		angleZ += angleZ_value;
	");

	for ( i in 0...arrowSpins.length ) {

		var mod = "angleZ";
		if (arrowSpins[i][2] == "y") {
			mod = "angleY";
		}
		if (arrowSpins[i][2] == "x") {
			mod = "angleX";
		}
		set((arrowSpins[i][0]/4)-0.001, "0,"+mod);
		ease(arrowSpins[i][0]/4, 4, 'expoOut', arrowSpins[i][1] + ","+mod);
	}

	for ( i in 0...shakes.length ) {
		ease((shakes[i])/4, 0.5, 'expoOut', "30,x");
		ease((shakes[i]+2)/4, 0.5, 'expoOut', "-30,x");
		ease((shakes[i]+4)/4, 0.5, 'expoOut', "30,x");
		ease((shakes[i]+6)/4, 0.5, 'expoOut', "-30,x");
		ease((shakes[i]+8)/4, 0.5, 'expoOut', "0,x");
	}*/

	//initModchart();

}
var bursts = [
    128,
    256,
    512,
    656,
    662,
    704,
    768,
    896,
    1024,
    1280,
    1408,
    1424,
    1430,
    1472,
    1520,
    1664
];
var tilts = [
    [656, 20],
    [662, -20],
    [1424, 20],
    [1430, -20]
];

var arrowSpins = [
    [128, 360],
    [192, -360],
    [256, 360, 'y'],
    [320, -360],
	[384, -360, 'y'],
	[448, 360],
    [512, 360, 'x'],
    [544, -360],
    [640, -360, 'x'],
    [672, -360],
    [896, 360],
    [960, -360],
    [1024, 360, 'y'],
    [1088, -360],
	[1120, 360, 'x'],
	[1152, -360, 'y'],
	[1216, -360],
    [1280, 360],
    [1312, -360],
    [1408, -360, 'x'],
    [1440, -360],
	[1472, 360, 'x'],
	[1488, 360, 'x'],
	[1504, 360, 'x'],
    [1536, 360],
    [1568, -360],
    [1600, 360],
	[1616, -360],
    [1632, -360],
    [1664, 360],
];
var shakes = [
    616,744,1384
];

var originalNotePositions = [];

function stepHit() {

   doNoteTrail = false;
    if ( modcharts ) { 
        if ( (curStep >= 614 && curStep < 638) || (curStep >= 655 && curStep < 657) || (curStep >= 661 && curStep < 663) 
        || (curStep >= 743 && curStep < 769) || (curStep >= 1383 && curStep < 1406) 
        || (curStep >= 1423 && curStep < 1425) || (curStep >= 1429 && curStep < 1431) || (curStep >= 1520) ) { 
			doNoteTrail = true;
        }
    }


    var section = Math.floor(curStep/16);
	/*
    if ( section > 0 && section < 92 ) { 
        if ( curStep % 32 == 0 ) { 
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut');
        } else if ( curStep % 32 == 28 ) { 
            tweenShaderProperty('mirror', 'zoom', 0.95, crochet*0.001*4, 'cubeIn');
        }

        if ( curStep % 32 == 20 ) { 
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut');
        } else if ( curStep % 32 == 16 ) { 
            tweenShaderProperty('mirror', 'zoom', 0.95, crochet*0.001*4, 'cubeIn');
        }
    }

    if ( curStep == 240 || curStep == 1008 ) { 
        tweenShaderProperty('mirror2', 'zoom', 0.9, crochet*0.001*16, 'cubeIn');
    } else if ( curStep == 240+16 || curStep == 1008+16 ) { 
        tweenShaderProperty('mirror2', 'zoom', 1, crochet*0.001*4, 'cubeOut');
    }
    if ( curStep == 496 || curStep == 1264 ) { 
        tweenShaderProperty('mirror2', 'zoom', 0.9, crochet*0.001*16, 'cubeIn');
        tweenShaderProperty('mirror2', 'angle', 45, crochet*0.001*16, 'cubeIn');
        tweenShaderProperty('pixel', 'strength', 45, crochet*0.001*16, 'cubeIn');
    } else if ( curStep == 496+16 || curStep == 1264+16 ) { 
        tweenShaderProperty('mirror2', 'zoom', 1, crochet*0.001*4, 'cubeOut');
        tweenShaderProperty('mirror2', 'angle', 0, crochet*0.001*4, 'cubeOut');
        tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*4, 'cubeOut');
    }

    if ( curStep == 624 || curStep == 1392 ) { 
        tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001*16, 'cubeOut');
    } else if ( curStep == 624+16 || curStep == 1392+16 ) {
        tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*2, 'cubeOut');
    }

    if ( curStep == 752 ) { 
        tweenShaderProperty('mirror2', 'angle', 60, crochet*0.001*16, 'cubeIn');
        tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001*16, 'cubeOut');
    } else if ( curStep == 752+16 ) { 
        tweenShaderProperty('mirror2', 'angle', 0, crochet*0.001*4, 'cubeOut');
        tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*64, 'cubeIn');
    }

    for ( i in 0...bursts.length ) {
        if ( curStep == bursts[i] ) { 
            bloomBurst();
        }
    }
    for ( i in 0...tilts.length ) {
        if ( curStep == tilts[i][1]-2 ) { 
            tweenShaderProperty('mirror', 'angle', tilts[i][2], crochet*0.001*2, 'cubeIn');
        } else if ( curStep == tilts[i][1] ) { 
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*3, 'cubeOut');
        }
    }

    if ( curStep == 1504 ) { 
        tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001*16, 'cubeIn');
    } else if ( curStep == 1648 ) {
        tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*16, 'cubeOut');
    }*/

    if ( modcharts ) { 
		if (curStep == 768 || curStep == 1664) {
			for (s in strumLines) {
				var pos = [];
				for (strum in s.members) {
					strum.moves = true;
					strum.velocity.x = FlxG.random.float(-100, 100);
					strum.velocity.y = FlxG.random.float(0.3, 1) * -500 * (downscroll ? -1 : 1);
					strum.acceleration.y = 800 * (downscroll ? -1 : 1);
					pos.push([strum.x, strum.y]);
				}
				originalNotePositions.push(pos);
			}
		} else if ( curStep == 864 ) {
			var sID = 0;
			for (s in strumLines) {
				var i = 0;
				for (strum in s.members) {
					strum.moves = false;
					strum.velocity.x = 0;
					strum.velocity.y = 0;
					strum.acceleration.y = 0;
					FlxTween.tween(strum, {x: originalNotePositions[sID][i][0],
						y: originalNotePositions[sID][i][1]}, crochet*0.001*32, {ease:FlxEase.expoOut});

					i++;
				}
				sID++;
			}
		}

		/*
        if ( curStep == 768 || curStep == 1664 ) { 
            for ( i = 0, (keyCount+playerKeyCount)-1 ) {
                setActorVelocityX(((math.random()*2)-1)*200, i); //explodey
                setActorVelocityY((math.random()*-300)-200, i);
                setActorAccelerationY(800, i);
            }
            setProperty('noteBG', 'visible', false);
        } else if ( curStep == 864 ) {
            for ( i = 0, (keyCount+playerKeyCount)-1 ) {
                setActorVelocityX(0, i);
                setActorVelocityY(0, i);
                setActorAccelerationY(0, i);
                tweenActorProperty(i, 'x', _G["defaultStrum"..i..'X'], crochet*0.001*32, 'expoOut');
                tweenActorProperty(i, 'y', _G["defaultStrum"..i..'Y'], crochet*0.001*32, 'expoOut');
            }
            setProperty('noteBG', 'visible', true);
        }

        for ( i in 0...arrowSpins.length ) {
            if ( curStep == arrowSpins[i][1] ) { 
                for ( j = 0, (keyCount+playerKeyCount)-1) {
                    tweenActorProperty(j, 'modAngle', arrowSpins[i][2], crochet*0.001*16, 'expoOut');
                }
            
            } else if ( curStep == arrowSpins[i][1]+17 ) {
                for ( j = 0, (keyCount+playerKeyCount)-1 ) {
                    setActorModAngle(0, j); //reset
                }
            }
        }

        for ( i in 0...shakes.length ) {
            if ( curStep == shakes[i] ) { 
                for ( j = 0, (keyCount+playerKeyCount)-1) {
                    tweenActorProperty(j, 'x', _G["defaultStrum"..j..'X']+30, crochet*0.001*2, 'expoOut');
                }
            } else if ( curStep == shakes[i]+2 ) {
                for ( j = 0, (keyCount+playerKeyCount)-1) {
                    tweenActorProperty(j, 'x', _G["defaultStrum"..j..'X']-30, crochet*0.001*2, 'expoOut');
                }
            } else if ( curStep == shakes[i]+4 ) {
                for ( j = 0, (keyCount+playerKeyCount)-1) {
                    tweenActorProperty(j, 'x', _G["defaultStrum"..j..'X']+30, crochet*0.001*2, 'expoOut');
                }
            } else if ( curStep == shakes[i]+6 ) {
                for ( j = 0, (keyCount+playerKeyCount)-1) {
                    tweenActorProperty(j, 'x', _G["defaultStrum"..j..'X']-30, crochet*0.001*2, 'expoOut');
                }
            } else if ( curStep == shakes[i]+8 ) {
                for ( j = 0, (keyCount+playerKeyCount)-1) {
                    tweenActorProperty(j, 'x', _G["defaultStrum"..j..'X'], crochet*0.001*2, 'expoOut');
                }
            }
        }
		*/

    }
}




function onSongStart() {
    black.alpha = 0;
    //tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*16, 'cubeOut');
    //tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*12, 'cubeOut');

    //tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*16*6, 'cubeIn');
}

var noteTrailCount = 0;
var noteTrailCap = 50;
var trails = [];
function onNoteHit(e) {
	if (!e.note.isSustainNote && doNoteTrail) {
		if (trails[noteTrailCount] == null) {
			trails[noteTrailCount] = new FlxSprite();
			add(trails[noteTrailCount]);
		}
		var spr = trails[noteTrailCount];
		var source = e.note;


		spr.setPosition(e.note.__strum.x, e.note.__strum.y);
		spr.frames = source.frames;
		spr.animation.copyFrom(source.animation);
		spr.visible = source.visible;
		spr.alpha = source.alpha;
		spr.antialiasing = source.antialiasing;
		spr.scale.set(source.scale.x, source.scale.y);
		spr.updateHitbox();
		spr.scrollFactor.set(source.scrollFactor.x, source.scrollFactor.y);
		spr.cameras = [camHUD];
		spr.shader = source.shader;
		
		spr.alpha = 0.6;
		FlxTween.tween(spr, {y: spr.y - 250}, crochet*0.001*16);
		FlxTween.tween(spr, {alpha: 0}, crochet*0.001*16, {ease:FlxEase.expoInOut});

		noteTrailCount++;
		if (noteTrailCount > noteTrailCap) noteTrailCount = 0;
	}
}

/*
var noteTrailCount = 0;
var noteTrailCap = 50;
function playerOneSingExtra(data, id, noteType, isSus) {
    if ( not isSus && doNoteTrail ) { 
        makeNoteTrail(data, id, noteType);
    }
}
function playerTwoSingExtra(data, id, noteType, isSus) {
    if ( not isSus && doNoteTrail ) { 
        makeNoteTrail(data, id, noteType);
    }
}

function makeNoteTrail(data, id, noteType) {

    var trail = 'noteTrail'..noteTrailCount

    var yVal = 150
    if (!downscroll) { 
        yVal = yVal * -1;
    }

    destroySprite(trail);
    makeNoteCopy(trail, id);
    setActorAlpha(0.6, trail);
    tweenActorProperty(trail, 'y', getActorY(trail)+yVal, crochet*0.001*16, 'linear');
    tweenActorProperty(trail, 'alpha', 0, crochet*0.001*16, 'expoInOut');

    setObjectCamera(trail, 'hud');

    noteTrailCount = noteTrailCount + 1;
    if ( noteTrailCount > noteTrailCap ) { 
        noteTrailCount = 0;
    }
}
*/