package online;

import online.Gloves.GloveDisplay;
import states.VoiidMainMenuState;
import Popup.MessagePopup;
import ui.Checkbox;
import online.ChatManager.CustomSliceSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import online.ChatManager.EmojiSelector;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxTimer;
import online.ChatManager.ChatMessage;
import states.LoadingState;
import states.PlayState;
import game.Conductor;
import lime.utils.Assets;
import game.Highscore;
import game.Song;
import states.VoiidAwardsState.ScrollBar;
import utilities.CoolUtil;
import substates.MusicBeatSubstate;
import game.Character;
import openfl.utils.ByteArray;
import openfl.events.Event;
import openfl.net.URLStream;
import openfl.net.URLRequest;
import flixel.graphics.FlxGraphic;
import flixel.addons.api.FlxGameJolt;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxGradient;
import flash.display.BitmapData;
import states.FreeplayState;
import flixel.math.FlxMath;
import ui.Alphabet;
import ui.HealthIcon;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import states.MusicBeatState;
#if discord_rpc
import utilities.Discord.DiscordClient;
#end

using StringTools;

class MultiplayerRoomState extends MusicBeatState
{
    var leftPod:FlxSprite;
    var rightPod:FlxSprite;


    var changeSongGrad:FlxSprite;

    var songGrad:FlxSprite;
    var songIcon:HealthIcon;
    var songName:Alphabet;

    var diffGrad:FlxSprite;
    var speedText:FlxText;
    var slash:FlxText;
    var diffSprite:FlxSprite;

    var backButton:FlxSprite;
    var settingsButton:FlxSprite;
    var settingsMenu:SettingsPopup;
    var changeSideButton:FlxSprite;
    var start:FlxSprite;
    var ready:FlxSprite;

    var player1Text:GradientText;
    var player2Text:GradientText;

    var player1ReadyText:GradientText;
    var player2ReadyText:GradientText;

    var player1Image:FlxSprite;
    var player2Image:FlxSprite;
    var hostIcon:FlxSprite;
    var readyText:FlxText;

    var bf:Character;
    var opp:Character;

    var spectatorText:FlxText;

    var curSong:String = "";
    var curDiff:String = "";
    var curSpeed:Float = 1.0;

    var whiteGloveDisplay:GloveDisplay;
    var purpGloveDisplay:GloveDisplay;

    var songList:SongList = new SongList();

    override public function create()
    {
        super.create();

        FlxG.mouse.visible = true;
        FlxG.autoPause = false;

        Multiplayer.forceUpdateTimestamp = true;

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("online/room/bg_online"));
        bg.setGraphicSize(1280);
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = true;
        add(bg);

        changeSongGrad = new FlxSprite(0,70).loadGraphic(Paths.image("online/room/gradient_white"));
        changeSongGrad.setGraphicSize(Std.int(FlxG.width*0.333));
        changeSongGrad.scale.y *= 0.666; //concept image was 1080p so converting to 720p
        changeSongGrad.updateHitbox();
        changeSongGrad.x = FlxG.width-changeSongGrad.width;
        changeSongGrad.antialiasing = true;
        add(changeSongGrad);

        var searchIcon:FlxSprite = new FlxSprite().loadGraphic(Paths.image("online/room/search"));
        searchIcon.scale *= 0.666;
        searchIcon.updateHitbox();
        searchIcon.antialiasing = true;
        searchIcon.x = FlxG.width-(searchIcon.width+10);
        searchIcon.y = changeSongGrad.y + (changeSongGrad.height*0.5)-(searchIcon.height*0.5);
        add(searchIcon);

