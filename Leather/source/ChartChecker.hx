import game.Song.Event;
import states.VoiidMainMenuState;
import states.PlayState;
import game.Note;
using StringTools;

typedef ChartData = 
{
    var song:String;
    var diff:String; 

    var totalNoteCount:Int;
    var playerNoteCount:Int;
    var ?keyCount:Null<Int>;
    var ?playerKeyCount:Null<Int>;
    var ?deathNoteCount:Null<Int>;
    var ?warningNoteCount:Null<Int>;
    var ?dodgeCount:Null<Int>;
}
class ChartChecker
{
    private static final chartList:Array<ChartData> =
    [
        {song: "warm-up", diff: "voiid", totalNoteCount: 945, playerNoteCount: 457},
        
        {song: "light-it-up", diff: "voiid", totalNoteCount: 697, playerNoteCount: 342},
        {song: "ruckus", diff: "voiid", totalNoteCount: 2369, playerNoteCount: 1187},
        {song: "target-practice", diff: "voiid", totalNoteCount: 2403, playerNoteCount: 1270},

        {song: "burnout", diff: "voiid", totalNoteCount: 1545, playerNoteCount: 742},
        {song: "burnout", diff: "7k", totalNoteCount: 1308, playerNoteCount: 618, keyCount: 7, playerKeyCount: 7},
        {song: "sporting", diff: "voiid", totalNoteCount: 2326, playerNoteCount: 1164},
        {song: "boxing-match", diff: "voiid", totalNoteCount: 3421, playerNoteCount: 1680, warningNoteCount: 22},

        {song: "flaming-glove", diff: "voiid", totalNoteCount: 1806, playerNoteCount: 862},
        {song: "flaming-glove", diff: "7k", totalNoteCount: 1736, playerNoteCount: 840, keyCount: 7, playerKeyCount: 7},
        {song: "punch-and-gun", diff: "voiid", totalNoteCount: 1042, playerNoteCount: 536},
        {song: "punch-and-gun", diff: "7k", totalNoteCount: 1052, playerNoteCount: 539, keyCount: 7, playerKeyCount: 7},
        {song: "venom", diff: "voiid", totalNoteCount: 782, playerNoteCount: 418, warningNoteCount: 51 },
        {song: "venom", diff: "7k", totalNoteCount: 688, playerNoteCount: 344, warningNoteCount: 118, keyCount: 7, playerKeyCount: 7},

        {song: "fisticuffs", diff: "voiid", totalNoteCount: 1284, playerNoteCount: 639, warningNoteCount: 47},
        {song: "blastout", diff: "voiid", totalNoteCount: 2959, playerNoteCount: 1450, warningNoteCount: 34, dodgeCount: 14},
        {song: "immortal", diff: "voiid", totalNoteCount: 2026, playerNoteCount: 1075, warningNoteCount: 103, dodgeCount: 9},
        {song: "king-hit", diff: "voiid", totalNoteCount: 3609, playerNoteCount: 1838, warningNoteCount: 353, playerKeyCount: 5, dodgeCount: 27},
        {song: "king-hit-wawa", diff: "voiid", totalNoteCount: 3263, playerNoteCount: 1629, warningNoteCount: 222, dodgeCount: 43},
        {song: "tko", diff: "voiid", totalNoteCount: 1443, playerNoteCount: 776, warningNoteCount: 26, dodgeCount: 7},
        {song: "tko", diff: "7k", totalNoteCount: 1802, playerNoteCount: 964, warningNoteCount: 59, keyCount: 7, playerKeyCount: 7},

        {song: "mat", diff: "voiid", totalNoteCount: 1342, playerNoteCount: 699},
        {song: "mat", diff: "7k", totalNoteCount: 1290, playerNoteCount: 668, keyCount: 7, playerKeyCount: 7},
        {song: "banger", diff: "voiid", totalNoteCount: 1626, playerNoteCount: 876, warningNoteCount: 318},
        {song: "banger", diff: "7k", totalNoteCount: 1571, playerNoteCount: 853, warningNoteCount: 258, keyCount: 7, playerKeyCount: 7},
        {song: "edgy", diff: "voiid", totalNoteCount: 2432, playerNoteCount: 1632, warningNoteCount: 135},

        {song: "alter-ego", diff: "voiid", totalNoteCount: 1131, playerNoteCount: 542, warningNoteCount: 99},

        {song: "rejected", diff: "voiid", totalNoteCount: 4717, playerNoteCount: 2726, deathNoteCount: 724},

        {song: "average-voiid-song", diff: "voiid", totalNoteCount: 648, playerNoteCount: 324},
        {song: "voiid-rush", diff: "voiid", totalNoteCount: 1723, playerNoteCount: 847, warningNoteCount: 21},    

        {song: "fishycuffs", diff: "voiid", totalNoteCount: 2040, playerNoteCount: 1128 },

        {song: "tko-vip", diff: "voiid", totalNoteCount: 4800, playerNoteCount: 2423, warningNoteCount: 203},

        {song: "disadvantage", diff: "voiid", totalNoteCount: 2493, playerNoteCount: 1290, warningNoteCount: 118},
        {song: "champion", diff: "voiid", totalNoteCount: 3054, playerNoteCount: 1727, warningNoteCount: 202},
        {song: "last-combat", diff: "voiid", totalNoteCount: 2588, playerNoteCount: 1173},

        {song: "greedoom", diff: "voiid", totalNoteCount: 4686, playerNoteCount: 2819},
        {song: "purgatory", diff: "voiid", totalNoteCount: 10205, playerNoteCount: 5213, warningNoteCount: 3},
        {song: "krakatoa", diff: "voiid", totalNoteCount: 7476, playerNoteCount: 3981, warningNoteCount: 698},

        {song: "sweet-dreams", diff: "voiid", totalNoteCount: 5535, playerNoteCount: 2755, warningNoteCount: 33},
        {song: "sweet-dreams", diff: "7k", totalNoteCount: 4982, playerNoteCount: 2499, keyCount: 7, playerKeyCount: 7},
        {song: "sweet-dreams", diff: "10k", totalNoteCount: 5735, playerNoteCount: 2874, keyCount: 10, playerKeyCount: 10},
        {song: "recovery", diff: "voiid", totalNoteCount: 1878, playerNoteCount: 961, warningNoteCount: 6},

        {song: "showdown", diff: "voiid", totalNoteCount: 1596, playerNoteCount: 820},
        {song: "take-it", diff: "voiid", totalNoteCount: 2045, playerNoteCount: 1059},

        {song: "cleverness", diff: "voiid", totalNoteCount: 1877, playerNoteCount: 811},
        {song: "tempo-slayer", diff: "voiid", totalNoteCount: 3322, playerNoteCount: 1889},
        {song: "total-bravery", diff: "voiid", totalNoteCount: 3208, playerNoteCount: 1657},

        {song: "defamation-of-reality", diff: "mania", totalNoteCount: 1942, playerNoteCount: 852},
        {song: "defamation-of-reality", diff: "canon", totalNoteCount: 1879, playerNoteCount: 806, keyCount: 9, playerKeyCount: 9},
        {song: "radical-showdown", diff: "mania", totalNoteCount: 1875, playerNoteCount: 928},
        {song: "radical-showdown", diff: "canon", totalNoteCount: 2007, playerNoteCount: 983, keyCount: 7, playerKeyCount: 7},
        {song: "alter-ego-vip", diff: "voiid", totalNoteCount: 1374, playerNoteCount: 659, warningNoteCount: 136},

        {song: "power-link", diff: "canon", totalNoteCount: 1215, playerNoteCount: 501},

        {song: "revenge", diff: "mania", totalNoteCount: 2917, playerNoteCount: 1561, warningNoteCount: 142, playerKeyCount: 5},
        {song: "revenge", diff: "canon", totalNoteCount: 2146, playerNoteCount: 1074, warningNoteCount: 101, keyCount: 6, playerKeyCount: 7},

        {song: "final-destination", diff: "canon", totalNoteCount: 3268, playerNoteCount: 1545, keyCount: 9, playerKeyCount: 9},
        {song: "final-destination", diff: "mania", totalNoteCount: 4178, playerNoteCount: 1905},
        {song: "final-destination", diff: "god-mania", totalNoteCount: 9087, playerNoteCount: 4379, deathNoteCount: 4},
        {song: "final-destination", diff: "canon-god-voiid-death-limited", totalNoteCount: 10671, playerNoteCount: 5074, deathNoteCount: 1582, warningNoteCount: 1274, keyCount: 9, playerKeyCount: 9},
        {song: "final-destination", diff: "god", totalNoteCount: 10671, playerNoteCount: 5074, 
        deathNoteCount: 1582, warningNoteCount: 1274, keyCount: 9, playerKeyCount: 9 },

        {song: "final-destination-old", diff: "canon", totalNoteCount: 2355, playerNoteCount: 1217, keyCount: 9, playerKeyCount: 9},
        {song: "final-destination-old", diff: "mania", totalNoteCount: 2719, playerNoteCount: 1356},
        {song: "final-destination-old", diff: "god-mania", totalNoteCount: 0, playerNoteCount: 0 },
        {song: "final-destination-old", diff: "god", totalNoteCount: 3935, playerNoteCount: 2052, deathNoteCount: 1057, warningNoteCount: 760, keyCount: 9, playerKeyCount: 9},

        {song: "mattpurgation", diff: "voiid-unfair", totalNoteCount: 2265, playerNoteCount: 1076, deathNoteCount: 542, warningNoteCount: 45},

        {song: "1core-killer", diff: "voiid", totalNoteCount: 3485, playerNoteCount: 1546},
        {song: "exodus", diff: "voiid", totalNoteCount: 1693, playerNoteCount: 776},
        {song: "edgelord", diff: "voiid", totalNoteCount: 4395, playerNoteCount: 2612, warningNoteCount: 246, playerKeyCount: 5},
        {song: "ballin", diff: "voiid", totalNoteCount: 1177, playerNoteCount: 636},
        {song: "interregnum", diff: "voiid", totalNoteCount: 2293, playerNoteCount: 1198, warningNoteCount: 196},

        {song: "ignis-gladius", diff: "hard", totalNoteCount: 2739, playerNoteCount: 1377},
        {song: "ignis-gladius", diff: "broke", totalNoteCount: 3300, playerNoteCount: 1693},

        {song: "paired-entities", diff: "canon", totalNoteCount: 2780, playerNoteCount: 1388, keyCount: 8, playerKeyCount: 8},
        {song: "paired-entities", diff: "mania", totalNoteCount: 0, playerNoteCount: 0 },
        {song: "glowing-collision", diff: "canon", totalNoteCount: 2737, playerNoteCount: 1404, keyCount: 9, playerKeyCount: 9},
        {song: "glowing-collision", diff: "mania", totalNoteCount: 0, playerNoteCount: 0 },
        {song: "multiversal-slash", diff: "canon", totalNoteCount: 5218, playerNoteCount: 2563, keyCount: 12, playerKeyCount: 12},
        {song: "multiversal-slash", diff: "mania", totalNoteCount: 0, playerNoteCount: 0 },
        {song: "multiversal-slash", diff: "easy", totalNoteCount: 5843, playerNoteCount: 2975, keyCount: 9, playerKeyCount: 9},

        {song: "cosmic-memories", diff: "canon", totalNoteCount: 4504, playerNoteCount: 1898, keyCount: 7, playerKeyCount: 7},
        {song: "new-horizon", diff: "canon", totalNoteCount: 2068, playerNoteCount: 971, keyCount: 9, playerKeyCount: 9},
        {song: "galactic-storm", diff: "canon", totalNoteCount: 5691, playerNoteCount: 2456, deathNoteCount: 378, warningNoteCount: 218, keyCount: 12, playerKeyCount: 12},
        {song: "galactic-storm", diff: "easy", totalNoteCount: 6436, playerNoteCount: 2756, warningNoteCount: 205, keyCount: 9, playerKeyCount: 9},

        {song: "wastelands", diff: "voiid", totalNoteCount: 2091, playerNoteCount: 1018},
    ];

