package online;

import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
//import flixel.addons.display.FlxSliceSprite;
import flixel.FlxG;
import flixel.addons.ui.FlxInputText;
import lime.utils.Assets;
import flixel.addons.api.FlxGameJolt;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

using StringTools;

typedef MessageData = 
{
    var user:String;
    var color:FlxColor;
    var text:String;
}

class ChatManager
{
    @:allow(online.ChatBox)
    private static var storedMessages:Array<MessageData> = []; //store messages


    public static function sendMessage(user:String, userColor:FlxColor, messageText:String)
    {
        messageText = messageText.trim().replace(" ", "-");
        if (messageText == "")
            return;

        var dataToSend:String = user + "<d>" + userColor.toHexString() + "<d>" + messageText;

        FlxGameJolt.fetchData(Multiplayer.serverPrefix + "chat" + Multiplayer.serverID, false, function(map:Map<String,String>)
        {
            if (map != null)
            {
                if (map.get('success') == 'true' && map.exists('data'))
                {
                    //already exists so update it
                    FlxGameJolt.updateData(Multiplayer.serverPrefix + "chat" + Multiplayer.serverID, "append", "<m>"+dataToSend, false, function(map2:Map<String,String>)
                    {
                        checkForMessages();
                    }, "messageSend");
                }
                else 
                {
                    //make new data storage
                    FlxGameJolt.setData(Multiplayer.serverPrefix + "chat" + Multiplayer.serverID, dataToSend, false, function(map2:Map<String,String>)
                    {
                        checkForMessages();
                    }, "messageSend");
                }

            }
        }, "messagesCheck");
    }

    public static function checkForMessages()
    {
        FlxGameJolt.fetchData(Multiplayer.serverPrefix + "chat" + Multiplayer.serverID, false, function(map:Map<String,String>)
        {
            if (map != null)
            {
                if (map.get('success') == 'true' && map.exists('data'))
                {
                    var dataStr:String = map.get("data");
                    parseMessageData(dataStr); //load in messages
                }
            }
        }, "messages");
    }

    public static function parseMessageData(dataStr:String)
    {
        storedMessages = []; //reset 
        var splitMessages = dataStr.split("<m>");
        for (m in splitMessages)
        {
            //create messages
            var mData = m.split("<d>");
            var message:MessageData = {user: mData[0], color: FlxColor.fromString(mData[1]), text: mData[2]};
            //trace(mData);
            //trace(message);
            storedMessages.push(message); 
        }
    }
}
//regular slice sprite is terrible for performance so yea
//kinda shitty but it works
class CustomSliceSprite extends FlxSpriteGroup
{
    var topLeft:FlxSprite;
    var topBar:FlxSprite;
    var topRight:FlxSprite;
    var rightBar:FlxSprite;
    var bottomRight:FlxSprite;
    var bottonBar:FlxSprite;
    var bottomLeft:FlxSprite;
    var leftBar:FlxSprite;
    var center:FlxSprite;


    var sliceRect:FlxRect;

    var baseSprite:FlxSprite;

    override public function new(Graphic:FlxGraphicAsset, SliceRect:FlxRect, Width:Int, Height:Int)
    {
        super();
        sliceRect = SliceRect;

        baseSprite = new FlxSprite().loadGraphic(Graphic);
        baseSprite.antialiasing = true;
        //loadGraphic(Graphic);

		setup(Width, Height);
        antialiasing = true;
    }


    function setup(width:Int, height:Int)
    {
        topLeft = new FlxSprite().loadGraphicFromSprite(baseSprite);
        topBar = new FlxSprite().makeGraphic(Std.int((width-baseSprite.width)+sliceRect.width), Std.int(sliceRect.y));
        topRight = new FlxSprite().loadGraphicFromSprite(baseSprite);
        rightBar = new FlxSprite().makeGraphic(Std.int(sliceRect.x), Std.int((height-baseSprite.height)+sliceRect.height));
        bottomRight = new FlxSprite().loadGraphicFromSprite(baseSprite);
        bottonBar = new FlxSprite().makeGraphic(Std.int((width-baseSprite.width)+sliceRect.width), Std.int(sliceRect.y));
        bottomLeft = new FlxSprite().loadGraphicFromSprite(baseSprite);
        leftBar = new FlxSprite().makeGraphic(Std.int(sliceRect.x), Std.int((height-baseSprite.height)+sliceRect.height));
        center = new FlxSprite().makeGraphic(Std.int((width-baseSprite.width)+sliceRect.width), Std.int((height-baseSprite.height)+sliceRect.height));

        topLeft.clipRect = new FlxRect(0, 0, sliceRect.x, sliceRect.y);
        topRight.clipRect = new FlxRect(sliceRect.width+sliceRect.x, 0, baseSprite.width, sliceRect.y);
        bottomLeft.clipRect = new FlxRect(0, sliceRect.height+sliceRect.y, sliceRect.x, baseSprite.height);
        bottomRight.clipRect = new FlxRect(sliceRect.width+sliceRect.x, sliceRect.height+sliceRect.y, baseSprite.width, baseSprite.height);

        topRight.x = width-topRight.width;
        bottomLeft.y = height-bottomLeft.height;
        bottomRight.x = width-bottomRight.width;
        bottomRight.y = height-bottomRight.height;

        add(topLeft);
        add(topRight);
        add(bottomLeft);
        add(bottomRight);

        topBar.x = sliceRect.x;
        //topBar.clipRect = new FlxRect(sliceRect.x/topBar.scale.x, 0, sliceRect.width/topBar.scale.x, sliceRect.y);
        add(topBar);

        bottonBar.x = sliceRect.x;
        bottonBar.y = height-bottonBar.height;
        add(bottonBar);

        leftBar.y = sliceRect.y;
        add(leftBar);

        rightBar.x = width-rightBar.width;
        rightBar.y = sliceRect.y;
        add(rightBar);

        center.x = sliceRect.x;
        center.y = sliceRect.y;
        add(center);
    }
}

