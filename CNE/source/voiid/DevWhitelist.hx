package voiid;

import openfl.display.Sprite;
import funkin.backend.assets.Paths;
import sys.FileSystem;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import openfl.text.TextFormat;
import flixel.FlxG;
import openfl.text.TextField;
import flixel.addons.api.FlxGameJolt;
import openfl.events.Event;

class DevWhitelist
{
    #if UPLOAD_WHITELIST
    public static final whitelist = [
        "TheZoroForce240",
        "RhysRJJ",
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
        "chronikmelody",
		"Corva",
		"Franklolx",
		"TroZe"
    ];
    #end

    #if UPLOAD_BLACKLIST
    public static final bannedPlayers = [
        "StreamHaper",
        "deltadayy",
        "lordvoiid",
    ];
    #end
	
	#if UPLOAD_WHITELIST
	public static function updateWhitelist() {
		
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
	}
	#end

	#if UPLOAD_BLACKLIST
	public static function updateBlacklist() {
		
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
	}
	#end

	#if devbuild
    public static function checkname()
    {
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

        if (GameJolt.connected)
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
                            var shit = new WaterMarks();
                            openfl.Lib.current.addChild(shit);
                            trace('all good');
                            return;
                        }
                    }
                }

                Sys.exit(0);
            }, "whitelist");
        }
        else
        {
			Sys.exit(0);
        }
    }
	#end
}

class WaterMarks extends Sprite {
	public function new() {
		super();


		var xpos:Float = 0;
		var ypos:Float = 0;
		while(true) {
			if (ypos >= FlxG.width) {
				break;
			}
			var t = new DevWatermark(xpos, ypos);
			xpos += t.textWidth + 20;
			if (xpos > FlxG.width) {
				xpos = 0;
				ypos += t.textHeight + 20;
			}
			addChild(t);
		}




		addEventListener(Event.ENTER_FRAME, onEnter);
	}

	function onEnter(event:Event) {
		this.scaleX = 1/(1280/openfl.Lib.application.window.width);
		this.scaleY = 1/(720/openfl.Lib.application.window.height);
	}
}

class DevWatermark extends TextField
{
    public function new(x:Float, y:Float) 
    {
        super();

        text = FlxGameJolt.getUserName();
        defaultTextFormat = new TextFormat(openfl.utils.Assets.getFont(Paths.font("Contb___.ttf")).fontName,
        64, 0xFFFFFF, null, null, null, null, null, LEFT);
        alpha = 0.15;
		this.width = textWidth;
        
		this.x = x;
		this.y = y;
    }
}