import flixel.FlxSprite;

var vShader = null;
function postCreate() {
	vShader = new CustomShader("VortexEffect");
	vShader.spiralColor = [2.5*0.7, 1.0*0.7, 1.5*0.7];

	var vortex = new FlxSprite(-900,-1400);
	vortex.scrollFactor.set(0.2, 0.2);
	vortex.makeGraphic(1,1);
	vortex.setGraphicSize(4000, 4000);
	vortex.updateHitbox();
	insert(0, vortex);
	vortex.shader = vShader;
}
function postUpdate(elapsed) {
	vShader.iTime = Conductor.songPosition*0.001*3;
	if (colorswapShader != null) {
		vShader.hue = colorswapShader.hue;
	}
	
	//vShader.uTime = [colorswapShader.hue, 0, 0];
}