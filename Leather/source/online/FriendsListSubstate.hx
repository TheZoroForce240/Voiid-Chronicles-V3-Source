package online;

import openfl.utils.ByteArray;
import openfl.net.URLStream;
import openfl.events.Event;
import openfl.display.Loader;
import openfl.net.URLRequest;
import flixel.addons.api.FlxGameJolt;
import flixel.graphics.FlxGraphic;
import flash.display.BitmapData;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import states.VoiidAwardsState.ScrollBar;
import flixel.text.FlxText;
import substates.MusicBeatSubstate;

class FriendsListSubstate extends MusicBeatSubstate
{

    var friends:Array<Friend> = [];
    var avatarsToLoad:Array<Friend> = [];
    override public function create()
    {
        super.create();

        var bg = new FlxSprite().makeGraphic(1280,720, 0xFF000000);
        bg.screenCenter();
        bg.alpha = 0.5;
        add(bg);

        var title = new FlxText(FlxG.width * 0.7, 20, 0, "Friends List", 20);
		title.setFormat(Paths.font("Contb___.ttf"), 48, FlxColor.WHITE, CENTER);
        title.screenCenter(X);
        add(title);

        var i = 0;
        for (friendID => friendData in GameJolt.friendsData)
        {
            var f = new Friend(friendData, 400, 80);
            f.screenCenter(X);
            f.y = 100 + (i*100);
            add(f);
            i++;
            friends.push(f);
            avatarsToLoad.push(f);

            /*FlxGameJolt.checkUserSession(friendData.get("username"), function(map:Map<String,String>) //doesnt seem to be supported in api rn
            {
                trace(friendID);
                trace(map);
            }, "sessionCheck");*/
        }        
        loadNextAvatar();
    }

    var currentStream:URLStream;

    function loadNextAvatar()
    {
        if (avatarsToLoad.length > 0)
        {
            //trace("loading avatar " + avatarsToLoad[0].userID);
            //trace(avatarsToLoad[0].data.get("avatar_url"));
            var request:URLRequest = new URLRequest(avatarsToLoad[0].data.get("avatar_url"));
			var stream:URLStream = new URLStream();
            currentStream = stream;
			stream.addEventListener(Event.COMPLETE, function(e:Event)
            {
                var bytes:ByteArray = new ByteArray();
                stream.readBytes(bytes, 0, stream.bytesAvailable);
                var bitmapData = BitmapData.fromBytes(bytes);
                
                if (bitmapData != null)
                {
                    //trace('loading image');
                    avatarsToLoad[0].loadAvatar(bitmapData);
                }
                stream.close();
                stream = null;
                request = null;
                avatarsToLoad.remove(avatarsToLoad[0]);
                loadNextAvatar(); //do again
            });
			stream.load(request);
            /*FlxGameJolt.fetchUserAvatarImage(avatarsToLoad[0].userID, function(bitmapData:BitmapData)
            {

            });*/
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.BACK)
        {
            if (currentStream != null)
                currentStream.close();
            close();
        }
    }
}

class Friend extends FlxSpriteGroup
{
    var border:Array<FlxSprite> = [];
    public var avatar:FlxSprite;
    public var userID:Int;
    public var data:Map<String,String>;
    override public function new(friendData:Map<String,String>, w:Int, h:Int)
    {
        super();
        data = friendData;
        userID = Std.parseInt(friendData.get("id"));
        var box:FlxSprite = new FlxSprite().makeGraphic(w,h, 0xFF000000);
        add(box);

        var borderLeft:FlxSprite = new FlxSprite(5,5).makeGraphic(1,h-10);
        var borderRight:FlxSprite = new FlxSprite(w-5,5).makeGraphic(1,h-10);
        var borderUp:FlxSprite = new FlxSprite(5,5).makeGraphic(w-10,1);
        var borderDown:FlxSprite = new FlxSprite(5,h-5).makeGraphic(w-9,1);
        border.push(borderLeft);
        border.push(borderRight);
        border.push(borderUp);
        border.push(borderDown);


        var userName:FlxText = new FlxText(5,5, 390, friendData.get("username"));
        userName.setFormat(Paths.font("Contb___.ttf"), 24, FlxColor.WHITE, LEFT);
        add(userName);

        var status:FlxText = new FlxText(5,5+userName.height+5, 390, "Last logged in: "+friendData.get("last_logged_in"));
        status.setFormat(Paths.font("Contb___.ttf"), 16, FlxColor.WHITE, LEFT);
        add(status);


        add(borderLeft); add(borderRight); add(borderUp); add(borderDown);

        avatar = new FlxSprite(w-70,h-70);
        avatar.makeGraphic(60,60, 0xFFFFFFFF);
        avatar.antialiasing = true;
        add(avatar);

    }
    public function loadAvatar(bitmapData:BitmapData)
    {
        avatar.loadGraphic(FlxGraphic.fromBitmapData(bitmapData));
        avatar.setGraphicSize(60,60);
        avatar.updateHitbox();
    }
}