class ChatMessage extends FlxSpriteGroup
{
    var bg:CustomSliceSprite;
    public var bubble:MessageBubble;
    override public function new(user:String, userColor:FlxColor, messageText:String, textSize:Int = 16)
    {
        super();

        messageText = messageText.replace("-", " ");

        var bgSize = 230;
        var textGap = 10;

        //var bg = new FlxSprite().makeGraphic(230,1, 0x55FFFFFF);



        /*text = new FlxText(5, 5, bg.width-10, ""+user + ": " + messageText);
        text.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        add(text);

        var userColorMarkup = new FlxTextFormatMarkerPair(new FlxTextFormat(userColor, false, false, FlxColor.BLACK), "<userColor>");
        var textColorMarkup = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.WHITE, false, false, FlxColor.BLACK), "<message>");
        text.applyMarkup(text.text, [userColorMarkup, textColorMarkup]);*/

        var text = new ChatTextGroup(user, userColor, messageText, bgSize-(textGap*2), textSize);
        text.x += textGap;
        text.y += textGap;

        if (text.bubble != null)
            bubble = text.bubble;        


        bg = new CustomSliceSprite(Paths.image("boxSlice"), new flixel.math.FlxRect(18, 18, 4, 4), bgSize, Std.int(text.height+(textGap*2)));
        add(bg);
        bg.antialiasing = true;
        //bg.alpha = 0.2;
        bg.color = 0x42777777;
        bg.alpha = 0.4;

        add(text);
    
        //bg.setGraphicSize(Std.int(bg.width), Std.int(text.height+10));
        //bg.updateHitbox();
    }
}

class ChatTextGroup extends FlxSpriteGroup
{
    var lastSpr:FlxSprite;
    var fieldWidth:Float;
    var size:Int;
    public var bubble:MessageBubble;
    override public function new(user:String, userColor:FlxColor, messageText:String, fieldWidth:Float, size:Int)
    {
        super();
        this.size = size;
        var userText = makeText(user + ":");
        userText.color = userColor;
        add(userText);
        lastSpr = userText;

        this.fieldWidth = fieldWidth;
        
        var spaceSplit = messageText.split(" ");
        for (i in spaceSplit)
        {
            var hasEmoji = false;
            for (j in 0...ChatEmoji.list.length)
            {
                if (i.contains(":"+ChatEmoji.list[j].name+":"))
                {
                    //emoji found
                    hasEmoji = true;
                }
            }
            if (!hasEmoji) //make text normally
            {
                appendText(i);
            }
            else 
            {
                var emojiSplit = i.split(":");
                for (j in emojiSplit)
                {
                    if (ChatEmoji.emojiExists(j))
                    {
                        appendEmoji(j);
                        if (spaceSplit.length == 1)
                        {
                            bubble = new MessageBubble(ChatEmoji.get(j));
                        }
                    }   
                    else 
                        appendText(j);
                }
            }
        }
    }

    function appendText(i:String)
    {
        var text = makeText(i);
        text.x = lastSpr.x+lastSpr.width;
        text.y = lastSpr.y;
        if (text.x + text.width > fieldWidth)
        {
            text.y += size+2; //new line
            text.x = 0;
        }
        add(text);
        lastSpr = text;
    }

    function appendEmoji(name:String)
    {
        var emoji = new ChatEmoji(ChatEmoji.get(name), size);
        emoji.x = lastSpr.x+lastSpr.width;
        emoji.y = lastSpr.y;
        if (emoji.x + emoji.width > fieldWidth)
        {
            emoji.y += size+2; //new line
            emoji.x = 0;
        }
        add(emoji);
        lastSpr = emoji;
    }


    function makeText(text:String)
    {
        var t = new FlxText(0,0, 0, text);
        t.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        return t;
    }

}

