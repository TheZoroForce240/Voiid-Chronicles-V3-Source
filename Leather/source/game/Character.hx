package game;

import online.SkinManager;
import flixel.math.FlxMatrix;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxRect;
import shaders.Shaders.RTXEffect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import animateatlas.AtlasFrameMaker;
import utilities.Options;
import flixel.FlxG;
import flixel.addons.effects.FlxTrail;
import flixel.util.FlxColor;
import lime.utils.Assets;
import haxe.Json;
import utilities.CoolUtil;
import states.PlayState;
import flixel.FlxSprite;
import modding.CharacterConfig;

using StringTools;

class Character extends ReflectedSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	var animationNotes:Array<Dynamic> = [];

	var dancesLeftAndRight:Bool = false;

	public var barColor:FlxColor = FlxColor.WHITE;
	public var positioningOffset:Array<Float> = [0, 0];
	public var cameraOffset:Array<Float> = [0, 0];

	public var otherCharacters:Array<Character>;

	var offsetsFlipWhenPlayer:Bool = true;
	var offsetsFlipWhenEnemy:Bool = false;

	public var coolTrail:FlxTrail;

	public var deathCharacter:String = "bf-dead";

	public var swapLeftAndRightSingPlayer:Bool = true;

	public var icon:String;

	var isDeathCharacter:Bool = false;
	
	public var playFullAnim:Bool = false;
	public var preventDanceForAnim:Bool = false;

	public var config:CharacterConfig;

	public var lastHitStrumTime:Float = 0;
	public var justHitStrumTime:Float = -5000;
	public var singAnimPrefix:String = 'sing';

	public var scaleMult:Float = 1.0;

	public var offsetOffset:Array<Float> = [0,0];

	public var rtxShader:RTXEffect = new RTXEffect();

	public var offsetFromStage:Array<Float> = [0,0];

	public var isBoxing:Bool = false;
	public var hasPowerup:Bool = false;
	public var hasGun:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false, ?isDeathCharacter:Bool = false, scaleMult:Float = 1.0)
	{
		super(x, y);
		this.scaleMult = scaleMult;

		animOffsets = new Map<String, Array<Dynamic>>();
		
		curCharacter = character;
		this.isPlayer = isPlayer;
		this.isDeathCharacter = isDeathCharacter;

		antialiasing = true;

		dancesLeftAndRight = false;

		var ilikeyacutg:Bool = false;

		rtxShader.parentSprite = this;
		shader = rtxShader.shader;

		switch (curCharacter)
		{
			case 'monster':
				frames = Paths.getSparrowAtlas('characters/Monster_Assets', 'shared');
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				// fixed this garbage lol
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);

				playAnim('idle');
				barColor = FlxColor.fromRGB(245, 255, 105);
			case 'monster-christmas':
				frames = Paths.getSparrowAtlas('characters/monsterChristmas', 'shared');
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				// fixed this too lol
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);

				playAnim('idle');
				barColor = FlxColor.fromRGB(245, 255, 105);
				icon = "monster";
			case 'pico':
				if(Options.getData("optimizedChars"))
					frames = Paths.getSparrowAtlas('characters/Optimized_Pico_FNF_assetss', 'shared');
				else
					frames = Paths.getSparrowAtlas('characters/Pico_FNF_assetss', 'shared');

				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);

				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				playAnim('idle');

				flipX = true;
				barColor = FlxColor.fromRGB(205, 229, 112);
				cameraOffset = [50,0];
			case 'bf-pixel':
				swapLeftAndRightSingPlayer = false;

				frames = Paths.getSparrowAtlas('characters/bfPixel', 'shared');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				animation.addByPrefix('hey', 'BF Peace Sign', 24, false);

				setGraphicSize(Std.int(width * 6));

				playAnim('idle');

				//width -= 100;
				//height -= 100;

				cameraOffset = [-100, -200];
				positioningOffset = [183, 202];

				antialiasing = false;

				flipX = true;

				barColor = FlxColor.fromRGB(123, 214, 246);
				offsetsFlipWhenEnemy = true;
				offsetsFlipWhenPlayer = false;

				deathCharacter = "bf-pixel-dead";
			case 'bf-pixel-dead':
				swapLeftAndRightSingPlayer = false;

				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD', 'shared');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);

				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				
				antialiasing = false;
				flipX = true;
				barColor = FlxColor.fromRGB(123, 214, 246);
			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai', 'shared');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				cameraOffset = [15, 0];
				positioningOffset = [317, 522];

				antialiasing = false;
				barColor = FlxColor.fromRGB(255, 170, 111);
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai', 'shared');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				cameraOffset = [15, 0];
				positioningOffset = [317, 522];

				antialiasing = false;
				barColor = FlxColor.fromRGB(255, 170, 111);
			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit', 'shared');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				positioningOffset = [67, 122];

				antialiasing = false;
				barColor = FlxColor.fromRGB(255, 60, 110);

				coolTrail = new FlxTrail(this, null, 4, 24, 0.3, 0.069);
			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets', 'shared');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				playAnim('idle');
				barColor = FlxColor.fromRGB(199, 111, 211);
			case '':
				trace("NO VALUE THINGY LOL DONT LOAD SHIT");
				deathCharacter = "bf-dead";

			default:
				if (isPlayer)
					flipX = !flipX;

				ilikeyacutg = true;
				
				loadNamedConfiguration(curCharacter);
		}

		if (isPlayer && !ilikeyacutg)
			flipX = !flipX;

		if (icon == null)
			icon = curCharacter;

		// YOOOOOOOOOO POG MODDING STUFF
		if(character != "")
			loadOffsetFile(curCharacter);

		if(curCharacter != '' && otherCharacters == null && animation.curAnim != null)
		{
			updateHitbox();

			if(!debugMode)
			{
				dance();
	
				if(isPlayer)
				{
					// Doesn't flip for BF, since his are already in the right place???
					if(swapLeftAndRightSingPlayer && !isDeathCharacter)
					{
						var oldOffRight = animOffsets.get("singRIGHT");
						var oldOffLeft = animOffsets.get("singLEFT");

						// var animArray
						var oldRight = animation.getByName('singRIGHT').frames;
						animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
						animation.getByName('singLEFT').frames = oldRight;

						animOffsets.set("singRIGHT", oldOffLeft);
						animOffsets.set("singLEFT", oldOffRight);
		
						// IF THEY HAVE MISS ANIMATIONS??
						if (animation.getByName('singRIGHTmiss') != null)
						{
							var oldOffRightMiss = animOffsets.get("singRIGHTmiss");
							var oldOffLeftMiss = animOffsets.get("singLEFTmiss");

							var oldMiss = animation.getByName('singRIGHTmiss').frames;
							animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
							animation.getByName('singLEFTmiss').frames = oldMiss;

							animOffsets.set("singRIGHTmiss", oldOffLeftMiss);
							animOffsets.set("singLEFTmiss", oldOffRightMiss);
						}
					}
				}
			}
		}
		else
			visible = false;
	}

	public static function getConfigFromCharacterName(characterName:String)
	{
		if(!Assets.exists(Paths.json("character data/" + characterName + "/config")))
		{
			characterName = "Taro";
		}
		var rawJson = Assets.getText(Paths.json("character data/" + characterName + "/config")).trim();

		var config:CharacterConfig = cast Json.parse(rawJson);

		return config;
	}

	function loadNamedConfiguration(characterName:String)
	{
		if(!Assets.exists(Paths.json("character data/" + characterName + "/config")))
		{
			characterName = "Taro";
			curCharacter = characterName;
		}

		if(Assets.exists(Paths.json("character data/optimized_" + characterName + "/config")) && Options.getData("optimizedChars"))
			characterName = "optimized_" + characterName;

		var rawJson = Assets.getText(Paths.json("character data/" + characterName + "/config")).trim();

		this.config = cast Json.parse(rawJson);

		loadCharacterConfiguration(this.config);
	}

	public function loadCharacterConfiguration(config:CharacterConfig)
	{
		if(config.characters == null || config.characters.length <= 1)
		{
			if(!isPlayer)
				flipX = config.defaultFlipX;
			else
				flipX = !config.defaultFlipX;

			if(config.offsetsFlipWhenPlayer == null)
			{
				if(curCharacter.startsWith("bf"))
					offsetsFlipWhenPlayer = false;
				else
					offsetsFlipWhenPlayer = true;
			}
			else
				offsetsFlipWhenPlayer = config.offsetsFlipWhenPlayer;

			if(config.offsetsFlipWhenEnemy == null)
			{
				if(curCharacter.startsWith("bf"))
					offsetsFlipWhenEnemy = true;
				else
					offsetsFlipWhenEnemy = false;
			}
			else
				offsetsFlipWhenEnemy = config.offsetsFlipWhenEnemy;

			if((isPlayer && offsetsFlipWhenPlayer) || (!isPlayer && offsetsFlipWhenEnemy))
			{
				rtxShader.flipX = true;
			}

			dancesLeftAndRight = config.dancesLeftAndRight;

			if(Assets.exists(Paths.file("images/characters/" + config.imagePath + ".txt", TEXT, "shared")))
				frames = Paths.getPackerAtlas('characters/' + config.imagePath, 'shared');
			else if(Assets.exists(Paths.file("images/characters/" + config.imagePath + "/Animation.json", TEXT, "shared")))
				frames = AtlasFrameMaker.construct("characters/" + config.imagePath);
			else
				frames = Paths.getSparrowAtlas('characters/' + config.imagePath, 'shared');

			var size:Null<Float> = config.graphicSize;

			if(size == null)
				size = config.graphicsSize;

			if(size != null)
				setGraphicSize(Std.int(width * size));

			for(selected_animation in config.animations)
			{
				if(selected_animation.indices != null)
				{
					animation.addByIndices(
						selected_animation.name,
						selected_animation.animation_name,
						selected_animation.indices, "",
						selected_animation.fps,
						selected_animation.looped
					);
				}
				else
				{
					animation.addByPrefix(
						selected_animation.name,
						selected_animation.animation_name,
						selected_animation.fps,
						selected_animation.looped
					);
				}
				if (selected_animation.name.contains("block"))
					isBoxing = true;
				else if (selected_animation.name.contains("trans"))
					hasPowerup = true;
				else if (selected_animation.name.contains("shoot"))
					hasGun = true;
			}

			if(isDeathCharacter)
				playAnim("firstDeath");
			else
			{
				if(dancesLeftAndRight)
					playAnim("danceRight");
				else
					playAnim("idle");
			}

			if(debugMode)
				flipX = config.defaultFlipX;
		
			if(config.antialiased != null)
				antialiasing = config.antialiased;

			scale *= scaleMult;
			updateHitbox();

			if(config.positionOffset != null)
				positioningOffset = config.positionOffset;

			if(config.trail == true)
				coolTrail = new FlxTrail(this, null, config.trailLength, config.trailDelay, config.trailStalpha, config.trailDiff);

			if(config.swapDirectionSingWhenPlayer != null)
				swapLeftAndRightSingPlayer = config.swapDirectionSingWhenPlayer;
			else if(curCharacter.startsWith("bf"))
				swapLeftAndRightSingPlayer = false;
		}
		else
		{
			otherCharacters = [];

			var idx = 0;
			for(characterData in config.characters)
			{
				var character:Character;

				var name = characterData.name;

				if (idx < 2)
				{
					if (isPlayer)
					{
						if (SkinManager.usingCustomSkin(isPlayer, idx == 1)) //skins for character groups!!! (only for first 2 characters)
						{
							name = SkinManager.getSkinForSong(isPlayer, idx == 1, name);
						}
					}
					else 
					{
						if (SkinManager.usingCustomSkin(isPlayer, idx == 0))
							{
								name = SkinManager.getSkinForSong(isPlayer, idx == 0, name);
							}
					}

				}
				idx++;

				
				

				if(!isPlayer)
					character = new Character(x, y, name, isPlayer, isDeathCharacter, scaleMult);
				else
					character = new Boyfriend(x, y, name, isDeathCharacter, scaleMult);

				if(flipX)
					characterData.positionOffset[0] = 0 - characterData.positionOffset[0]*scaleMult;

				character.positioningOffset[0] += characterData.positionOffset[0]*scaleMult;
				character.positioningOffset[1] += characterData.positionOffset[1]*scaleMult;
				
				otherCharacters.push(character);
			}
		}

		if(config.barColor == null)
			config.barColor = [255,0,0];

		barColor = FlxColor.fromRGB(config.barColor[0], config.barColor[1], config.barColor[2]);

		if(config.cameraOffset != null)
		{
			if(flipX)
				config.cameraOffset[0] = 0 - config.cameraOffset[0];

			cameraOffset = config.cameraOffset;
		}

		if(config.deathCharacterName != null)
			deathCharacter = config.deathCharacterName;
		else
			deathCharacter = "bf-dead";

		if(config.healthIcon != null)
			icon = config.healthIcon;
	}

	public function loadOffsetFile(characterName:String)
	{
		animOffsets = new Map<String, Array<Dynamic>>();
		
		if(Assets.exists(Paths.txt("character data/" + characterName + "/" + "offsets")))
		{
			var offsets:Array<String> = CoolUtil.coolTextFile(Paths.txt("character data/" + characterName + "/" + "offsets"));

			for(x in 0...offsets.length)
			{
				var selectedOffset = offsets[x];
				var arrayOffset:Array<String>;
				arrayOffset = selectedOffset.split(" ");

				addOffset(arrayOffset[0], Std.parseInt(arrayOffset[1]), Std.parseInt(arrayOffset[2]));
			}
		}
	}

	public function quickAnimAdd(animName:String, animPrefix:String)
	{
		animation.addByPrefix(animName, animPrefix, 24, false);
	}

	public var shouldDance:Bool = true;
	public var forceAutoDance:Bool = false;

	override function update(elapsed:Float)
	{
		if(!debugMode && curCharacter != '' && animation.curAnim != null)
		{
			if(animation.curAnim.finished && animation.getByName(animation.curAnim.name + '-loop') != null)
			{
				playAnim(animation.curAnim.name + '-loop');
			}
			else if (playFullAnim && animation.curAnim.finished)
			{
				playFullAnim = false;
				dance();
			}
			else if (preventDanceForAnim && animation.curAnim.finished)
			{
				preventDanceForAnim = false;
				dance();
			}
			if (!isPlayer || forceAutoDance)
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed * (FlxG.state == PlayState.instance ? PlayState.songMultiplier : 1);
				}

				var dadVar:Float = 4;

				if (curCharacter == 'dad')
					dadVar = 6.1;
				
				if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
				{
					dance(mostRecentAlt);
					holdTimer = 0;
				}
			}

			// fix for multi character stuff lmao
			if(animation.curAnim != null)
			{
				if(animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
			}

			if (FlxG.state == PlayState.instance)
			{
				@:privateAccess
				rtxShader.hue = PlayState.instance.stage.colorSwap.hue;
			}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	var mostRecentAlt:String = "";

	public var extraSuffix:String = "";

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?altAnim:String = '')
	{
		if(shouldDance)
		{
			if (!debugMode && curCharacter != '' && animation.curAnim != null && !playFullAnim && !preventDanceForAnim)
			{
				// fix for multi character stuff lmao
				if(animation.curAnim != null)
				{
					var alt = "";

					color = 0xFFFFFFFF;

					if((!dancesLeftAndRight && animation.getByName("idle" + altAnim) != null) || (dancesLeftAndRight && animation.getByName("danceLeft" + altAnim) != null && animation.getByName("danceRight" + altAnim) != null))
						alt = altAnim;

					mostRecentAlt = alt;

					if (!animation.curAnim.name.startsWith('hair'))
					{
						if(!dancesLeftAndRight)
							playAnim('idle' + alt);
						else
						{
							danced = !danced;

							if (danced)
								playAnim('danceRight' + alt);
							else
								playAnim('danceLeft' + alt);
						}
					}
				}
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0, ?strumTime:Float):Void
	{
		if (playFullAnim)
			return;
		preventDanceForAnim = false; //reset it

		

		if (singAnimPrefix != 'sing' && AnimName.contains('sing'))
		{
			var anim = AnimName;
			anim = anim.replace('sing', singAnimPrefix);
			if (animation.getByName(anim) != null) //check if it exists so no broken anims
				AnimName = anim;
		}
			
		AnimName += extraSuffix;

		color = 0xFFFFFFFF;
		if (animation.getByName(AnimName) == null)
		{
			if (AnimName.contains('dodge'))
			{
				color = 0xFF545454;
				preventDanceForAnim = true;
				AnimName = AnimName.replace("dodge", "sing"); //swap back to sing
			}
			else if (AnimName.contains("miss"))
			{
				color = 0xFF380045;
				preventDanceForAnim = true;
				AnimName = AnimName.replace("miss", ""); //remove miss to just place normal anim
			}
			else if (AnimName.contains("parry"))
			{
				AnimName = AnimName.replace("parry", "sing"); //swap back to sing
			}
			else if (AnimName.contains("-mic"))
			{
				AnimName = AnimName.replace("-mic", ""); //remove -mic if not found
			}
			else if (AnimName.contains("-alt"))
			{
				AnimName = AnimName.replace("-alt", "");
			}
			else if (AnimName.contains("block"))
			{
				return; //just dont block
			}
		}



		//if ((AnimName.contains('sing') && !AnimName.contains('miss')) || AnimName.contains('dodge') || AnimName.contains('parry'))
		//{
		if (strumTime != null)
		{
			justHitStrumTime = strumTime;
		}
		else
			justHitStrumTime = Conductor.songPosition;
		
		if (lastHitStrumTime == justHitStrumTime && animation.curAnim != null)
		{
			//trace('hit double');

			var actor = this;
			var Sprite:ReflectedSprite = new ReflectedSprite(actor.x, actor.y);
			Sprite.drawFlipped = this.drawFlipped;
			//copy sprite
			Sprite.loadGraphicFromSprite(actor);
			Sprite.alpha = 0.5;
			Sprite.angle = actor.angle;
			Sprite.offset.x = actor.offset.x;
			Sprite.offset.y = actor.offset.y;
			Sprite.origin.x = actor.origin.x;
			Sprite.origin.y = actor.origin.y;
			Sprite.scale.x = actor.scale.x;
			Sprite.scale.y = actor.scale.y;
			Sprite.active = false;
			Sprite.animation.frameIndex = actor.animation.frameIndex;
			Sprite.flipX = actor.flipX;
			Sprite.flipY = actor.flipY;

			Sprite.shader = rtxShader.copy().shader;

			//play anim
			Sprite.animation.play(animation.curAnim.name, Force, Reversed, Frame);
			var daOffset = animOffsets.get(animation.curAnim.name);
			if (animOffsets.exists(animation.curAnim.name))
				Sprite.offset.set(daOffset[0] + offsetOffset[0], daOffset[1] + offsetOffset[1]);
			else
				Sprite.offset.set(offsetOffset[0], offsetOffset[1]);

			//add
			FlxG.state.insert(FlxG.state.members.indexOf(this)-1, Sprite);
			FlxTween.tween(Sprite, {alpha: 0}, Conductor.crochet*0.001, {ease: FlxEase.expoIn, onComplete: function(twn:FlxTween)
			{
				//remove sprite
				Sprite.destroy();
			}});
		}
		lastHitStrumTime = justHitStrumTime;
		//}


		animation.play(AnimName, Force, Reversed, Frame);

		if (AnimName.contains('dodge'))
			preventDanceForAnim = true;

		var daOffset = animOffsets.get(AnimName);

		if (animOffsets.exists(AnimName))
			offset.set((daOffset[0]*scaleMult) + offsetOffset[0], (daOffset[1]*scaleMult) + offsetOffset[1]);
		else
			offset.set(offsetOffset[0], offsetOffset[1]);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		if((isPlayer && offsetsFlipWhenPlayer) || (!isPlayer && offsetsFlipWhenEnemy))
		{
			drawFlipped = true;
			x = 0 - x;
		} //

		animOffsets.set(name, [x, y]);
	}
	public var followMainCharacter:Bool = false;
	public function getMainCharacter():Character
	{
		if (otherCharacters != null && otherCharacters.length > 0)
		{
			if (followMainCharacter)
				return otherCharacters[0];
		}
		return this;
	}


	override public function draw()
	{
		rtxShader.update(0); //update right before drawing
		super.draw();
	}
}

class ReflectedSprite extends FlxSprite
{
	public var drawFlipped = false;
	public var drawReflection:Bool = false;
	public var reflectionYOffset:Float = 0;
	public var reflectionAlpha:Float = 0.5;
	private var _drawingReflection:Bool = false;
	public var reflectionColor:FlxColor = 0xFF000000;
	public var reflectionScaleY:Float = 0.6;

	public var transform:FlxMatrix = new FlxMatrix();

	override public function draw()
	{
		if (drawReflection)
		{
			_drawingReflection = true;
			var startX = x;
			var startY = y;
			var alp = alpha;
			var col = color;
			var scaleY = scale.y;
			//flip everything
			color = reflectionColor;
			scale.y = -scale.y;
			offset.y = -offset.y;
			alpha *= reflectionAlpha;
			y += height+reflectionYOffset;
			x += width;

			transform.identity();

			//transform.c += 2.0;
			

			super.draw(); //draw reflection
			//reset back to default
			scale.y = scaleY;
			offset.y = -offset.y;
			alpha = alp;
			y = startY;
			x = startX;
			color = col;
			_drawingReflection = false;
		}
		if (drawFlipped)
		{
			flipX = !flipX;
			scale.x = -scale.x;
			super.draw();
			flipX = !flipX;
			scale.x = -scale.x;
		}
		else 
		{
			super.draw(); //draw normal sprite
		}
	}

	override function drawComplex(camera:FlxCamera):Void
	{
		_frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());

		_matrix.translate(-origin.x, -origin.y);
		_matrix.scale(scale.x, scale.y);
		if (_drawingReflection)
		{
			_matrix.concat(transform);
		}



		if (bakedRotationAngle <= 0)
		{
			updateTrig();

			if (angle != 0)
				_matrix.rotateWithTrig(_cosAngle, _sinAngle);
		}

		getScreenPosition(_point, camera).subtractPoint(offset);
		_point.add(origin.x, origin.y);
		_matrix.translate(_point.x, _point.y);

		if (isPixelPerfectRender(camera))
		{
			_matrix.tx = Math.floor(_matrix.tx);
			_matrix.ty = Math.floor(_matrix.ty);
		}


		camera.drawPixels(_frame, framePixels, _matrix, colorTransform, blend, antialiasing, shader);
	}


	override public function isOnScreen(?camera:FlxCamera):Bool //stupid shit breaking with negative scaley
	{
		return super.isOnScreen(camera);
	}
	override public function getScreenBounds(?newRect:FlxRect, ?camera:FlxCamera):FlxRect 
	{
		if (drawFlipped) //shoutout to CNE devs
		{
			scale.x = -scale.x;
			var bounds = super.getScreenBounds(newRect, camera);
			scale.x = -scale.x;
			return bounds;
		}
		if (_drawingReflection)
		{
			scale.y = -scale.y;
			var bounds = super.getScreenBounds(newRect, camera);
			scale.y = -scale.y;
			return bounds;
		}
		return super.getScreenBounds(newRect, camera);
	}
}
