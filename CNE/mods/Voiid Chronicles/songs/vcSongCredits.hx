import VCSongText;


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

var songTable = [
    //song, composer, charter, og song composer, popuptime, textsize

    //Tutorial
    ["Warm Up", "NunsStop", "Xyriax", "RozeBud"],

    //Wiik 1
    ["Light It Up", "ImPaper", "RhysRJJ", "TheOnlyVolume", 6620],
    ["Ruckus", "Singular and Lord Voiid", "Xyriax", "TheOnlyVolume", 8170],
    ["Target Practice", "Lord Voiid", "Wolfinu", "TheOnlyVolume"],
    
    //Wiik 2
    ["Burnout", "Lord Voiid", "RhysRJJ (Voiid)", ""],
    ["Sporting", "Invalid", "Xyriax", "Biddle3"],
    ["Boxing Match", "Lord Voiid", "RhysRJJ", "TheOnlyVolume", 11330],

    //Matt With Hair
    ["Flaming Glove", "ImPaper", "Wolfinu (Voiid), RhysRJJ (7K)", ""],
    ["Punch and Gun", "Mineformer, DeltaMoai", "RhysRJJ (Voiid, 7K)", "MLOM"],
    ["Venom", "Lord Voiid", "RhysRJJ (Voiid, 7K)", "k-net"],

    //Wiik 3
    ["Fisticuffs", "Lord Voiid", "RhysRJJ", "HamillUn"],
    ["Blastout", "Revilo", "RhysRJJ", ""],
    ["Immortal", "Hippo0824 and Lord Voiid", "RhysRJJ", ""],
    ["King Hit", "Lord Voiid", "RhysRJJ", "TheOnlyVolume"],
    ["King Hit Wawa", "Lord Voiid", "Official_YS", "TheOnlyVolume"],
    ["TKO", "Lord Voiid and Invalid", "RhysRJJ (Voiid), Wolfinu (7K)", "HamillUn and Shteque"],

    //Wiik 4
    ["Disadvantage", "Lord Voiid", "Ushear & RhysRJJ", "Revilo"],
    ["Champion", "Lord Voiid (Voices), NobodyKnows (Inst)", "RhysRJJ", "Box of Rocks"],
    ["Last Combat", "Lord Voiid and NobodyKnows", "RhysRJJ", "BoxOfRocks"],
    ["Purgatory", "Lord Voiid and NobodyKnows", "Wolfinu", "BoxOfRocks"],
    ["Krakatoa", "NobodyKnows", "bruvDiego", ""],
    ["Sweet Dreams", "Lord Voiid, ImPaper, FZ Green, Lightor, Revilo, Spurk, NobodyKnows, Tomz_, Antarkh, MLOM", "RhysRJJ (4K/10K), Official_YS (7K)", "", 0, 16],

    //Greed Wiik
    ["Greedoom", "Lord Voiid and NobodyKnows", "RhysRJJ", ""],
    ["Purgatory", "Lord Voiid and NobodyKnows", "Wolfinu", "BoxOfRocks"],
    ["Krakatoa", "NobodyKnows", "bruvDiego", ""],

    //Cval Wiik 4
    ["Showdown", "Revilo", "RhysRJJ", "fluffyhairs music and Foodieti"],
    ["Take It", "NobodyKnows", "RhysRJJ", ""],

    //Wiik 100
    ["Mat", "Joa (Inst) and Hippo0824 (Voices)", "needs rechart (Voiid), RhysRJJ (7K)", "st4rcannon"],
    ["Banger", "Lord Voiid", "bruvDiego (Voiid), MLOM (7K)", "st4rcannon"],
    ["Edgy", "Lord Voiid (Voices) and MLOM (Inst)", "RhysRJJ", "st4rcannon", 18460],

    //Extras
    ["Recovery", "Lord Voiid and Joa", "RhysRJJ", ""],
    ["Rejected", "Lord Voiid", "Official_YS", "CrazyCake", 11320],
    ["Mattpurgation", "Invalid and DeltaMoai", "Xyriax", "JADS", 4000],
    ["Fishycuffs", "Lord Voiid", "Official_YS", "HamillUn"],
    ["Alter Ego", "Lord Voiid and Revilo", "RhysRJJ", ""],
    ["1CORE KILLER", "Lord Voiid", "RhysRJJ", "Lyfer MuSICK"],
    ["Bombastic", "Lord Voiid", "RhysRJJ", "Oofator"],
    ["Edgelord", "Lord Voiid and Joa", "bruvDiego, RhysRJJ, Official_YS", "Joa"],
    ["Ballin", "Lord Voiid, MLOM, and Revilo", "Official_YS", "AngryRacc"],
    ["Interregnum", "ImPaper (Inst, Voices) and Lord Voiid (Voices)", "RhysRJJ", "Tomz_ and Singular"],
    ["Ignis Gladius", "LegendaryPlz and Spring", "needs rechart (Hard), Ushear and Official_YS (Broke)", "CrazyCake"],
    ["Wii Remote", "VoiidicMelody (Voices)", "RhysRJJ", "JPR"],
    ["Average Voiid Song", "Fallnnn", "Xyriax", ""],

    //VIP Remixes
    ["TKO VIP", "Lord Voiid, NobodyKnows (Voices) and AngryRacc (Inst)", "RhysRJJ", "HamillUn and Shteque", 20480, 20],
    ["Alter Ego VIP", "Lord Voiid, ImPaper (Voices) and NobodyKnows (Inst)", "RhysRJJ", "Lord Voiid and Revilo", 0, 22],
    ["Burnout VIP", "Janemusic, Joa, Invalid, Revilo, and Lord Voiid", "RhysRJJ", "Lord Voiid"],
    ["Rejected VIP", "Lord Voiid, NobodyKnows, Revilo, ImPaper, and Invalid", "RhysRJJ, Wolfinu, and DiegoBruv", "CrazyCake"],

    //Shaggy X Matt
    ["Revenge", "Lord Voiid and Invalid", "Wolfinu (Mania), Offcial_YS (6K)", "TheOnlyVolume", 3000],
    ["Final Destination", "Lord Voiid", "RhysRJJ (Canon, God, God Mania), Wolfinu (Mania)", "srPerez", 6400],
    ["Final Destination Old", "Lord Voiid", "Medo and MarkC645 (Canon, God, God Mania), TheZoroForce240 and RhysRJJ (Mania)", "srPerez", 0, 19],

    //Antarkh X Voiid
    ["Glowing Collision", "Antarkh (Inst, Voices) and Lord Voiid (Voices)", "Official_YS (Mania), RhysRJJ (Canon)", ""],
    ["Paired Entities", "Antarkh (Voices) and Lord Voiid (Inst, Voices)", "RhysRJJ (Canon)", ""],
    ["Multiversal Slash", "Antarkh (Inst, Voices) and Lord Voiid (Voices)", "bruvDiego (Mania), RhysRJJ (Canon), TheZoroForce240 (Easy)", "", 0, 22],

    //Galactic Showdown
    ["Cosmic Memories", "Lord Voiid", "RhysRJJ (Mania, Canon)", ""],
    ["New Horizon", "SmokeCannon", "RhysRJJ (Mania, Canon)", ""],
    ["Galactic Storm", "Lord Voiid (Voices), and NobodyKnows (Inst, Voices)", "RhysRJJ (Mania, Canon), TheZoroForce240 (Easy)", "", 0, 20],

    //2k Specials
    ["Cleverness", "Lord Voiid", "Ushear", ""],
    ["Tempo Slayer", "Lord Voiid", "RhysRJJ", ""],
    ["Total Bravery", "Lord Voiid", "Ushear", ""],

    //Collabs
    ["Defamation Of Reality", "AngryRacc and Lord Voiid", "RhysRJJ", ""],
    ["Radical Showdown", "Singular and Lord Voiid", "RhysRJJ (Canon), Official_YS (Mania)", ""],

    //Agoti
    ["Exodus", "Lord Voiid", "needs rechart", ""],

    //Tricky
    ["Wastelands", "Lord Voiid", "Wolfinu", ""],
    ["Toxic", "Invalid", "RhysRJJ", ""],
    
];
var song = null;

