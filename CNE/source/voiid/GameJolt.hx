package voiid;

import funkin.backend.assets.Paths;
import lime.utils.Assets;
import flixel.addons.api.FlxGameJolt;
import flixel.util.FlxTimer;
import flixel.FlxG;
import haxe.io.Bytes;
import voiid.Leaderboards;

using StringTools;

class GameJolt
{
    public static final gameID:Int = 810060;

    public static var fetchingData:Bool = false;

    public static var connectedToGame:Bool = false;
    public static var loggedIn:Bool = false;

    public static var connected(get, null):Bool;
    static function get_connected():Bool {
		return connectedToGame && loggedIn;
	}

    public static function initStuffs():String
    {
		if (connectedToGame) return "";

		#if ENCRYPTED_FILES
		var privateKey:String = FileEncrypt.decryptString(Paths.getPath('gj'));
		#else
		var privateKey:String = Assets.getText(Paths.getPath('gj'));
		#end

        /*
		var gotResponse:Bool = false;
        new FlxTimer().start(15, function(timer:FlxTimer)
        {
            if (connected)
                return;

            if (!gotResponse) {
				trace("couldnt connect (timed out)");
            }
        });
		*/

		@:privateAccess {
			FlxGameJolt._gameID = gameID;
			FlxGameJolt._privateKey.value = privateKey;
		}


		if (FlxG.save.data.gameJoltUserName == null)
            return 'no login found';
        if (FlxG.save.data.gameJoltUserToken == null)
            return 'no login found';

		FlxGameJolt.authUser(FlxG.save.data.gameJoltUserName, FlxG.save.data.gameJoltUserToken, function(success:Bool) {
			connectedToGame = true;
			loggedIn = success;
			if (success) {
				trace("logged in");
				setupSession();
			}
		}, "login");

		FlxG.signals.postStateSwitch.add(resetPingTimer);
        
        return 'trying to login'; //should be logged in????  
    }

	public static function login(callback:Bool->Void) {
		@:privateAccess
		FlxGameJolt._initialized = false;
		FlxGameJolt.resetUser(FlxG.save.data.gameJoltUserName, FlxG.save.data.gameJoltUserToken, function(success:Bool) {
			connectedToGame = true;
			loggedIn = success;

			if (success) {
				setupSession();
			}
			callback(success);
		});
	}

	public static function logout() {
		pingTimer = null;
		loggedIn = false;
		@:privateAccess
		FlxGameJolt._initialized = false;
		FlxGameJolt.closeSession(function(n) {}, "logout");
	}

    private static var pingTimer:FlxTimer = null;

    public static function setupSession() //call after login
    {
        FlxGameJolt.openSession(function(mapThing:Map<String,String>)
        {
            resetPingTimer();
        });
    }
    public static function resetPingTimer()
    {
		if (!connected) return;

        ping();
        pingTimer = new FlxTimer().start(30, function(tmr:FlxTimer) //ping every 30 secs
        {
            var doPing = true;
            if (doPing) ping(); 
        }, 0); //0 means loop forever
    }
    public static function ping()
    {
        FlxGameJolt.pingSession(true, function(mapThing:Map<String,String>){
            if (mapThing.get('success') != null && mapThing.get('success') == 'false') //if theres an error message then reset session, probably if you were afk or something
            {                                    //not getting any traces that say it resets but it seems to work on the next ping???
                setupSession();
            }
        }); 
    }

    public static function syncAchievements()
    {
        //rewrite this later
        
    }
    

    public static function unlockAchievement(id:Int)
    {
        if (connected)
        {
            FlxGameJolt.addTrophy(id);
        }
    }

    public static function checkAchievement(id:Int, ?func:Map<String,String>->Void)
    {
        if (connected)
        {
            FlxGameJolt.fetchTrophy(id, function(mapThing:Map<String,String>)
            {
                //idk how to do this lol
                //trace(mapThing);
                if (func != null)
                    func(mapThing);
                
            });
        }
    }
}