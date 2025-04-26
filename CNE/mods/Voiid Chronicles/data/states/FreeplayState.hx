import funkin.backend.scripting.ModState;
import funkin.backend.utils.CoolUtil;
import flixel.math.FlxMath;
import funkin.options.Options;
import funkin.backend.chart.Chart;
import funkin.backend.MusicBeatGroup;
import funkin.backend.utils.AudioAnalyzer;
import funkin.editors.ui.UIState;
import funkin.savedata.FunkinSave;
import funkin.game.HealthIcon;
import openfl.ui.MouseCursor;
import openfl.ui.Mouse;
import VCSongText;

#if VOIID_CHRONICLES_CUSTOM_BUILD
import voiid.Leaderboards;
#end

class SongItem extends FlxSprite {
	public var song:Dynamic;
	public var text:Dynamic;
	public var icon:HealthIcon;
	public var back:FlxSprite;
	public var selectedBack:FlxSprite;
	public var port:String;
	public var loadingScreen:String = "default";
	public var selected:Bool = false;

	public var gmAlt:SongItem;
	public var showAlt:Bool = false;

	public var skipLerp = false;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		text.update(elapsed);
		if (icon != null) icon.update(elapsed);
		back.update(elapsed);
		selectedBack.update(elapsed);
		if (gmAlt != null) gmAlt.update(elapsed);
	}
	override public function draw() {
		if (gmAlt != null) {
			gmAlt.y = y;
			gmAlt.selected = selected;
			gmAlt.draw();
		}

		text.scale.set(0.6, 0.6); text.updateHitbox();
		back.scale.set(0.7, 0.7); back.updateHitbox();
		selectedBack.scale.set(0.7, 0.7); selectedBack.updateHitbox();

		if (icon != null) {
			icon.scale.y = icon.scale.x = CoolUtil.fpsLerp(icon.scale.x, 0.7, skipLerp ? 1.0 : 0.06);
			icon.updateHitbox();
		}


		text.x = x - 36;
		text.y = y + 5;
		if (icon != null) {
			icon.x = -36 + x - icon.width;
			icon.y = y + ((back.height/2) - (icon.height/2));
		}

		back.x = x - 150;
		back.y = y;

		selectedBack.alpha = CoolUtil.fpsLerp(selectedBack.alpha, selected ? 1.0 : 0.0, skipLerp ? 1.0 : 0.1);
		back.alpha = CoolUtil.fpsLerp(back.alpha, selected ? 0.0 : 1.0, skipLerp ? 1.0 : 0.1);
		selectedBack.y = y + ((back.height/2) - (selectedBack.height/2));
		selectedBack.x = Math.min(-50, x);

		back.draw();
		selectedBack.draw();
		text.draw();
		if (icon != null) icon.draw();

		skipLerp = false;

	}
	override public function destroy() {
		back.destroy();
		selectedBack.destroy();
		text.destroy();
		if (icon != null) icon.destroy();
		super.destroy();
		if (gmAlt != null) gmAlt.destroy();
	}
}

//list of all metadata
var songList = [];
var songCatData = [];
//list of text objects
var songItems = [];
//group of currently shown text objects
var songGroup:MusicBeatGroup;
var iconGroup:MusicBeatGroup;

var categories = ["" => []];
var catList:Array<String> = [];
var currentCategory:Int = 0;
var selectingCategory:Bool = true;
var categoryGroup:MusicBeatGroup;

static var lastCategory = -1;

var audioAnalyzer:AudioAnalyzer;
var audioBars = [];

function create() {
	categories.clear();
	//var freeplaySongs = Json.parse(Assets.getText(Paths.getPath("data/freeplaySongs.json")));

	for (lib in Paths.assetsTree.libraries) {
		if (lib.exists(Paths.getPath("data/freeplaySongs.json"), "TEXT")) {
			var freeplaySongs = Json.parse(lib.getText(Paths.getPath("data/freeplaySongs.json")));
			loadFreeplaySongsJson(freeplaySongs);
		}
	}	
}

function loadFreeplaySongsJson(freeplaySongs) {
	for (cat in freeplaySongs.categories) {
		for (song in cat.songs) {
			songList.push(Chart.loadChartMeta(song.name, "normal", true));
			songCatData.push(song);

			if (!categories.exists(cat.name)) {
				categories.set(cat.name, []);
				catList.push(cat.name);
			}

			categories.get(cat.name).push(songList.length-1);
		}
	}
}

var defaultSong = '
{
	"composer": "",
	"charter": "",
	"originalComposer": "",
	"startTime": 0,
	"songFont": "dumbnerd.ttf",
	"songFontSize": 128,
	"infoFontSize": 24,
	"outerBorderTop": "#000000",
	"outerBorderBot": "#000000",
	"midBorderTop": "#c735ff",
	"midBorderBot": "#6414ea",
	"innerBorderTop": "#3f3f3f",
	"innerBorderBot": "#121617"
}';