    private static function getChartFromList(song:String, diff:String)
    {
        for (c in chartList)
            if (c.song == song && c.diff == diff)
                return c;
        return null;
    }

    public static function exists(song:String)
    {
        song = song.replace(" ", "-");
        for (c in chartList)
            if (c.song == song)
                return true;
        return false;
    }

    public static final mustMissNotes = ["REJECTED_NOTES", 'death', 'hurt', 'REJECTED_VIP_NOTES'];
    public static final badNotes = ["REJECTED_NOTES", 'ParryNote', 'death', 'hurt', 'REJECTED_VIP_NOTES']; //these get removed with mechanics off, need to take off fireballs as well so its a separate list
    public static final mustHitNotes = ["BoxingMatchPunch", "Wiik3Punch", "Wiik4Sword", "caution", "VoiidBullet", "GreedNotes", "RejectedBullet", "RejectedPunch", "RejectedSword", "RevPunch", "RevSword"];

    public static function getTotalNotes(notes:Array<Note>, mustPress:Bool)
    {
        var c:Int = 0;
        for (n in notes)
        {
            if (!n.isSustainNote)
            {
                if (n.mustPress == mustPress)
                    c++;
                if (mustMissNotes.contains(n.arrow_Type))
                    c--;
            }

        }
        return c;
    }