        var changeSongText = new FlxText(0,0,0, "CHANGE SONG");
        changeSongText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.BLACK, RIGHT);
        changeSongText.x = searchIcon.x-(changeSongText.width+20);
        changeSongText.y = changeSongGrad.y + (changeSongGrad.height*0.5)-(changeSongText.height*0.5);
        add(changeSongText);

        songGrad = new FlxSprite(0,changeSongGrad.y + changeSongGrad.height + 10).loadGraphic(Paths.image("online/room/gradient_black"));
        songGrad.setGraphicSize(Std.int(FlxG.width*0.4));
        //songGrad.scale.y *= 0.666; //concept image was 1080p so converting to 720p
        songGrad.updateHitbox();
        songGrad.x = FlxG.width-songGrad.width;
        songGrad.antialiasing = true;
        add(songGrad);


        songIcon = new HealthIcon("bf");
        add(songIcon);

        songName = new Alphabet(0, 0, "Song Name", true, false, 1.0);
        add(songName);


        diffGrad = new FlxSprite(0,songGrad.y + songGrad.height + 10).loadGraphic(Paths.image("online/room/gradient_black"));
        diffGrad.setGraphicSize(Std.int(FlxG.width*0.3));
        diffGrad.scale.y *= 0.666;
        diffGrad.updateHitbox();
        diffGrad.x = FlxG.width-diffGrad.width;
        diffGrad.antialiasing = true;
        add(diffGrad);


        diffSprite = new FlxSprite().makeGraphic(100,70);
        diffSprite.antialiasing = true;
        add(diffSprite);

        slash = new FlxText(0,0,0,"/");
        slash.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        slash.borderSize = 2;
        add(slash);
        //

        speedText = new FlxText(0, 0, 0, "1");
        speedText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        speedText.borderSize = 2;
        add(speedText);


        

        readyText = new FlxText(0,diffGrad.y + diffGrad.height + 10,0,"0/0 READY!");
        readyText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        readyText.x = FlxG.width-(readyText.width+10);
        readyText.borderSize = 2;
        add(readyText);


        leftPod = new FlxSprite(0, 530).loadGraphic(Paths.image("online/room/podium_opponent"));
        leftPod.setGraphicSize(300);
        leftPod.updateHitbox();
        leftPod.antialiasing = true;
        leftPod.x = (FlxG.width*0.333)-(leftPod.width*0.5);
        add(leftPod);

        rightPod = new FlxSprite(0, 530).loadGraphic(Paths.image("online/room/podium_player"));
        rightPod.setGraphicSize(300);
        rightPod.updateHitbox();
        rightPod.antialiasing = true;
        rightPod.x = (FlxG.width*0.666)-(rightPod.width*0.5);
        add(rightPod);

        bf = new Character(rightPod.x, rightPod.y, "bf", true);
        add(bf);
        bf.scale *= 0.5;
        bf.scaleMult = 0.5;
        bf.updateHitbox();
        bf.y = (rightPod.y-bf.height)+50;
        bf.x = rightPod.x + (rightPod.width*0.5)-(bf.width*0.5);

        opp = new Character(leftPod.x, leftPod.y, "bf", false);
        add(opp);
        opp.scale *= 0.5;
        opp.scaleMult = 0.5;
        opp.updateHitbox();
        opp.y = (leftPod.y-opp.height)+50;
        opp.x = leftPod.x + (leftPod.width*0.5)-(opp.width*0.5);



        var topBar:FlxSprite = new FlxSprite().makeGraphic(1,1, FlxColor.BLACK);
        topBar.setGraphicSize(1280, 60);
        topBar.updateHitbox();
        topBar.screenCenter(X);
        add(topBar);

        var bottomBar:FlxSprite = new FlxSprite(0, FlxG.height-60).makeGraphic(1,1, FlxColor.BLACK);
        bottomBar.setGraphicSize(1280, 60);
        bottomBar.updateHitbox();
        bottomBar.screenCenter(X);
        add(bottomBar);

        var roomID = new FlxText(0, 60, 0, "ROOM ID:");
        roomID.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(roomID);
        roomID.screenCenter(X);
        roomID.y -= roomID.height+5;

        var idText = new GradientText(0, 65, 0, "#"+Multiplayer.serverID);
        idText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(idText);
        idText.screenCenter(X);
        idText.setGradient(0xFF6f00ff, 0xFFf000ff, 0xFF000000);


        var chatBox = new ChatBox(20, bottomBar.y);
        add(chatBox);



        backButton = new FlxSprite(10,10).loadGraphic(Paths.image("online/room/button_back"));
        backButton.scale *= 0.666;
        backButton.updateHitbox();
        backButton.antialiasing = true;
        add(backButton);

        settingsButton = new FlxSprite(10,backButton.y + backButton.height + 10).loadGraphic(Paths.image("online/room/button_options"));
        settingsButton.scale *= 0.666;
        settingsButton.updateHitbox();
        settingsButton.antialiasing = true;
        add(settingsButton);

        settingsMenu = new SettingsPopup();
        settingsMenu.x = settingsButton.x+settingsButton.width+5;
        settingsMenu.y = settingsButton.y;
        settingsMenu.visible = false;
        add(settingsMenu);

        hostIcon = new FlxSprite().loadGraphic(Paths.image("online/room/host"));
        hostIcon.scale *= 0.7;
        hostIcon.antialiasing = true;
        hostIcon.updateHitbox();
        add(hostIcon);

        whiteGloveDisplay = new GloveDisplay("white", Gloves.getWhiteGloveCount(), 32);
        whiteGloveDisplay.x = backButton.x + backButton.width;
        whiteGloveDisplay.y = -10;
        add(whiteGloveDisplay);

        purpGloveDisplay = new GloveDisplay("lean", Gloves.getPurpleGloveCount(), 32);
        purpGloveDisplay.x = whiteGloveDisplay.x + whiteGloveDisplay.width;
        purpGloveDisplay.y = -10;
        add(purpGloveDisplay);


        player1Text = new GradientText(0,FlxG.height-50,0, "Player 1");
        player1Text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        player1Text.x = FlxG.width*0.666-(player1Text.width*0.5);
        add(player1Text);

        player1Image = new FlxSprite();
        player1Image.makeGraphic(60,60);
        player1Image.y = FlxG.height-120;
        add(player1Image);

        player1ReadyText = new GradientText(0, FlxG.height-20, 0, "[NOT READY]");
        player1ReadyText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        player1ReadyText.x = FlxG.width*0.666-(player1Text.width*0.5);
        add(player1ReadyText);

        
        //updatePlayerName(player1Text, "", true, true, player1Image);

        //FlxGradient.overlayGradientOnFlxSprite(player1Text, Std.int(player1Text.width), Std.int(player1Text.height), [], 0, 0, 1, 90);

        player2Text = new GradientText(0,FlxG.height-50,0, "Player 2");
        player2Text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        player2Text.x = FlxG.width*0.333-(player2Text.width*0.5);
        add(player2Text);

        player2Image = new FlxSprite();
        player2Image.makeGraphic(60,60);
        player2Image.y = FlxG.height-120;
        add(player2Image);

        player2ReadyText = new GradientText(0, FlxG.height-20, 0, "[NOT READY]");
        player2ReadyText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        player2ReadyText.x = FlxG.width*0.333-(player1Text.width*0.5);
        add(player2ReadyText);

        if (Multiplayer.player1Client != null && Multiplayer.player2Client != null)
        {
            updatePlayerName(player1Text, Multiplayer.player1Client.playerName, true, true, player1Image);
            updatePlayerName(player2Text, Multiplayer.player2Client.playerName, false, false, player2Image);
        }
        else 
        {
            updatePlayerName(player1Text, "Player1", true, true, player1Image);
            updatePlayerName(player2Text, "Player2", false, false, player2Image);
        }

        //updatePlayerName(player2Text, "", false, false, player2Image);

        changeSideButton = new FlxSprite(0, 550).loadGraphic(Paths.image("online/room/change_side"));
        changeSideButton.scale *= 0.7;
        changeSideButton.antialiasing = true;
        changeSideButton.updateHitbox();
        changeSideButton.screenCenter(X);
        add(changeSideButton);


        start = new FlxSprite().loadGraphic(Paths.image("online/room/start"));
        start.scale *= 0.6;
        start.antialiasing = true;
        start.updateHitbox();
        start.x = FlxG.width-start.width;
        start.y = FlxG.height-start.height;
        start.visible = false;
        add(start);

        ready = new FlxSprite().loadGraphic(Paths.image("online/room/ready"));
        ready.scale *= 0.6;
        ready.antialiasing = true;
        ready.updateHitbox();
        ready.x = FlxG.width-ready.width;
        ready.y = FlxG.height-ready.height;
        add(ready);


        updateSong("Alter Ego");
        updateSpeed(1);
        updateDiff("Voiid");

        if (Multiplayer.currentPlayer == 0)
            ChatManager.sendMessage("SERVER", 0xFF49F0FF, "Room created.:punch:");

        #if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Online Room", null, "empty", "logo");
		#end
    }


    function updateSong(song:String)
    {
        curSong = song.replace(" ", "-");

        songName.scaleMult = 0.7;
        songName.setText(song.replace("-", " "));

        var icon:String = "";
        
        for (s in songList.getFullSongList())
        {
            if (s.songName.toLowerCase() == song.replace("-", " ").toLowerCase())
            {
                icon = s.songCharacter;
                break;
            }
        }
        

        songIcon.changeIconSet(icon);
        songIcon.scale.set(0.7,0.7);
        songIcon.updateHitbox();

        songIcon.y = songGrad.y + (songGrad.height*0.5)-(songIcon.height*0.5);
        songIcon.x = FlxG.width-(songIcon.width+10);
        songName.y = songGrad.y + (songGrad.height*0.5)-(songName.height*0.5);
        songName.x = songIcon.x-(songName.width+25);
    }
    function updateDiff(diff:String)
    {
        curDiff = diff.toUpperCase();
        if (FreeplayState.diffImageMap.exists(curDiff.replace("-", " ")))
        {
            diffSprite.loadGraphic(Paths.image("campaign menu/difficulties/Voiid/"+FreeplayState.diffImageMap.get(curDiff.replace("-", " "))));
            diffSprite.setGraphicSize(100);
            diffSprite.updateHitbox();
        }
        diffSprite.y = diffGrad.y+(diffGrad.height*0.5)-(diffSprite.height*0.5);
        diffSprite.x = slash.x - (diffSprite.width+10);
        updateCharacters();
    }
    function updateSpeed(speed:Float)
    {
        curSpeed = FlxMath.roundDecimal(speed, 2);
        speedText.text = curSpeed+"";
        speedText.y = diffGrad.y+(diffGrad.height*0.5)-(speedText.height*0.5);
        speedText.x = FlxG.width-(speedText.width+20);

        slash.x = speedText.x - (slash.width+20);
        slash.y = diffGrad.y+(diffGrad.height*0.5)-(slash.height*0.5);
    }
    function updateCharacters()
    {
        var poop:String = Highscore.formatSong(curSong.replace("-", " ").toLowerCase(), curDiff.replace("-", " ").toLowerCase());
        //remake characters from song json
        if(Assets.exists(Paths.json("song data/" + curSong.toLowerCase().replace("-", " ") + "/" + poop)))
        {
            var songJson = Song.loadFromJson(poop, curSong.toLowerCase().replace("-", " "));

            if (bf.curCharacter != songJson.player1)
            {
                remove(bf);
                if (bf.otherCharacters != null)
                    for (c in bf.otherCharacters)
                        remove(c);
                bf = new Character(0, 0, songJson.player1, true, false, 0.5);
                add(bf);
                bf.updateHitbox();
                bf.y = (rightPod.y-bf.height)+50;
                bf.x = rightPod.x + (rightPod.width*0.5)-(bf.width*0.5);
                bf.offsetOffset = [bf.offset.x, bf.offset.y]; //keep it centered
                if (bf.otherCharacters != null)
                {
                    var x = rightPod.x + (rightPod.width*0.25);
                    for (c in bf.otherCharacters)
                    {
                        c.updateHitbox();
                        c.setPosition(x+c.positioningOffset[0], (rightPod.y-c.height)+50);
                        add(c);
                        c.offsetOffset = [c.offset.x, c.offset.y];
                    }
                }
            }
            if (opp.curCharacter != songJson.player2)
            {
                remove(opp);
                if (opp.otherCharacters != null)
                    for (c in opp.otherCharacters)
                        remove(c);

                opp = new Character(0, 0, songJson.player2, false, 0.5);
                add(opp);
                opp.updateHitbox();
                opp.y = (leftPod.y-opp.height)+50;
                opp.x = leftPod.x + (leftPod.width*0.5)-(opp.width*0.5);
                opp.offsetOffset = [opp.offset.x, opp.offset.y];
                if (opp.otherCharacters != null)
                {
                    var x = leftPod.x + (leftPod.width*0.25);
                    for (c in opp.otherCharacters)
                    {
                        c.updateHitbox();
                        c.setPosition(x+c.positioningOffset[0], (leftPod.y+50)-c.height);
                        add(c);
                        c.offsetOffset = [c.offset.x, c.offset.y];
                    }
                }
            }
        }
        else
        {
            trace('song doesnt exist?');
            trace(curSong.toLowerCase().replace("-", " "));
            trace(poop);
        }
    }

    var diffList:Array<String> = ["Voiid"];
    var curDiffIdx:Int = 0;
    public function changeSong(song:String, icon:String, diffs:Array<String>)
    {
        diffList = diffs;
        updateSong(song);
        updateDiff(diffs[0]);

        ChatManager.sendMessage("SERVER", 0xFF49F0FF, "Song changed to " + song);
        var poop:String = Highscore.formatSong(curSong.replace("-", " ").toLowerCase(), curDiff.replace("-", " ").toLowerCase());
        //load song
        if(!Assets.exists(Paths.json("song data/" + curSong.replace("-", " ").toLowerCase() + "/" + poop)))
        {
            if (Multiplayer.clients[Multiplayer.currentPlayer] != null)
            {
                ChatManager.sendMessage("WARNING", 0xFFFF4949, "SONG does not exist for " + Multiplayer.clients[Multiplayer.currentPlayer].playerName + "!");
            }
            else 
            {
                ChatManager.sendMessage("WARNING", 0xFFFF4949, "SONG does not exist for everyone!");
            }
            
        }
    }


    private static final customDevNames:Map<String, Dynamic> = [
        //name             //color/gradient           //suffix   //border color
        "LordVoiid" => [[0xFF6f00ff, 0xFFf000ff], " [OWNER]", 0xFF000000],
        "RhysRJJ" => [[0xFF1E90FF, 0xFF69B5FF], " [CO-DIRECTOR]", 0xFF000000],
        "TheZoroForce240" => [[0xffff6a00, 0xffff9513], " [CODER]", 0xFF000000],
        "Official_YS" => [[0xFF7303fc, 0xFF7303fc], " [MART MAN]", 0xFF000000],
        "Cons" => [[0xFFFFFFFF, 0xFFFFFFFF], " [Loreman]", 0xFF000000],
        "diegobruv" => [[0xFF698cff, 0xFFFFFFFF], " [mid charter]", 0xFF000000],
        "mlomofficial" => [[0xFF030ce0, 0xFF030ce0], " [matt va]", 0xFF000000],
        "ChronikMelody" => [[0xFF3a339e, 0xFF3a339e], " [GF VA]", 0xFF000000],
        "Fallnnn" => [[0xffff35da, 0xff00aeff], " [a really long tag]", 0xFFAE00FF],
        "Delta_Fr" => [[0xffA25AD9, 0xffCAB1FF], " [drill guy]", 0xFF000000],
        "TheMineFormer" => [[0xff49aae3, 0xff14459c], " [Bri'ish]", 0xFFFFFFFF],
        "TroZeStickIsNub" => [[0xffFF6833, 0xFFFF6833], " [Upcoming animatr]", 0xFF000000],
        "Wolfinu" => [[0xffe35310, 0xFFe31010], " [Monke]", 0xFF000000],
        "Hippo0824" => [[0xff00ff00, 0xFF00ff00], " [ÐƏV]", 0xFF000000],
        "SubSilent" => [[0xff848484, 0xFFe8e8e8], " [Sub]", 0xFF000000],
    ];

    public static function applyGradientToText(text:GradientText, name:String)
    {
        if (customDevNames.exists(name))
        {
            var data = customDevNames.get(name);
            text.text = name + data[1];

            if (data[0].length > 1)
            {
                
                if (data[2] != 0xFF000000)
                {
                    text.color = 0xFFFF0000;
                    text.borderColor = 0xFF00FF00;
                }
                else 
                {
                    text.borderColor = 0xFF000000;
                    text.color = 0xFFFFFFFF;
                }
                text.setGradient(data[0][0], data[0][1], data[2]);
            }
            else 
            {
                text.removeGradient();
                text.color = data[0][0];
            }
        }
        else 
        {
            text.text = name;
            text.removeGradient();
            text.color = 0xFFFFFFFF;
            text.borderColor = 0xFF000000;
        }
    }

    function updatePlayerName(text:GradientText, name:String, p1:Bool, host:Bool, avatarImage:FlxSprite)
    {
        applyGradientToText(text, name);

        var w:Float = text.width;
        if (host)
            w += hostIcon.width+10;


        var targetPos = FlxG.width*0.666;
        if (!p1)
            targetPos = FlxG.width*0.333;

        text.x = targetPos-(w*0.5);
        avatarImage.x = targetPos-(avatarImage.width*0.5);

        if (host)
        {
            text.x += hostIcon.width+10;
            hostIcon.x = text.x-(hostIcon.width+10);
            hostIcon.y = text.y + (text.height*0.5)-(hostIcon.height*0.5);
        }

        //load avatars
        FlxGameJolt.fetchUser(null, name, null, function(map:Map<String,String>)
        {
            if (map != null)
            {
                if (map.get('success') == 'true')
                {
                    if (map.exists("avatar_url"))
                    {
                        var request:URLRequest = new URLRequest(map.get("avatar_url"));
                        var stream:URLStream = new URLStream();
                        stream.addEventListener(Event.COMPLETE, function(e:Event)
                        {
                            var bytes:ByteArray = new ByteArray();
                            stream.readBytes(bytes, 0, stream.bytesAvailable);
                            var bitmapData = BitmapData.fromBytes(bytes);
                            
                            if (bitmapData != null)
                            {
                                //trace('loading image');
                                avatarImage.loadGraphic(FlxGraphic.fromBitmapData(bitmapData));
                                avatarImage.setGraphicSize(60);
                                avatarImage.antialiasing = true;
                                avatarImage.updateHitbox();
                            }
                            stream.close();
                            stream = null;
                            request = null;
                        });
                        stream.load(request);
                    }
                }
            }
        }, "mpLoadAvatar"+p1);
        
    }


    var exiting:Bool = false;

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        FlxG.mouse.visible = true;
        FlxG.autoPause = false;

        if (exiting)
            return;

        

        if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

        if (Multiplayer.player1Client != null && Multiplayer.player2Client != null)
        {
            if (Multiplayer.player1Client.ready)
                player1ReadyText.text = "[READY]";
            else 
                player1ReadyText.text = "[NOT READY]";
            if (Multiplayer.player2Client.ready)
                player2ReadyText.text = "[READY]";
            else 
                player2ReadyText.text = "[NOT READY]";

            player1ReadyText.x = FlxG.width*0.666-(player1ReadyText.width*0.5);
            player2ReadyText.x = FlxG.width*0.333-(player2ReadyText.width*0.5);
            if (Multiplayer.player1Client.ready && Multiplayer.player2Client.ready)
            {
                ready.visible = false;
                start.visible = false;
                if (Multiplayer.currentPlayer == 0)
                    start.visible = true;
            }

            if (Multiplayer.currentPlayer != 0)
            {
                if (curSong != Multiplayer.player1Client.song && Multiplayer.player1Client.song != "")
                    updateSong(Multiplayer.player1Client.song);
                if (curDiff != Multiplayer.player1Client.diff.toLowerCase())
                    updateDiff(curDiff);
                if (curSpeed != Multiplayer.player1Client.songSpeed)
                    updateSpeed(Multiplayer.player1Client.songSpeed);
            }
            else 
            {
                Multiplayer.player1Client.song = curSong.replace(" ", "-");
                Multiplayer.player1Client.diff = curDiff.replace(" ", "-");
                Multiplayer.player1Client.songSpeed = curSpeed;
            }
        }


        if (FlxG.mouse.justPressed)
        {
            if (FlxG.mouse.overlaps(changeSongGrad) && ready.visible && Multiplayer.currentPlayer == 0)
            {
                openSubState(new SongSelectSubstate(this));
                persistentUpdate = true;
                
            }

            if (FlxG.mouse.overlaps(ready) && ready.visible)
            {
                ready.visible = false;
                if (Multiplayer.clients[Multiplayer.currentPlayer] != null)
                {
                    Multiplayer.clients[Multiplayer.currentPlayer].ready = true;
                    ChatManager.sendMessage("SERVER", 0xFF49F0FF, 
                    Multiplayer.clients[Multiplayer.currentPlayer].playerName + " is ready!:martthumbs:");
                }   
            }
            if (FlxG.mouse.overlaps(start) && start.visible)
            {
                if (Multiplayer.clients[Multiplayer.currentPlayer] != null)
                    Multiplayer.clients[Multiplayer.currentPlayer].started = true;
            }

            if (FlxG.mouse.overlaps(settingsButton))
                settingsMenu.visible = !settingsMenu.visible;

            if (FlxG.mouse.overlaps(backButton))
            {
                var isReady:Bool = false;
                if (Multiplayer.clients[Multiplayer.currentPlayer] != null)
                {
                    if (Multiplayer.clients[Multiplayer.currentPlayer].ready)
                        isReady = true; //check if ready first
                }

                if (isReady) //unready
                {
                    if (Multiplayer.clients[Multiplayer.currentPlayer] != null)
                    {
                        Multiplayer.clients[Multiplayer.currentPlayer].ready = false;
                        ready.visible = true;
                    }
                    ChatManager.sendMessage("SERVER", 0xFF49F0FF, 
                    Multiplayer.clients[Multiplayer.currentPlayer].playerName + " is no longer ready.:die:");
                }
                else //leave server
                {

                    if (Multiplayer.clients[Multiplayer.currentPlayer] != null)
                    {
                        ChatManager.sendMessage("SERVER", 0xFF49F0FF, 
                        Multiplayer.clients[Multiplayer.currentPlayer].playerName + " has left.:skull:");
                        Multiplayer.clients[Multiplayer.currentPlayer].playerConnected = false;
                    }
                        
                    //Multiplayer.endServer();
                    Multiplayer.forceUpdateTimestamp = false;
                    FlxG.switchState(new VoiidMainMenuState());
                    exiting = true;
                    return;
                }
            }
        }
        if (Multiplayer.player1Client != null)
        {
            if (Multiplayer.player1Client.started)
            {
                if (curSong.toLowerCase() == "chess")
                {
                    Multiplayer.forceUpdateTimestamp = false;
					FlxG.switchState(new ChessState());
                    exiting = true;
                    return;
                }
                //trace(curSong);
                //trace(curDiff);
                //trace(curSpeed);
                var poop:String = Highscore.formatSong(curSong.replace("-", " ").toLowerCase(), curDiff.replace("-", " ").toLowerCase());
                //load song
                if(Assets.exists(Paths.json("song data/" + curSong.replace("-", " ").toLowerCase() + "/" + poop)))
                {
                    PlayState.SONG = Song.loadFromJson(poop, curSong.replace("-", " ").toLowerCase());
                    PlayState.isStoryMode = false;
                    PlayState.storyDifficulty = 0;
                    PlayState.songMultiplier = curSpeed;
                    PlayState.storyDifficultyStr = curDiff.replace("-", " ").toUpperCase();
                    PlayState.diffLoadedInWith = curDiff.replace("-", " ").toLowerCase();

                    PlayState.inMultiplayerSession = true;
                    PlayState.chartingMode = false;
                    Multiplayer.forceUpdateTimestamp = false;
					LoadingState.loadAndSwitchState(new PlayState());
                    exiting = true;
                }
            }
        }

        if (!Multiplayer.active)
        {
            Main.popupManager.addPopup(new MessagePopup(6, 300, 50, "Opponent has Disconnected"));
			Multiplayer.endServer();
            Multiplayer.forceUpdateTimestamp = false;
            FlxG.switchState(new VoiidMainMenuState());
            exiting = true;
        }
    }

    override public function beatHit()
    {
        super.beatHit();
        bf.dance();
        if (bf.otherCharacters != null)
            for (c in bf.otherCharacters)
                c.dance();
        opp.dance();
        if (opp.otherCharacters != null)
            for (c in opp.otherCharacters)
                c.dance();
    }

}

