package online;

import sys.FileSystem;
import flixel.util.FlxTimer;
import states.PlayState;
import game.Song;
import flixel.util.FlxSave;
import openfl.text.TextFormat;
import flixel.FlxG;
import openfl.text.TextField;
import states.VoiidMainMenuState;
import flixel.addons.api.FlxGameJolt;
import openfl.events.Event;

class DevWhitelist
{
    #if UPLOAD_WHITELIST
    public static final whitelist = [
        "TheZoroForce240",
        "RhysRJJ",
        "lordvoiid",
        "Wolfinu",
        "Spike_1012",
        "Delta_Fr",
        "BlueParasolKirby",
        "Revilo_",
        "ChronikMelody",
        "hippo0824",
        "AngryRacc",
        "irrxyk",
        "IvanoDrako",
        "joa_mesi",
        "invalid_bruh",
        "Noicy",
        "PaperDS",
        "ModeusThemArtist",
        "MLOM",
        "mlomofficial",
        "TroZeStickIsNub",
        "ShadowClaw7",
        "wawa_sans",
        "wawa_sans2",
        "Xyriax",
        "oddestial",
        "NobodyKnowsLikesGirls",
        "IsisTheGoddess",
        "ImSilva",
        "chronikmelody"
    ];
    #end

    #if UPLOAD_BLACKLIST
    public static final bannedPlayers = [
        "StreamHaper",
    ];
    #end

    static var checkedBlacklist:Bool = false;

    public static var shit:DevWatermark = null;

    public static function checkname()
    {
        if (!checkedBlacklist)
        {
            if (GameJolt.connected)
            {
                FlxGameJolt.fetchData("!bannedPlayers", false, function(mapThing:Map<String,String>)
                {
                    if (mapThing != null)
                    {
                        if (mapThing.get('success') == 'true' && mapThing.exists('data'))
                        {
                            var dataString = mapThing.get('data');
                            var blacklist = dataString.split(",");
                            //trace(blacklist);
    
                            if (blacklist.contains(FlxGameJolt.getUserName()))
                            {
                                //you will die

                                //need to remember to hide this code whenever the source is released
                                var save = new FlxSave();
                                save.bind("funkin", "ninjamuffin99");
                                save.data.asdf = true;
                                save.flush();
                                save.destroy();
                            }
                            else 
                            {
                                checkedBlacklist = true;
                            }
                        }
                    }
                }, "banCheck");
            }
        }

        if (!VoiidMainMenuState.devBuild)
        {
            return;
        }
            

        #if mobile 
        return;
        #end


        #if UPLOAD_WHITELIST
        if (GameJolt.connected)
        {
            var dataStr:String = "";
            for (i in 0...whitelist.length)
            {
                dataStr += whitelist[i];
                if (i < whitelist.length-1)
                    dataStr += ",";
            }
            trace(dataStr);
            FlxGameJolt.setData("!devWhitelist", dataStr, false, function(mapThing:Map<String,String>)
            {
                
            }, "whitelist");
        }
        #end
        #if UPLOAD_BLACKLIST
        if (GameJolt.connected)
        {
            var dataStr:String = "";
            for (i in 0...bannedPlayers.length)
            {
                dataStr += bannedPlayers[i];
                if (i < bannedPlayers.length-1)
                    dataStr += ",";
            }
            trace(dataStr);
            FlxGameJolt.setData("!bannedPlayers", dataStr, false, function(mapThing:Map<String,String>)
            {
                
            }, "blacklist");
        }
        #end

        if (shit != null)
            return; //already verified                  

        if (shit == null && GameJolt.connected)
        {

            FlxGameJolt.fetchData("!devWhitelist", false, function(mapThing:Map<String,String>)
            {
                if (mapThing != null)
                {
                    if (mapThing.get('success') == 'true' && mapThing.exists('data'))
                    {
                        var dataString = mapThing.get('data');
                        var whitelist = dataString.split(",");
                        //trace(whitelist);

                        //all good
                        if (whitelist.contains(FlxGameJolt.getUserName()))
                        {
                            shit = new DevWatermark();
                            openfl.Lib.current.addChild(shit);
                            trace('all good');
                            return;
                        }
                    }
                }

                while(true)
                {
                    //die
                }
            }, "whitelist");


        }
        else 
        {
            while(true)
            {
                //die
            }
        }
    }
}

class DevWatermark extends TextField
{
    public function new() 
    {
        super();

        text = FlxGameJolt.getUserName();
        defaultTextFormat = new TextFormat(openfl.utils.Assets.getFont(Paths.font("Contb___.ttf")).fontName,
        64, 0xFFFFFF, null, null, null, null, null, CENTER);
        alpha = 0.15;
        width = FlxG.width;
		height = FlxG.height;

        addEventListener(Event.ENTER_FRAME, onEnter);
    }
    private function onEnter(event:Event)
    {
        width = openfl.Lib.application.window.width;
		height = openfl.Lib.application.window.height;
        x = 0;
        y = openfl.Lib.application.window.height*0.5;
    }
}