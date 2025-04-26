package online;

import utilities.Options;
import states.PlayState;

typedef SkinType = 
{
    var hasPowerup:Bool;
    var hasBoxing:Bool;
    var ?name:String;
    var ?charName:String;
}

class SkinManager
{
    public static var boxingSongs:Array<String> = [ //defaults to "any"
        //song           //type needed for song
        "Fisticuffs",
        "Blastout",
        "Immortal",
        "King Hit",
        "TKO",
        "TKO VIP",
    ];

    public static var regularSkins:Array<SkinType> = [
        { name: "Taro",hasBoxing: false, hasPowerup: false, charName: "Taro"},
        { name: "Matt (Wiik 1)", hasBoxing: false, hasPowerup: false, charName: "Wiik1VoiidMatt"}, 
        { name: "Matt (Wiik 2)", hasBoxing: false, hasPowerup: true, charName: "Wiik2VoiidMatt"}, 
        { name: "Matt (Wiik 3)", hasBoxing: true, hasPowerup: false, charName: "Wiik3VoiidMatt"}, 
        { name: "Matt (Wiik 100)", hasBoxing: false, hasPowerup: false, charName: "Wiik100Matt"}, 
        { name: "Rejected", hasBoxing: false, hasPowerup: false, charName: "RejectedMatt"}, 
        
        { name: "Shaggy", hasBoxing: false, hasPowerup: false, charName: "VoiidShaggy"},

        { name: "Rev Matt", hasBoxing: false, hasPowerup: false, charName: "RevMatt"},
        { name: "Rev BF", hasBoxing: false, hasPowerup: false, charName: "RevBF"},

        { name: "MLOM Matt", hasBoxing: false, hasPowerup: false, charName: "MLOMmatt"},
        { name: "Ancium Matt", hasBoxing: false, hasPowerup: false, charName: "MagMatt"},

        { name: "mat", hasBoxing: false, hasPowerup: true, charName: "mat"},

        { name: "Fatt", hasBoxing: false, hasPowerup: false, charName: "Fatt"},
        { name: "Gerald", hasBoxing: false, hasPowerup: false, charName: "Gerald"},
    ];

    public static var boxingSkins:Array<SkinType> = [
        { name: "Taro Boxing (Wiik 3)",hasBoxing: true, hasPowerup: false, charName: "TaroWiik3"},
        { name: "Matt Boxing (Wiik 3)", hasBoxing: true, hasPowerup: false, charName: "Wiik3VoiidMatt"},
        { name: "Taro Boxing (Onii)",hasBoxing: true, hasPowerup: false, charName: "Wiik3BFOnii"},
    ];

    public static var devSkins:Array<SkinType> = [
        { name: "Cons",hasBoxing: false, hasPowerup: false, charName: "CATMII"},
        { name: "NK",hasBoxing: false, hasPowerup: false, charName: "nk"},
        { name: "Hippo",hasBoxing: false, hasPowerup: false, charName: "hippo"},
        { name: "The Drinker",hasBoxing: false, hasPowerup: false, charName: "guydrinking"},
    ];

    public static var p1RegularSkin:String = "";
    public static var p1SecondarySkin:String = "";
    public static var p1BoxingSkin:String = "";

    public static var p2RegularSkin:String = "";
    public static var p2SecondarySkin:String = "";
    public static var p2BoxingSkin:String = "";

    public static function getSkin(player:Bool, boxing:Bool, secondary:Bool)
    {
        if (boxing)
            return player ? p1BoxingSkin : p2BoxingSkin;
        return player ? (secondary ? p1SecondarySkin : p1RegularSkin) : (secondary ? p2SecondarySkin : p2RegularSkin);
    }
    public static function getSkinForSong(player:Bool, secondary:Bool, defaultSkin:String)
    {
        var skin = getSkin(player, boxingSongs.contains(PlayState.SONG.song), secondary);
        if (skin == "" || PlayState.isStoryMode) //no skin selected or story mode
            skin = defaultSkin;
        return skin;
    }
    public static function usingCustomSkin(player:Bool, secondary:Bool)
    {
        var skin = getSkin(player, boxingSongs.contains(PlayState.SONG.song), secondary);
        if (skin == "" || PlayState.isStoryMode)
            return false; //not using a custom skin
        return true;
    }


    public static function reloadSkinSettings() 
    {
        p1RegularSkin = getData("p1Skin");
        p1BoxingSkin = getData("p1BoxingSkin");
        p2RegularSkin = getData("p2Skin");
        p2BoxingSkin = getData("p2BoxingSkin");

        p1SecondarySkin = getData("p1SecondarySkin");
        p2SecondarySkin = getData("p2SecondarySkin");
    }
    private static function getData(skin:String)
    {
        if (Options.getData(skin) != null)
            return Options.getData(skin);
        return "";
    }

    public static function saveSkin(skin:String, player:Bool, boxing:Bool, secondary:Bool)
    {
        var skinStr = player ? "p1Skin" : "p2Skin";
        if (boxing)
            skinStr = player ? "p1BoxingSkin" : "p2BoxingSkin";
        if (secondary)
            skinStr = player ? "p1SecondarySkin" : "p2SecondarySkin";

        Options.setData(skin, skinStr);
    }
}