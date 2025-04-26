package online;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import online.ChatManager.CustomSliceSprite;
import flixel.group.FlxSpriteGroup;
import Popup.GlovePopup;
import states.PlayState;
import utilities.Options;
import EncryptedValue;
import EncryptedValue.EncryptedInt;
import haxe.io.Bytes;
import haxe.crypto.RC4;
using StringTools;

class Gloves
{
    private static var whiteGloves:EncryptedInt = new EncryptedInt(0);
    private static var purpleGloves:EncryptedInt = new EncryptedInt(0);

    public static function loadGloves()
    {
        if (Options.getData("whiteGK", "progress") != null)
        {
            @:privateAccess
            {
                whiteGloves.key = Bytes.ofHex(Options.getData("whiteGK", "progress"));
                whiteGloves.bytes = Bytes.ofHex(Options.getData("whiteGB", "progress"));
                //trace(Options.getData("wGK", "progress"));
                //trace(Options.getData("wGB", "progress"));
            }
        }
            
        if (Options.getData("purpGK", "progress") != null)
        {
            @:privateAccess
            {
                purpleGloves.key = Bytes.ofHex(Options.getData("purpGK", "progress"));
                purpleGloves.bytes = Bytes.ofHex(Options.getData("purpGB", "progress"));
            }
        }
    }
    public static function saveGloves()
    {
        @:privateAccess
        {
            Options.setData(whiteGloves.key.toHex(), "whiteGK", "progress");
            Options.setData(purpleGloves.key.toHex(), "purpGK", "progress");
            Options.setData(whiteGloves.bytes.toHex(), "whiteGB", "progress");
            Options.setData(purpleGloves.bytes.toHex(), "purpGB", "progress");
        }

    }

    public static function getWhiteGloveCount() {return whiteGloves.value;}
    public static function getPurpleGloveCount() {return purpleGloves.value;}

    
    @:allow(states.PlayState)
    private static function calculateGloveGain(misses:Int, accuracy:Float, song:String, diff:String, speed:Float, didWin:Bool)
    {
        song = song.replace(" ", "-");
        diff = diff.replace(" ", "-");
        if (ChartChecker.exists(song))
        {
            @:privateAccess
            var chart = ChartChecker.getChartFromList(song, diff);
            var noteCount:Int = PlayState.characterPlayingAs == 0 ? chart.playerNoteCount : (chart.totalNoteCount - chart.playerNoteCount);
            var keyCount:Int = PlayState.characterPlayingAs == 0 ? PlayState.SONG.playerKeyCount : PlayState.SONG.keyCount;
            var keyCountMult:Float = keyCount / 4.0;

            if (chart.deathNoteCount != null) //mechanic bonuses
                noteCount += chart.deathNoteCount;
            if (chart.warningNoteCount != null)
                noteCount += chart.warningNoteCount;
            if (chart.dodgeCount != null)
                noteCount += chart.dodgeCount*5;

            
            //white gloves           
            var w:Float = noteCount - (misses*(40/keyCountMult)); //gloves earned = noteCount, but take away around 40 for every miss,
                                                                                   //expect more misses on higher keycounts so reduce it
            if (w < noteCount*0.4)
                w = noteCount*0.4; //min per song

            w *= speed; //mult by song speed and accuracy
            w *= accuracy*0.01;

            w *= 0.1; //multiply overall by 0.1

            whiteGloves.value = whiteGloves.value + Math.floor(w);

            Main.glovePopupManager.addPopup(new GlovePopup(3, 300, 64, "white", Math.floor(w)));

            if (PlayState.instance.multiplayerSessionEndcheck) //in multiplayer
            {
                //purple gloves
                var p = w * (didWin ? 1.5 : 0.5); // +/- 50% based on win
                purpleGloves.value = purpleGloves.value + Math.floor(p);
                Main.glovePopupManager.addPopup(new GlovePopup(3, 300, 64, "lean", Math.floor(p)));
            }

            saveGloves();
        }
    }
}


class GloveDisplay extends FlxSpriteGroup
{
    var bg:CustomSliceSprite;
    public var text:FlxText;
    override public function new(gloveColor:String, gloveCount:Int, textSize:Int = 16)
    {
        super();

        text = new FlxText(0,0, 0, gloveCount+"");
        text.setFormat(Paths.font("vcr.ttf"), textSize, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);  
        text.borderSize = 2.5;
        
        var glove = new FlxSprite(0,0).loadGraphic(Paths.image("online/room/glove_"+gloveColor));
        glove.scale.set(0.75, 0.75);
        glove.updateHitbox();
        glove.antialiasing = true;
        text.x = glove.x + glove.width - 10;
        text.y = glove.y + (glove.height*0.5) - (text.height*0.5);
        

        bg = new CustomSliceSprite(Paths.image("boxSlice"), new flixel.math.FlxRect(18, 18, 4, 4), Std.int(glove.width + text.width - 30), Std.int(text.height+10));
        add(bg);
        bg.antialiasing = true;
        //bg.alpha = 0.2;
        bg.color = 0x42777777;
        bg.alpha = 0.4;

        bg.x = glove.x + glove.width*0.5;
        bg.y = glove.y + (glove.height*0.5) - ((text.height+10)*0.5);

        add(glove);
        add(text);
    
        //bg.setGraphicSize(Std.int(bg.width), Std.int(text.height+10));
        //bg.updateHitbox();
    }
}