var songBG = null;
var songText = null;
var extraText = null;

function postCreate() {

	if (Assets.exists("songs/"+PlayState.SONG.meta.name+"/credits.json")) {
		if (Assets.exists("songs/"+PlayState.SONG.meta.name+"/credits-" + PlayState.difficulty + ".json")) {
			song = Json.parse(Assets.getText("songs/"+PlayState.SONG.meta.name+"/credits-" + PlayState.difficulty + ".json"));
		} else {
			song = Json.parse(Assets.getText("songs/"+PlayState.SONG.meta.name+"/credits.json"));
		}
	} else {
		song = Json.parse(defaultSong);
	}
	

	songBG = new FlxSprite();
	songBG.loadGraphic(Paths.image("songPopupThingy"));
	songBG.screenCenter();
	songBG.cameras = [camHUD];
	insert(0, songBG);

	songText = createSongText(PlayState.SONG.meta.displayName, song.songFontSize, 16, song);
	songText.cameras = [camHUD];
	insert(1, songText);
	

	var textShit = "Composer: "+song.composer+"      Charter: "+song.charter;
    if (song.originalComposer != "")
        textShit = textShit+"      Original Song: " + song.originalComposer;

	var textSize = song.infoFontSize;
    //if (song[5] != null) textSize = song[5];

	extraText = new FunkinText(0,0,0,textShit,textSize);
	extraText.cameras = [camHUD];
	extraText.font = Paths.font("Contb___.ttf");
	extraText.screenCenter();
	extraText.y -= 60 * (downscroll ? 1 : -1);
	extraText.color = 0xFF000000;
	extraText.borderColor = 0xFFFFFFFF;
	extraText.borderSize = 1;
	extraText.antialiasing = true;
	insert(1, extraText);

	songText.x += 2000;
	extraText.x += 2000;
	songBG.x += 2000;
}




