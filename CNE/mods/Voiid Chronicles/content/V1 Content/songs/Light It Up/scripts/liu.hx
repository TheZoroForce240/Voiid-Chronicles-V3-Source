function create() {
    //setProperty('', 'playCount) {wn', false)
	//introLength = 1;
}
function onCountdown(e) {
	if (Conductor.songPosition < 6000) e.cancel();
	e.soundPath = "";
}
function onPostStartCountdown() {
	Conductor.songPosition = -1000;
}
function postCreate() {
	var black = new FlxSprite();
	black.cameras = [camHUD];
	black.makeGraphic(1,1,0xFF000000);
	black.setGraphicSize(4000,2000);
	black.updateHitbox();
	black.screenCenter();
	add(black);
	FlxTween.tween(black, {alpha: 0}, 1.5, {ease:FlxEase.quadIn});
}
var three = [160];
var two = [168,172,173,174];
var one = [176,180];
var go = [184, 186, 188, 190,191,192,220,222,224,248,252];
function stepHit() {
    for ( i in 0...three.length) { 
        if ( curStep == three[i] ){ 

        }
    }

    for ( i in 0...two.length) { 
        if ( curStep == two[i] ){ 
			countdown(1);
        }
    }
    for ( i in 0...one.length) { 
        if ( curStep == one[i] ){ 
			countdown(2);
        }
    }
    for ( i in 0...go.length) { 
        if ( curStep == go[i] ){ 
            countdown(3);
        }
    }
}