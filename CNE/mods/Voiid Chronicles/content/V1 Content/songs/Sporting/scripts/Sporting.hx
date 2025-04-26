
var left:FlxSprite;
var right:FlxSprite;

function postCreate() {
	camGame.zoom += 0.2;

    showOnlyStrums = true;

	left = new FlxSprite();
	left.cameras = [camHUD];
	left.makeGraphic(1,1,0xFF000000);
	left.setGraphicSize(160,720);
	left.updateHitbox();
	left.screenCenter();
	left.x = -160;
	add(left);

	right = new FlxSprite();
	right.cameras = [camHUD];
	right.makeGraphic(1,1,0xFF000000);
	right.setGraphicSize(160,720);
	right.updateHitbox();
	right.screenCenter();
	right.x = 1280;
	add(right);
}

var pixelMode = false;

function stepHit() {
    var section = Math.floor(curStep/16);
    var secStep = curStep%16;
    var doubleSecStep = curStep%32;

	if (secStep == 0) sectionHit(section);
}

function sectionHit(section) {

	 if (section == 16) { 
        showOnlyStrums = false;
    }
    

    if (section == 95) { 
        pixelMode = true;

		FlxTween.tween(left, {x: 0}, crochet*0.001*16, {ease:FlxEase.expoIn});
		FlxTween.tween(right, {x: 1280-160}, crochet*0.001*16, {ease:FlxEase.expoIn});

    } else if (section == 127) { 
        pixelMode = false;

		FlxTween.tween(left, {x: -160}, crochet*0.001*16, {ease:FlxEase.expoIn});
		FlxTween.tween(right, {x: 1280}, crochet*0.001*16, {ease:FlxEase.expoIn});

    } else if (section == 128) { 
        showOnlyStrums = true;
	} else if (section == 130) { 
        showOnlyStrums = false;
    }
}
function postUpdate(elapsed) {


    if (pixelMode) { 
		FlxG.camera.targetOffset.x = (FlxG.camera.scroll.x % 6);
		FlxG.camera.targetOffset.y = (FlxG.camera.scroll.y % 6);
    }
}