var curScroll:Float = 0.0;

var dotsTop = null;
var dotsBottom = null;

var backButton = null;
var settingsButton = null;

var lastLoadedBGPort = "";
var bgSprite = null;
var emptyBGSprite = null;
var bgFade = null;
var bgFadeShader = null;
var bgFadeValue = 1;

var lastDiffLoaded = "";
var difficultySprite = null;
var diffArrowL = null;
var diffArrowR = null;
var difficultyText = null;

public static var SONG_SPEED = 1.0;
var selectedSongSpeed = 1;
var speedText = null;
var speedArrowL = null;
var speedArrowR = null;
var speedNameText = null;

var freeplayText = null;
var freeplayInfoText = null;

var leaderboardsLogo = null;
var leaderboardsText = null;

var highscoreNameText = null;
var highscoreTotalText = null;
var highscoreInfoText = null;

var currentHighscoreData = null;
var targetScore = ["", "", "", "", "", ""];
var currentScore = ["", "", "", "", "", ""];
var scoreTmr = 0.0;
var scoreIndex = 0;

function postCreate() {

	if (lastCategory != -1) {
		currentCategory = lastCategory;
		selectingCategory = false;
	}

	remove(scoreBG);
	remove(scoreText);
	remove(diffText);
	remove(coopText);

	bg.loadGraphic(Paths.image('menus/freeplay/BG'));
	bg.setGraphicSize(1280); bg.updateHitbox();

	var totalBars = 64;
	for (i in 0...totalBars) {
		var spr = new FlxSprite(((FlxG.width/totalBars)+5) * i, FlxG.height);
		spr.makeGraphic(1,1);
		spr.setGraphicSize((FlxG.width/totalBars)-5, 1);
		spr.updateHitbox();
		spr.scrollFactor.set();
		audioBars.push(spr);
		add(spr);
	}

	////////////////////////////////////////

	bgFade = new FlxSprite(0, 156);
	bgFade.loadGraphic(Paths.image('menus/freeplay/bgfade')); add(bgFade);
	bgFade.scale.set(1280/1920,1280/1920); bgFade.updateHitbox();
	bgFade.x = 1280-bgFade.width;
	bgFade.shader = bgFadeShader = new CustomShader("BGFade");

	bgSprite = new FlxSprite();
	//bgSprite.loadGraphic(Paths.image("menus/freeplay/bgs/Wiik1"));
	bgSprite.alpha = 0.001;
	add(bgSprite);

	emptyBGSprite = new FlxSprite();
	emptyBGSprite.makeGraphic(1,1,0xFF000000);
	emptyBGSprite.alpha = 0.001;
	add(emptyBGSprite);

	bgFadeShader.bg = emptyBGSprite.graphic.bitmap;
	bgFadeShader.prevBG = emptyBGSprite.graphic.bitmap;

	/////////////////////////////////////

	dotsTop = new FlxSprite();
	dotsTop.loadGraphic(Paths.image('menus/freeplay/dot_up')); add(dotsTop);
	dotsTop.setGraphicSize(1280); dotsTop.updateHitbox();

	dotsBottom = new FlxSprite();
	dotsBottom.loadGraphic(Paths.image('menus/freeplay/dot_down')); add(dotsBottom);
	dotsBottom.setGraphicSize(1280); dotsBottom.updateHitbox();

	///////////////////////////////////////////

	freeplayText = new VCSongText(0, -5, 0, "FREEPLAY");
	freeplayText.size = 64;
	freeplayText.border1Size = 0;
	freeplayText.border2Size = 5;
	freeplayText.borderIterations = 8;
	freeplayText.border2Color = 0xFF000000;
	freeplayText.font = Paths.font("vcr.ttf");

	freeplayText.x = 1280 - (freeplayText.width+5);
	add(freeplayText);

	freeplayInfoText = new VCSongText(150, 5, 0, "- LEFT and RIGHT to change difficulty | SHIFT + LEFT and RIGHT to change song speed\n- TAB to open leaderboards");
	freeplayInfoText.size = 16;
	freeplayInfoText.border1Size = 0;
	freeplayInfoText.border2Size = 2;
	freeplayInfoText.borderIterations = 8;
	freeplayInfoText.border2Color = 0xFF000000;
	freeplayInfoText.font = Paths.font("vcr.ttf");
	add(freeplayInfoText);

	backButton = new FlxSprite(5, 0);
	backButton.loadGraphic(Paths.image('menus/freeplay/back_button'));
	backButton.scale.set(0.7,0.7); backButton.updateHitbox();
	add(backButton); backButton.antialiasing = true;

	settingsButton = new FlxSprite(5, 0 + backButton.height);
	settingsButton.loadGraphic(Paths.image('menus/freeplay/config_button'));
	settingsButton.scale.set(0.7,0.7); settingsButton.updateHitbox();
	add(settingsButton); settingsButton.antialiasing = true;

	///////////////////////////////////////////////

	leaderboardsLogo = new FlxSprite(0, 720-150);
	leaderboardsLogo.loadGraphic(Paths.image('menus/freeplay/leaderboards'));
	leaderboardsLogo.scale.set(0.6,0.6); leaderboardsLogo.updateHitbox();
	add(leaderboardsLogo); leaderboardsLogo.antialiasing = true;
	leaderboardsLogo.screenCenter(FlxAxes.X);

	leaderboardsText = new VCSongText(0, leaderboardsLogo.y + leaderboardsLogo.height, 0, "---\n\n---\n\n---");
	leaderboardsText.border1Size = 0;
	leaderboardsText.border2Size = 4;
	leaderboardsText.borderIterations = 8;
	leaderboardsText.border2Color = 0xFF000000;
	leaderboardsText.alignment = "center";
	leaderboardsText.font = Paths.font("digitalix.ttf");
	leaderboardsText.size = 25;
	leaderboardsText.scale.set(0.4, 0.4); leaderboardsText.updateHitbox();
	add(leaderboardsText);
	leaderboardsText.screenCenter(FlxAxes.X);

	////////////////////////////////////////////////




	highscoreTotalText = new VCSongText(0, 0, 0, "000000");
	highscoreTotalText.border1Size = 0;
	highscoreTotalText.border2Size = 4;
	highscoreTotalText.borderIterations = 8;
	highscoreTotalText.border2Color = 0xFF000000;
	highscoreTotalText.font = Paths.font("digitalix.ttf");
	highscoreTotalText.size = 51;
	add(highscoreTotalText);
	highscoreTotalText.x = 1280 - highscoreTotalText.width;
	highscoreTotalText.y = 720 - highscoreTotalText.height;

	highscoreTotalText.shader = new CustomShader("FreeplayScoreText");

	highscoreNameText = new VCSongText(0, 0, 0, "HIGHSCORE");
	highscoreNameText.color = 0xFFFFFFFF;
	highscoreNameText.border1Size = 0;
	highscoreNameText.border2Size = 5;
	highscoreNameText.borderIterations = 8;
	highscoreNameText.border2Color = 0xFF000000;
	highscoreNameText.font = Paths.font("digitalix.ttf");
	highscoreNameText.size = 25;
	highscoreNameText.scale.set(0.72, 0.72); highscoreNameText.updateHitbox();
	add(highscoreNameText);

	highscoreNameText.x = 1280 - highscoreNameText.width;
	highscoreNameText.y = highscoreTotalText.y - highscoreNameText.height;
	highscoreNameText.y += 10;


	highscoreInfoText = new VCSongText(25, 568, 0, "[asdhjk]");
	highscoreInfoText.color = 0xFF6d4e80;
	highscoreInfoText.border1Size = 0;
	highscoreInfoText.border2Size = 5;
	highscoreInfoText.borderIterations = 8;
	highscoreInfoText.border2Color = 0xFF000000;
	highscoreInfoText.font = Paths.font("digitalix.ttf");
	highscoreInfoText.size = 25;
	highscoreInfoText.scale.set(0.72, 0.72); highscoreInfoText.updateHitbox();
	add(highscoreInfoText);
	highscoreInfoText.x = 1280 - highscoreInfoText.width;

	////////////////////////////////////////////

	remove(grpSongs);
	for (icon in iconArray) remove(icon);

	songGroup = new MusicBeatGroup();
	insert(999,songGroup);

	categoryGroup = new MusicBeatGroup();
	insert(999,categoryGroup);

	function createSongItem(index, songName, songIcon, metaData, port, loadingScreen, alt) {
		var data = null;
		if (Assets.exists("songs/"+songName+"/credits"+alt+".json")) {
			data = Json.parse(Assets.getText("songs/"+songName+"/credits"+alt+".json"));
		} else {
			data = Json.parse(defaultSong);
		}

		var songText = createSongText(songName, data.songFontSize, 16, data);
		
		songText.ID = index;
		var icon:HealthIcon = new HealthIcon(songIcon);
		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image("menus/freeplay/square_song"));
		bg.scale.set(0.9, 0.9); bg.updateHitbox();

		var selectedBG:FlxSprite = new FlxSprite();
		selectedBG.loadGraphic(Paths.image("menus/freeplay/square_song_selected"));
		selectedBG.scale.set(0.9, 0.9); selectedBG.updateHitbox();
		selectedBG.alpha = 0;

		songText.scale.set(0.6, 0.6);
		songText.updateHitbox();
		songText.centerOffsets();

		if (songText.width > 650) {
			songText.setGraphicSize(650);
			songText.updateHitbox();
			songText.centerOffsets();
		}

		var songItem = new SongItem();
		songItem.ID = index;
		songItem.song = metaData;
		songItem.text = songText;
		songItem.icon = icon;
		songItem.back = bg;
		songItem.selectedBack = selectedBG;
		songItem.port = port;
		if (loadingScreen != null) songItem.loadingScreen = loadingScreen;
		return songItem;
	}

	for (i in 0...songList.length)
	{
		var songItem = createSongItem(i, songList[i].displayName, songList[i].icon, songList[i], songCatData[i].port, songCatData[i].loadingScreen, "");

		if (songList[i].displayName == "Final Destination") {
			songItem.gmAlt = createSongItem(i, songList[i].displayName, "VoiidGodShagXMatt-icons", songList[i], "FDGOD", "default", "-god");
			songItem.gmAlt.x = -1280;
		}

		songItems.push(songItem);
	}

	//////////////////////////

	difficultySprite = new FlxSprite(0, 720);
	difficultySprite.loadGraphic(Paths.image("menus/freeplay/difficulties/voiid"));
	difficultySprite.scale.set(0.7, 0.7); difficultySprite.updateHitbox();
	difficultySprite.antialiasing = true;
	insert(999, difficultySprite);
	difficultySprite.y -= difficultySprite.height;
	difficultySprite.x = 25;

	difficultyText = new VCSongText(25, difficultySprite.y-24, 0, "DIFFICULTY");
	difficultyText.color = 0xFF6d4e80;
	difficultyText.border1Size = 0;
	difficultyText.border2Size = 5;
	difficultyText.borderIterations = 8;
	difficultyText.border2Color = 0xFF000000;
	difficultyText.font = Paths.font("digitalix.ttf");
	difficultyText.size = 25;
	difficultyText.scale.set(0.72, 0.72); difficultyText.updateHitbox();
	insert(999, difficultyText);

	difficultyText.x = difficultySprite.x + (difficultySprite.width/2) - (difficultyText.width/2);

	diffArrowL = new FlxSprite(0,0);
	diffArrowL.loadGraphic(Paths.image("menus/freeplay/left_arrow"));
	diffArrowL.antialiasing = true;
	diffArrowL.scale.set(0.85, 0.85); diffArrowL.updateHitbox();
	diffArrowL.x = difficultySprite.x - (diffArrowL.width/2);
	diffArrowL.y = difficultySprite.y + (difficultySprite.height/2) - (diffArrowL.height/2);
	insert(999, diffArrowL);

	diffArrowR = new FlxSprite(0,0);
	diffArrowR.loadGraphic(Paths.image("menus/freeplay/left_arrow"));
	diffArrowR.antialiasing = true;
	diffArrowR.flipX = true;
	diffArrowR.scale.set(0.85, 0.85); diffArrowR.updateHitbox();
	diffArrowR.x = (difficultySprite.width + difficultySprite.x) - (diffArrowR.width/2);
	diffArrowR.y = difficultySprite.y + (difficultySprite.height/2) - (diffArrowR.height/2);
	insert(999, diffArrowR);

	////////////////////////////////////

	speedNameText = new VCSongText(50+200, difficultyText.y, 0, "SONG SPEED");
	speedNameText.color = 0xFF6d4e80;
	speedNameText.border1Size = 0;
	speedNameText.border2Size = 5;
	speedNameText.borderIterations = 8;
	speedNameText.border2Color = 0xFF000000;
	speedNameText.font = Paths.font("digitalix.ttf");
	speedNameText.size = 25;
	speedNameText.scale.set(0.72, 0.72); speedNameText.updateHitbox();
	insert(999, speedNameText);


	speedText = new VCSongText(50, 0, 0, "1.0");
	speedText.color = 0xffffffff;
	speedText.border1Size = 0;
	speedText.border2Size = 5;
	speedText.borderIterations = 8;
	speedText.border2Color = 0xFF000000;
	speedText.font = Paths.font("digitalix.ttf");
	speedText.size = 25;
	speedText.scale.set(1, 1); speedText.updateHitbox();
	insert(999, speedText);

	speedText.x = 215 + difficultySprite.x + (difficultySprite.width/2) - (speedText.width/2);
	speedText.y = difficultySprite.y + (difficultySprite.height/2) - (speedText.height/2);
	speedNameText.x = speedText.x + (speedText.width/2) - (speedNameText.width/2);

	speedArrowL = new FlxSprite(0,0);
	speedArrowL.loadGraphic(Paths.image("menus/freeplay/left_arrow"));
	speedArrowL.antialiasing = true;
	speedArrowL.scale.set(0.85, 0.85); speedArrowL.updateHitbox();
	speedArrowL.x = -32 + speedText.x - (speedArrowL.width/2);
	speedArrowL.y = speedText.y + (speedText.height/2) - (speedArrowL.height/2);
	insert(999, speedArrowL);

	speedArrowR = new FlxSprite(0,0);
	speedArrowR.loadGraphic(Paths.image("menus/freeplay/left_arrow"));
	speedArrowR.antialiasing = true;
	speedArrowR.flipX = true;
	speedArrowR.scale.set(0.85, 0.85); speedArrowR.updateHitbox();
	speedArrowR.x = 32 + (speedText.width + speedText.x) - (speedArrowR.width/2);
	speedArrowR.y = speedText.y + (speedText.height/2) - (speedArrowR.height/2);
	insert(999, speedArrowR);



	///////////////////////////////////

	
	for (i => cat in catList) {
		var data = null;
		if (Assets.exists("data/freeplayCategories/"+cat+".json")) {
			data = Json.parse(Assets.getText("data/freeplayCategories/"+cat+".json"));
		} else {
			data = Json.parse(defaultSong);
		}

		var songText = createSongText(cat, data.songFontSize, 16, data);
		songText.ID = i;

		var bg:FlxSprite = new FlxSprite();
		bg.loadGraphic(Paths.image("menus/freeplay/square_song"));
		bg.scale.set(0.9, 0.9); bg.updateHitbox();

		var selectedBG:FlxSprite = new FlxSprite();
		selectedBG.loadGraphic(Paths.image("menus/freeplay/square_song_selected"));
		selectedBG.scale.set(0.9, 0.9); selectedBG.updateHitbox();
		selectedBG.alpha = 0;

		songText.scale.set(0.6, 0.6);
		songText.updateHitbox();
		songText.centerOffsets();
		if (songText.width > 650) {
			songText.setGraphicSize(650);
			songText.updateHitbox();
			songText.centerOffsets();
		}

		var songItem = new SongItem();
		songItem.ID = i;
		songItem.text = songText;
		songItem.back = bg;
		songItem.selectedBack = selectedBG;
		songItem.port = "";
		
		categoryGroup.add(songItem);
	}

	loadCategory(catList[currentCategory]);

	for(k=>s in songs) {
		if (s.name == Options.freeplayLastSong) {
			curSelected = k;
		}
	}
	if (songs[curSelected] != null) {
		for(k=>diff in songs[curSelected].difficulties) {
			if (diff == Options.freeplayLastDifficulty) {
				curDifficulty = k;
			}
		}
	}
	curScroll = curSelected;
	if (curScroll < 1) curScroll = 1;
	if (curScroll > songGroup.members.length-2) curScroll = songGroup.members.length-2;
	changeDiff(0, true);
	updateSongGroup(curSelected);
}

