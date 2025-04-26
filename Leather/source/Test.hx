package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import openfl.geom.Rectangle;
import perspective.*;

class TestState extends FlxState
{
	override public function create()
	{
		super.create();

		/*
		FlxPerspectiveSprite.globalCamera.cameraStyle = FOLLOW;
		FlxPerspectiveSprite.globalCamera.lookAt.z = 0.0;

		var scene = new FlxScene3D();
		add(scene);

		var wall = new FlxPerspectiveSprite(0, 0, 640);
		wall.loadGraphic(FlxGradient.createGradientBitmapData(1, 720, [FlxColor.LIME, FlxColor.RED]));
		wall.setGraphicSize(1280, 720);
		wall.antialiasing = true;
		wall.updateHitbox();
		wall.screenCenter();
		scene.add(wall);

		var floor = new FlxPerspectiveStrip(0, 720, 0);
		floor.isFloor = true;
		floor.repeat = true;
		floor.antialiasing = true;
		floor.makeGraphic(100, 100, FlxColor.WHITE);
		floor.pixels.fillRect(new Rectangle(0, 0, 50, 50), 0xFF000000); // make checkerboard
		floor.pixels.fillRect(new Rectangle(50, 50, 50, 50), 0xFF000000);
		floor.addVertex({
			x: 0,
			y: 0,
			z: 640,
			uvX: 0,
			uvY: 0
		});
		floor.addVertex({
			x: 1280,
			y: 0,
			z: 640,
			uvX: 10,
			uvY: 0
		});
		floor.addVertex({
			x: 0,
			y: 0,
			z: -640,
			uvX: 0,
			uvY: 10
		});
		floor.addVertex({
			x: 0,
			y: 0,
			z: -640,
			uvX: 0,
			uvY: 10
		});
		floor.addVertex({
			x: 1280,
			y: 0,
			z: 640,
			uvX: 10,
			uvY: 0
		});
		floor.addVertex({
			x: 1280,
			y: 0,
			z: -640,
			uvX: 10,
			uvY: 10
		});
		floor.indices.push(1);
		floor.indices.push(0);
		floor.indices.push(2);
		floor.indices.push(5);
		floor.indices.push(4);
		floor.indices.push(3);

		// floor.indices.push(3);
		// floor.indices.push(1);
		// floor.indices.push(2);
		scene.add(floor);

		var testObj = new FlxPerspectiveSprite(0, 0, 0);
		testObj.loadGraphic(FlxGraphic.fromClass(GraphicLogo));
		testObj.setGraphicSize(200);
		testObj.updateHitbox();
		testObj.antialiasing = true;
		testObj.screenCenter(X);
		testObj.y = 720 - testObj.height;
		scene.add(testObj);

		var cubeN:FlxPerspectiveSprite = new FlxPerspectiveSprite(1000, 520);
		cubeN.makeGraphic(200, 200, FlxColor.RED);
		var cubeS:FlxPerspectiveSprite = new FlxPerspectiveSprite(1000, 520, 200);
		cubeS.makeGraphic(200, 200, FlxColor.GREEN);

		var cubeE:FlxPerspectiveSprite = new FlxPerspectiveSprite(900, 520, 100);
		cubeE.scale.x = 0;
		cubeE.updateHitbox();
		cubeE.offsetTL = cubeE.offsetBL = [0, 0, 100, 0];
		cubeE.offsetTR = cubeE.offsetBR = [0, 0, -100, 0];
		cubeE.makeGraphic(200, 200, FlxColor.BLUE);

		var cubeW:FlxPerspectiveSprite = new FlxPerspectiveSprite(1100, 520, 100);
		cubeW.scale.x = 0;
		cubeW.updateHitbox();
		cubeW.offsetTL = cubeW.offsetBL = [0, 0, 100, 0];
		cubeW.offsetTR = cubeW.offsetBR = [0, 0, -100, 0];
		cubeW.makeGraphic(200, 200, FlxColor.PURPLE);

		var cubeTop:FlxPerspectiveSprite = new FlxPerspectiveSprite(1000, 520, 100);
		cubeTop.offsetTL = cubeTop.offsetTR = [0, 0, 100, 0];
		cubeTop.offsetBL = cubeTop.offsetBR = [0, 0, -100, 0];
		cubeTop.makeGraphic(200, 200, FlxColor.ORANGE);
		cubeTop.scale.y = 0;
		cubeTop.updateHitbox();

		scene.add(cubeN);
		scene.add(cubeS);
		scene.add(cubeE);
		scene.add(cubeW);
		scene.add(cubeTop);

		var monkey = new FlxPerspectiveStrip(100, 600);
		monkey.antialiasing = true;
		monkey.repeat = true;
		monkey.makeGraphic(100, 100, FlxColor.GRAY);
		monkey.applyModelData(OBJLoader.loadFromAssets(Paths.file("models/monkey.obj"))[0]);
		monkey.alpha = 0.5;
		scene.add(monkey);

		var sphere = new FlxPerspectiveStrip(640, 600, -600);
		sphere.antialiasing = true;
		sphere.repeat = true;
		sphere.loadGraphic(FlxGraphic.fromClass(GraphicLogo));
		sphere.applyModelData(OBJLoader.loadFromAssets(Paths.file("models/sphere.obj"))[0]);
		scene.add(sphere);
		/*

			shag = new FlxPerspectiveStrip(0);
			shag.antialiasing = true;
			shag.repeat = true;
			var modelData = OBJLoader.loadFromAssets(Paths.file("models/shaggy.obj"), true)[0];
			trace(modelData.mtl);
			shag.loadGraphic(Paths.file("models/"+modelData.mtl.diffuseTexture, IMAGE));
			shag.applyModelData(modelData);
			scene.add(shag);

			var testCube = new FlxPerspectiveStrip(0, 600);
			testCube.antialiasing = true;
			testCube.repeat = true;
			testCube.loadGraphic(Paths.image("bf"));
			var cubeData = OBJLoader.loadString(lime.utils.Assets.getText(Paths.file("models/sphere.obj")))[0];
			testCube.applyModelData(cubeData);
			scene.add(testCube);

			//var test = OBJLoader.loadMTLFromString(lime.utils.Assets.getText(Paths.file("models/matt/matt.mtl")));

			//var mattData = OBJLoader.loadString(lime.utils.Assets.getText(Paths.file("models/matt/matt.obj")), null, true);
			//var imagePaths = ["models/matt/matt_shirt.png", "models/matt/head_and_face.png", "models/matt/hands.png", "models/matt/pants.png"];

			var mattData = OBJLoader.loadFromAssets(Paths.file("models/matt/matt"), true);
			for (i in 0...mattData.length)
			{
				var p = new FlxPerspectiveStrip(300, 0);
				p.antialiasing = true;
				p.repeat = true;
				//trace(mattData[i].vertices.length);
				p.loadGraphic(Paths.file("models/matt/" + mattData[i].mtl.diffuseTexture, IMAGE));
				p.applyModelData(mattData[i]);
				scene.add(p);
			}

		 */

		// trace(testTri.stripVertices);
		/*

			testTri.addVertex({x: 100, y:-100, z:100, uvX: 1, uvY: 0});
			testTri.addVertex({x: -100, y:-100, z:100, uvX: 0, uvY: 0});
			testTri.addVertex({x: 100, y:100,  z:100, uvX: 1, uvY: 1});
			testTri.addVertex({x: -100, y:100, z:100, uvX: 0, uvY: 1});
			testTri.addVertex({x: 100, y:100, z:100, uvX: 1, uvY: 1});
			testTri.addVertex({x: -100, y:-100, z:100, uvX: 0, uvY: 0});

			testTri.addVertex({x: -100, y:-100, z:-100, uvX: 0, uvY: 0});
			testTri.addVertex({x: 100, y:-100, z:-100, uvX: 1, uvY: 0});
			testTri.addVertex({x: 100, y:100,  z:-100, uvX: 1, uvY: 1});
			testTri.addVertex({x: 100, y:100, z:-100, uvX: 1, uvY: 1});
			testTri.addVertex({x: -100, y:100, z:-100, uvX: 0, uvY: 1});
			testTri.addVertex({x: -100, y:-100, z:-100, uvX: 0, uvY: 0});

			testTri.addVertex({x: 100, y:100, z:-100, uvX: 1, uvY: 1});
			testTri.addVertex({x: -100, y:100, z:-100, uvX: 0, uvY: 1});
			testTri.addVertex({x: -100, y:-100, z:-100, uvX: 0, uvY: 0});
			testTri.addVertex({x: -100, y:-100, z:-100, uvX: 0, uvY: 0});

			for (i in 0...12)
				testTri.indices.push(i);

		 */
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxPerspectiveSprite.globalCamera.debugControls(elapsed);
		FlxPerspectiveSprite.globalCamera.updateViewMatrix();
	}
}
