package online;

import flixel.math.FlxPoint;
import states.PlayState;
import flixel.math.FlxMath;
import online.ChatManager.ChatMessage;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import online.ChatManager.EmojiSelector;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

/**
 * A Chat box that shows messages and allows a user to send messages to a server
 */
class ChatBox extends FlxSpriteGroup
{
    var chatBox:FlxSprite;
    var chatBoxEmoji:FlxSprite;
    var chatEmojiButton:FlxSprite;
    public var chatInput:FlxInputText;
    var emojiSelector:EmojiSelector;
    var loadedMessages:Array<ChatMessage> = [];


    public var hidden(default, set):Bool = false;
    
	function set_hidden(value:Bool):Bool {
        chatBox.visible = value;
        chatBoxEmoji.visible = value;
        chatInput.visible = value;
        chatInput.active = value;
        emojiSelector.active = false;
        emojiSelector.visible = false;
        //for ()
		return hidden = value;
	}


    override public function new(X:Float, Y:Float)
    {
        super();

        chatBox = new FlxSprite(X, Y).loadGraphic(Paths.image("online/room/chat_emoti_off"));
        chatBox.scale *= 0.666;
        chatBox.updateHitbox();
        chatBox.y -= chatBox.height*0.5;
        chatBox.antialiasing = true;
        add(chatBox);

        chatBoxEmoji = new FlxSprite(chatBox.x, chatBox.y).loadGraphic(Paths.image("online/room/chat_emoti_on"));
        chatBoxEmoji.scale *= 0.666;
        chatBoxEmoji.updateHitbox();
        chatBoxEmoji.antialiasing = true;
        chatBoxEmoji.visible = false;
        add(chatBoxEmoji);

        chatEmojiButton = new FlxSprite(chatBox.x + 7, chatBox.y + 18).makeGraphic(26,26);
        chatEmojiButton.visible = false;
        add(chatEmojiButton);

        chatInput = new FixedInputText(chatBox.x+40, chatBox.y+20, 150, "", 14, FlxColor.WHITE, FlxColor.TRANSPARENT);
        chatInput.font = Paths.font("vcr.ttf");
        add(chatInput);

        emojiSelector = new EmojiSelector(chatInput);
        emojiSelector.x = chatBox.x+10;
        emojiSelector.y = (chatBox.y - emojiSelector.height)+10;
        emojiSelector.active = false;
        emojiSelector.visible = false;
        add(emojiSelector);

        loadCurrentMessages();
    }