class SongSelectSubstate extends MusicBeatSubstate
{
    var instance:MultiplayerRoomState;
    override public function new(instance:MultiplayerRoomState)
    {
        super();
        this.instance = instance;
        //instance.persistentUpdate = false;
        //Multiplayer.resetServerPingTimer();
        FlxG.mouse.enabled = false;
    }

    var songs:Array<Alphabet> = [];
    var icons:Array<HealthIcon> = [];
    var songsData:Array<Dynamic> = [];

    var curSelected:Int = 0;

    var songList:SongList = new SongList();
    
    override public function create()
    {
        super.create();
        var bg = new FlxSprite().makeGraphic(1280,720, FlxColor.BLACK);
        bg.screenCenter();
        bg.alpha = 0.6;
        add(bg);

        var fullSongList = songList.getFullSongList();
        fullSongList.push(new SongMetadata("Chess", 0, "", ["VOIID"]));
        for (s in fullSongList)
        {
            songsData.push([s.songName, s.songCharacter, s.difficulties]);
            var scaleShit = (12 / s.songName.length);
            if (s.songName.length <= 12)
                scaleShit = 1;
            var text = new Alphabet(0, 0, s.songName, true, false, scaleShit);
            text.isMenuItem = true;
            text.targetY = songs.length;
            add(text);
            songs.push(text);

            var icon = new HealthIcon(s.songCharacter);
            icon.sprTracker = text;
            add(icon);
            icons.push(icon);
        }
        /*
        var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

        // Loops through all songs in freeplaySonglist.txt
		for (i in 0...initSonglist.length)
        {
            // Creates an array of their strings
            var listArray = initSonglist[i].split(":");

            // Variables I like yes mmmm tasty
            var week = Std.parseInt(listArray[2]);
            var icon = listArray[1];
            var song = listArray[0];
            
            var diffsStr = listArray[3];
            var diffs = ["easy", "normal", "hard"];

            var color = listArray[4];
            var actualColor:Null<FlxColor> = null;

            if(color != null)
                actualColor = FlxColor.fromString(color);

            if(diffsStr != null)
                diffs = diffsStr.split(",");

            songsData.push([song, icon, diffs]);
            var scaleShit = (12 / song.length);
            if (song.length <= 12)
                scaleShit = 1;
            var text = new Alphabet(0, 0, song, true, false, scaleShit);
            //text.setFormat(Paths.font("Contb___.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            //text.borderSize = 4;
            //text.screenCenter(X);
            text.isMenuItem = true;
            text.targetY = i;
            add(text);
            songs.push(text);

            var icon = new HealthIcon(icon);
            icon.sprTracker = text;
            add(icon);
            icons.push(icon);
        }*/

        

        #if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Online Room - Picking a Song", null, "empty", "logo");
		#end

        //scrollBar = new ScrollBar(1200, 50, 20, 620, this, "curScroll", (songs.length*60)-400);
        //add(scrollBar);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        /*curScroll -= FlxG.mouse.wheel*50*elapsed*480;
        if (controls.DOWN)
            curScroll += 800*elapsed;
        if (controls.UP)
            curScroll -= 800*elapsed;
        
        var listHeight:Float = (songs.length*60)-400;
        if (listHeight < 0)
            listHeight = 0;

        curScroll = FlxMath.bound(curScroll, 0, listHeight); //bound

        for (i in 0...songs.length)
        {
            songs[i].y = FlxMath.lerp(songs[i].y, (150 + (60*i))-curScroll, elapsed*10);
            if (FlxG.mouse.overlaps(songs[i]))
            {
                songs[i].color = 0xFF8C00FF;
                if (FlxG.mouse.justPressed)
                {
                    instance.changeSong(songsData[i][0], songsData[i][1], songsData[i][2]);
                    instance.persistentUpdate = true;
                    close();
                }
            }
            else 
                songs[i].color = 0xFFFFFFFF;
        }*/

        var shiftMult = (FlxG.keys.pressed.SHIFT ? 3 : 1);

        if (controls.UP_P || FlxG.mouse.wheel == 1)
            changeSelection(Std.int(-1*shiftMult));
        if (controls.DOWN_P || FlxG.mouse.wheel == -1)
            changeSelection(Std.int(1*shiftMult));

        if (controls.ACCEPT)
        {
            instance.changeSong(songsData[curSelected][0], songsData[curSelected][1], songsData[curSelected][2]);
            //instance.persistentUpdate = true;
            FlxG.mouse.enabled = true;
            close();
            //Multiplayer.resetServerPingTimer();
        }

    }

