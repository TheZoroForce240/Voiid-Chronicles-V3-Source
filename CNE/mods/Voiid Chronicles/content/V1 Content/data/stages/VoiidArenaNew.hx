import funkin.backend.shaders.CustomShader;
public var camScreen:FlxCamera;
function postCreate() {

	FlxG.cameras.remove(camHUD, false);

	FlxG.cameras.add(camScreen = new FlxCamera(), false);
	camScreen.bgColor = 0;
	FlxG.cameras.add(camHUD, false);

	for (s in strumLines) {
		for (char in s.characters) {
			char.forceIsOnScreen = true;
		}
	}

	//trace(stage.stageSprites["bg"].width);
	//trace(stage.stageSprites["bg"].height);
}

var loaded = false;
function postUpdate(elapsed) {
	if (!loaded) { //load on first frame cuz the colorswap fucks with it loading in postcreate

		//needs to be on another camera because you cant really render something while its already being rendered to the same framebuffer (you can it just looks weird)
		stage.stageSprites["screen"].cameras = [camScreen];
		stage.stageSprites["grain"].cameras = [camScreen];
		stage.stageSprites["screen"].shader = new CustomShader("screenShader");
		loaded = true;
	}
	FlxG.camera.canvas.__cacheAsBitmap = true; //store the bitmap so we can use in shader
	if (FlxG.camera.canvas.__cacheBitmapRenderer != null) {
		//FlxG.camera.canvas.__cacheBitmapRenderer.__updateCacheBitmap(FlxG.camera.canvas.__cacheBitmapRenderer, true);
		stage.stageSprites["screen"].shader.screenBitmap = FlxG.camera.canvas.__cacheBitmap.bitmapData;
		stage.stageSprites["screen"].shader.zoom = FlxG.camera.zoom;
		stage.stageSprites["screen"].shader.width = FlxG.camera.canvas.__cacheBitmap.bitmapData.width; //width/height sometimes changes?
		stage.stageSprites["screen"].shader.height = FlxG.camera.canvas.__cacheBitmap.bitmapData.height;

		stage.stageSprites["screen"].shader.scale = FlxG.scaleMode.scale.x > FlxG.scaleMode.scale.y ? FlxG.scaleMode.scale.x : FlxG.scaleMode.scale.y;
	}

	camScreen.scroll = camGame.scroll;
	camScreen.zoom = camGame.zoom;
	camScreen.angle = camGame.zoom;
	camScreen._filters = camGame._filters;


	for (s in strumLines) {
		for (char in s.characters) {
			char.cameraOffset.y = -800 / (camGame.zoom*10);
		}
	}

	
}