var showedPopups = false;
function onSongStart() {
	if (song.startTime == null) {
		showedPopups = true;
		FlxTween.tween(songBG, {x: songBG.x-2000}, Conductor.stepCrochet*0.001*8, {ease:FlxEase.expoOut});
		FlxTween.tween(songText, {x: songText.x-2000}, Conductor.stepCrochet*0.001*8, {ease:FlxEase.expoOut});
		FlxTween.tween(extraText, {x: extraText.x-2000}, Conductor.stepCrochet*0.001*8, {ease:FlxEase.expoOut});
	}
}
var hiddenPopups = false;
var killedPopups = false;

function stepHit() {
	var delay = 0;
	if (song.startTime != null) {
		delay = song.startTime;
		if (Conductor.songPosition >= delay && !showedPopups) {
			showedPopups = true;
			FlxTween.tween(songBG, {x: songBG.x-2000}, Conductor.stepCrochet*0.001*8, {ease:FlxEase.expoOut});
			FlxTween.tween(songText, {x: songText.x-2000}, Conductor.stepCrochet*0.001*8, {ease:FlxEase.expoOut});
			FlxTween.tween(extraText, {x: extraText.x-2000}, Conductor.stepCrochet*0.001*8, {ease:FlxEase.expoOut});
		}
	}
	if (Conductor.songPosition > 5000+delay && !hiddenPopups) {
		hiddenPopups = true;
		FlxTween.tween(songBG, {x: songBG.x-2000}, Conductor.stepCrochet*0.001*4, {ease:FlxEase.expoIn});
		FlxTween.tween(songText, {x: songText.x-2000}, Conductor.stepCrochet*0.001*4, {ease:FlxEase.expoIn});
		FlxTween.tween(extraText, {x: extraText.x-2000}, Conductor.stepCrochet*0.001*4, {ease:FlxEase.expoIn});
	}
	if (Conductor.songPosition > 10000+delay && !killedPopups) {
		killedPopups = true;
		for (obj in [songBG, songText, extraText]) {
			remove(obj);
			obj.destroy();
		}
	}
}