var PUNCH_TIME = 333;
var echosData = [];
var deadEchos = [];

var lastTime = -5000;
var lastCount = 0;

var attackSpriteSheets = [
	"Wiik3Purple" => "characters/MattStand_Attack",
	"Wiik3White" => "characters/WhiteMattStand_Attack",
	"Wiik4Purple" => "characters/MattSlash",
	"Wiik4White" => "characters/WhiteMattSlash"
];

function onEchoCreate(time, name) {
	
	switch(name) {
		case "Wiik3Purple" | "Wiik3White":
			var data = {
				time: time - PUNCH_TIME,
				type: "attack",
				name: name,
				sprite: new FunkinSprite(),
				started: false,
				finished: false,
				offsetX: 0,
				offsetY: 0
			};
			data.sprite.frames = Paths.getSparrowAtlas(attackSpriteSheets.get(name));
			data.sprite.animation.addByPrefix("attack", "attack", 24, false);
			data.sprite.scale.set(1.5,1.5);
			data.sprite.updateHitbox();

			if (time-lastTime < 1000) {
				lastCount++;

				if (lastCount == 1) data.sprite.flipX = true;

				if (lastCount == 2) {
					data.sprite.flipX = false;

					data.sprite.scale.set(0.4,1.2);
					data.sprite.skew.y = 10;
					data.sprite.skew.x = 0;
					data.offsetX += 150;
				}
				
				if (lastCount == 3) {
					data.sprite.flipX = true;

					data.sprite.scale.set(0.4,1.2);
					data.sprite.skew.y = -10;
					data.sprite.skew.x = 0;
					data.offsetX -= 300;
				}
				if (lastCount == 4) lastCount = 0;

				
				
			} else {
				lastCount = 0;
			}
			echosData.push(data);
		case "Wiik4Purple" | "Wiik4White":
			var data = {
				time: time - PUNCH_TIME,
				type: "attack",
				name: name,
				sprite: new FunkinSprite(),
				started: false,
				finished: false,
				offsetX: 0,
				offsetY: 0
			};
			data.sprite.frames = Paths.getSparrowAtlas(attackSpriteSheets.get(name));
			data.sprite.animation.addByPrefix("attack", "mattslash", 24, false);
			data.sprite.scale.set(1.5,1.5);
			data.sprite.updateHitbox();

			if (time-lastTime < 1000) {
				lastCount++;

				if (lastCount == 1) data.sprite.flipX = true;

				if (lastCount == 2) {
					data.sprite.flipX = false;

					data.sprite.scale.set(0.4,1.2);
					data.sprite.skew.y = 10;
					data.sprite.skew.x = 0;
					data.offsetX += 150;
				}
				
				if (lastCount == 3) {
					data.sprite.flipX = true;

					data.sprite.scale.set(0.4,1.2);
					data.sprite.skew.y = -10;
					data.sprite.skew.x = 0;
					data.offsetX -= 300;
				}
				if (lastCount == 4) lastCount = 0;
				
			} else {
				lastCount = 0;
			}
			echosData.push(data);
		case "Wiik2":
			var data = {
				time: time - 725,
				type: "Wiik2",
				name: name,
				sprite: new FunkinSprite(),
				glove: new FlxSprite(),
				splash: new FlxSprite(),
				started: false,
				finished: false,
				offsetX: 0,
				offsetY: 0
			};
			data.sprite.frames = Paths.getSparrowAtlas("characters/Wiik_2_Echo");
			data.sprite.animation.addByPrefix("attack", "attack", 24, false);
			data.sprite.scale.set(1.5,1.5);
			data.sprite.updateHitbox();

			data.glove.frames = Paths.getSparrowAtlas("characters/EchoGlove");
			data.glove.animation.addByPrefix("echoglove", "echoglove", 24, true); 
			data.glove.animation.play("echoglove");
			data.glove.angle = 45;

			data.splash.frames = Paths.getSparrowAtlas("characters/Splash");
			data.splash.animation.addByPrefix("splash", "splash", 24, false);
			data.splash.visible = false;

			if (time-lastTime < 1000) {
				lastCount++;

				if (lastCount == 1) data.sprite.flipX = true;

				if (lastCount == 2) {
					data.sprite.flipX = false;

					data.offsetX += 200;
					data.offsetY -= 200;
				}
				
				if (lastCount == 3) {
					data.sprite.flipX = true;

					data.offsetX -= 200;
					data.offsetY -= 200;
				}
				if (lastCount == 4) lastCount = 0;

			} else {
				lastCount = 0;
			}
			echosData.push(data);
	}
	lastTime = time;
}
var firstFrame = true;
function postUpdate(elapsed) {

	if (firstFrame) {
		firstFrame = false;
		echosData.sort(function(a, b) {
			if(a.time < b.time) return -1;
			else if(a.time > b.time) return 1;
			else return 0;
		 });
	}


	for (echo in echosData) {
		if (Conductor.songPosition < echo.time) {
			break;
		}
		if (!echo.started) {
			echo.started = true;
			onEchoStart(echo);
		}
		onEchoUpdate(echo);

		if (echo.finished) {
			onEchoFinish(echo);
			deadEchos.push(echo);
			echosData.remove(echo);
		}
	}
}

