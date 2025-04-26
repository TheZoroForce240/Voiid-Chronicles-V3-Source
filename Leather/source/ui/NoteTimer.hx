package ui;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BlendMode;
import openfl.display.BitmapDataChannel;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;
import flixel.math.FlxMath;
import game.Conductor;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.addons.display.FlxPieDial;
import states.PlayState;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

using flixel.util.FlxSpriteUtil;

class CircleShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        float PI = 3.14159265358;
        uniform float percent;

        vec2 rotate(vec2 v, float a) {
            float s = sin(a);
            float c = cos(a);
            mat2 m = mat2(c, -s, s, c);
            return m * v;
        }

        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec4 spritecolor = flixel_texture2D(bitmap, openfl_TextureCoordv);

            //rotate uv so circle matches properly
            uv -= vec2(0.5, 0.5);
            uv = rotate(uv, PI*0.5);
            uv += vec2(0.5, 0.5);

            float percentAngle = (percent*360.0) / (180.0/PI);

            vec2 center = vec2(0.5, 0.5);
            float radius = 0.5;
            float angle = atan(uv.y - center.y, uv.x - center.x);
            float distance = length(uv - center);

            if ((angle + (PI)) > percentAngle)
            {
                spritecolor = vec4(0.0,0.0,0.0,0.0);
            }
        
            gl_FragColor = spritecolor;
        }
    ')

    public function new()
    {
       super();
    }
}

class NoteTimer extends FlxTypedSpriteGroup<FlxSprite>
{
    private var instance:PlayState;
    private var timerText:FlxText;
    private var timerCircle:FlxSprite;
    private var circleShader:CircleShader = new CircleShader();
    private var skipText:FlxText;
    public function new(instance:PlayState)
    {
        super();
        this.instance = instance;

        timerCircle = new FlxSprite().loadGraphic(Paths.image("circleThing"));
        timerCircle.antialiasing = true;
        timerCircle.shader = circleShader;
        timerCircle.scale *= 0.75;
        timerCircle.updateHitbox();
        add(timerCircle);
        timerText = new FlxText(0,0,0,"");
        timerText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(timerText);

        skipText = new FlxText(0,0,0,"Press SHIFT to Skip Intro");
        skipText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(skipText);
        skipText.visible = false;

        timerCircle.screenCenter();
        timerText.screenCenter();

        circleShader.percent.value = [0.0];



        firstNoteTime = getClosestNote();
        if (firstNoteTime != FlxMath.MAX_VALUE_FLOAT && firstNoteTime > 5000 && !PlayState.inMultiplayerSession)
        {
            skipped = false;
            skipText.visible = true;
            skipText.alpha = 0;
            PlayState.instance.tweenManager.tween(skipText, {alpha: 1}, 1, {ease:FlxEase.cubeInOut, startDelay: Conductor.crochet*0.001*5, onComplete: function(twn)
            {
                PlayState.instance.tweenManager.tween(skipText, {alpha: 0}, 1, {ease:FlxEase.cubeIn, startDelay: Conductor.crochet*0.001*5});
            }});
        }
        else 
            skipped = true;

        //alpha = 0;
    }

    private var firstNoteTime:Float = 0;

    private var lastStartTime:Float = FlxMath.MAX_VALUE_FLOAT;
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        var timeTillNextNote:Float = FlxMath.MAX_VALUE_FLOAT;

        if (skipped)
            skipText.visible = false;

