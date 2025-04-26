package online;

import ui.HealthIcon;
import ui.Alphabet;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import lime.app.Future;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import game.Character;
import online.SkinManager.SkinType;
import substates.MusicBeatSubstate;

class SkinSelectionMenu extends MusicBeatSubstate
{
    var char:Character;
    var charNameText:FlxText;
    var skinTypeText:FlxText;
    var skinList:Array<SkinType> = [];
    var curCharIdx:Int = 0;
    var curTypeIdx:Int = 0;

    var currentFuture:Future<Character>;

    override public function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/BG'));
        bg.color = 0xFF6A00C6;
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

        FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

        charNameText = new FlxText(0, 600, 0, "");
        charNameText.setFormat(Paths.font("Contb___.ttf"), 48, FlxColor.WHITE, CENTER, OUTLINE, 0xFF000000);
        add(charNameText);

        skinTypeText = new FlxText(0, 600, 0, "");
        skinTypeText.setFormat(Paths.font("Contb___.ttf"), 48, FlxColor.WHITE, CENTER, OUTLINE, 0xFF000000);
        add(skinTypeText);

        Main.noGPU = true; //cant aysnc i think?

        
        SkinManager.reloadSkinSettings();

        for (skin in SkinManager.regularSkins)
            skinList.push(skin);
        for (skin in SkinManager.devSkins)
            skinList.push(skin);
        //trace(skinNames);
        //trace(skinList);

        changeType(0);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);



        if (controls.ACCEPT)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            //SkinManager.saveSkin(skinList[curCharIdx].charName, curTypeIdx < 2, curTypeIdx % 2 == 1);
            SkinManager.reloadSkinSettings();
            changeSelection();
        }

        if (controls.LEFT_P)
            changeSelection(-1);
        else if (controls.RIGHT_P)
            changeSelection(1);
        if (controls.UP_P)
            changeType(-1);
        else if (controls.DOWN_P)
            changeType(1);


        if (controls.BACK)
        {
            currentFuture = null; //stop from adding after leaving
            Main.noGPU = false;
            close();
            
        }
    }

    function changeType(change:Int = 0)
    {
        curTypeIdx += change;
        if (curTypeIdx < 0)
        {
            curTypeIdx = 3;
        }
        if (curTypeIdx > 3)
        {
            curTypeIdx = 0;
        }

        var types = ["Player Skin: ", "Player Skin (Boxing): ", "Opponent Skin: ", "Opponent Skin (Boxing):"];
        skinTypeText.text = types[curTypeIdx];

        skinList = [];

        skinList.push({name: "None",hasBoxing: false, hasPowerup: false, charName: ""});

        if (curTypeIdx % 2 == 1) //show boxing skins
        {
            for (skin in SkinManager.boxingSkins)
                skinList.push(skin);
        }
        for (skin in SkinManager.regularSkins)
            skinList.push(skin);
        for (skin in SkinManager.devSkins)
            skinList.push(skin);

        for(i in 0...skinList.length)
        {
            if (skinList[i].charName == SkinManager.getSkin(curTypeIdx < 2, curTypeIdx % 2 == 1, false))
            {
                curCharIdx = i; //set to selected skin
                break;
            }
        }

        changeSelection();
    }

    function changeSelection(change:Int = 0)
    {
        curCharIdx += change;

        if (curCharIdx < 0)
        {
            curCharIdx = skinList.length - 1;
        }
        if (curCharIdx >= skinList.length)
        {
            curCharIdx = 0;
        }


        var text = skinList[curCharIdx].name;
        if (SkinManager.getSkin(curTypeIdx < 2, curTypeIdx % 2 == 1, false) == skinList[curCharIdx].charName)
            text += " (Selected)";

        charNameText.text = text;
        charNameText.screenCenter(X);
        skinTypeText.x = charNameText.x - (skinTypeText.width+15);
        

        if (char != null)
            remove(char);

        if (skinList[curCharIdx].charName == "")
        {
            currentFuture = null; //dont load
            return;
        }
        
        //async character loading
        var fut:Future<Character> = new Future(function()
        {
            var charToLoad = new Character(0, 0, skinList[curCharIdx].charName, curTypeIdx < 2, false, 0.75);
            return charToLoad;
        }, true);
        fut.onComplete(function(c:Character)
        {
            onLoadCharacter(fut, c);
        });

        currentFuture = fut;
    }

    function onLoadCharacter(fut:Future<Character>, loadedChar:Character)
    {
        if (currentFuture == fut) //only add if its the current selected character
        {
            char = loadedChar;
            //char.screenCenter();

            char.setPosition((640 - (char.width / 2)) + char.positioningOffset[0], 
                (550 - char.height) + char.positioningOffset[1]);
            
                char.screenCenter(X);
            insert(members.indexOf(charNameText), char);
        }        
    }
}