class MessageBubble extends FlxSpriteGroup
{
    override public function new(emojiData:EmojiData)
    {
        super();
        var bubble = new FlxSprite().loadGraphic(Paths.image("online/Bubble"));
        bubble.setGraphicSize(250);
        bubble.updateHitbox();
        bubble.antialiasing = true;
        add(bubble);
        var emoji = new ChatEmoji(emojiData, 120);
        emoji.x = bubble.x + (bubble.width*0.5) - (emoji.width*0.5);
        emoji.y = bubble.y + (bubble.height*0.5) - (emoji.height*0.5);
        emoji.y -= 25;
        add(emoji);
    }
}

typedef EmojiData = 
{
    var name:String;
    var ?anim:String;
    var ?scale:Float;
    var ?offsetX:Float;
    var ?offsetY:Float;
}

class ChatEmoji extends FlxSprite
{
    public static final list:Array<EmojiData> = [
        {name: "martthumbs", anim: "martthumbs"},
        {name: "die", anim: "die"},
        {name: "talk", anim: "talk"},
        {name: "BUSS", anim: "BUSS"},
        {name: "cries", anim: "cries", scale: 1.2, offsetX: 35},
        {name: "punch", anim: "punch", scale: 1.5, offsetY: -10},
        {name: "vcdevs", anim: "vcdevs"},
        {name: "zen"},
        {name: "cons", anim: "Cons"},
        {name: "consssdf", anim: "Conspart"},
        {name: "pibby", anim: "Pibby"},
        {name: "rejected", anim: "Rejected"},
        {name: "smattt", anim: "Smatt"},
        {name: "skull", anim: "Skull"},
        {name: "rhys", anim: "Reece"},
    ];
    public static function get(name:String)
    {
        for (i in list)
            if (i.name == name)
                return i;
        return null;
    }
    public static function emojiExists(name:String)
    {
        for (i in list)
            if (i.name == name)
                return true;

        return false;
    }
    public var name:String = "";
    override public function new(e:EmojiData, size:Int)
    {
        super();
        if (e == null)
        {
            makeGraphic(size, size);
            return;
        }
        name = e.name;
            
        //if (e.scale != null)
            //size = Std.int(size*e.scale);

        if (Assets.exists(Paths.image("online/emojis/"+e.name)))
        {
            if (Assets.exists(Paths.file("images/online/emojis/"+e.name+".xml")) && e.anim != null)
            {
                frames = Paths.getSparrowAtlas("online/emojis/"+e.name);
                animation.addByPrefix(e.name, e.anim, 24, true);
                animation.play(e.name);
            }
            else 
            {
                loadGraphic(Paths.image("online/emojis/"+e.name));
            }
            setGraphicSize(size, size);
            updateHitbox();
            setGraphicSize(size);
            if (e.scale != null)
                scale *= e.scale;
            //offset.y -= (size*scale.y*0.5)-(height*0.5);
            if (e.offsetX != null)
                offset.x += e.offsetX*scale.x;
            if (e.offsetY != null)
                offset.y += e.offsetY*scale.y;
            antialiasing = true;

        }
    }
}

class EmojiSelector extends FlxSpriteGroup
{
    var inputText:FlxInputText;
    var emojis:Array<ChatEmoji> = [];
    override public function new(inputText:FlxInputText)
    {
        super();
        this.inputText = inputText;

        //var bg = new FlxSprite().makeGraphic(230,1, 0xCC000000);
        //bg.setGraphicSize(230, 285);
        //bg.updateHitbox();

        var bg = new CustomSliceSprite(Paths.image("boxSlice"), new flixel.math.FlxRect(18, 18, 4, 4), 240, 285);
        bg.color = 0xFF000000;
        bg.alpha = 0.75;
        add(bg);
        for (i in 0...ChatEmoji.list.length)
        {
            var emoji = new ChatEmoji(ChatEmoji.list[i], 50);
            emoji.x = 10 + ((i%4)*55);
            emoji.y = 10 + (Math.floor(i/4)*55);
            add(emoji);
            emojis.push(emoji);
        }
    }
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (visible)
        {
            for (emoji in emojis)
            {
                if (emoji.overlapsPoint(FlxG.mouse.getWorldPosition(camera), false, camera))
                {
                    emoji.active = true;
                    emoji.color = 0xFFFFFFFF;
                    if (FlxG.mouse.justPressed)
                    {
                        active = false; //hide
                        visible = false;
                        
                        inputText.hasFocus = true;
                        var toAdd = ":"+emoji.name+":";
                        @:privateAccess
                        inputText.text = inputText.insertSubstring(inputText.text, toAdd, inputText.caretIndex);
                        inputText.caretIndex += toAdd.length;
                    }
                }
                else 
                {
                    emoji.color = 0xAA868686;
                    emoji.active = false;
                }
            }   
        }
    }
}