        if (instance != null)
        {
            var show:Bool = false;
            if (Conductor.songPosition > 0)
            {
                for (daNote in instance.notes)
                    if (daNote.mustPress == (PlayState.characterPlayingAs == 0)) //check notes for closest
                    {
                        var timeDiff = daNote.strumTime-Conductor.songPosition;
                        if (timeDiff < timeTillNextNote)
                            timeTillNextNote = timeDiff;
                    }

                if (timeTillNextNote == FlxMath.MAX_VALUE_FLOAT) //now check unspawnNotes if not found anything
                {
                    for (daNote in instance.unspawnNotes)
                        if (daNote.mustPress == (PlayState.characterPlayingAs == 0))
                        {
                            var timeDiff = daNote.strumTime-Conductor.songPosition;
                            if (timeDiff < timeTillNextNote)
                            {
                                timeTillNextNote = timeDiff;
                                break;
                            }
                                
                        }
                }
                show = timeTillNextNote != FlxMath.MAX_VALUE_FLOAT; //if found a note and time is larger than 2 secs
            }

            //visible = false;
            var targetAlpha:Float = 0.0;
            if (show)
            {
                //trace('show timer');
                if (lastStartTime == FlxMath.MAX_VALUE_FLOAT && timeTillNextNote > 3000)
                    lastStartTime = timeTillNextNote;

                //trace(timeTillNextNote);

                if (lastStartTime != FlxMath.MAX_VALUE_FLOAT)
                {
                    var secsLeft:Float = Math.ceil(timeTillNextNote*0.001);
                    var percent:Float = timeTillNextNote/lastStartTime;
                    //timerCircle.amount = percent;
                    // trace(percent);
                    if (percent <= 0.0)
                    {
                        lastStartTime = FlxMath.MAX_VALUE_FLOAT; //reset
                        timerText.text = "";
                        circleShader.percent.value = [0.0];
                    }
                    else
                    {
                        circleShader.percent.value = [percent];
                        timerText.text = ""+secsLeft;
                    }
                    updatePosition();
                    
                }
                if (timeTillNextNote > 1000)
                {
                    //visible = true;
                    targetAlpha = 1.0;

                    if (FlxG.keys.justPressed.SHIFT)
                    {
                        if (!skipped)
                        {
                            if (Conductor.songPosition < firstNoteTime-1000)
                                skipToTime(firstNoteTime-350);
                        }
                    }

                }
            }

            timerText.alpha = FlxMath.lerp(timerText.alpha, targetAlpha, elapsed*5);
            timerCircle.alpha = timerText.alpha;
        }
    }

    function updatePosition()
    {
        timerCircle.screenCenter();
        timerText.screenCenter();
        skipText.screenCenter();
        if (utilities.Options.getData("downscroll"))
        {
            timerCircle.y += 260;
            timerText.y += 260;
            skipText.y += 260-100;
        }
        else 
        {
            timerCircle.y -= 260;
            timerText.y -= 260;
            skipText.y -= 260-100;
        }
    }

    public var skipped:Bool = false;

    public function getClosestNote()
    {
        var t:Float = FlxMath.MAX_VALUE_FLOAT;
        for (daNote in instance.notes)
        {
            var timeDiff = daNote.strumTime;
            if (timeDiff < t)
                t = timeDiff;
        }

        //if (t == FlxMath.MAX_VALUE_FLOAT) //now check unspawnNotes if not found anything
        //{
            for (daNote in instance.unspawnNotes)
            {
                var timeDiff = daNote.strumTime;
                if (timeDiff < t)
                {
                    t = timeDiff;
                    //break;
                }
            }
        //}
        return t;
    }

    public function skipToTime(time:Float)
    {
        if (skipped)
            return;
        skipped = true;
        var timeDiff = time-Conductor.songPosition;
        var addedTime = Conductor.songPosition;

        while(timeDiff > 0)
        {
            var timeToAdd = Conductor.stepCrochet;
            var ending:Bool = false;
            if (timeDiff <= timeToAdd)
            {
                timeToAdd = timeDiff; //less than a step left so just takeaway the rest
                ending = true;
            }
            timeDiff -= timeToAdd;
            //trace('time left: ' + timeDiff);
            //trace('song pos: ' + Conductor.songPosition);
            FlxG.state.update(timeToAdd*0.001); //advance time
            
            addedTime += timeToAdd; //need to do it like this because the songpos gets updated with FlxG.elapsed which wouldnt change
            Conductor.songPosition = addedTime; //make sure it updates the step correctly
            if (ending)
            {
                timeDiff = 0;
                Conductor.songPosition = time;
                FlxG.sound.music.time = time;
                break;
            }
        }
    }
}