    function changeSelection(change:Int)
    {
        curSelected += change;
        if (curSelected < 0)
            curSelected = songs.length-1;
        if (curSelected > songs.length-1)
            curSelected = 0;

        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);


        if(icons.length > 0)
        {
            for (i in 0...icons.length)
            {
                icons[i].alpha = 0.6;

                if(icons[i].animation.curAnim != null && !icons[i].animatedIcon)
                    icons[i].animation.curAnim.curFrame = 0;
            }
    
            icons[curSelected].alpha = 1;

            if(icons[curSelected].animation.curAnim != null && !icons[curSelected].animatedIcon)
            {
                icons[curSelected].animation.curAnim.curFrame = 2;

                if(icons[curSelected].animation.curAnim.curFrame != 2)
                    icons[curSelected].animation.curAnim.curFrame = 0;
            }
        }

        var bullShit:Int = 0;
        for (item in songs)
        {
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = 0.6;

            if (item.targetY == 0)
            {
                item.alpha = 1;
            }
        }

    }
}

//simple gradient shader for text, works best with white text
class TextGradientShader extends FlxShader 
{
    @:glFragmentSource('
        #pragma header

        uniform vec3 col1;
        uniform vec3 col2;
        uniform vec3 border;

        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec4 spritecolor = flixel_texture2D(bitmap, openfl_TextureCoordv);

            if (border.r == 0.0 && border.g == 0.0 && border.b == 0.0)
            {
                spritecolor.rgb = spritecolor.rgb * mix(col2, col1, uv.y);
            }
            else 
            {
                if (spritecolor.r >= 0.1)
                {
                    spritecolor.rgb = mix(col2, col1, uv.y);
                }
                else if (spritecolor.g >= 0.1)
                {
                    spritecolor.rgb = border.rgb;
                }
            }


        
            gl_FragColor = spritecolor;
        }
    ')