function loadCategory(name:String) {
	for (song in songGroup.members) {
		songGroup.remove(song);
	}
	songGroup.clear();
	songs = [];

	lastCategory = currentCategory;

	if (categories.exists(name)) {
		var list = categories.get(name);
		for (id in list) {
			songs.push(songList[id]);
			songGroup.add(songItems[id]);
			//songItems[id].x = 1280;
			songItems[id].selected = false;
		}
	}
	curSelected = FlxMath.wrap(curSelected, 0, songs.length-1);
	curScroll = curSelected;
	if (curScroll < 1) curScroll = 1;
	if (curScroll > songGroup.members.length-2) curScroll = songGroup.members.length-2;
	changeDiff(0, true);
	updateSongGroup(curSelected);
}

var songXPos = 2000;
var reloadCategory = false;
var firstFrame = true;

function getMinSongIndex() {return Math.max(0, curSelected-3);}
function getMaxSongIndex() {return Math.min(songGroup.members.length, curSelected+3);}

function postUpdate(elapsed) {
	var skipLerp = firstFrame && !selectingCategory;

	songXPos = CoolUtil.fpsLerp(songXPos, selectingCategory ? -1280 : 0, skipLerp ? 60.0 : 0.07);
	bgFade.x = (1280-bgFade.width)-songXPos;

	bgFadeValue = CoolUtil.fpsLerp(bgFadeValue, 0, 0.05);
	bgFadeShader.fade = bgFadeValue;

	for (i in getMinSongIndex()...getMaxSongIndex()) {
		var p = (curScroll - i) - 2;
		if (p < -3) p = -3;
		if (p > -1) p = -1;

		var t = songGroup.members[i];

		var targetY = (-p * 136) + 38;
		var targetX = 150.0;
		var lerpSpeed = 0.2;
		if (Math.abs(curScroll - i) > 1) {
			targetX = -1280;
			lerpSpeed = 0.05;
		} else if (curSelected - i == 0) {
			targetX = 200;
		}

		var altTargetX = -1280;
		if (curSelected - i == 0 && (lastDiffLoaded.toLowerCase() == "god" || lastDiffLoaded.toLowerCase() == "god mania")) {
			t.showAlt = true;
			targetX = -1280;
			altTargetX = 200;
		} else {
			t.showAlt = false;
		}

		if (t.gmAlt != null) {
			t.gmAlt.x = CoolUtil.fpsLerp(t.gmAlt.x, songXPos + altTargetX, skipLerp ? 60.0 : lerpSpeed);
		}

		t.y = CoolUtil.fpsLerp(t.y, targetY, skipLerp ? 60.0 : 0.12);
		t.x = CoolUtil.fpsLerp(t.x, songXPos + targetX, skipLerp ? 60.0 : lerpSpeed);
		t.selected = curSelected - i == 0;

		

	}

	for (i in 0...categoryGroup.members.length) {
		var p = (currentCategory - i) - 2;
		if (p < -3) p = -3;
		if (p > -1) p = -1;

		var t = categoryGroup.members[i];

		var targetY = (-p * 136) + 38;
		var targetX = 150.0;
		var lerpSpeed = 0.2;
		if (Math.abs(currentCategory - i) > 1) {
			targetX = -1280;
			lerpSpeed = 0.05;
		} else if (currentCategory - i == 0) {
			targetX = 200;
		}

		if (!selectingCategory) {
			targetX -= 1280;
		}

		
		t.y = CoolUtil.fpsLerp(t.y, targetY, skipLerp ? 60.0 : 0.12);
		t.x = CoolUtil.fpsLerp(t.x, targetX, skipLerp ? 60.0 : lerpSpeed);
		t.selected = currentCategory - i == 0;
	}

	if (scoreIndex < targetScore.length) {
		scoreTmr += elapsed;
		if (scoreTmr > 0.05) {
			scoreTmr = 0;

			currentScore[scoreIndex] = targetScore[scoreIndex];

			var str = "";
			for (i in 0...currentScore.length) {
				str = str + currentScore[i];
			}

			highscoreTotalText.text = str;
			highscoreTotalText.x = 1280 - highscoreTotalText.width;
			//var str = highscoreTotalText.text;

			//str[scoreIndex] = targetScore[scoreIndex];

			//highscoreTotalText.text = str;

			scoreIndex++;
		}
	}

	

	if (curPlayingInst != lastPlayedInst) {
		audioAnalyzer = null;
		if (FlxG.sound.music != null && FlxG.sound.music.playing) {
			audioAnalyzer = new AudioAnalyzer(FlxG.sound.music);
			lastPlayedInst = curPlayingInst;
			var meta = songs[curSelected]; //update the bpm
			lastPlayedSongInst = meta.displayName;
			Conductor.changeBPM(meta.bpm, meta.beatsPerMeasure, meta.stepsPerBeat);
		}
	}
	if (FlxG.sound.music != null && FlxG.sound.music.playing) {
		FlxG.sound.music.pitch = selectedSongSpeed;
	}


	var l = 0;
	var n = 0;
	var time = Math.floor(FlxG.sound.music.time/10)*10;
	for (i in 0...audioBars.length) {
		var spr = audioBars[i];
		
		n += 10 / audioBars.length;
		var v = audioAnalyzer != null ? audioAnalyzer.analyze(time + l, time + n) : 0;
		spr.scale.y = CoolUtil.fpsLerp(spr.scale.y, v*250, 0.15);
		spr.y = FlxG.height-spr.scale.y;
		spr.updateHitbox();
		l = n;
	}
		//var shit = Math.log(1 + (audioAnalyzer.analyze(Conductor.songPosition, Conductor.songPosition+1))) / Math.log(10);
		//var targetZoom = 1.0 + (shit);
		//FlxG.camera.zoom = CoolUtil.fpsLerp(FlxG.camera.zoom, targetZoom, 0.2);
		//trace(Conductor.songPosition + " : " + audioAnalyzer.analyze(Conductor.songPosition, Conductor.songPosition+1));

	if (reloadCategory) {
		loadCategory(catList[currentCategory]);
		reloadCategory = false;
	}

	firstFrame = false;
}