class SkinMenu extends MusicBeatSubstate
{
    var selectedOption:Int = 0;
    var characters:Array<Character> = [];
    var xPos = [640-900, 640-600, 640-200,
                640+200, 640+600, 640+900];

    var light:FlxSprite;

    var cam:FlxCamera;

    var skinTypeText:FlxText;

    override public function create()
    {
        super.create();

        cam = new FlxCamera();
        cam.bgColor.alpha = 0;
        FlxG.cameras.add(cam, false);
        this.cameras = [cam];

        cam.zoom = 0.5;

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('online/room/bg_online'));
        bg.setGraphicSize(2560);
        bg.updateHitbox();
        bg.alpha = 0;
        bg.scrollFactor.set();
        bg.screenCenter();
        add(bg);

        FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});



        light = new FlxSprite().loadGraphic(Paths.image("online/beam"));
        light.scale.set(2,2);
        light.updateHitbox();
        light.screenCenter(Y);
        add(light);



        var titleBG = new FlxSprite().loadGraphic(Paths.image('freeplay/thing'));
        titleBG.scale.set(2,2);
        titleBG.updateHitbox();
        add(titleBG);
        titleBG.screenCenter(X);

        var title = new FlxText(0, -260, 0, "Skin Selection");
        title.setFormat(Paths.font("Contb___.ttf"), 128, FlxColor.WHITE, CENTER, OUTLINE, 0xFF000000);
        title.screenCenter(X);
        title.borderSize = 3;
        title.antialiasing = true;
        add(title);

        skinTypeText = new FlxText(0, 720+200, 0, "");
        skinTypeText.setFormat(Paths.font("Contb___.ttf"), 96, FlxColor.WHITE, CENTER, OUTLINE, 0xFF000000);
        skinTypeText.borderSize = 3;
        skinTypeText.screenCenter(X);
        skinTypeText.antialiasing = true;
        add(skinTypeText);

        titleBG.y = (title.y + (title.height*0.5)) - (titleBG.height*0.5);

        
        reloadCharacters();

        changeSelection();
    }

    function reloadCharacters()
    {
        for (c in characters)
            remove(c);

        characters = [];

        SkinManager.reloadSkinSettings();

        var names = [SkinManager.p2SecondarySkin, SkinManager.p2RegularSkin, SkinManager.p2BoxingSkin,
                    SkinManager.p1BoxingSkin, SkinManager.p1RegularSkin, SkinManager.p1SecondarySkin];

        for (i in 0...6)
        {
            var char = new Character(0, 0, names[i], i >= 3, false, 1.0);

            var y = 850;

            if (i == 0 || i == 5)
                y = 750;

            char.setPosition((xPos[i] - (char.width / 2)) + (char.positioningOffset[0]*1.0), 
                            (850 - char.height) + (char.positioningOffset[1]*1.0));

            if (i == 0 || i == 5)
                insert(members.indexOf(light)+1, char);
            else 
                add(char);

            characters.push(char);
        }
    }

    var idleTimer:Float = 0.0;

    var justEntered:Bool = true;

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (justEntered)
        {
            justEntered = false;
            return;
        }

        idleTimer += elapsed;
        if (idleTimer >= 0.5)
        {
            idleTimer -= 0.5;
            for (c in characters)
                c.dance();
        }

        if (controls.ACCEPT)
        {
            //FlxG.sound.play(Paths.sound('confirmMenu'));

            var skins:Array<SkinType> = [];
            skins.push({ name: "None",hasBoxing: false, hasPowerup: false, charName: ""});
            if (selectedOption == 2 || selectedOption == 3)
            {
                for (skin in SkinManager.boxingSkins)
                    skins.push(skin);
            }

            for (skin in SkinManager.regularSkins)
                skins.push(skin);
            for (skin in SkinManager.devSkins)
                skins.push(skin);
            openSubState(new SkinSelector(skins, function(name:String)
            {
                SkinManager.saveSkin(name, selectedOption >= 3, selectedOption == 2 || selectedOption == 3, selectedOption == 0 || selectedOption == 5);
                reloadCharacters();
                justEntered = true;
            }));
            //SkinManager.saveSkin(skinList[curCharIdx].charName, curTypeIdx < 2, curTypeIdx % 2 == 1);
            //SkinManager.reloadSkinSettings();
            //changeSelection();
        }

        if (controls.LEFT_P)
            changeSelection(-1);
        else if (controls.RIGHT_P)
            changeSelection(1);


        light.x = FlxMath.lerp(light.x, xPos[selectedOption] - (light.width*0.5), elapsed*8);

        if (controls.BACK)
        {
            
            close();
            FlxG.cameras.remove(cam);
        }
    
    }

    function changeSelection(change:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
        selectedOption += change;

        if (selectedOption < 0)
        {
            selectedOption = 5;
        }
        if (selectedOption > 5)
        {
            selectedOption = 0;
        }

        var types = ["Opponent (Secondary)", "Opponent", "Opponent (Boxing)",
                     "Player (Boxing)", "Player", "Player (Secondary)"];

        skinTypeText.text = "< " + types[selectedOption] + " >";
        skinTypeText.screenCenter(X);
    }
}