    public static function checkEvents(song:String, diff:String, events:Array<Array<Dynamic>>)
    {
        song = song.replace(" ", "-");
        diff = diff.replace(" ", "-");
        var chartData = getChartFromList(song, diff);
        var dodgeCount = 0;

        for (event in events)
        {
            if (event[0] == "punch" || event[0] == "slash")
                dodgeCount++;
        }
        if (VoiidMainMenuState.devBuild)
            trace(dodgeCount);
        if (chartData != null)
        {
            if (chartData.dodgeCount != null)
                if (chartData.dodgeCount != dodgeCount)
                    return false;
            return true;
        }

        return false;
    }

    public static function checkChart(song:String, diff:String, notes:Array<Note>) : Bool
    {
        song = song.replace(" ", "-");
        diff = diff.replace(" ", "-");
        var chartData = getChartFromList(song, diff);
        var noteCount = notes.length;
        var playerNoteCount = 0;
        var deathNoteCount = 0;
        var punchCount = 0;
        for (n in notes)
        {
            if (n.mustPress)
                playerNoteCount++;
            if (mustMissNotes.contains(n.arrow_Type))
                deathNoteCount++;
            if (mustHitNotes.contains(n.arrow_Type))
                punchCount++;
        }
        //trace(noteCount);
        //trace(playerNoteCount);
        //trace(deathNoteCount);
        //trace(punchCount);

        var doPrint:Bool = VoiidMainMenuState.devBuild;
        if (doPrint) //to make my life easier
        {
            var printStr = '{';
            printStr += "song: ";
            printStr += '"'+PlayState.SONG.song.toLowerCase().replace(" ", "-") + '"';
            printStr += ", ";

            printStr += "diff: ";
            printStr += '"'+PlayState.storyDifficultyStr.toLowerCase().replace(" ", "-") + '"';
            printStr += ", ";

            printStr += "totalNoteCount: ";
            printStr += noteCount;
            printStr += ", ";

            printStr += "playerNoteCount: ";
            printStr += playerNoteCount;

            if (deathNoteCount > 0)
            {
                printStr += ", deathNoteCount: ";
                printStr += deathNoteCount;
            }
            if (punchCount > 0)
            {
                printStr += ", warningNoteCount: ";
                printStr += punchCount;
            }
            if (PlayState.SONG.keyCount != 4)
            {
                printStr += ", keyCount: ";
                printStr += PlayState.SONG.keyCount;
            }
            if (PlayState.SONG.playerKeyCount != 4)
            {
                printStr += ", playerKeyCount: ";
                printStr += PlayState.SONG.playerKeyCount;
            }
            //printStr += ", ";

            printStr += '},';

            trace(printStr); //just copy paste into the list
        }

        if (chartData != null)
        {
            if (chartData.keyCount != null)
                if (chartData.keyCount != PlayState.SONG.keyCount)
                    return false;
            if (chartData.playerKeyCount != null)
                if (chartData.playerKeyCount != PlayState.SONG.playerKeyCount)
                    return false;
            if (chartData.deathNoteCount != null)
            {
                if (chartData.deathNoteCount != deathNoteCount)
                    return false;
            }
            else if (deathNoteCount > 0)
                return false;

            if (chartData.warningNoteCount != null)
            {
                if (chartData.warningNoteCount != punchCount)
                    return false;
            }
            else if (punchCount > 0)
                return false; //just in case punches are added after, it would still get accepted


            if (chartData.totalNoteCount == noteCount && chartData.playerNoteCount == playerNoteCount)
                return true; //chart is good
            else 
                return false; //evil chart
        }

        return false;
    }
}