var lastPlayedInst:String = null;
var lastPlayedSongInst:String = "";

var hoveringThisFrame = false;

function update(elapsed) {
	hoveringThisFrame = false;

	var actualBACK = controls.BACK;
	controls.BACK = false;
	var actualACCEPT = controls.ACCEPT;
	controls.ACCEPT = false;

	

	canSelect = false;
	if (FlxG.mouse.justMoved) FlxG.mouse.visible = true;

	if (!selectingCategory) {
		changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);
		if (FlxG.keys.pressed.SHIFT)
			changeSongSpeed((controls.LEFT_P ? -0.1 : 0) + (controls.RIGHT_P ? 0.1 : 0));
		else
			changeDiff((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));

		for (i in getMinSongIndex()...getMaxSongIndex()) {		
			var t = songGroup.members[i];


			if (FlxG.mouse.overlaps(t.back) || FlxG.mouse.overlaps(t.text)) {

				hoveringThisFrame = true;
				if (FlxG.mouse.justPressed) {
					if (curSelected != i) {
						curSelected = i;
						var lastCurScroll = curScroll;
						changeSelection(0, true);
						curScroll = lastCurScroll;
					} else {
						actualACCEPT = true;
					}
				} 
			}
		}

		if (isClicked(diffArrowL)) changeDiff(-1);
		if (isClicked(diffArrowR)) changeDiff(1);
		if (isClicked(speedArrowL)) changeSongSpeed(-0.1);
		if (isClicked(speedArrowR)) changeSongSpeed(0.1);

	} else {
		var change = (controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0);
		if (change != 0) {
			currentCategory = FlxMath.wrap(currentCategory + change, 0, catList.length-1);
		}
	}

	if (isClicked(backButton)) actualBACK = true;

	if (actualBACK) {
		if (selectingCategory) {
			CoolUtil.playMenuSFX(2, 0.7);
			FlxG.switchState(new MainMenuState());
		} else {
			selectingCategory = true;
			songInstPlaying = true;
			lastCategory = -1;
		}
	}
	if (actualACCEPT) {
		if (selectingCategory) {
			selectingCategory = false;
			reloadCategory = true;
			autoplayElapsed = 0;
			songInstPlaying = false;
		} else {
			SONG_SPEED = selectedSongSpeed;
			CURRENT_LOADING_SCREEN = songGroup.members[curSelected].loadingScreen;
			select();
		}
	}

	Mouse.cursor = hoveringThisFrame ? MouseCursor.BUTTON : MouseCursor.ARROW;
}
function destroy() {
	Mouse.cursor = MouseCursor.ARROW;
}