class SkinSelector extends MusicBeatSubstate
{
    var skinList:Array<SkinType> = [];
    var textList:Array<Alphabet> = [];
    var iconArray:Array<HealthIcon> = [];

    var onSelected:String->Void;

    var cam:FlxCamera;

    override public function new(skinList:Array<SkinType>, onSelected:String->Void)
    {
        this.onSelected = onSelected;
        this.skinList = skinList;
        super();
    }

    var curSelected:Int = 0;
    override public function create()
    {
        super.create();

        cam = new FlxCamera();
        cam.bgColor.alpha = 0;
        FlxG.cameras.add(cam, false);
        this.cameras = [cam];

        var bg:FlxSprite = new FlxSprite().makeGraphic(1,1,FlxColor.BLACK);
        bg.setGraphicSize(2560);
        bg.updateHitbox();
        bg.alpha = 0;
        bg.scrollFactor.set();
        bg.screenCenter();
        add(bg);

        FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

        for (i in 0...skinList.length)
        {
            var songText:Alphabet = new Alphabet(0, (70 * i) + 30, skinList[i].name, true, false, 1.0);
            songText.isMenuItem = true;
            songText.targetY = i;
            //songText.forceX = 90;
            textList.push(songText);
            add(songText);
    
            if(utilities.Options.getData("healthIcons"))
            {
                var cfg = Character.getConfigFromCharacterName(skinList[i].charName);
                var iconName = skinList[i].charName;
                if (cfg.healthIcon != null)
                    iconName = cfg.healthIcon;

                var icon:HealthIcon = new HealthIcon(iconName);
                icon.sprTracker = songText;
    
                iconArray.push(icon);
                add(icon);
            }
        }

        changeSelection();
    }

    var justEntered = true;

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        
        if (justEntered)
        {
            justEntered = false;
            return;
        }

        if (controls.ACCEPT)
        {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            //SkinManager.saveSkin(skinList[curCharIdx].charName, curTypeIdx < 2, curTypeIdx % 2 == 1);
            //SkinManager.reloadSkinSettings();
            //changeSelection();
            onSelected(skinList[curSelected].charName);
            close();
            FlxG.cameras.remove(cam);
            
        }

        if (controls.UP_P)
            changeSelection(-1);
        else if (controls.DOWN_P)
            changeSelection(1);

        if (controls.BACK)
        {
            
            close();
            FlxG.cameras.remove(cam);
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected += change;

        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        if (curSelected < 0)
        {
            curSelected = skinList.length-1;
        }
        if (curSelected > skinList.length-1)
        {
            curSelected = 0;
        }

        if(iconArray.length > 0)
        {
            for (i in 0...iconArray.length)
            {
                iconArray[i].alpha = 0.6;

                if(iconArray[i].animation.curAnim != null && !iconArray[i].animatedIcon)
                    iconArray[i].animation.curAnim.curFrame = 0;
            }
    
            iconArray[curSelected].alpha = 1;

            if(iconArray[curSelected].animation.curAnim != null && !iconArray[curSelected].animatedIcon)
            {
                iconArray[curSelected].animation.curAnim.curFrame = 2;

                if(iconArray[curSelected].animation.curAnim.curFrame != 2)
                    iconArray[curSelected].animation.curAnim.curFrame = 0;
            }
        }

        var bullShit = 0;
        for (item in textList)
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