    //preloads messages from prev states
    function loadCurrentMessages()
    {
        while (ChatManager.storedMessages.length > loadedMessages.length)
        {
            var messageData = ChatManager.storedMessages[loadedMessages.length];
            var m = new ChatMessage(messageData.user, messageData.color, messageData.text, 18);
            insert(members.indexOf(chatBox), m); //insert behind chat box
            loadedMessages.push(m);
            m.y = chatBox.y;
        }
        if (loadedMessages.length > 0)
        {
            var targetY = chatBox.y+10;
            var i = loadedMessages.length-1;
            while (i >= 0)
            {
                var m = loadedMessages[i];
    
                targetY -= m.height+5;
                if (targetY < 200)
                {
                    m.visible = false;
                    m.active = false;
                    //break;
                }
                else 
                {
                    m.x = chatBox.x+10;
                    m.y = targetY;
                }
                i--;
            }
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        //sending a message
        if (chatInput.hasFocus)
        {
            if (FlxG.keys.justPressed.ENTER && chatInput.text != "")
            {
                if (Multiplayer.player1Client != null && Multiplayer.player2Client != null)
                {
                    if (Multiplayer.clients[Multiplayer.currentPlayer] != null)
                        ChatManager.sendMessage(Multiplayer.clients[Multiplayer.currentPlayer].playerName, 0xFFFFFFFF, chatInput.text);
                    chatInput.text = "";
                    chatInput.caretIndex = 0;
                }
            }
        }
    
        //check if a new message has been found, if so load and add it to the list
        if (ChatManager.storedMessages.length > loadedMessages.length)
        {
            var messageData = ChatManager.storedMessages[loadedMessages.length];
            var m = new ChatMessage(messageData.user, messageData.color, messageData.text, 18);
            insert(members.indexOf(chatBox), m); //insert behind chat box
            loadedMessages.push(m);
            m.y = chatBox.y;


            //create a bubble if one needs to be made
            if (Multiplayer.player1Client != null && Multiplayer.player2Client != null)
            {
                if (m.bubble != null)
                {
                    FlxG.state.add(m.bubble);
                    FlxTween.tween(m.bubble, {alpha: 0}, 1, {ease:FlxEase.cubeOut, startDelay: 5, onComplete: function(twn:FlxTween)
                    {
                        //remove(m.bubble);
                        m.bubble.destroy();
                    }});
                    if (PlayState.instance != null && FlxG.state == PlayState.instance)
                    {
                        if (messageData.user == Multiplayer.player1Client.playerName)
                        {
                            var char = PlayState.boyfriend.getMainCharacter();
                            m.bubble.y = char.y - m.bubble.height;
                            m.bubble.x = char.x + (char.width*0.5) - (m.bubble.width*0.5);
                        }
                        else if (messageData.user == Multiplayer.player2Client.playerName)
                        {
                            var char = PlayState.dad.getMainCharacter();
                            m.bubble.y = char.y - m.bubble.height;
                            m.bubble.x = char.x + (char.width*0.5) - (m.bubble.width*0.5);
                        }
                        else 
                        {
                            m.bubble.visible = false; //bubble is from a spectator so ignore it
                        }
                    }
                    else 
                    {
                        if (messageData.user == Multiplayer.player1Client.playerName)
                            m.bubble.x = (FlxG.width*0.666)- (m.bubble.width*0.5);
                        else 
                            m.bubble.x = (FlxG.width*0.333)- (m.bubble.width*0.5);

                        m.bubble.y = 600-m.bubble.height;
                    }
                }
            }
        }
    
        //lerp and position messages
        if (loadedMessages.length > 0)
        {
            var targetY = chatBox.y+10;

            var i = loadedMessages.length-1;
            while (i >= 0)
            {
                var m = loadedMessages[i];
    
                targetY -= m.height+5;
                if (targetY < 200)
                {
                    m.visible = false;
                    m.active = false;
                    break;
                }
                else 
                {
                    m.x = chatBox.x+10;
                    if (Math.abs(m.y-targetY) > 2)
                        m.y = FlxMath.lerp(m.y, targetY, elapsed*10);
                    else 
                        m.y = targetY;
                }
                i--;
            }
        }

        //hover and selection for emoji stuff
        if (FlxG.mouse.justMoved)
        {
            if (chatEmojiButton.overlapsPoint(FlxG.mouse.getWorldPosition(camera), false, camera))
            {
                chatBox.visible = false;
                chatBoxEmoji.visible = true;
            }
            else 
            {
                chatBox.visible = true;
                chatBoxEmoji.visible = false;
            }
        }
        if (FlxG.mouse.justPressed)
        {
            if (chatEmojiButton.overlapsPoint(FlxG.mouse.getWorldPosition(camera), false, camera))
            {
                emojiSelector.visible = !emojiSelector.visible;
                emojiSelector.active = !emojiSelector.active;
            }
        }


    }
}

//fix for cameras
private class FixedInputText extends FlxInputText
{
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        #if FLX_MOUSE
        // Set focus and caretIndex as a response to mouse press
        if (FlxG.mouse.justPressed)
        {
            var hadFocus:Bool = hasFocus;
            if (this.overlapsPoint(FlxG.mouse.getWorldPosition(camera), true, camera))
            {
                caretIndex = getCaretIndex();
                hasFocus = true;
                if (!hadFocus && focusGained != null)
                    focusGained();
            }
            else
            {
                hasFocus = false;
                if (hadFocus && focusLost != null)
                    focusLost();
            }
        }
        #end
    }
    	/**
	 * Gets the index of the character in this box under the mouse cursor
	 * @return The index of the character.
	 *         between 0 and the length of the text
	 */
	override private function getCaretIndex():Int
    {
        #if FLX_MOUSE
        var hit = FlxPoint.get(FlxG.mouse.getWorldPosition(camera).x - x, FlxG.mouse.getWorldPosition(camera).y - y);
        return getCharIndexAtPoint(hit.x, hit.y);
        #else
        return 0;
        #end
    }
}