function onChangeSelection(e) {
	

	updateSongGroup(e.value);
	curScroll = e.value;
	if (curScroll < 1) curScroll = 1;
	if (songGroup == null) return;
	if (curScroll > songGroup.members.length-2) curScroll = songGroup.members.length-2; 
}
var wasGM = false;
function onChangeDiff(e) {
	if (difficultySprite == null) return;

	var diffs = songs[curSelected].difficulties;

	if (lastDiffLoaded != diffs[e.value]) {
		lastDiffLoaded = diffs[e.value];
		if (Assets.exists(Paths.image("menus/freeplay/difficulties/" + diffs[e.value].toLowerCase()))) {
			difficultySprite.loadGraphic(Paths.image("menus/freeplay/difficulties/" + diffs[e.value].toLowerCase()));
			difficultySprite.scale.set(0.7, 0.7); difficultySprite.updateHitbox();
			difficultySprite.visible = true;
		} else {
			difficultySprite.visible = false;
		}

		var isGod = (lastDiffLoaded.toLowerCase() == "god" || lastDiffLoaded.toLowerCase() == "god mania");
		if (wasGM != isGod) {
			wasGM = isGod;
			autoplayElapsed = 0;
			songInstPlaying = false;
			updateSongGroup(curSelected, isGod);
		}
	}

	diffArrowL.visible = diffArrowR.visible = diffs.length > 1;

	updateScores(e.value);
}
function updateSongGroup(v, ?doAlt = false) {
	if (doAlt == null) doAlt = false;

	if (songGroup == null) return;
	for (i in 0...songGroup.members.length) {
		var p = (v - i);
		
		var t = songGroup.members[i];
		t.active = t.visible = true;
		if (p < -2) {
			t.selected = false;
			t.active = t.visible = false;
			t.x = -1280;
		} else if (p > 2) {
			t.selected = false;
			t.active = t.visible = false;
			t.x = -1280;
		}
	}

	var bgPort = songGroup.members[v].port;
	if (doAlt) {
		bgPort = songGroup.members[v].gmAlt.port;
	}
	if (lastLoadedBGPort != bgPort) {
		lastLoadedBGPort = bgPort;
		bgFadeShader.prevBG = bgFadeShader.bg;
		bgFadeValue = 1;
		if (Assets.exists(Paths.image('freeplayBGs/'+bgPort))) {
			bgSprite.loadGraphic(Paths.image("freeplayBGs/"+bgPort));
			bgFadeShader.bg = bgSprite.graphic.bitmap;
		} else {
			bgFadeShader.bg = emptyBGSprite.graphic.bitmap;
		}
	}
}

