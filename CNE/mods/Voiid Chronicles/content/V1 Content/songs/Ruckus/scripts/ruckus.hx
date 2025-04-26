var black:FlxSprite;
function postCreate() {
    
	black = new FlxSprite();
	black.cameras = [camHUD];
	black.makeGraphic(1,1,0xFF000000);
	black.setGraphicSize(4000,2000);
	black.updateHitbox();
	black.screenCenter();
	add(black);
}
    
function onSongStart() {
	FlxTween.tween(black, {alpha: 0}, crochet*0.001*16*4, {ease:FlxEase.cubeOut});
}