    public function new()
    {
       super();
    }
}

class GradientText extends FlxText
{
    var gradient:TextGradientShader;
    public function setGradient(color1:FlxColor, color2:FlxColor, border:FlxColor)
    {
        if (gradient == null)
            gradient = new TextGradientShader();

        gradient.col1.value = [color1.redFloat, color1.greenFloat, color1.blueFloat];
        gradient.col2.value = [color2.redFloat, color2.greenFloat, color2.blueFloat];
        gradient.border.value = [border.redFloat, border.greenFloat, border.blueFloat];
        this.shader = gradient;
    }
    public function removeGradient()
    {
        this.shader = null;
    }
}


private class SettingsPopup extends FlxSpriteGroup
{
    final options:Array<String> = ["Modcharts", "Mechanics", "No Death"];
    var selections:Array<Alphabet> = [];
    var checkboxes:Array<Checkbox> = [];
    override public function new()
    {
        super();
        var bg = new CustomSliceSprite(Paths.image("boxSlice"), new flixel.math.FlxRect(18, 18, 4, 4), 400, 300);
        bg.color = 0xFF000000;
        bg.alpha = 0.75;
        add(bg);

        var currentSelections:Array<Bool> = [false,false,false];

        if (Multiplayer.player1Client != null)
        {
            currentSelections[0] = Multiplayer.player1Client.modcharts;
            currentSelections[1] = Multiplayer.player1Client.mechanics;
        }

        for (i in 0...options.length)
        {
            var a = new Alphabet(0, 0, options[i], true, false, 0.6);
            a.x = 10;
            a.y = 10 + (90*i);

            var checkbox = new Checkbox(a);
            checkbox.checked = currentSelections[i];

            add(a);
            add(checkbox);
            selections.push(a);
            checkboxes.push(checkbox);
        }
    }
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (visible)
        {
            if (Multiplayer.currentPlayer == 0 && Multiplayer.player1Client != null)
            {
                for (i in 0...selections.length)
                {
                    if (FlxG.mouse.justPressed)
                    {
                        if (FlxG.mouse.overlaps(selections[i]) || FlxG.mouse.overlaps(checkboxes[i]))
                        {
                            toggleSelection(i);
                        }
                    }
                }
            }
        }
    }

    function toggleSelection(s:Int)
    {
        switch(options[s])
        {
            case "Modcharts": 
                Multiplayer.player1Client.modcharts = !Multiplayer.player1Client.modcharts;
                checkboxes[s].checked = Multiplayer.player1Client.modcharts;
                ChatManager.sendMessage("SERVER", 0xFF49F0FF, "Modcharts set to: " + Multiplayer.player1Client.modcharts);
            case "Mechanics": 
                Multiplayer.player1Client.mechanics = !Multiplayer.player1Client.mechanics;
                checkboxes[s].checked = Multiplayer.player1Client.mechanics;
                ChatManager.sendMessage("SERVER", 0xFF49F0FF, "Mechanics set to: " + Multiplayer.player1Client.mechanics);
            case "No Death": 

        }
    }
}