function changeSongSpeed(change:Float) {
	if (change == 0) return;

	selectedSongSpeed += change;
	if (selectedSongSpeed < 0.5) selectedSongSpeed = 0.5;
	if (selectedSongSpeed > 2) selectedSongSpeed = 2;
	selectedSongSpeed = FlxMath.roundDecimal(selectedSongSpeed, 2);
	var display = selectedSongSpeed+"";
	if (display.indexOf(".") == -1) display += ".0";
	speedText.text = display;
}

function updateScores(diffValue) {
	var changes:Array<HighscoreChange> = [];
	if (__coopMode) changes.push(HighscoreChange.CCoopMode);
	if (__opponentMode) changes.push(HighscoreChange.COpponentMode);
	currentHighscoreData = FunkinSave.getSongHighscore(songs[curSelected].name, songs[curSelected].difficulties[diffValue], changes);
	//trace(saveData);

	var str = Std.string(currentHighscoreData.score);
	for (i in 0...targetScore.length) {
		targetScore[i] = "";
	}

	var diff = targetScore.length - str.length;
	for (i in 0...str.length) {
		if (diff > 0) {
			targetScore[i+diff] = str.charAt(i);
		} else {
			targetScore[i] = str.charAt(i);
		}
	}

	while (targetScore.length > currentScore.length) {
		currentScore.insert(0, "");
	}

	for (i in 0...targetScore.length) {
		if (targetScore[i] == "" && targetScore.length-i <= 6) {
			targetScore[i] = "0";
		}
	}
	
	scoreTmr = 0;
	scoreIndex = 0;

	var diffs = songs[curSelected].difficulties;

	var infoText:String = "[ ";
	infoText += diffs[diffValue].toUpperCase() + " - ";
	if (currentHighscoreData.score > 0) {
		infoText += (currentHighscoreData.misses == 0 ? "FC" : "CLEAR") + " - ";
		infoText += getRank(currentHighscoreData.accuracy);
	} else {
		infoText += "NOT CLEARED";
	}

	infoText += " ]";
	highscoreInfoText.text = infoText;
	highscoreInfoText.updateHitbox();
	highscoreInfoText.x = 1280 - highscoreInfoText.width;

	curDifficulty = diffValue;
	updateLeaderboards();
}
var ranks = [
	[0, "F"],
	[0.5, "E"],
	[0.7, "D"],
	[0.8, "C"],
	[0.85, "B"],
	[0.9, "A"],
	[0.95, "S"],
	[1.0, "S++"]
];

