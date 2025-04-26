import flixel.FlxSprite;
import flixel.FlxState;

var loadingScreen:FlxSprite;
var loadingText:FlxText;

public static var CURRENT_LOADING_SCREEN = "default";

static var loadingPlayState = false;
function postCreate()
{
	var out = newState != null;

	if (newState is PlayState)
		loadingPlayState = true;

	if (loadingPlayState) //show loading screen when loading playstate
	{
		loadingScreen = new FlxSprite();
		loadingScreen.loadGraphic(Paths.image("loading/"+CURRENT_LOADING_SCREEN));

		if (loadingScreen.width / loadingScreen.height < 16.0 / 9.0) {
			loadingScreen.setGraphicSize(FlxG.width);
		} else {
			loadingScreen.setGraphicSize(0, FlxG.height);
		}
		loadingScreen.antialiasing = true;
		loadingScreen.screenCenter();
		loadingScreen.scrollFactor.set(0,0);

		loadingText = new FlxText(10, FlxG.height, 0, 'Loading...', 64);
		loadingText.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE);
		loadingText.y -= loadingText.height;
		loadingText.scrollFactor.set();


		if (!out)
		{
			loadingScreen.flipY = true;
			loadingPlayState = false;
			add(loadingScreen);
			//add(loadingText);
			remove(transitionSprite);
			remove(blackSpr);

			transitionTween = FlxTween.tween(loadingScreen, {alpha: 0}, 2/3, {ease:FlxEase.sineOut, onComplete:function(twn)
			{
				finish();
			}});

			CURRENT_LOADING_SCREEN = "default";
		}
		else 
		{
			
			transitionTween.onComplete = function(twn)
			{
				//remove(transitionSprite);
				//remove(blackSpr);

				add(loadingScreen);
				add(loadingText);

				loadingScreen.alpha = loadingText.alpha = 0;
				
				FlxTween.tween(loadingText, {alpha: 1}, 2/3, {ease:FlxEase.sineOut});
				FlxTween.tween(loadingScreen, {alpha: 1}, 2/3, {ease:FlxEase.sineOut, onComplete:function(twn)
				{
					nextFrameSkip = true;
				}});
				FlxG.sound.music.fadeOut(2/3, 0);
			}
		}
			
	}
}	