function onEchoStart(echo) {
	switch(echo.type) {
		case "attack":
			insert(members.indexOf(boyfriend)+1, echo.sprite);
			echo.sprite.animation.play("attack");
			echo.sprite.shader = colorswapShader;

			switch(echo.name) {
				case "Wiik3Purple" | "Wiik3White":
					if (echo.sprite.flipX) {
						echo.sprite.x = echo.offsetX + boyfriend.x+(760+FlxG.random.float(-20,20))-(echo.sprite.width-300);
					} else {
						echo.sprite.x = echo.offsetX + boyfriend.x-(950+FlxG.random.float(-20,20));
					}
					echo.sprite.y = echo.offsetY + boyfriend.y-(80+410+FlxG.random.float(-5,5));

					echo.sprite.scale.x = boyfriend.scale.x*1.5;
					echo.sprite.scale.y = boyfriend.scale.y*1.5;
				case "Wiik4Purple" | "Wiik4White":
					if (echo.sprite.flipX) {
						echo.sprite.x = echo.offsetX + boyfriend.x+(1200+FlxG.random.float(-20,20))-(echo.sprite.width-300);
					} else {
						echo.sprite.x = echo.offsetX + boyfriend.x-(1400+FlxG.random.float(-20,20));
					}
					echo.sprite.y = echo.offsetY + boyfriend.y-(870+FlxG.random.float(-5,5));

					echo.sprite.scale.x = boyfriend.scale.x*1.5;
					echo.sprite.scale.y = boyfriend.scale.y*1.5;
			}
		case "Wiik2":
			insert(members.indexOf(boyfriend)+1, echo.sprite);
			echo.sprite.animation.play("attack");
			echo.sprite.shader = colorswapShader;
			echo.glove.shader = colorswapShader;

			if (echo.sprite.flipX) {
				echo.sprite.x = echo.offsetX + boyfriend.x+(700+FlxG.random.float(-100,100))-(echo.sprite.width-boyfriend.width);
				echo.glove.x = echo.sprite.x;
			} else {
				echo.sprite.x = echo.offsetX + boyfriend.x-(950+FlxG.random.float(-100,100));
				echo.glove.x = (echo.sprite.x + echo.sprite.width)-250;
			}

			echo.sprite.y = echo.offsetY + boyfriend.y-(750+FlxG.random.float(-100,100));
			echo.glove.y = echo.sprite.y + 100;

			echo.splash.x = boyfriend.x - 270;
			echo.splash.y = boyfriend.y - 150;

			if (echo.sprite.flipX) {
				echo.glove.angle += 90;
			}

			var targetX = boyfriend.x - 270;
			var targetY = boyfriend.y - 50;

			new FlxTimer().start((1/24)*15, function(tmr) {
				insert(members.indexOf(boyfriend)+1, echo.glove);
				FlxTween.tween(echo.glove, {x: targetX, y: targetY}, 0.1, {onComplete:function(twn) {
					echo.glove.visible = false;

					insert(members.indexOf(boyfriend)-1, echo.splash);
					echo.splash.visible = true;
					echo.splash.animation.play("splash");
				}});
			});



			
	}
}
function onEchoUpdate(echo) {
	switch(echo.type) {
		case "attack":
			if (echo.sprite.animation.curAnim.finished) {
				echo.finished = true;
			}
		case "Wiik2":
			if (echo.splash.visible && echo.splash.animation.curAnim.finished && echo.sprite.animation.curAnim.finished) {
				echo.finished = true;
			}
	}
}
function onEchoFinish(echo) {
	switch(echo.type) {
		case "attack":
			remove(echo.sprite);
		case "Wiik2":
			remove(echo.sprite);
			remove(echo.glove);
			remove(echo.splash);
	}
}

function destroyEcho(echo) {
	switch(echo.type) {
		case "attack":
			echo.sprite.destroy();
			echo.sprite = null;
		case "Wiik2":
			echo.sprite.destroy();
			echo.sprite = null;
			echo.glove.destroy();
			echo.glove = null;
			echo.splash.destroy();
			echo.splash = null;
	}
}

function destroy() {
	for (echo in deadEchos) {
		destroyEcho(echo);
		echo = null;
	}
	deadEchos.splice(0, deadEchos.length);

	for (echo in echosData) {
		destroyEcho(echo);
		echo = null;
	}
	echosData.splice(0, echosData.length);
}