function getRank(acc) {
	var rank = "F";
	for(e in ranks)
		if (e[0] <= acc)
			rank = e[1];

	return rank;
}

function updateLeaderboards() {
	setLeaderboardText("Fetching scores...");
	Leaderboards.getLeaderboard(songs[curSelected].name.toLowerCase(), songs[curSelected].difficulties[curDifficulty].toLowerCase(), selectedSongSpeed, false, function(str:String)
	{
		var text:String = '';
		//trace(str);
		switch(str)
		{
			case 'noScores':
				text = '---\n\n---\n\n---\n\n';
			case 'notLoggedIn':
				text = 'Not logged in.';
			case 'error': 
				text = 'Error fetching scores.';
			default: 
				trace("got score");
				//trace(str);
				var scoreList = Leaderboards.parseLeaderboardString(str);
				
				var limit = scoreList.scores.length;
				if (limit > 3)
					limit = 3; //only show top 3 
				
				var scoresShown:Int = 0;
				for (i in 0...limit)
				{
					var data = scoreList.scores[i];
					text += (i+1)+'.  ';
					text += ''+data.name;
					text += '  |  '+data.acc; //% doesnt exist with this font
					text += '  |  '+data.score;
					text += '  |  Miss: '+data.misses;
					text += "\n\n";
					scoresShown++;
				}
				while (scoresShown < 3) {
					text += "---\n\n";
					scoresShown++;
				}
		}
		if (FlxG.state != this)
		{
			return;
		}
		setLeaderboardText(text);
	});
}
function setLeaderboardText(text) {
	leaderboardsText.text = text;
	leaderboardsText.updateHitbox();
	leaderboardsText.screenCenter(FlxAxes.X);
}

function beatHit() {
	if (Conductor.bpm < 200 || curBeat % 2 == 0) {
		for (i in 0...songGroup.members.length) {
			//var t = songGroup.members[i];
			if (songGroup.members[i].song.displayName == lastPlayedSongInst) {
				songGroup.members[i].icon.scale.x = 0.7*1.2;
				songGroup.members[i].icon.scale.y = 0.7*1.2;
				if (songGroup.members[i].gmAlt != null) {
					songGroup.members[i].gmAlt.icon.scale.x = 0.7*1.2;
					songGroup.members[i].gmAlt.icon.scale.y = 0.7*1.2;
				}
			}
		}
	}
	//if (curBeat % 4 == 0) {

	//}

}


function isClicked(obj:FlxSprite) {
	var overlapping = obj.visible && FlxG.mouse.overlaps(obj);
	if (overlapping) {
		hoveringThisFrame = true;
	}
	return overlapping && FlxG.mouse.justPressed;
}