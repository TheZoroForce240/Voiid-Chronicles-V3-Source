package shaders;

import flixel.FlxCamera;
import openfl.display.BitmapData;
import game.Character;
import flixel.math.FlxPoint;
import utilities.CoolUtil;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.system.FlxAssets;

using StringTools;

class Shaders
{
    public static function newEffect(?name:String = "3d"):Dynamic
    {
        switch(name.toLowerCase())
        {
            case "3d":
                return new ThreeDEffect();
        }

        return new ThreeDEffect();
    }
}

class ShaderEffect
{
    public function update(elapsed:Float)
    {
        // nothing yet
    }
}

class ThreeDEffect extends ShaderEffect
{
    public var shader(default,null):ThreeDShader = new ThreeDShader();

    public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;

	public function new():Void
	{
		shader.uTime.value = [0];
	}

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        shader.uTime.value[0] += elapsed;
    }

    function set_waveSpeed(v:Float):Float
    {
        waveSpeed = v;
        shader.uSpeed.value = [waveSpeed];
        return v;
    }
    
    function set_waveFrequency(v:Float):Float
    {
        waveFrequency = v;
        shader.uFrequency.value = [waveFrequency];
        return v;
    }
    
    function set_waveAmplitude(v:Float):Float
    {
        waveAmplitude = v;
        shader.uWaveAmplitude.value = [waveAmplitude];
        return v;
    }
}

class ThreeDShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header
    //uniform float tx, ty; // x,y waves phase

    //modified version of the wave shader to create weird garbled corruption like messes
    uniform float uTime;
    
    /**
     * How fast the waves move over time
     */
    uniform float uSpeed;
    
    /**
     * Number of waves over time
     */
    uniform float uFrequency;
    
    /**
     * How much the pixels are going to stretch over the waves
     */
    uniform float uWaveAmplitude;

    vec2 sineWave(vec2 pt)
    {
        float x = 0.0;
        float y = 0.0;
        
        float offsetX = sin(pt.y * uFrequency + uTime * uSpeed) * (uWaveAmplitude / pt.x * pt.y);
        float offsetY = sin(pt.x * uFrequency - uTime * uSpeed) * (uWaveAmplitude / pt.y * pt.x);
        pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
        pt.y += offsetY;

        return vec2(pt.x + x, pt.y + y);
    }

    void main()
    {
        vec2 uv = sineWave(openfl_TextureCoordv);
        gl_FragColor = texture2D(bitmap, uv);
    }')

    public function new()
    {
       super();
    }
}

class RTXEffect extends ShaderEffect
{
    public var shader(default,null):RTXShader = new RTXShader();
    public var overlayColor(default, set):FlxColor = 0x00000000;
    public var satinColor(default, set):FlxColor = 0x000000FF;
    public var innerShadowColor(default, set):FlxColor = 0x00000000;
    public var innerShadowDistance:Float = 10;
    public var innerShadowAngle:Float = 270;
    public var parentSprite:ReflectedSprite = null;

    public var pointLight:Bool = false;
    public var lightX:Float = 0;
    public var lightY:Float = 0;

    public var hue(default, set):Float = 0.0;
    public var sat:Float = 0.0;
    public var brt:Float = 1.0;

    var shiftedOverlayColor:FlxColor = 0x00000000;
    var shiftedSatinColor:FlxColor = 0x000000FF;
    var shiftedInnerColor:FlxColor = 0x00000000;


    public var CFred:Float = 0.0;
    public var CFgreen:Float = 0.0;
    public var CFblue:Float = 0.0;
    public var CFfade:Float = 1.0;

    public var flipX:Bool = false;


    public function updateColorShift()
    {
        shiftedOverlayColor = CoolUtil.getShiftedColor(overlayColor, hue, sat, brt);
        shiftedSatinColor = CoolUtil.getShiftedColor(satinColor, hue, sat, brt);
        shiftedInnerColor = CoolUtil.getShiftedColor(innerShadowColor, hue, sat, brt);

        shader.overlayColor.value = [shiftedOverlayColor.redFloat, shiftedOverlayColor.greenFloat, shiftedOverlayColor.blueFloat];
        shader.overlayAlpha.value = [overlayColor.alphaFloat];

        shader.satinColor.value = [shiftedSatinColor.redFloat, shiftedSatinColor.greenFloat, shiftedSatinColor.blueFloat];
        shader.satinAlpha.value = [satinColor.alphaFloat];

        shader.innerShadowColor.value = [shiftedInnerColor.redFloat, shiftedInnerColor.greenFloat, shiftedInnerColor.blueFloat];
        shader.innerShadowAlpha.value = [innerShadowColor.alphaFloat];
    }

	public function new():Void
    {
        shader.frameBounds.value = [0, 0, 1, 1];
        update(0.0);
        updateColorShift();
    }
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        /*
        var overlay = CoolUtil.getShiftedColor(overlayColor, hue, sat, brt); //get hue shifted color
        shader.overlayColor.value = [overlay.redFloat, overlay.greenFloat, overlay.blueFloat];
        shader.overlayAlpha.value = [overlayColor.alphaFloat];

        var satin = CoolUtil.getShiftedColor(satinColor, hue, sat, brt);
        shader.satinColor.value = [satin.redFloat, satin.greenFloat, satin.blueFloat];
        shader.satinAlpha.value = [satinColor.alphaFloat];

        var inner = CoolUtil.getShiftedColor(innerShadowColor, hue, sat, brt);
        shader.innerShadowColor.value = [inner.redFloat, inner.greenFloat, inner.blueFloat];
        shader.innerShadowAlpha.value = [innerShadowColor.alphaFloat];
        */

        shader.innerShadowDistance.value = [innerShadowDistance];

        if (pointLight && parentSprite != null)
        {
            var pos = parentSprite.getGraphicMidpoint();
            pos.x = lightX-pos.x;
            pos.y = lightY-pos.y;
            if (parentSprite.drawFlipped)
            {
                pos.x = -pos.x;
            }
            shader.innerShadowAngle.value = [pos.radians];
        }
        else 
        {
            var ang = innerShadowAngle*FlxAngle.TO_RAD;
            var pos = FlxPoint.weak(Math.cos(ang), Math.sin(ang));
            if (flipX)
                pos.x = -pos.x; //flip
            shader.innerShadowAngle.value = [pos.radians];
        }
        
        shader.CFred.value = [CFred];
        shader.CFgreen.value = [CFgreen];
        shader.CFblue.value = [CFblue];
        shader.CFfade.value = [CFfade];

        if (parentSprite != null)
        {
            if (parentSprite.frame != null)
                shader.frameBounds.value = [parentSprite.frame.uv.x,parentSprite.frame.uv.y,parentSprite.frame.uv.width,parentSprite.frame.uv.height];
        }
    }

    public function copy()
    {
        var rtx = new RTXEffect();

        rtx.overlayColor = overlayColor;
        rtx.satinColor = satinColor;
        rtx.innerShadowColor = innerShadowColor;
        rtx.hue = hue;
        rtx.innerShadowDistance = innerShadowDistance;
        rtx.innerShadowAngle = innerShadowAngle;
        rtx.parentSprite = parentSprite;
        rtx.pointLight = pointLight;
        rtx.lightX = lightX;
        rtx.lightY = lightY;
        rtx.flipX = flipX;
        rtx.CFred = CFred;
        rtx.CFgreen = CFgreen;
        rtx.CFblue = CFblue;
        rtx.CFfade = CFfade;
        rtx.updateColorShift();
        rtx.update(0);
        return rtx;
    }

    function set_innerShadowColor(value:FlxColor):FlxColor {
        if (innerShadowColor != value)
            updateColorShift();
        return innerShadowColor = value;
    }
    function set_overlayColor(value:FlxColor):FlxColor {
        if (overlayColor != value)
            updateColorShift();
        return overlayColor = value;
    }
    function set_satinColor(value:FlxColor):FlxColor {
        if (satinColor != value)
            updateColorShift();
        return satinColor = value;
    }
    function set_hue(value:Float):Float {

        if (hue != value)
        {
            hue = value;
            updateColorShift();
        }
            
        return value;
    }
}

class RTXShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        //https://github.com/jamieowen/glsl-blend !!!!
        
        float blendOverlay(float base, float blend) {
            return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
        }
        
        vec3 blendOverlay(vec3 base, vec3 blend) {
            return vec3(blendOverlay(base.r,blend.r),blendOverlay(base.g,blend.g),blendOverlay(base.b,blend.b));
        }
        
        vec3 blendOverlay(vec3 base, vec3 blend, float opacity) {
            return (blendOverlay(base, blend) * opacity + base * (1.0 - opacity));
        }
        
        float blendColorDodge(float base, float blend) {
            return (blend==1.0)?blend:min(base/(1.0-blend),1.0);
        }
        
        vec3 blendColorDodge(vec3 base, vec3 blend) {
            return vec3(blendColorDodge(base.r,blend.r),blendColorDodge(base.g,blend.g),blendColorDodge(base.b,blend.b));
        }
        
        vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
            return (blendColorDodge(base, blend) * opacity + base * (1.0 - opacity));
        }
        
        float blendLighten(float base, float blend) {
            return max(blend,base);
        }
        vec3 blendLighten(vec3 base, vec3 blend) {
            return vec3(blendLighten(base.r,blend.r),blendLighten(base.g,blend.g),blendLighten(base.b,blend.b));
        }
        vec3 blendLighten(vec3 base, vec3 blend, float opacity) {
            return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
        }
        
        vec3 blendMultiply(vec3 base, vec3 blend) {
            return base*blend;
        }
        vec3 blendMultiply(vec3 base, vec3 blend, float opacity) {
            return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
        }
        
        float inv(float val)
        {
            return (0.0 - val) + 1.0;
        }

        //color fill stuff for back compat with events
        uniform float CFred;
        uniform float CFgreen;
        uniform float CFblue;
        uniform float CFfade;
        
        
        uniform vec3 overlayColor;
        uniform float overlayAlpha;
        
        uniform vec3 satinColor;
        uniform float satinAlpha;
        
        uniform vec3 innerShadowColor;
        uniform float innerShadowAlpha;
        uniform float innerShadowAngle;
        uniform float innerShadowDistance;

        uniform vec4 frameBounds;
        
        float SAMPLEDIST = 5.0;
                
        void main()
        {	
            vec2 uv = openfl_TextureCoordv.xy;
            vec4 spritecolor = flixel_texture2D(bitmap, uv);    
            vec2 resFactor = 1.0 / openfl_TextureSize.xy;
            
            spritecolor.rgb = blendMultiply(spritecolor.rgb, satinColor, satinAlpha);
        
            //inner shadow
            float offsetX = cos(innerShadowAngle);
            float offsetY = sin(innerShadowAngle);
            vec2 distMult = (innerShadowDistance*resFactor) / SAMPLEDIST;

            for (float i = 0.0; i < SAMPLEDIST; i++) //sample nearby pixels to see if theyre transparent, multiply blend by inverse alpha to brighten the edge pixels
            {
                vec2 offsetUV = uv + vec2(offsetX*(distMult.x*i), offsetY*(distMult.y*i));

                vec4 col = vec4(0.0, 0.0, 0.0, 0.0);
                if (offsetUV.x < frameBounds.x || offsetUV.x > frameBounds.z || offsetUV.y < frameBounds.y || offsetUV.y > frameBounds.w) //outside frame bounds
                {

                }
                else 
                {
                    //make sure to use texture2D instead of flixel_texture2D so alpha doesnt effect it
                    col = texture2D(bitmap, offsetUV); //sample now
                }
                spritecolor.rgb = blendColorDodge(spritecolor.rgb, innerShadowColor, innerShadowAlpha * inv(col.a)); //mult by the inverse alpha so it blends from the outside
            }

            spritecolor.rgb = blendLighten(spritecolor.rgb, overlayColor, overlayAlpha);
        
            
            gl_FragColor = spritecolor*spritecolor.a;

            vec4 CFcol = vec4(CFred / 255.0, CFgreen / 255.0, CFblue / 255.0, spritecolor.a);
            gl_FragColor = mix(CFcol*spritecolor.a, gl_FragColor, CFfade);
        }
    ')

    public function new()
    {
       super();
    }
}

class EchoEffect extends ShaderEffect
{
    public var shader(default,null):EchoShader = new EchoShader();
    
	public function new():Void
    {

    }
}

class EchoShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        vec3 borderCol = vec3(0.353, 0.024, 0.439);
        vec3 innerCol = vec3(0.671, 0.09, 0.722);
        
        vec4 getCol(vec2 uv)
        {
            vec4 spritecolor = flixel_texture2D(bitmap, uv);    
        
            spritecolor.rgb /= 3.0;
        
            if (spritecolor.r < 0.05 && spritecolor.g < 0.05 && spritecolor.b < 0.05)
            {
                spritecolor.rgb = borderCol*spritecolor.a;
            }   
            else if (spritecolor.r > 0.31 && spritecolor.g > 0.31 && spritecolor.b > 0.31)
            {
                spritecolor.rgb *= 3.0;
            }
            else 
            {
                spritecolor.rgb = innerCol*spritecolor.a;
            }
            return spritecolor;
        }
                
        void main()
        {	
            vec2 uv = openfl_TextureCoordv.xy;
            
        
            vec4 color = vec4(0.0);
            vec2 offset = vec2(8.0) / openfl_TextureSize;
            float intensity = 2.0;
        
            if (getCol(uv).a < 0.5) //blur
            {
                float mult = 0.0;
                mult += getCol(uv).a;
                mult += getCol(uv + vec2(offset.x, 0.0)).a;
                mult += getCol(uv - vec2(offset.x, 0.0)).a;
                mult += getCol(uv + vec2(0.0, offset.y)).a;
                mult += getCol(uv - vec2(0.0, offset.y)).a;
                //mult += getCol(uv + vec2(offset.x, offset.y)).a;
                //mult += getCol(uv - vec2(offset.x, offset.y)).a;
                //mult += getCol(uv + vec2(-offset.x, offset.y)).a;
                //mult += getCol(uv - vec2(-offset.x, offset.y)).a;
                
                mult = mult/5.0;
                color.rgb = innerCol*mult;
                color.a = mult;
            }
            else 
            {
                color = getCol(uv);
            }
        
        
        
            //vec4 spritecolor = getCol(uv);
        
            gl_FragColor = color;
        }
    ')

    public function new()
    {
       super();
    }
}


class ColorFillEffect extends ShaderEffect
{
    public var shader(default,null):ColorFillShader = new ColorFillShader();
    public var red:Float = 0.0;
    public var green:Float = 0.0;
    public var blue:Float = 0.0;
    public var fade:Float = 1.0;
	public function new():Void
    {
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];
        shader.fade.value = [fade];
    }
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];
        shader.fade.value = [fade];
    }
}

class ColorFillShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform float red;
        uniform float green;
        uniform float blue;
        uniform float fade;
        
        void main()
        {
            vec4 spritecolor = flixel_texture2D(bitmap, openfl_TextureCoordv);
            vec4 col = vec4(red/255,green/255,blue/255, spritecolor.a);
            vec3 finalCol = mix(col.rgb*spritecolor.a, spritecolor.rgb, fade);
        
            gl_FragColor = vec4( finalCol.r, finalCol.g, finalCol.b, spritecolor.a );
        }
    ')

    public function new()
    {
       super();
    }
}

class ColorOverrideEffect extends ShaderEffect
{
    public var shader(default,null):ColorOverrideShader = new ColorOverrideShader();
    public var red:Float = 0.0;
    public var green:Float = 0.0;
    public var blue:Float = 0.0;
	public function new():Void
    {
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];
    }
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];
    }
}

class ColorOverrideShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform float red;
        uniform float green;
        uniform float blue;
        
        void main()
        {
            vec4 spritecolor = flixel_texture2D(bitmap, openfl_TextureCoordv);

            spritecolor.r *= red;
            spritecolor.g *= green;
            spritecolor.b *= blue;
        
            gl_FragColor = spritecolor;
        }
    ')

    public function new()
    {
       super();
    }
}

class ChromAbEffect extends ShaderEffect
{
	public var shader(default,null):ChromAbShader = new ChromAbShader();
	public var strength:Float = 0.0;

	public function new():Void
	{
		shader.strength.value = [0];
	}

	override public function update(elapsed:Float):Void
	{
		shader.strength.value[0] = strength;
	}
}

class ChromAbShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
		uniform float strength;

		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			vec4 col = flixel_texture2D(bitmap, uv);
			col.r = flixel_texture2D(bitmap, vec2(uv.x+strength, uv.y)).r;
			col.b = flixel_texture2D(bitmap, vec2(uv.x-strength, uv.y)).b;

			col = col * (1.0 - strength * 0.5);

			gl_FragColor = col;
		}')
	public function new()
	{
		super();
	}
}

class ChromAbBlueSwapEffect extends ShaderEffect
{
	public var shader(default,null):ChromAbBlueSwapShader = new ChromAbBlueSwapShader();
	public var strength:Float = 0.0;

	public function new():Void
	{
		shader.strength.value = [0];
	}

	override public function update(elapsed:Float):Void
	{
		shader.strength.value[0] = strength;
	}
}

class ChromAbBlueSwapShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
		uniform float strength;

		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			vec4 col = flixel_texture2D(bitmap, uv);
			col.r = flixel_texture2D(bitmap, vec2(uv.x+strength, uv.y)).r;
			col.g = flixel_texture2D(bitmap, vec2(uv.x-strength, uv.y)).g;

			col = col * (1.0 - strength * 0.5);

			gl_FragColor = col;
		}')
	public function new()
	{
		super();
	}
}

class GreyscaleEffect extends ShaderEffect
{
	public var shader(default,null):GreyscaleShader = new GreyscaleShader();
	public var strength:Float = 0.0;

	public function new():Void
	{
		shader.strength.value = [0];
	}

	override public function update(elapsed:Float):Void
	{
		shader.strength.value[0] = strength;
	}
}

class GreyscaleShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
		uniform float strength;

		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			vec4 col = flixel_texture2D(bitmap, uv);
			float grey = dot(col.rgb, vec3(0.299, 0.587, 0.114)); //https://en.wikipedia.org/wiki/Grayscale
			gl_FragColor = mix(col, vec4(grey,grey,grey, col.a), strength);
		}')
	public function new()
	{
		super();
	}
}

class SobelEffect extends ShaderEffect
{
	public var shader(default,null):SobelShader = new SobelShader();
	public var strength:Float = 1.0;
    public var intensity:Float = 1.0;

	public function new():Void
	{
		shader.strength.value = [0];
        shader.intensity.value = [0];
	}

	override public function update(elapsed:Float):Void
	{
		shader.strength.value[0] = strength;
        shader.intensity.value[0] = intensity;
	}
}

class SobelShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
		uniform float strength;
        uniform float intensity;

		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			vec4 col = flixel_texture2D(bitmap, uv);
            vec2 resFactor = (1/openfl_TextureSize.xy)*intensity;

            if (strength <= 0)
            {
                gl_FragColor = col;
                return;
            }

            //https://en.wikipedia.org/wiki/Sobel_operator
            //adsjklalskdfjhaslkdfhaslkdfhj

            vec4 topLeft = flixel_texture2D(bitmap, vec2(uv.x-resFactor.x, uv.y-resFactor.y));
            vec4 topMiddle = flixel_texture2D(bitmap, vec2(uv.x, uv.y-resFactor.y));
            vec4 topRight = flixel_texture2D(bitmap, vec2(uv.x+resFactor.x, uv.y-resFactor.y));

            vec4 midLeft = flixel_texture2D(bitmap, vec2(uv.x-resFactor.x, uv.y));
            vec4 midRight = flixel_texture2D(bitmap, vec2(uv.x+resFactor.x, uv.y));

            vec4 bottomLeft = flixel_texture2D(bitmap, vec2(uv.x-resFactor.x, uv.y+resFactor.y));
            vec4 bottomMiddle = flixel_texture2D(bitmap, vec2(uv.x, uv.y+resFactor.y));
            vec4 bottomRight = flixel_texture2D(bitmap, vec2(uv.x+resFactor.x, uv.y+resFactor.y));

            vec4 Gx = (topLeft) + (2*midLeft) + (bottomLeft) - (topRight) - (2*midRight) - (bottomRight);
            vec4 Gy = (topLeft) + (2*topMiddle) + (topRight) - (bottomLeft) - (2*bottomMiddle) - (bottomRight);
            vec4 G = sqrt((Gx*Gx) + (Gy*Gy));
			
			gl_FragColor = mix(col, G, strength);
		}')
	public function new()
	{
		super();
	}
}


class MosaicEffect extends ShaderEffect
{
	public var shader(default,null):MosaicShader = new MosaicShader();
	public var strength:Float = 0.0;

	public function new():Void
	{
		shader.strength.value = [0];
	}

	override public function update(elapsed:Float):Void
	{
		shader.strength.value[0] = strength;
	}
}

class MosaicShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
		uniform float strength;

		void main()
		{
            if (strength == 0.0)
            {
                gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
                return;
            }

			vec2 blocks = openfl_TextureSize / vec2(strength,strength);
			gl_FragColor = flixel_texture2D(bitmap, floor(openfl_TextureCoordv * blocks) / blocks);
		}')
	public function new()
	{
		super();
	}
}

class BlurEffect extends ShaderEffect
{
	public var shader(default,null):BlurShader = new BlurShader();
	public var strength:Float = 0.0;
    public var strengthY:Float = 0.0;
    public var vertical:Bool = false;

	public function new():Void
	{
		shader.strength.value = [0];
        shader.strengthY.value = [0];
        //shader.vertical.value[0] = vertical;
	}

	override public function update(elapsed:Float):Void
	{
		shader.strength.value[0] = strength;
        shader.strengthY.value[0] = strengthY;
        //shader.vertical.value = [vertical];
	}
}

class BlurShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
		uniform float strength;
        uniform float strengthY;
        //uniform bool vertical;

		void main()
		{
            //https://github.com/Jam3/glsl-fast-gaussian-blur/blob/master/5.glsl

            vec4 color = vec4(0.0,0.0,0.0,0.0);
            vec2 uv = openfl_TextureCoordv;
            vec2 resolution = vec2(1280.0,720.0);
            vec2 direction = vec2(strength, strengthY);
            //if (vertical)
            //{
            //    direction = vec2(0.0, 1.0);
            //}
            vec2 off1 = vec2(1.3333333333333333, 1.3333333333333333) * direction;
            color += flixel_texture2D(bitmap, uv) * 0.29411764705882354;
            color += flixel_texture2D(bitmap, uv + (off1 / resolution)) * 0.35294117647058826;
            color += flixel_texture2D(bitmap, uv - (off1 / resolution)) * 0.35294117647058826;
            
			gl_FragColor = color;
		}')
	public function new()
	{
		super();
	}
}

class BetterBlurEffect extends ShaderEffect
{
	public var shader(default,null):BetterBlurShader = new BetterBlurShader();
	public var loops:Float = 16.0;
    public var quality:Float = 5.0;
    public var strength:Float = 0.0;

	public function new():Void
	{
		shader.loops.value = [0];
        shader.quality.value = [0];
        shader.strength.value = [0];
	}

	override public function update(elapsed:Float):Void
	{
		shader.loops.value[0] = loops;
        shader.quality.value[0] = quality;
        shader.strength.value[0] = strength;
        //shader.vertical.value = [vertical];
	}
}

class BetterBlurShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		//https://www.shadertoy.com/view/Xltfzj
        //https://xorshaders.weebly.com/tutorials/blur-shaders-5-part-2

		uniform float strength;
        uniform float loops;
        uniform float quality;
        float Pi = 6.28318530718; // Pi*2

		void main()
		{
            vec2 uv = openfl_TextureCoordv;
            vec4 color = flixel_texture2D(bitmap, uv);
            vec2 resolution = vec2(1280.0,720.0);
            
            vec2 rad = strength/openfl_TextureSize;

            for( float d=0.0; d<Pi; d+=Pi/loops)
            {
                for(float i=1.0/quality; i<=1.0; i+=1.0/quality)
                {
                    color += flixel_texture2D( bitmap, uv+vec2(cos(d),sin(d))*rad*i);		
                }
            }
            
            color /= quality * loops - 15.0;
			gl_FragColor = color;
		}')
	public function new()
	{
		super();
	}
}

class VortexEffect extends ShaderEffect
{
	public var shader(default,null):VortexShader = new VortexShader();
	public var iTime:Float = 0;
    public var speed:Float = 3;

    public var red:Float = 2.5;
    public var green:Float = 1.0;
    public var blue:Float = 1.5;

	public function new():Void
	{
        shader.uTime.value = [0, 0, 0];
        red = 2.5*0.7;
        green = 1.0*0.7;
        blue = 1.5*0.7;
        update(0);
	}

	override public function update(elapsed:Float):Void
	{
        iTime += elapsed * speed;
		shader.iTime.value = [iTime];
        shader.spiralColor.value = [red,green,blue];
	}

    public var hue(default, set):Float = 0;
	public var saturation(default, set):Float = 0;
	public var brightness(default, set):Float = 0;

	private function set_hue(value:Float) {
		hue = value;
		shader.uTime.value[0] = hue;
		return hue;
	}

	private function set_saturation(value:Float) {
		saturation = value;
		shader.uTime.value[1] = saturation;
		return saturation;
	}

	private function set_brightness(value:Float) {
		brightness = value;
		shader.uTime.value[2] = brightness;
		return brightness;
	}
}

class VortexShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header

    //forked from https://www.shadertoy.com/view/Md3SWH
    
    uniform float iTime;
    uniform vec3 spiralColor;
    float radius = 20.0;
    float radiusInv = 0.05;

    uniform vec3 uTime; //colorswap stuff
    vec3 rgb2hsv(vec3 c)
    {
        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }

    vec3 hsv2rgb(vec3 c)
    {
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }
    
    //noise funcs: https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
    float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
    vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
    vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}
    
    float noise(vec3 p){
        vec3 a = floor(p);
        vec3 d = p - a;
        d = d * d * (3.0 - 2.0 * d);
    
        vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
        vec4 k1 = perm(b.xyxy);
        vec4 k2 = perm(k1.xyxy + b.zzww);
    
        vec4 c = k2 + a.zzzz;
        vec4 k3 = perm(c);
        vec4 k4 = perm(c + 1.0);
    
        vec4 o1 = fract(k3 * (1.0 / 41.0));
        vec4 o2 = fract(k4 * (1.0 / 41.0));
    
        vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
        vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);
    
        return o4.y * d.y + o4.x * (1.0 - d.y);
    }
    
    float fbm(vec3 pos)
    {
        vec3 q = pos;
        float f  = 0.5*noise( q ); q = q*2.01;
        f += 0.2500*noise( q ); q = q*2.02;
        f += 0.1250*noise( q ); q = q*2.03;
        f += 0.0625*noise( q ); q = q*2.01;
        return f;
    }
    
    float galaxyNoise(vec2 uv, float angle, float speed)
    {
        float dist = length(uv);    
        float percent = max(0., (radius - dist) * radiusInv);
        float theta = iTime * speed + percent * percent * angle;
        vec2 cs = vec2(cos(theta), sin(theta));
        uv *= mat2(cs.x, -cs.y, cs.y, cs.x);
        
        float n = abs(fbm(vec3(uv, iTime) * 0.2) - 0.5) * 2.5;
        float nSmall = smoothstep(0.2, 0.0, n);
        
        float result = 0.;
        result += nSmall * 0.6;
        result += n;
        result += smoothstep(0.75, 1., percent);
        result *= smoothstep(0.2, 0.7, percent);
        return pow(result, 2.);
    }
    
    vec3 galaxy(vec2 uv)
    {
        float f = 0.;
        f += galaxyNoise(uv * 1.0, 9.0, 0.15) * 0.5;
        f += galaxyNoise(uv * 1.3, 11.0, -0.1) * 0.6;
        f += galaxyNoise(uv * 1.6, 8.0, 0.1) * 0.7;
        f = max(0., f);
        
        vec3 color = mix(spiralColor, vec3(0.0, 0.0, 0.0), length(uv) * radiusInv); 
        color *= f;
        
        return color;
    }
    
    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy-0.5;
    
        //vec2 uv = (fragCoord.xy / iResolution.xy - vec2(0.5)) * vec2(iResolution.x / iResolution.y, 1.);
        uv *= 5. + 0. * cos(iTime * 0.3);
        vec4 color = vec4(galaxy(uv * 3.),1.0);

        vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);
        swagColor[0] = swagColor[0] + uTime[0];
        swagColor[1] = swagColor[1] + uTime[1];
        swagColor[2] = swagColor[2] * (1.0 + uTime[2]);
        if(swagColor[1] < 0.0)
        {
            swagColor[1] = 0.0;
        }
        else if(swagColor[1] > 1.0)
        {
            swagColor[1] = 1.0;
        }
        gl_FragColor = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);
    }

    ')
	public function new()
	{
		super();
	}
}




class BloomEffect extends ShaderEffect
{
    public var shader:BloomShader = new BloomShader();
    public var effect:Float = 5;
    public var strength:Float = 0.2;
    public var contrast:Float = 1.0;
    public var brightness:Float = 0.0;
    public function new(){
        shader.effect.value = [effect];
        shader.strength.value = [strength];
        shader.iResolution.value = [FlxG.width,FlxG.height];
        shader.contrast.value = [contrast];
        shader.brightness.value = [brightness];
    }

    override public function update(elapsed:Float){
        shader.effect.value = [effect];
        shader.strength.value = [strength];
        shader.iResolution.value = [FlxG.width,FlxG.height];
        shader.contrast.value = [contrast];
        shader.brightness.value = [brightness];
    }
}

class BloomShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header

    uniform float effect;
    uniform float strength;


    uniform float contrast;
    uniform float brightness;

    uniform vec2 iResolution;

    void main()
    {
        vec2 uv = openfl_TextureCoordv;


		vec4 color = flixel_texture2D(bitmap,uv);
        //float brightness = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));

        //vec4 newColor = vec4(color.rgb * brightness * strength * color.a, color.a);

        //got some stuff from here: https://github.com/amilajack/gaussian-blur/blob/master/src/9.glsl
        //this also helped to understand: https://learnopengl.com/Advanced-Lighting/Bloom


        color.rgb *= contrast;
        color.rgb += vec3(brightness,brightness,brightness);

        if (effect <= 0)
        {
            gl_FragColor = color;
            return;
        }


        vec2 off1 = vec2(1.3846153846) * effect;
        vec2 off2 = vec2(3.2307692308) * effect;

        color += flixel_texture2D(bitmap, uv) * 0.2270270270 * strength;
        color += flixel_texture2D(bitmap, uv + (off1 / iResolution)) * 0.3162162162 * strength;
        color += flixel_texture2D(bitmap, uv - (off1 / iResolution)) * 0.3162162162 * strength;
        color += flixel_texture2D(bitmap, uv + (off2 / iResolution)) * 0.0702702703 * strength;
        color += flixel_texture2D(bitmap, uv - (off2 / iResolution)) * 0.0702702703 * strength;

		gl_FragColor = color;
    }')
    public function new()
        {
          super();
        } 
}

class BloomVerticalEffect extends ShaderEffect
{
    public var shader:BloomVerticalShader = new BloomVerticalShader();
    public var effect:Float = 15;
    public var strength:Float = 0.25;
    public function new(){
        shader.effect.value = [effect];
        shader.strength.value = [strength];
    }

    override public function update(elapsed:Float){
        shader.effect.value = [effect];
        shader.strength.value = [strength];
    }
}

class BloomVerticalShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header

    uniform float effect;
    uniform float strength;
    
    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        vec2 iResolution = vec2(1280.0, 720.0);
        vec2 res = 1.0 / iResolution;
        //vec4 color = ;
    
        if (effect <= 0)
        {
            gl_FragColor = flixel_texture2D(bitmap,uv);
            return;
        }
    
        vec4 color = vec4(0.0);
        vec2 off1 = vec2(0.0, 1.3333333333333333) * effect;
        vec2 off2 = vec2(1.3333333333333333);
    
        color += flixel_texture2D(bitmap, uv);
    
        color += flixel_texture2D(bitmap, (uv + (off1 * res)) + (off2 * res)) * 0.35294117647058826 * strength * 0.5;
        color += flixel_texture2D(bitmap, (uv - (off1 * res)) + (off2 * res)) * 0.35294117647058826 * strength * 0.5;
        color += flixel_texture2D(bitmap, (uv + (off1 * res)) - (off2 * res)) * 0.35294117647058826 * strength * 0.5;
        color += flixel_texture2D(bitmap, (uv - (off1 * res)) - (off2 * res)) * 0.35294117647058826 * strength * 0.5;
    
        gl_FragColor = color;
    }')
    public function new()
        {
          super();
        } 
}



class VignetteEffect extends ShaderEffect
{
	public var shader(default,null):VignetteShader = new VignetteShader();
	public var strength:Float = 1.0;
    public var size:Float = 0.0;
    public var red:Float = 0.0;
    public var green:Float = 0.0;
    public var blue:Float = 0.0;

	public function new():Void
	{
		shader.strength.value = [0];
        shader.size.value = [0];
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];
	}

	override public function update(elapsed:Float):Void
	{
		shader.strength.value[0] = strength;
        shader.size.value[0] = size;
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];
	}
}

class VignetteShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
		uniform float strength;
        uniform float size;

        uniform float red;
        uniform float green;
        uniform float blue;

		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			vec4 col = flixel_texture2D(bitmap, uv);

            //modified from this
            //https://www.shadertoy.com/view/lsKSWR

            uv = uv * (1.0 - uv.yx);
            float vig = uv.x*uv.y * strength; 
            vig = pow(vig, size);

            vig = 0.0-vig+1.0;

            vec3 vigCol = vec3(vig,vig,vig);
            vigCol.r = vigCol.r * (red/255);
            vigCol.g = vigCol.g * (green/255);
            vigCol.b = vigCol.b * (blue/255);
            col.rgb += vigCol;
            col.a += vig;

			gl_FragColor = col;
		}')
	public function new()
	{
		super();
	}
}

class BarrelBlurEffect extends ShaderEffect
{
	public var shader(default,null):BarrelBlurShader = new BarrelBlurShader();
    public var barrel:Float = 2.0;
	public var zoom:Float = 5.0;
    public var doChroma:Bool = false;
    var iTime:Float = 0.0;

    public var angle:Float = 0.0;

    public var x:Float = 0.0;
    public var y:Float = 0.0;

	public function new():Void
	{
		shader.barrel.value = [barrel];
        shader.zoom.value = [zoom];
        shader.doChroma.value = [doChroma];
        shader.angle.value = [angle];
        shader.iTime.value = [0.0];
        shader.x.value = [x];
        shader.y.value = [y];
	}

	override public function update(elapsed:Float):Void
	{
		shader.barrel.value = [barrel];
        shader.zoom.value = [zoom];
        shader.doChroma.value = [doChroma];
        shader.angle.value = [angle];
        iTime += elapsed;
        shader.iTime.value = [iTime];
        shader.x.value = [x];
        shader.y.value = [y];
	}
}

class BarrelBlurShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
        uniform float barrel;
        uniform float zoom;
        uniform bool doChroma;
        uniform float angle;
        uniform float iTime;

        uniform float x;
        uniform float y;

        //edited version of this
        //https://www.shadertoy.com/view/td2XDz

        vec2 remap( vec2 t, vec2 a, vec2 b ) {
            return clamp( (t - a) / (b - a), 0.0, 1.0 );
        }

        vec4 spectrum_offset_rgb( float t )
        {
            if (!doChroma)
                return vec4(1.0,1.0,1.0,1.0); //turn off chroma
            float t0 = 3.0 * t - 1.5;
            vec3 ret = clamp( vec3( -t0, 1.0-abs(t0), t0), 0.0, 1.0);
            return vec4(ret.r,ret.g,ret.b, 1.0);
        }

        vec2 brownConradyDistortion(vec2 uv, float dist)
        {
            uv = uv * 2.0 - 1.0;
            float barrelDistortion1 = 0.1 * dist; // K1 in text books
            float barrelDistortion2 = -0.025 * dist; // K2 in text books

            float r2 = dot(uv,uv);
            uv *= 1.0 + barrelDistortion1 * r2 + barrelDistortion2 * r2 * r2;
            
            return uv * 0.5 + 0.5;
        }

        vec2 distort( vec2 uv, float t, vec2 min_distort, vec2 max_distort )
        {
            vec2 dist = mix( min_distort, max_distort, t );
            return brownConradyDistortion( uv, 75.0 * dist.x );
        }

        float nrand( vec2 n )
        {
            return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
        }

        vec4 render( vec2 uv )
        {
            uv.x += x;
            uv.y += y;
            
            //funny mirroring shit
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;



            return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
        }

        void main()
        {	
            vec2 iResolution = vec2(1280,720);
            //rotation bullshit
            vec2 center = vec2(0.5,0.5);
            vec2 uv = openfl_TextureCoordv.xy;
            


            //uv = uv.xy - center; //move uv center point from center to top left

            mat2 translation = mat2(
                0, 0,
                0, 0 );


            mat2 scaling = mat2(
                zoom, 0.0,
                0.0, zoom );

            //uv = uv * scaling;

            float angInRad = radians(angle);
            mat2 rotation = mat2(
                cos(angInRad), -sin(angInRad),
                sin(angInRad), cos(angInRad) );

            //used to stretch back into 16:9
            //0.5625 is from 9/16
            mat2 aspectRatioShit = mat2(
                0.5625, 0.0,
                0.0, 1.0 );

            vec2 fragCoordShit = iResolution*openfl_TextureCoordv.xy;
            uv = ( fragCoordShit - .5*iResolution.xy ) / iResolution.y;
            uv = uv * scaling;
            uv = (aspectRatioShit) * (rotation * uv);
            uv = uv.xy + center; //move back to center
            
            const float MAX_DIST_PX = 50.0;
            float max_distort_px = MAX_DIST_PX * barrel;
            vec2 max_distort = vec2(max_distort_px) / iResolution.xy;
            vec2 min_distort = 0.5 * max_distort;
            
            vec2 oversiz = distort( vec2(1.0), 1.0, min_distort, max_distort );
            uv = mix(uv,remap( uv, 1.0-oversiz, oversiz ),0.0);
            
            const int num_iter = 7;
            const float stepsiz = 1.0 / (float(num_iter)-1.0);
            float rnd = nrand( uv + fract(iTime) );
            float t = rnd*stepsiz;
            
            vec4 sumcol = vec4(0.0);
            vec3 sumw = vec3(0.0);
            for ( int i=0; i<num_iter; ++i )
            {
                vec4 w = spectrum_offset_rgb( t );
                sumw += w.rgb;
                vec2 uvd = distort(uv, t, min_distort, max_distort);
                sumcol += w * render( uvd );
                t += stepsiz;
            }
            sumcol.rgb /= sumw;
            
            vec3 outcol = sumcol.rgb;
            outcol =  outcol;
            outcol += rnd/255.0;
            
            gl_FragColor = vec4( outcol, sumcol.a / num_iter);
        }

        ')
	public function new()
	{
		super();
	}
}
//same thingy just copied so i can use it in scripts
/**
 * Cool Shader by ShadowMario that changes RGB based on HSV.
 */
 class ColorSwapEffect extends ShaderEffect 
 {
	public var shader(default, null):ColorSwap.ColorSwapShader = new ColorSwap.ColorSwapShader();
	public var hue(default, set):Float = 0;
	public var saturation(default, set):Float = 0;
	public var brightness(default, set):Float = 0;

	private function set_hue(value:Float) {
		hue = value;
		shader.uTime.value[0] = hue;
		return hue;
	}

	private function set_saturation(value:Float) {
		saturation = value;
		shader.uTime.value[1] = saturation;
		return saturation;
	}

	private function set_brightness(value:Float) {
		brightness = value;
		shader.uTime.value[2] = brightness;
		return brightness;
	}

	public function new()
	{
		shader.uTime.value = [0, 0, 0];
		shader.awesomeOutline.value = [false];
	}
}


class HeatEffect extends ShaderEffect
{
	public var shader(default,null):HeatShader = new HeatShader();
    public var strength:Float = 1.0;
    var iTime:Float = 0.0;


	public function new():Void
	{
        shader.strength.value = [strength];
        shader.iTime.value = [0.0];
	}

	override public function update(elapsed:Float):Void
	{
		shader.strength.value = [strength];
        iTime += elapsed;
        shader.iTime.value = [iTime];
	}
}

class HeatShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		
        uniform float strength;
        uniform float iTime;
        
        float rand(vec2 n) { return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);}
        float noise(vec2 n) 
        {
            const vec2 d = vec2(0.0, 1.0);
            vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
            return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
        }

        //https://www.shadertoy.com/view/XsVSRd 
        //edited version of this
        //partially using a version in the comments that doesnt use a texture and uses noise instead
            
        void main()
        {	
            
            vec2 uv = openfl_TextureCoordv.xy;
            vec2 offsetUV = vec4(noise(vec2(uv.x,uv.y+(iTime*0.1)) * vec2(50))).xy;
            offsetUV -= vec2(.5,.5);
            offsetUV *= 2.;
            offsetUV *= 0.01*0.1*strength;
            offsetUV *= (1. + uv.y);
            
            gl_FragColor = flixel_texture2D( bitmap, uv+offsetUV );
        }

        ')
	public function new()
	{
		super();
	}
}

class MirrorRepeatEffect extends ShaderEffect
{
	public var shader(default,null):MirrorRepeatShader = new MirrorRepeatShader();
	public var zoom:Float = 5.0;
    var iTime:Float = 0.0;

    public var angle:Float = 0.0;

    public var x:Float = 0.0;
    public var y:Float = 0.0;

	public function new():Void
	{
        shader.zoom.value = [zoom];
        shader.angle.value = [angle];
        shader.iTime.value = [0.0];
        shader.x.value = [x];
        shader.y.value = [y];
	}

	override public function update(elapsed:Float):Void
	{
        shader.zoom.value = [zoom];
        shader.angle.value = [angle];
        iTime += elapsed;
        shader.iTime.value = [iTime];
        shader.x.value = [x];
        shader.y.value = [y];
	}
}

//moved to a seperate shader because not all modcharts need the barrel shit and probably runs slightly better on weaker pcs
class MirrorRepeatShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        //written by TheZoroForce240
		
        uniform float zoom;
        uniform float angle;
        uniform float iTime;

        uniform float x;
        uniform float y;

        vec4 render( vec2 uv )
        {
            uv.x += x;
            uv.y += y;
            
            //funny mirroring shit
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;

            return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
        }

        void main()
        {	
            vec2 iResolution = vec2(1280,720);
            //rotation bullshit
            vec2 center = vec2(0.5,0.5);
            vec2 uv = openfl_TextureCoordv.xy;

            mat2 scaling = mat2(
                zoom, 0.0,
                0.0, zoom );

            //uv = uv * scaling;

            float angInRad = radians(angle);
            mat2 rotation = mat2(
                cos(angInRad), -sin(angInRad),
                sin(angInRad), cos(angInRad) );

            //used to stretch back into 16:9
            //0.5625 is from 9/16
            mat2 aspectRatioShit = mat2(
                0.5625, 0.0,
                0.0, 1.0 );

            vec2 fragCoordShit = iResolution*openfl_TextureCoordv.xy;
            uv = ( fragCoordShit - .5*iResolution.xy ) / iResolution.y; //this helped a little, specifically the guy in the comments: https://www.shadertoy.com/view/tsSXzt
            uv = uv * scaling;
            uv = (aspectRatioShit) * (rotation * uv);
            uv = uv.xy + center; //move back to center
            
            gl_FragColor = render(uv);
        }

        ')
	public function new()
	{
		super();
	}
}

//https://www.shadertoy.com/view/MlfBWr
//le shader
class RainEffect extends ShaderEffect
{
	public var shader(default,null):RainShader = new RainShader();
    var iTime:Float = 0.0;


	public function new():Void
	{
        shader.iTime.value = [0.0];
	}

	override public function update(elapsed:Float):Void
	{
        iTime += elapsed;
        shader.iTime.value = [iTime];
	}
}

class RainShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
            
        uniform float iTime;

        vec2 rand(vec2 c){
            mat2 m = mat2(12.9898,.16180,78.233,.31415);
            return fract(sin(m * c) * vec2(43758.5453, 14142.1));
        }

        vec2 noise(vec2 p){
            vec2 co = floor(p);
            vec2 mu = fract(p);
            mu = 3.*mu*mu-2.*mu*mu*mu;
            vec2 a = rand((co+vec2(0.,0.)));
            vec2 b = rand((co+vec2(1.,0.)));
            vec2 c = rand((co+vec2(0.,1.)));
            vec2 d = rand((co+vec2(1.,1.)));
            return mix(mix(a, b, mu.x), mix(c, d, mu.x), mu.y);
        }

        vec2 round(vec2 num)
        {
            num.x = floor(num.x + 0.5);
            num.y = floor(num.y + 0.5);
            return num;
        }




        void main()
        {	
            vec2 iResolution = vec2(1280,720);
            vec2 c = openfl_TextureCoordv.xy;

            vec2 u = c,
                    v = (c*.1),
                    n = noise(v*200.); // Displacement
            
            vec4 f = flixel_texture2D(bitmap, openfl_TextureCoordv.xy);
            
            // Loop through the different inverse sizes of drops
            for (float r = 4. ; r > 0. ; r--) {
                vec2 x = iResolution.xy * r * .015,  // Number of potential drops (in a grid)
                        p = 6.28 * u * x + (n - .5) * 2.,
                        s = sin(p);
                
                // Current drop properties. Coordinates are rounded to ensure a
                // consistent value among the fragment of a given drop.
                vec2 v = round(u * x - 0.25) / x;
                vec4 d = vec4(noise(v*200.), noise(v));
                
                // Drop shape and fading
                float t = (s.x+s.y) * max(0., 1. - fract(iTime * (d.b + .1) + d.g) * 2.);;
                
                // d.r -> only x% of drops are kept on, with x depending on the size of drops
                if (d.r < (5.-r)*.08 && t > .5) {
                    // Drop normal
                    vec3 v = normalize(-vec3(cos(p), mix(.2, 2., t-.5)));
                    // fragColor = vec4(v * 0.5 + 0.5, 1.0);  // show normals
                    
                    // Poor mans refraction (no visual need to do more)
                    f = flixel_texture2D(bitmap, u - v.xy * .3);
                }
            }
            gl_FragColor = f;
        }

        ')
	public function new()
	{
		super();
	}
}

class ScanlineEffect extends ShaderEffect
{
	public var shader(default,null):ScanlineShader = new ScanlineShader();
    public var strength:Float = 0.0;
    public var pixelsBetweenEachLine:Float = 15.0;
    public var smooth:Bool = false;

	public function new():Void
	{
        shader.strength.value = [strength];
        shader.pixelsBetweenEachLine.value = [pixelsBetweenEachLine];
        shader.smoothVar.value = [smooth];
	}

	override public function update(elapsed:Float):Void
	{
        shader.strength.value = [strength];
        shader.pixelsBetweenEachLine.value = [pixelsBetweenEachLine];
        shader.smoothVar.value = [smooth];
	}
}

class ScanlineShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
            
        uniform float strength;
        uniform float pixelsBetweenEachLine;
        uniform bool smoothVar;

        float m(float a, float b) //was having an issue with mod so i did this to try and fix it
        {
            return a - (b * floor(a/b));
        }

        void main()
        {	
            vec2 iResolution = vec2(1280.0,720.0);
            vec2 uv = openfl_TextureCoordv.xy;
            vec2 fragCoordShit = iResolution*uv;

            vec4 col = flixel_texture2D(bitmap, uv);

            if (smoothVar)
            {
                float apply = abs(sin(fragCoordShit.y)*0.5*pixelsBetweenEachLine);
                vec3 finalCol = mix(col.rgb, vec3(0.0, 0.0, 0.0), apply);
                vec4 scanline = vec4(finalCol.r, finalCol.g, finalCol.b, col.a);
    	        gl_FragColor = mix(col, scanline, strength);
                return;
            }

            vec4 scanline = flixel_texture2D(bitmap, uv);
            if (m(floor(fragCoordShit.y), pixelsBetweenEachLine) == 0.0)
            {
                scanline = vec4(0.0,0.0,0.0,1.0);
            }
            
            gl_FragColor = mix(col, scanline, strength);
        }

        ')
	public function new()
	{
		super();
	}
}

class PerlinSmokeEffect extends ShaderEffect
{
	public var shader(default,null):PerlinSmokeShader = new PerlinSmokeShader();
    public var waveStrength:Float = 0; //for screen wave (only for ruckus)
    public var smokeStrength:Float = 1;
    public var speed:Float = 1;
    var iTime:Float = 0.0;
	public function new():Void
	{
        shader.waveStrength.value = [waveStrength];
        shader.smokeStrength.value = [smokeStrength];
        shader.iTime.value = [0.0];
	}

	override public function update(elapsed:Float):Void
	{
        shader.waveStrength.value = [waveStrength];
        shader.smokeStrength.value = [smokeStrength];
        iTime += elapsed*speed;
        shader.iTime.value = [iTime];
	}
}

class PerlinSmokeShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header
		
    uniform float iTime;
    uniform float waveStrength;
    uniform float smokeStrength;
    
    
    //https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
    //	Classic Perlin 3D Noise 
    //	by Stefan Gustavson
    //
    vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
    vec4 taylorInvSqrt(vec4 r){return 1.79284291400159 - 0.85373472095314 * r;}
    vec3 fade(vec3 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}
    
    float cnoise(vec3 P){
      vec3 Pi0 = floor(P); // Integer part for indexing
      vec3 Pi1 = Pi0 + vec3(1.0); // Integer part + 1
      Pi0 = mod(Pi0, 289.0);
      Pi1 = mod(Pi1, 289.0);
      vec3 Pf0 = fract(P); // Fractional part for interpolation
      vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
      vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
      vec4 iy = vec4(Pi0.yy, Pi1.yy);
      vec4 iz0 = Pi0.zzzz;
      vec4 iz1 = Pi1.zzzz;
    
      vec4 ixy = permute(permute(ix) + iy);
      vec4 ixy0 = permute(ixy + iz0);
      vec4 ixy1 = permute(ixy + iz1);
    
      vec4 gx0 = ixy0 / 7.0;
      vec4 gy0 = fract(floor(gx0) / 7.0) - 0.5;
      gx0 = fract(gx0);
      vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
      vec4 sz0 = step(gz0, vec4(0.0));
      gx0 -= sz0 * (step(0.0, gx0) - 0.5);
      gy0 -= sz0 * (step(0.0, gy0) - 0.5);
    
      vec4 gx1 = ixy1 / 7.0;
      vec4 gy1 = fract(floor(gx1) / 7.0) - 0.5;
      gx1 = fract(gx1);
      vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
      vec4 sz1 = step(gz1, vec4(0.0));
      gx1 -= sz1 * (step(0.0, gx1) - 0.5);
      gy1 -= sz1 * (step(0.0, gy1) - 0.5);
    
      vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
      vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
      vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
      vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
      vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
      vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
      vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
      vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);
    
      vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
      g000 *= norm0.x;
      g010 *= norm0.y;
      g100 *= norm0.z;
      g110 *= norm0.w;
      vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
      g001 *= norm1.x;
      g011 *= norm1.y;
      g101 *= norm1.z;
      g111 *= norm1.w;
    
      float n000 = dot(g000, Pf0);
      float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
      float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
      float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
      float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
      float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
      float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
      float n111 = dot(g111, Pf1);
    
      vec3 fade_xyz = fade(Pf0);
      vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
      vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
      float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
      return 2.2 * n_xyz;
    }
    
    float generateSmoke(vec2 uv, vec2 offset, float scale, float speed)
    {
        return cnoise(vec3((uv.x+offset.x)*scale, (uv.y+offset.y)*scale, iTime*speed));
    }
    
    float getSmoke(vec2 uv)
    {
      float smoke = 0.0;
      if (smokeStrength == 0.0)
        return smoke;
    
      float smoke1 = generateSmoke(uv, vec2(0.0-(iTime*0.5),0.0+sin(iTime*0.1)+(iTime*0.1)), 1.0, 0.5*0.1);
      float smoke2 = generateSmoke(uv, vec2(200.0-(iTime*0.2),200.0+sin(iTime*0.1)+(iTime*0.05)), 4.0, 0.3*0.1);
      float smoke3 = generateSmoke(uv, vec2(700.0-(iTime*0.1),700.0+sin(iTime*0.1)+(iTime*0.1)), 6.0, 0.7*0.1);
      smoke = smoke1*smoke2*smoke3*2.0;
    
      return smoke*smokeStrength;
    }
        
    void main()
    {	
        
        vec2 uv = openfl_TextureCoordv.xy + vec2(sin(cnoise(vec3(0.0,openfl_TextureCoordv.y*2.5,iTime))), 0.0)*waveStrength;
        vec2 smokeUV = uv;
        float smokeFactor = getSmoke(uv);
        if (smokeFactor < 0.0)
          smokeFactor = 0.0;
        
        vec3 finalCol = flixel_texture2D( bitmap, uv ).rgb + smokeFactor;
        
        gl_FragColor = vec4(finalCol.r, finalCol.g, finalCol.b, flixel_texture2D( bitmap, uv ).a);
    }

        ')
	public function new()
	{
		super();
	}
}


class WaveBurstEffect extends ShaderEffect
{
	public var shader(default,null):WaveBurstShader = new WaveBurstShader();
    public var strength:Float = 0.0;

	public function new():Void
	{
        shader.strength.value = [strength];
	}

	override public function update(elapsed:Float):Void
	{
        shader.strength.value = [strength];
	}
}

class WaveBurstShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
            
        uniform float strength;
        float nrand( vec2 n )
        {
            return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
        }
            
        void main()
        {	
            
            vec2 uv = openfl_TextureCoordv.xy;
            vec4 col = flixel_texture2D( bitmap, uv );
            float rnd = sin(uv.y*1000.0)*strength;
            rnd += nrand(uv)*strength;
    
            col = flixel_texture2D( bitmap, vec2(uv.x - rnd, uv.y) );
        
            gl_FragColor = col;
        }

        ')
	public function new()
	{
		super();
	}
}

class WaterEffect extends ShaderEffect
{
	public var shader(default,null):WaterShader = new WaterShader();
    public var strength:Float = 10.0;
    public var iTime:Float = 0.0;
    public var speed:Float = 1.0;

	public function new():Void
	{
        shader.strength.value = [strength];
        shader.iTime.value = [iTime];
	}

	override public function update(elapsed:Float):Void
	{
        shader.strength.value = [strength];
        iTime += elapsed*speed;
        shader.iTime.value = [iTime];
	}
}

class WaterShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header
            
        uniform float iTime;
        uniform float strength;
        
        vec2 mirror(vec2 uv)
        {
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;
            return vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0)));
        }
        vec2 warp(vec2 uv)
        {
            vec2 warp = strength*(uv+iTime);
            uv = vec2(cos(warp.x-warp.y)*cos(warp.y),
            sin(warp.x-warp.y)*sin(warp.y));
            return uv;
        }
        
        void main()
        {	
            
            vec2 uv = openfl_TextureCoordv.xy;
            vec4 col = flixel_texture2D( bitmap, mirror(uv + (warp(uv)-warp(uv+1.0))*(0.0035) ) );
        
            gl_FragColor = col;
        }

        ')
	public function new()
	{
		super();
	}
}

class RayMarchEffect extends ShaderEffect
{
    public var shader:RayMarchShader = new RayMarchShader();
	public var x:Float = 0;
	public var y:Float = 0;
    public var z:Float = 0;
    public var zoom:Float = -2;
    public function new(){
        shader.iResolution.value = [1280,720];
        shader.rotation.value = [0, 0, 0];
        shader.zoom.value = [zoom];
    }
  
    override public function update(elapsed:Float){
        shader.iResolution.value = [1280,720];
        
        shader.rotation.value = [x*FlxAngle.TO_RAD, y*FlxAngle.TO_RAD, z*FlxAngle.TO_RAD];
        shader.zoom.value = [zoom];
    }

    public function setPoint(){
        
    }
}

//shader from here: https://www.shadertoy.com/view/WtGXDD
class RayMarchShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header

    // "RayMarching starting point" 
    // by Martijn Steinrucken aka The Art of Code/BigWings - 2020
    // The MIT License
    // Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    // Email: countfrolic@gmail.com
    // Twitter: @The_ArtOfCode
    // YouTube: youtube.com/TheArtOfCodeIsCool
    // Facebook: https://www.facebook.com/groups/theartofcode/
    //
    // You can use this shader as a template for ray marching shaders

    #define MAX_STEPS 100
    #define MAX_DIST 100.
    #define SURF_DIST .001

    #define S smoothstep
    #define T iTime

    uniform vec3 rotation;
    uniform vec3 iResolution;
    uniform float zoom;

    // Rotation matrix around the X axis.
    mat3 rotateX(float theta) {
        float c = cos(theta);
        float s = sin(theta);
        return mat3(
            vec3(1, 0, 0),
            vec3(0, c, -s),
            vec3(0, s, c)
        );
    }

    // Rotation matrix around the Y axis.
    mat3 rotateY(float theta) {
        float c = cos(theta);
        float s = sin(theta);
        return mat3(
            vec3(c, 0, s),
            vec3(0, 1, 0),
            vec3(-s, 0, c)
        );
    }

    // Rotation matrix around the Z axis.
    mat3 rotateZ(float theta) {
        float c = cos(theta);
        float s = sin(theta);
        return mat3(
            vec3(c, -s, 0),
            vec3(s, c, 0),
            vec3(0, 0, 1)
        );
    }

    mat2 Rot(float a) {
        float s=sin(a), c=cos(a);
        return mat2(c, -s, s, c);
    }

    float sdBox(vec3 p, vec3 s) {
        //p = p * rotateX(rotation.x) * rotateY(rotation.y) * rotateZ(rotation.z);
        p = abs(p)-s;
        return length(max(p, 0.))+min(max(p.x, max(p.y, p.z)), 0.);
    }
    float plane(vec3 p, vec3 offset) {
        float d = p.z;
        return d;
    }


    float GetDist(vec3 p) {
        float d = sdBox(p, vec3(1.0,1.0,0.01));
        
        return d;
    }

    float RayMarch(vec3 ro, vec3 rd) {
        float dO=0.;
        
        for(int i=0; i<MAX_STEPS; i++) {
            vec3 p = ro + rd*dO;
            float dS = GetDist(p);
            dO += dS;
            if(dO>MAX_DIST || abs(dS)<SURF_DIST) break;
        }
        
        return dO;
    }

    vec3 GetNormal(vec3 p) {
        float d = GetDist(p);
        vec2 e = vec2(.001, 0.0);
        
        vec3 n = d - vec3(
            GetDist(p-e.xyy),
            GetDist(p-e.yxy),
            GetDist(p-e.yyx));
        
        return normalize(n);
    }

    vec3 GetRayDir(vec2 uv, vec3 p, vec3 l, float z) {
        vec3 f = normalize(l-p),
            r = normalize(cross(vec3(0.0,1.0,0.0), f)),
            u = cross(f,r),
            c = f*z,
            i = c + uv.x*r + uv.y*u,
            d = normalize(i);
        return d;
    }

    vec4 getColor(vec2 uv)
    {
        if (uv.x > 1.0 || uv.x < 0.0 || uv.y > 1.0 || uv.y < 0.0)
            return vec4(0.0, 0.0, 0.0, 0.0); //hide

        return flixel_texture2D(bitmap, uv);
    }

    void main() //this shader is pain
    {
        vec2 center = vec2(0.5, 0.5);
        vec2 uv = openfl_TextureCoordv.xy - center;

        uv.x = 0-uv.x;

        vec3 ro = vec3(0.0, 0.0, zoom);

        ro = ro * rotateX(rotation.x) * rotateY(rotation.y) * rotateZ(rotation.z);

        //ro.yz *= Rot(ShaderPointShit.y); //rotation shit
        //ro.xz *= Rot(ShaderPointShit.x);
        
        vec3 rd = GetRayDir(uv, ro, vec3(0.0,0.,0.0), 1.0);
        vec4 col = vec4(0.0);
    
        float d = RayMarch(ro, rd);

        if(d<MAX_DIST) {
            vec3 p = ro + rd * d;
            uv = vec2(p.x,p.y) * 0.5;
            uv += center; //move coords from top left to center
            col = getColor(uv); //shadertoy to haxe bullshit i barely understand
        }        
        gl_FragColor = col;
    }')
    public function new()
        {
          super();
        } 
}

class SparkEffect extends ShaderEffect
{
	public var shader(default,null):SparkShader = new SparkShader();
    public var red:Float = 0.7;
    public var green:Float = 0.22;
    public var blue:Float = 0.95;

    public var size:Float = 140.0;
    public var scale:Float = 1.2;
    public var warp:Float = -250.0;
    public var iTime:Float = 0.0;

    public var speed:Float = 1.0;

	public function new():Void
	{
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];

        shader.size.value = [size];
        shader.scale.value = [scale];
        shader.warp.value = [warp];
        shader.iTime.value = [iTime];
	}

	override public function update(elapsed:Float):Void
	{
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];
        shader.size.value = [size];
        shader.scale.value = [scale];
        shader.warp.value = [warp];
        iTime += elapsed*speed;
        shader.iTime.value = [iTime];
	}
}

class SparkShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header

    uniform float iTime;
    uniform float red;
    uniform float green;
    uniform float blue;
    uniform float size;
    uniform float scale;
    uniform float warp;
    
    //credit:
    //https://www.shadertoy.com/view/MlKSWm
    //edited to remove fire and smoke
    
    //
    // Description : Array and textureless GLSL 2D/3D/4D simplex 
    //							 noise functions.
    //			Author : Ian McEwan, Ashima Arts.
    //	Maintainer : ijm
    //		 Lastmod : 20110822 (ijm)
    //		 License : Copyright (C) 2011 Ashima Arts. All rights reserved.
    //							 Distributed under the MIT License. See LICENSE file.
    //							 https://github.com/ashima/webgl-noise
    // 
    
    
    
    vec3 mod289(vec3 x) {
        return x - floor(x * (1.0 / 289.0)) * 289.0;
    }
    
    vec4 mod289(vec4 x) {
        return x - floor(x * (1.0 / 289.0)) * 289.0;
    }
    
    vec4 permute(vec4 x) {
             return mod289(((x*34.0)+1.0)*x);
    }
    
    vec4 taylorInvSqrt(vec4 r)
    {
        return 1.79284291400159 - 0.85373472095314 * r;
    }
    
    float snoise(vec3 v)
        { 
        const vec2	C = vec2(1.0/6.0, 1.0/3.0) ;
        const vec4	D = vec4(0.0, 0.5, 1.0, 2.0);
    
    // First corner
        vec3 i	= floor(v + dot(v, C.yyy) );
        vec3 x0 =	 v - i + dot(i, C.xxx) ;
    
    // Other corners
        vec3 g = step(x0.yzx, x0.xyz);
        vec3 l = 1.0 - g;
        vec3 i1 = min( g.xyz, l.zxy );
        vec3 i2 = max( g.xyz, l.zxy );
    
        //	 x0 = x0 - 0.0 + 0.0 * C.xxx;
        //	 x1 = x0 - i1	+ 1.0 * C.xxx;
        //	 x2 = x0 - i2	+ 2.0 * C.xxx;
        //	 x3 = x0 - 1.0 + 3.0 * C.xxx;
        vec3 x1 = x0 - i1 + C.xxx;
        vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
        vec3 x3 = x0 - D.yyy;			// -1.0+3.0*C.x = -0.5 = -D.y
    
    // Permutations
        i = mod289(i); 
        vec4 p = permute( permute( permute( 
                             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
                         + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
                         + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
    
    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
        float n_ = 0.142857142857; // 1.0/7.0
        vec3	ns = n_ * D.wyz - D.xzx;
    
        vec4 j = p - 49.0 * floor(p * ns.z * ns.z);	//	mod(p,7*7)
    
        vec4 x_ = floor(j * ns.z);
        vec4 y_ = floor(j - 7.0 * x_ );		// mod(j,N)
    
        vec4 x = x_ *ns.x + ns.yyyy;
        vec4 y = y_ *ns.x + ns.yyyy;
        vec4 h = 1.0 - abs(x) - abs(y);
    
        vec4 b0 = vec4( x.xy, y.xy );
        vec4 b1 = vec4( x.zw, y.zw );
    
        //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
        //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
        vec4 s0 = floor(b0)*2.0 + 1.0;
        vec4 s1 = floor(b1)*2.0 + 1.0;
        vec4 sh = -step(h, vec4(0.0));
    
        vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
        vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;
    
        vec3 p0 = vec3(a0.xy,h.x);
        vec3 p1 = vec3(a0.zw,h.y);
        vec3 p2 = vec3(a1.xy,h.z);
        vec3 p3 = vec3(a1.zw,h.w);
    
    //Normalise gradients
        //vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
        vec4 norm = inversesqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
        p0 *= norm.x;
        p1 *= norm.y;
        p2 *= norm.z;
        p3 *= norm.w;
    
    // Mix final noise value
        vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
        m = m * m;
        return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), 
                                                                    dot(p2,x2), dot(p3,x3) ) );
        }
    
    //////////////////////////////////////////////////////////////
    
    // PRNG
    // From https://www.shadertoy.com/view/4djSRW
    float prng(in vec2 seed) {
        seed = fract (seed * vec2 (5.3983, 5.4427));
        seed += dot (seed.yx, seed.xy + vec2 (21.5351, 14.3137));
        return fract (seed.x * seed.y * 95.4337);
    }
    
    //////////////////////////////////////////////////////////////
    
    float PI = 3.1415926535897932384626433832795;
    
    float noiseStack(vec3 pos,int octaves,float falloff){
        float noise = snoise(vec3(pos));
        float off = 1.0;
        if (octaves>1) {
            pos *= 2.0;
            off *= falloff;
            noise = (1.0-off)*noise + off*snoise(vec3(pos));
        }
        if (octaves>2) {
            pos *= 2.0;
            off *= falloff;
            noise = (1.0-off)*noise + off*snoise(vec3(pos));
        }
        if (octaves>3) {
            pos *= 2.0;
            off *= falloff;
            noise = (1.0-off)*noise + off*snoise(vec3(pos));
        }
        return (1.0+noise)/2.0;
    }
    
    vec2 noiseStackUV(vec3 pos,int octaves,float falloff,float diff){
        float displaceA = noiseStack(pos,octaves,falloff);
        float displaceB = noiseStack(pos+vec3(3984.293,423.21,5235.19),octaves,falloff);
        return vec2(displaceA,displaceB);
    }
    
    void main()
    {	
        vec2 uv = openfl_TextureCoordv.xy;
        float time = iTime;
        vec2 resolution = vec2(1280.0,720.0);
        vec2 offset = vec2(0.0,0.0);
        vec2 fragCoord = uv*resolution;
            //
        float xpart = uv.x;
        float ypart = uv.y;
        //
        float clip = 210.0;
        float ypartClip = fragCoord.y/clip;
        float ypartClippedFalloff = clamp(2.0-ypartClip,0.0,1.0);
        float ypartClipped = min(ypartClip,1.0);
        float ypartClippedn = 1.0-ypartClipped;
        //
        float xfuel = 1.0-abs(1.0*(xpart-0.5));//pow(1.0-abs(2.0*xpart-1.0),0.5);
        //
        float realTime = time;
        //
        vec3 flow = vec3(4.1*(0.5-xpart)*pow(ypartClippedn,4.0),-2.0*xfuel*pow(ypartClippedn,64.0),0.0);
    
        // sparks
        float sparkGridSize = size;
        vec2 sparkCoord = fragCoord - vec2(2.0*offset.x,warp*realTime);
        sparkCoord -= 30.0*noiseStackUV(0.01*vec3(sparkCoord,30.0*time),1,0.4,0.1);
        sparkCoord += 100.0*flow.xy;
    
        
    
        if (mod(sparkCoord.y/sparkGridSize,2.0)<1.0) sparkCoord.x += 0.5*sparkGridSize;
        vec2 sparkGridIndex = vec2(floor(sparkCoord/sparkGridSize));
        float sparkRandom = prng(sparkGridIndex);
        float sparkLife = min(10.0*(1.0-min((sparkGridIndex.y+(warp*realTime/sparkGridSize))/(24.0-20.0*sparkRandom),1.0)),1.0);
        vec4 sparks = vec4(0.0);
        if (sparkLife>0.0) {
            float sparkSize = xfuel*xfuel*sparkRandom*0.08*scale;
            float sparkRadians = 999.0*sparkRandom*2.0*PI + 2.0*time;
            vec2 sparkCircular = vec2(sin(sparkRadians),cos(sparkRadians));
            vec2 sparkOffset = (0.5-sparkSize)*sparkGridSize*sparkCircular;
            vec2 sparkModulus = mod(sparkCoord+sparkOffset,sparkGridSize) - 0.5*vec2(sparkGridSize);
            float sparkLength = length(sparkModulus);
            float sparksGray = max(0.0, 1.0 - sparkLength/(sparkSize*sparkGridSize));
            sparks = sparkLife*sparksGray*vec4(red,green,blue, 1.0);
        }
        //
        vec4 bgCol = flixel_texture2D(bitmap, uv);
        gl_FragColor = bgCol + sparks;
    }

        ')
	public function new()
	{
		super();
	}
}

class PaletteEffect extends ShaderEffect
{
	public var shader(default,null):PaletteShader = new PaletteShader();
    public var strength:Float = 0.0;
    public var paletteSize:Float = 8.0;

	public function new():Void
	{
        shader.strength.value = [strength];
        shader.paletteSize.value = [paletteSize];
	}

	override public function update(elapsed:Float):Void
	{
        shader.strength.value = [strength];
        shader.paletteSize.value = [paletteSize];
	}
}

class PaletteShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header

    uniform float strength;
    uniform float paletteSize;

    float palette(float val, float size)
    {
        float f = floor(val * (size-1.0) + 0.5);
        return f / (size-1.0);
    }
    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        vec4 col = flixel_texture2D(bitmap, uv);
       
        vec4 reducedCol = vec4(col.r,col.g,col.b,col.a);
 
        reducedCol.r = palette(reducedCol.r, 8.0);
        reducedCol.g = palette(reducedCol.g, 8.0);
        reducedCol.b = palette(reducedCol.b, 8.0);
        gl_FragColor = mix(col, reducedCol, strength);
    }

        ')
	public function new()
	{
		super();
	}
}

class MirrorRepeatWarpEffect extends ShaderEffect
{
	public var shader(default,null):MirrorRepeatWarpShader = new MirrorRepeatWarpShader();
	public var zoom:Float = 5.0;
    var iTime:Float = 0.0;

    public var angle:Float = 0.0;

    public var x:Float = 0.0;
    public var y:Float = 0.0;
    public var warp:Float = 0.0;

	public function new():Void
	{
        shader.zoom.value = [zoom];
        shader.angle.value = [angle];
        shader.iTime.value = [0.0];
        shader.x.value = [x];
        shader.y.value = [y];
        shader.warp.value = [warp];
	}

	override public function update(elapsed:Float):Void
	{
        shader.zoom.value = [zoom];
        shader.angle.value = [angle];
        iTime += elapsed;
        shader.iTime.value = [iTime];
        shader.x.value = [x];
        shader.y.value = [y];
        shader.warp.value = [warp];
	}
}

//moved to a seperate shader because not all modcharts need the barrel shit and probably runs slightly better on weaker pcs
class MirrorRepeatWarpShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        //written by TheZoroForce240
		
        uniform float zoom;
        uniform float angle;
        uniform float iTime;

        uniform float x;
        uniform float y;

        uniform float warp;

        vec4 render( vec2 uv )
        {
            uv.x += x;
            uv.y += y;
            
            //funny mirroring shit
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;

            return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
        }

        void main()
        {	
            vec2 iResolution = vec2(1280,720);
            //rotation bullshit
            vec2 center = vec2(0.5,0.5);
            vec2 uv = openfl_TextureCoordv.xy;

            mat2 scaling = mat2(
                zoom, 0.0,
                0.0, zoom );

            //uv = uv * scaling;

            float angInRad = radians(angle);
            mat2 rotation = mat2(
                cos(angInRad), -sin(angInRad),
                sin(angInRad), cos(angInRad) );

            //used to stretch back into 16:9
            //0.5625 is from 9/16
            mat2 aspectRatioShit = mat2(
                0.5625, 0.0,
                0.0, 1.0 );

            vec2 fragCoordShit = iResolution*openfl_TextureCoordv.xy;
            uv = ( fragCoordShit - .5*iResolution.xy ) / iResolution.y; //this helped a little, specifically the guy in the comments: https://www.shadertoy.com/view/tsSXzt
            uv = uv * scaling;

            float length = length(uv); //barrel warp stuff
            uv *= (1.0+warp*length*length);

            uv = (aspectRatioShit) * (rotation * uv);
            uv = uv.xy + center; //move back to center
            
            gl_FragColor = render(uv);
        }

        ')
	public function new()
	{
		super();
	}
}


class MirrorRepeatWarpBackBlendEffect extends ShaderEffect
{
	public var shader(default,null):MirrorRepeatWarpBackBlendShader = new MirrorRepeatWarpBackBlendShader();
	public var zoom:Float = 1.0;
    public var blend:Float = 0.0;

    public var angle:Float = 0.0;

    public var x:Float = 0.0;
    public var y:Float = 0.0;
    public var warp:Float = 0.0;

	public function new():Void
	{
        shader.zoom.value = [zoom];
        shader.angle.value = [angle];
        shader.alphaBlend.value = [blend];
        shader.x.value = [x];
        shader.y.value = [y];
        shader.warp.value = [warp];
	}

	override public function update(elapsed:Float):Void
	{
        shader.zoom.value = [zoom];
        shader.angle.value = [angle];
        shader.alphaBlend.value = [blend];
        shader.x.value = [x];
        shader.y.value = [y];
        shader.warp.value = [warp];
	}
}

//moved to a seperate shader because not all modcharts need the barrel shit and probably runs slightly better on weaker pcs
class MirrorRepeatWarpBackBlendShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        //written by TheZoroForce240
		
        uniform float zoom;
        uniform float angle;
        uniform float alphaBlend;

        uniform float x;
        uniform float y;

        uniform float warp;

        vec4 render( vec2 uv )
        {
            uv.x += x;
            uv.y += y;
            
            //funny mirroring shit
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;

            return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
        }

        void main()
        {	
            vec2 iResolution = vec2(1280,720);
            //rotation bullshit
            vec2 center = vec2(0.5,0.5);
            vec2 uv = openfl_TextureCoordv.xy;

            mat2 scaling = mat2(
                zoom, 0.0,
                0.0, zoom );

            //uv = uv * scaling;

            float angInRad = radians(angle);
            mat2 rotation = mat2(
                cos(angInRad), -sin(angInRad),
                sin(angInRad), cos(angInRad) );

            //used to stretch back into 16:9
            //0.5625 is from 9/16
            mat2 aspectRatioShit = mat2(
                0.5625, 0.0,
                0.0, 1.0 );

            vec2 fragCoordShit = iResolution*openfl_TextureCoordv.xy;
            uv = ( fragCoordShit - .5*iResolution.xy ) / iResolution.y; //this helped a little, specifically the guy in the comments: https://www.shadertoy.com/view/tsSXzt
            uv = uv * scaling;

            float length = length(uv); //barrel warp stuff
            uv *= (1.0+warp*length*length);

            uv = (aspectRatioShit) * (rotation * uv);
            uv = uv.xy + center; //move back to center

            vec4 backCol = render(uv);
            vec4 mainCol = flixel_texture2D( bitmap, openfl_TextureCoordv.xy);
            vec4 finalCol = ((mainCol+backCol) * alphaBlend) + (mainCol * (1.0 - alphaBlend));

            gl_FragColor = finalCol;
        }

        ')
	public function new()
	{
		super();
	}
}

class PopoEffect extends ShaderEffect
{
	public var shader(default,null):PopoShader = new PopoShader();
    public var strength:Float = 1.0;
    public var speed:Float = 1.2;
    var iTime:Float = 0.0;

	public function new():Void
	{
        shader.beamStrength.value = [strength];
        shader.iTime.value = [iTime];
        shader.beamSpeed.value = [speed];
	}

	override public function update(elapsed:Float):Void
	{
        shader.beamStrength.value = [strength];
        shader.beamSpeed.value = [speed];
        iTime += elapsed;
        shader.iTime.value = [iTime];
	}
}

class PopoShader extends FlxShader
{
	@:glFragmentSource('
    #pragma header

    float PI = 3.14159;
    float rad = 3.14159/180.0;
    float doublePI = 3.14159*2.0;
    float BEAMWIDTH = 0.7;
    float BEAMFALL = 0.7;
    uniform float beamStrength;
    uniform float beamSpeed;
    uniform float iTime;


    float beam(vec2 uv, vec2 pos, float angle)
    {
        float a = atan(uv.y - pos.y, uv.x - pos.x) - PI*0.5;

        float fa = (a);
        float fl = (angle-BEAMWIDTH);
        float fr = (angle+BEAMWIDTH);
        
        if ((fa > fl && fa < fr))
        {
            //return 1.0;
            return abs(0.0-abs((angle)-a)+BEAMFALL)*beamStrength;
        }
        else if ((fr >= PI && fa+doublePI < fr)) //fix for edge cutoff with the angle
        {
            return abs(0.0-abs((angle)-(a+doublePI))+BEAMFALL)*beamStrength;
        }
        else if ((fl <= -PI && fa-doublePI > fl))
        {
            return abs(0.0-abs((angle)-(a-doublePI))+BEAMFALL)*beamStrength;
        }
        return 0.0;
    }
    
    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy;
        vec3 col = flixel_texture2D(bitmap,uv).rgb;
        vec2 iResolution = vec2(1280.0,720.0);
        
        //col.r += beam(uv, vec2(1.0,0.0), sin(iTime));
        //col.b += beam(uv, vec2(1.0,0.0), cos(iTime));
        
        float t = iTime*-beamSpeed;
        
        float angleTime = (mod(t*180.0, 360.0)-180.0) * rad;
        float angleTime2 = (mod((t*180.0)+180.0, 360.0)-180.0) * rad;
        float angleTime3 = (mod((t*180.0)+45.0, 360.0)-180.0) * rad;
        float angleTime4 = (mod((t*180.0)-135.0, 360.0)-180.0) * rad;
        
        vec2 fragCoord = uv*iResolution.xy;

        float y = (sin(iTime)*0.5)+0.5;
        float y2 = (sin(-iTime)*0.5)+0.5;

        col.r += beam(fragCoord, vec2(0.0,y)*iResolution.xy, angleTime);
        col.b += beam(fragCoord, vec2(0.0,y)*iResolution.xy, angleTime2);
        col.r += beam(fragCoord, vec2(1.0,y2)*iResolution.xy, -angleTime3);
        col.b += beam(fragCoord, vec2(1.0,y2)*iResolution.xy, -angleTime4);
        
        gl_FragColor = vec4(col,flixel_texture2D(bitmap,uv).a);
    }

        ')
	public function new()
	{
		super();
	}
}

class GlitchEffect extends ShaderEffect
{
	public var shader(default,null):GlitchShader = new GlitchShader();
    public var strength:Float = 0.2;
    public var speed:Float = 1.0;
    var iTime:Float = 0.0;

	public function new():Void
	{
        shader.strength.value = [strength];
        shader.iTime.value = [iTime];
        //shader.speed.value = [speed];
	}

	override public function update(elapsed:Float):Void
	{
        shader.strength.value = [strength];
        //shader.speed.value = [speed];
        iTime += elapsed*speed;
        shader.iTime.value = [iTime];
	}
}

class GlitchShader extends FlxShader
{
    //https://www.shadertoy.com/view/lsfGD2
	@:glFragmentSource('
    #pragma header

    uniform float iTime;
    uniform float strength;

    float sat( float t ) {
        return clamp( t, 0.0, 1.0 );
    }
    
    vec2 sat( vec2 t ) {
        return clamp( t, 0.0, 1.0 );
    }
    
    //remaps inteval [a;b] to [0;1]
    float remap  ( float t, float a, float b ) {
        return sat( (t - a) / (b - a) );
    }
    
    float linterp( float t ) {
        return sat( 1.0 - abs( 2.0*t - 1.0 ) );
    }
    
    vec3 spectrum_offset( float t ) {
        float t0 = 3.0 * t - 1.5;
        //return vec3(1.0/3.0);
        return clamp( vec3( -t0, 1.0-abs(t0), t0), 0.0, 1.0);
        /*
        vec3 ret;
        float lo = step(t,0.5);
        float hi = 1.0-lo;
        float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
        float neg_w = 1.0-w;
        ret = vec3(lo,1.0,hi) * vec3(neg_w, w, neg_w);
        return pow( ret, vec3(1.0/2.2) );
    */
    }
    
    //note: [0;1]
    float rand( vec2 n ) {
      return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
    }
    
    //note: [-1;1]
    float srand( vec2 n ) {
        return rand(n) * 2.0 - 1.0;
    }
    
    float mytrunc( float x, float num_levels )
    {
        return floor(x*num_levels) / num_levels;
    }
    vec2 mytrunc( vec2 x, float num_levels )
    {
        return floor(x*num_levels) / num_levels;
    }
    
    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy;
        float time = mod(iTime, 32.0); // + modelmat[0].x + modelmat[0].z;
    
        float GLITCH = strength;
        
        float gnm = sat( GLITCH );
        float rnd0 = rand( mytrunc( vec2(time, time), 6.0 ) );
        float r0 = sat((1.0-gnm)*0.7 + rnd0);
        float rnd1 = rand( vec2(mytrunc( uv.x, 10.0*r0 ), time) ); //horz
        //float r1 = 1.0f - sat( (1.0f-gnm)*0.5f + rnd1 );
        float r1 = 0.5 - 0.5 * gnm + rnd1;
        r1 = 1.0 - max( 0.0, ((r1<1.0) ? r1 : 0.9999999) ); //note: weird ass bug on old drivers
        float rnd2 = rand( vec2(mytrunc( uv.y, 40.0*r1 ), time) ); //vert
        float r2 = sat( rnd2 );
    
        float rnd3 = rand( vec2(mytrunc( uv.y, 10.0*r0 ), time) );
        float r3 = (1.0-sat(rnd3+0.8)) - 0.1;
    
        float pxrnd = rand( uv + time );
    
        float ofs = 0.05 * r2 * GLITCH * ( rnd0 > 0.5 ? 1.0 : -1.0 );
        ofs += 0.5 * pxrnd * ofs;
    
        uv.y += 0.1 * r3 * GLITCH;
    
        const int NUM_SAMPLES = 10;
        const float RCP_NUM_SAMPLES_F = 1.0 / float(NUM_SAMPLES);
        
        vec4 sum = vec4(0.0);
        vec3 wsum = vec3(0.0);
        for( int i=0; i<NUM_SAMPLES; ++i )
        {
            float t = float(i) * RCP_NUM_SAMPLES_F;
            uv.x = sat( uv.x + ofs * t );
            vec4 samplecol = flixel_texture2D(bitmap,uv);
            vec3 s = spectrum_offset( t );
            samplecol.rgb = samplecol.rgb * s;
            sum += samplecol;
            wsum += s;
        }
        sum.rgb /= wsum;
        sum.a *= RCP_NUM_SAMPLES_F;
            
        gl_FragColor = sum;
    }
    

        ')
	public function new()
	{
		super();
	}
}


class KrakatoaRaymarchEffect extends ShaderEffect
{
	public var shader(default,null):KrakatoaRaymarchShader = new KrakatoaRaymarchShader();

    public var x:Float = 0.0;
    public var y:Float = 0.0;
    public var z:Float = -2.0;
    public var tilt:Float = 0.0;


    public var floorX:Float = 0.0;
    public var floorY:Float = 0.0;
    public var floorZ:Float = 0.0;

    public var wobble:Float = 0.0;

    public var boxX0:Float = 0.0;
    public var boxY0:Float = 0.0;
    public var boxZ0:Float = 0.0;

    public var boxAngleX0:Float = 0.0;
    public var boxAngleY0:Float = 0.0;
    public var boxAngleZ0:Float = 0.0;

    public var boxX1:Float = 0.0;
    public var boxY1:Float = 0.0;
    public var boxZ1:Float = -5.0;

    public var boxAngleX1:Float = 0.0;
    public var boxAngleY1:Float = 0.0;
    public var boxAngleZ1:Float = 0.0;

    public var sphereX:Float = 0.0;
    public var sphereY:Float = 0.0;
    public var sphereZ:Float = -5.0;

    public var sphereAngleX:Float = 0.0;
    public var sphereAngleY:Float = 0.0;
    public var sphereAngleZ:Float = 0.0;

	public function new():Void
	{
        update(0.0);
	}

	override public function update(elapsed:Float):Void
	{
        shader.tilt.value = [tilt];
        shader.x.value = [x];
        shader.y.value = [y];
        shader.z.value = [z];
        shader.pitch.value = [0.0];
        shader.yaw.value = [-90.0];
        shader.wobble.value = [wobble];
        shader.floorPosition.value = [floorX, floorY, floorZ];

        shader.boxPosition.value = [boxX0, boxY0, boxZ0];
        shader.boxRotation.value = [boxAngleX0*FlxAngle.TO_RAD, boxAngleY0*FlxAngle.TO_RAD, boxAngleZ0*FlxAngle.TO_RAD];
        shader.boxPosition2.value = [boxX1, boxY1, boxZ1];
        shader.boxRotation2.value = [boxAngleX1*FlxAngle.TO_RAD, boxAngleY1*FlxAngle.TO_RAD, boxAngleZ1*FlxAngle.TO_RAD];

        shader.spherePosition.value = [sphereX, sphereY, sphereZ];
        shader.sphereRotation.value = [sphereAngleX*FlxAngle.TO_RAD, sphereAngleY*FlxAngle.TO_RAD, sphereAngleZ*FlxAngle.TO_RAD];
	}
}

class KrakatoaRaymarchShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        //built off of a shadertoy tutorial: https://inspirnathan.com/posts/53-shadertoy-tutorial-part-7/

        const int MAX_MARCHING_STEPS = 50;
        const int MAX_MARCHING_STEPS_REFLECTION = 150;
        const float MIN_DIST = 0.0;
        const float MAX_DIST = 25.0;
        const float PRECISION = 0.001;
        const float EPSILON = 0.0005;
        const float PI = 3.14159;
        const float ASPECTRATIO = 1.77777;
        const float ASPECTRATIOINV = 0.5625;

        uniform float tilt;

        //camera stuffs
        uniform float x;
        uniform float y;
        uniform float z;
        uniform float pitch;
        uniform float yaw;

        uniform vec3 boxPosition;
        uniform vec3 boxRotation;
        uniform vec3 boxPosition2;
        uniform vec3 boxRotation2;

        uniform vec3 spherePosition;
        uniform vec3 sphereRotation;

        uniform vec3 floorPosition;
        uniform float wobble;


        struct Surface {
            float sd; // signed distance value
            vec3 p;
            vec4 col; // color
        };

        // Rotation matrix around the X axis.
        mat3 rotateX(float theta) 
        {
            float c = cos(theta);
            float s = sin(theta);
            return mat3(
                vec3(1.0, 0.0, 0.0),
                vec3(0.0, c, -s),
                vec3(0.0, s, c)
            );
        }

        // Rotation matrix around the Y axis.
        mat3 rotateY(float theta)
        {
            float c = cos(theta);
            float s = sin(theta);
            return mat3(
                vec3(c, 0.0, s),
                vec3(0.0, 1, 0.0),
                vec3(-s, 0.0, c)
            );
        }

        // Rotation matrix around the Z axis.
        mat3 rotateZ(float theta) 
        {
            float c = cos(theta);
            float s = sin(theta);
            return mat3(
                vec3(c, -s, 0.0),
                vec3(s, c, 0.0),
                vec3(0.0, 0.0, 1)
            );
        }

        vec3 opCheapBend(vec3 p, float freq, float amp)
        {
            float c = cos(freq*p.x)*amp;
            //float s = sin(k*p.x+2.0);
            //mat2  m = mat2(c,-s,s,c);
            vec3  q = vec3(p.x,c+p.y,p.z);
            return q;
        }

        ///////////////////////shapes


        vec2 repeatUV(vec2 uv)
        {
        //funny mirroring shit
        if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
            uv.x = (0.0-uv.x)+1.0;
        if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
            uv.y = (0.0-uv.y)+1.0;

        return vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0)));
        }

        vec2 getUV3D(vec3 p)
        {
        vec2 uvThing = vec2(p.x,p.y) * 0.5; //need to add its offset to match shit
        vec2 center = vec2(-0.5, -0.5);
        uvThing.y *= ASPECTRATIO;
        uvThing += center;
        uvThing.y = -uvThing.y; //needs to flip to match the camera flip bullshit
        uvThing.x = -uvThing.x;  
        return uvThing;
        }



        Surface sdFloor(vec3 p, vec3 offset, vec4 col) 
        {
        p = opCheapBend(p, wobble, 0.1) + offset;
        float d = p.y + 1.0;
        
        //col = flixel_texture2D(bitmap, repeatUV(getUV3D(vec3(p.x, p.z, p.y))));
        p = vec3(p.x, p.z, p.y); //fix for texture
        return Surface(d, p, col);
        }

        Surface sdCeil(vec3 p, float offset, vec4 col) 
        {
        //p = opCheapBend(p, wobble, 0.1);
        float d = p.y - 1.0 + offset;
        
        //col = flixel_texture2D(bitmap, repeatUV(getUV3D(vec3(p.x, p.z, p.y))));
        return Surface(d, p, col);
        }


        Surface sdPlane(vec3 p, vec3 n, vec3 offset, vec4 col)
        {
            p = (p - offset);

            //col = flixel_texture2D(bitmap, repeatUV(getUV3D(vec3(p.x, p.z, p.y))));
            float d = dot(p, n);
            return Surface(d, p, col);
        }


        Surface sdWallX(vec3 p, float offset, vec4 col) 
        {
            float d = p.x + offset;
            return Surface(d, p, col);
        }
        Surface sdWallZ(vec3 p, float offset, vec4 col) 
        {
            
            float d = p.z + offset;
            //col = flixel_texture2D(bitmap, repeatUV(getUV3D(p)));
            return Surface(d, p, col);
        }



        Surface sdBox( vec3 p, vec3 scale, vec3 offset, vec4 col, mat3 transform)
        {
            
            p = (p - offset) * transform;

            //p.z += 0-(length(col.rgb)*0.4);
            //p = opCheapBend(p, wobble, 0.1);
            //p.z -= length(flixel_texture2D(bitmap, vec2(-p.x+0.5, -p.y+0.5)))*0.1;
            //col = flixel_texture2D(bitmap, getUV3D(p));
            //p.z -= 1*length(col.rgb);
            //col = flixel_texture2D(bitmap, getUV3D(p));
            vec3 q = abs(p) - scale;    
            
            float d = length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);

            return Surface(d, p, col);
        }

        Surface sdSphere(vec3 p, float radius, vec3 offset, vec4 col, mat3 transform) 
        {
            p = (p - offset) * transform;
            //col = flixel_texture2D(bitmap, repeatUV(getUV3D(p)));
            float d = length(p) - radius;
            return Surface(d, p, col);
        }


        ////////////////////////////

        //checks which object is in front
        Surface opUnion(Surface obj1, Surface obj2) {
            if (obj2.sd < obj1.sd) return obj2;
            return obj1;
        }



        //SDF funcs
        /*

        float opSmoothUnion(float d1, float d2, float k) {
        float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
        return mix( d2, d1, h ) - k*h*(1.0-h);
        }

        float opIntersection(float d1, float d2) {
        return max(d1, d2);
        }

        float opSmoothIntersection(float d1, float d2, float k) {
        float h = clamp( 0.5 - 0.5*(d2-d1)/k, 0.0, 1.0 );
        return mix( d2, d1, h ) + k*h*(1.0-h);
        }

        float opSubtraction(float d1, float d2) {
        return max(-d1, d2);
        }

        float opSmoothSubtraction(float d1, float d2, float k) {
        float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
        return mix( d2, -d1, h ) + k*h*(1.0-h);
        }

        float opSubtraction2(float d1, float d2) {
        return max(d1, -d2);
        }

        float opSmoothSubtraction2(float d1, float d2, float k) {
        float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
        return mix( d1, -d2, h ) + k*h*(1.0-h);
        }

        ////////////////////////////////////


        float rand(vec2 co){
            return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
        }
        */

        ///the scene///////////////

        Surface scene(vec3 p) {



            Surface co = sdBox(p, vec3(1.0, ASPECTRATIOINV, (0.01)), boxPosition, vec4(0.0, 0.0, 0.0, 0.0), rotateZ(boxRotation[2]) * rotateX(boxRotation[0]) * rotateY(boxRotation[1]));


            //if (useFNFBox)
            co = opUnion(co, sdFloor(p, floorPosition, vec4(0.0, 0.0, 0.0, 0.0)) );
            co = opUnion(co, sdBox(p, vec3(1.0, ASPECTRATIOINV, (0.01)), boxPosition2, vec4(0.0, 0.0, 0.0, 0.0), rotateZ(boxRotation2[2]) * rotateX(boxRotation2[0]) * rotateY(boxRotation2[1])));
            
            co = opUnion(co, sdSphere(p, 1.0, spherePosition, vec4(0.0, 0.0, 0.0, 0.0), rotateZ(sphereRotation[2]) * rotateX(sphereRotation[0]) * rotateY(sphereRotation[1])));



            return co;
        }



        /////////////////////////////

        Surface rayMarch(vec3 ro, vec3 rd) {
        float depth = MIN_DIST;
        Surface co; // closest object

        for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
            vec3 p = ro + depth * rd;
            co = scene(p);
            depth += co.sd;
            if (co.sd < PRECISION || depth > MAX_DIST) break;
        }
        
        co.sd = depth;
        
        return co;
        }
        /*
        Surface rayMarchReflection(vec3 ro, vec3 rd) {
        float depth = MIN_DIST;
        Surface co; // closest object

        for (int i = 0; i < MAX_MARCHING_STEPS_REFLECTION; i++) {
            vec3 p = ro + depth * rd;
            co = scene(p);
            depth += co.sd;
            if (co.sd < PRECISION || depth > MAX_DIST) break;
        }
        
        co.sd = depth;
        
        return co;
        }





        vec3 calcNormal(in vec3 p) {
            vec2 e = vec2(1, -1) * EPSILON;
            return normalize(
            e.xyy * scene(p + e.xyy).sd +
            e.yyx * scene(p + e.yyx).sd +
            e.yxy * scene(p + e.yxy).sd +
            e.xxx * scene(p + e.xxx).sd);
        }

        float softShadow(vec3 ro, vec3 rd, float mint, float tmax) {
        float res = 1.0;
        float t = mint;

        for(int i = 0; i < 16; i++) {
            float h = scene(ro + rd * t).sd;
            res = min(res, 8.0*h/t);
            t += clamp(h, 0.02, 0.10);
            if(h < 0.001 || t > tmax) break;
        }

        return clamp( res, 0.0, 1.0 );
        }
        */
        mat3 camera(vec3 cameraPos, vec3 lookAtPoint) {
            vec3 cd = normalize(lookAtPoint - cameraPos); // camera direction
            vec3 cr = normalize(cross(vec3(0.0, -1.0, 0.0), cd)); // camera right
            vec3 cu = normalize(cross(cd, cr)); // camera up
            
            return mat3(-cr, cu, -cd);
        }

        vec3 getLookAt(float y, float p)
        {
        vec3 pos = vec3(0.0,0.0,0.0);
        float rad = (PI/180.0);
        pos.x = cos(y * rad) * cos(p * rad);
        pos.y = sin(p * rad);
        pos.z = sin(y * rad) * cos(p * rad);
        return pos;
        }

        void main()
        {
        vec2 center = vec2(0.5, 0.5);
        vec2 uv = openfl_TextureCoordv.xy - center; //offset shit
        
        uv.y *= ASPECTRATIOINV; //fix aspect ratio
            
        vec4 backgroundColor = vec4(0.0,0.0,0.0,0.0);

        mat2 rotation = mat2(
            cos(tilt), -sin(tilt),
            sin(tilt), cos(tilt) );

        vec4 col = vec4(0.0,0.0,0.0,0.0);
        vec3 ro = vec3(x, y, z); // ray origin that represents camera position
        vec3 rd = vec3(0.0); // ray direction

        vec3 lp = getLookAt(yaw, pitch); // lookat point (aka camera target)
        rd = camera(ro, lp) * normalize(vec3(uv*rotation, -1.0)); // ray direction

            

        Surface co = rayMarch(ro, rd); // closest object

        if (co.sd > MAX_DIST) {
            col = backgroundColor; // ray didnt hit anything
        } else {
            //vec3 p = ro + rd * co.sd; // point discovered from ray marching
            //vec3 normal = calcNormal(p);

            //vec3 lightPosition = vec3(-2, 2, 0.8);
            //vec3 lightDirection = normalize(lightPosition - p);

            //float dif = clamp(dot(normal, lightDirection), 0., 1.) + 0.5; // diffuse reflection

            //float softShadow1 = clamp(softShadow(p, lightDirection, 0.02, 2.5), 0.1, 1.0);

            col = flixel_texture2D(bitmap, repeatUV(getUV3D(co.p)));

            if (col.r < 0.02 && col.g < 0.02 && col.b < 0.02)
            {
                col = vec4(0.0, 0.0, 0.0, col.a); //make sure that hit colors arent transparent
            }
        }

            //col = mix(col, backgroundColor, 1.0 - exp(fogAmount * co.sd * co.sd * co.sd)); // fog
            //col = pow(col, vec3(1.0/1.1)); // Gamma correction
            gl_FragColor = col; // Output to screen
        }

        ')
	public function new()
	{
		super();
	}
}


class RaymarchDepthEffect extends ShaderEffect
{
	public var shader(default,null):RaymarchDepthShader = new RaymarchDepthShader();

    public var x:Float = 0.0;
    public var y:Float = 0.0;
    public var z:Float = -2.0;
    public var tilt:Float = 0.0;

    public var boxDepth:Float = 0.0;

    public var boxX0:Float = 0.0;
    public var boxY0:Float = 0.0;
    public var boxZ0:Float = 0.0;

    public var boxAngleX0:Float = 0.0;
    public var boxAngleY0:Float = 0.0;
    public var boxAngleZ0:Float = 0.0;

	public function new():Void
	{
        update(0.0);

        
	}

	override public function update(elapsed:Float):Void
	{
        shader.tilt.value = [tilt];
        shader.x.value = [x];
        shader.y.value = [y];
        shader.z.value = [z];
        shader.pitch.value = [0.0];
        shader.yaw.value = [-90.0];
        shader.boxDepth.value = [boxDepth];

        shader.boxPosition.value = [boxX0, boxY0, boxZ0];
        shader.boxRotation.value = [boxAngleX0*FlxAngle.TO_RAD, boxAngleY0*FlxAngle.TO_RAD, boxAngleZ0*FlxAngle.TO_RAD];
	}
}

class RaymarchDepthShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        //built off of a shadertoy tutorial: https://inspirnathan.com/posts/53-shadertoy-tutorial-part-7/

        const int MAX_MARCHING_STEPS = 50;
        const int MAX_MARCHING_STEPS_REFLECTION = 150;
        const float MIN_DIST = 0.0;
        const float MAX_DIST = 25.0;
        const float PRECISION = 0.001;
        const float EPSILON = 0.0005;
        const float PI = 3.14159;
        const float ASPECTRATIO = 1.77777;
        const float ASPECTRATIOINV = 0.5625;

        uniform float tilt;

        //camera stuffs
        uniform float x;
        uniform float y;
        uniform float z;
        uniform float pitch;
        uniform float yaw;

        uniform vec3 boxPosition;
        uniform vec3 boxRotation;

        uniform float boxDepth;


        struct Surface {
            float sd; // signed distance value
            vec3 p;
            vec4 col; // color
        };

        // Rotation matrix around the X axis.
        mat3 rotateX(float theta) 
        {
            float c = cos(theta);
            float s = sin(theta);
            return mat3(
                vec3(1.0, 0.0, 0.0),
                vec3(0.0, c, -s),
                vec3(0.0, s, c)
            );
        }

        // Rotation matrix around the Y axis.
        mat3 rotateY(float theta)
        {
            float c = cos(theta);
            float s = sin(theta);
            return mat3(
                vec3(c, 0.0, s),
                vec3(0.0, 1, 0.0),
                vec3(-s, 0.0, c)
            );
        }

        // Rotation matrix around the Z axis.
        mat3 rotateZ(float theta) 
        {
            float c = cos(theta);
            float s = sin(theta);
            return mat3(
                vec3(c, -s, 0.0),
                vec3(s, c, 0.0),
                vec3(0.0, 0.0, 1)
            );
        }

        vec3 opCheapBend(vec3 p, float freq, float amp)
        {
            float c = cos(freq*p.x)*amp;
            //float s = sin(k*p.x+2.0);
            //mat2  m = mat2(c,-s,s,c);
            vec3  q = vec3(p.x,c+p.y,p.z);
            return q;
        }

        ///////////////////////shapes


        vec2 repeatUV(vec2 uv)
        {
            //funny mirroring shit
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;

            return vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0)));
        }

        vec2 getUV3D(vec3 p)
        {
            vec2 uvThing = vec2(p.x,p.y) * 0.5; //need to add its offset to match shit
            vec2 center = vec2(-0.5, -0.5);
            uvThing.y *= ASPECTRATIO;
            uvThing += center;
            uvThing.y = -uvThing.y; //needs to flip to match the camera flip bullshit
            uvThing.x = -uvThing.x;  
            return uvThing;
        }


        const float upperBound = 10.0;
        const float g = sin(atan(1.,upperBound));

        float grayScale(vec4 c) { return c.x*.29 + c.y*.58 + c.z*.13; }

        Surface sdBox( vec3 p, vec3 scale, vec3 offset, vec4 col, mat3 transform)
        {
            
            p = (p - offset) * transform;

            col = flixel_texture2D(bitmap, repeatUV(getUV3D(p)));

            //float depthOffset = floor(length(col.rgb));

            //p.z -= depthOffset*boxDepth;
            //p.z *= g;

            /*
            float depthOffset = floor(grayScale(col)*3.0)/3.0; //get depth
        
            if (depthOffset <= 0.0)
            {
              //col.rgb = vec3(1.0, 0.0, 0.0);
              //p.z -= depthOffset*0.2;
              //p.z *= g;
        
              p.z += boxDepth;
            }
            p.z *= g;

            */

            //im going insane

            if (col.a > 0.2) //add depth to colors that are above that alpha
            {
                p.z -= boxDepth;
        
                if (p.z <= boxDepth) //if on the side
                {
                    col.a = 1.0;
                    //col.rgb = vec3(1.0, 0.0, 0.0);
                }
                
            }
            p.z *= g; //multiply by constant for making depth shit work idk

            vec3 q = abs(p) - scale;    
            
            float d = length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);

            return Surface(d, p, col);
        }



        ////////////////////////////

        //checks which object is in front
        Surface opUnion(Surface obj1, Surface obj2) {
            if (obj2.sd < obj1.sd) return obj2;
            return obj1;
        }



        ///the scene///////////////

        Surface scene(vec3 p) {



            Surface co = sdBox(p, vec3(1.0, ASPECTRATIOINV, (0.01)), boxPosition, vec4(0.0, 0.0, 0.0, 0.0), rotateZ(boxRotation[2]) * rotateX(boxRotation[0]) * rotateY(boxRotation[1]));


            //if (useFNFBox)
            //co = opUnion(co, sdFloor(p, floorPosition, vec4(0.0, 0.0, 0.0, 0.0)) );
            //co = opUnion(co, sdBox(p, vec3(1.0, ASPECTRATIOINV, (0.01)), boxPosition2, vec4(0.0, 0.0, 0.0, 0.0), rotateZ(boxRotation2[2]) * rotateX(boxRotation2[0]) * rotateY(boxRotation2[1])));
            
            //co = opUnion(co, sdSphere(p, 1.0, spherePosition, vec4(0.0, 0.0, 0.0, 0.0), rotateZ(sphereRotation[2]) * rotateX(sphereRotation[0]) * rotateY(sphereRotation[1])));



            return co;
        }



        /////////////////////////////

        Surface rayMarch(vec3 ro, vec3 rd) {
        float depth = MIN_DIST;
        Surface co; // closest object

        for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
            vec3 p = ro + depth * rd;
            co = scene(p);
            depth += co.sd;
            if (co.sd < PRECISION || depth > MAX_DIST) break;
        }
        
        co.sd = depth;
        
        return co;
        }
        
        mat3 camera(vec3 cameraPos, vec3 lookAtPoint) {
            vec3 cd = normalize(lookAtPoint - cameraPos); // camera direction
            vec3 cr = normalize(cross(vec3(0.0, -1.0, 0.0), cd)); // camera right
            vec3 cu = normalize(cross(cd, cr)); // camera up
            
            return mat3(-cr, cu, -cd);
        }

        vec3 getLookAt(float y, float p)
        {
        vec3 pos = vec3(0.0,0.0,0.0);
        float rad = (PI/180.0);
        pos.x = cos(y * rad) * cos(p * rad);
        pos.y = sin(p * rad);
        pos.z = sin(y * rad) * cos(p * rad);
        return pos;
        }

        void main()
        {
        vec2 center = vec2(0.5, 0.5);
        vec2 uv = openfl_TextureCoordv.xy - center; //offset shit
        
        uv.y *= ASPECTRATIOINV; //fix aspect ratio
            
        vec4 backgroundColor = vec4(0.0,0.0,0.0,0.0);

        mat2 rotation = mat2(
            cos(tilt), -sin(tilt),
            sin(tilt), cos(tilt) );

        vec4 col = vec4(0.0,0.0,0.0,0.0);
        vec3 ro = vec3(x, y, z); // ray origin that represents camera position
        vec3 rd = vec3(0.0); // ray direction

        vec3 lp = getLookAt(yaw, pitch); // lookat point (aka camera target)
        rd = camera(ro, lp) * normalize(vec3(uv*rotation, -1.0)); // ray direction

            

        Surface co = rayMarch(ro, rd); // closest object

        if (co.sd > MAX_DIST) {
            col = backgroundColor; // ray didnt hit anything
        } else {

            //col = flixel_texture2D(bitmap, repeatUV(getUV3D(co.p)));
            col = co.col;
        }

            //col = mix(col, backgroundColor, 1.0 - exp(fogAmount * co.sd * co.sd * co.sd)); // fog
            //col = pow(col, vec3(1.0/1.1)); // Gamma correction
            gl_FragColor = col; // Output to screen
        }

        ')
	public function new()
	{
		super();
	}
}

class WiggleEffect extends ShaderEffect
{
	public var shader(default,null):WiggleShader = new WiggleShader();

	public var effectType(default, set):Int = 0;
	public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;

	public function new():Void
	{
		shader.uTime.value = [0];
	}

	override public function update(elapsed:Float):Void
	{
        shader.uTime.value[0] += elapsed;
	}

    function set_effectType(v:Int):Int
    {
        effectType = v;
        shader.effectType.value = [v];
        return v;
    }

    function set_waveSpeed(v:Float):Float
    {
        waveSpeed = v;
        shader.uSpeed.value = [waveSpeed];
        return v;
    }

    function set_waveFrequency(v:Float):Float
    {
        waveFrequency = v;
        shader.uFrequency.value = [waveFrequency];
        return v;
    }

    function set_waveAmplitude(v:Float):Float
    {
        waveAmplitude = v;
        shader.uWaveAmplitude.value = [waveAmplitude];
        return v;
    }
}


class WiggleShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		//uniform float tx, ty; // x,y waves phase
		uniform float uTime;
		
		const int EFFECT_TYPE_DREAMY = 0;
		const int EFFECT_TYPE_WAVY = 1;
		const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
		const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
		const int EFFECT_TYPE_FLAG = 4;
		
		uniform int effectType;
		
		/**
		 * How fast the waves move over time
		 */
		uniform float uSpeed;
		
		/**
		 * Number of waves over time
		 */
		uniform float uFrequency;
		
		/**
		 * How much the pixels are going to stretch over the waves
		 */
		uniform float uWaveAmplitude;

		vec2 sineWave(vec2 pt)
		{
			float x = 0.0;
			float y = 0.0;
			
			if (effectType == EFFECT_TYPE_DREAMY) 
			{
				float offsetX = sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
				pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
			}
			else if (effectType == EFFECT_TYPE_WAVY) 
			{
				float offsetY = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
				pt.y += offsetY; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
			}
			else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
			{
				x = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
			}
			else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
			{
				y = sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
			}
			else if (effectType == EFFECT_TYPE_FLAG)
			{
				y = sin(pt.y * uFrequency + 10.0 * pt.x + uTime * uSpeed) * uWaveAmplitude;
				x = sin(pt.x * uFrequency + 5.0 * pt.y + uTime * uSpeed) * uWaveAmplitude;
			}
			
			return vec2(pt.x + x, pt.y + y);
		}

        vec4 render( vec2 uv )
        {            
            //funny mirroring shit
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;

            return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
        }

		void main()
		{
			vec2 uv = sineWave(openfl_TextureCoordv);
			gl_FragColor = render(uv);
		}')
	public function new()
	{
		super();
	}
}

class VHSEffect extends ShaderEffect
{
	public var shader(default,null):VHSShader = new VHSShader();

    public var iTime:Float = 0.0;
	public var chromaStrength:Float = 0.005;
    public var effect:Float = 0.0;
	public function new():Void
	{
		
	}

	override public function update(elapsed:Float):Void
	{
        iTime += elapsed;
        shader.iTime.value = [iTime];
        shader.effect.value = [effect];
        shader.chromaStrength.value = [chromaStrength];
	}
}


class VHSShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float iTime;
        uniform float chromaStrength;
        uniform float effect;

        float barC = 7.5;
        float barSpeed = 3.5;
        float barHeight = 0.06;


        //noise funcs: https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
        float rand(vec2 n) { 
            return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
        }

        float noise(vec2 p){
            vec2 ip = floor(p);
            vec2 u = fract(p);
            u = u*u*(3.0-2.0*u);
            
            float res = mix(
                mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
                mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
            return res*res;
        }

        vec4 render( vec2 uv )
        {            
            //funny mirroring shit
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;

            return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
        }

        float getNoise(vec2 p)
        {
            return noise(p)-0.5; //set from 0-1 to -0.5 to 0.5;
        }

        float getBar(vec2 uv)
        {
            return clamp((sin(uv.y * barC - (-iTime*barSpeed)) - (1.0-barHeight)) * noise(vec2(iTime)), 0.0, 0.05); //clamp at 0.05 to only get that part of the wave
        }


        void main(){
            vec2 uv = openfl_TextureCoordv;
            vec4 col = vec4(0.0, 0.0, 0.0, 0.0);
            
            //noise offsets
            uv.x += getNoise(vec2(uv.y, iTime))*0.005;
            uv.x += getNoise(vec2(uv.y*1000.0, iTime*10.0))*0.008;
            
            float bar = getBar(uv);
            float barNoise = getNoise(vec2(uv.y*500.0, iTime*15.0))*3.0;
            uv.x = uv.x - (bar*barNoise);
                
            col = render(uv);
            vec4 defaultCol = render(openfl_TextureCoordv);
            col.rgb *= 0.5; //the other 0.5 gets added after with chroma
            float offset = chromaStrength;
            
            col.r += render(uv + vec2( -1.0, 0.0 )*offset ).r * 0.25; //blurred chromatic aberration
            col.g += render(uv + vec2( -2.0, 0.0 )*offset ).g * 0.25;
            col.b += render(uv + vec2( -3.0, 0.0 )*offset ).b * 0.25;
            col.r += render(uv + vec2( 1.0, 0.0 )*offset ).r * 0.25;
            col.g += render(uv + vec2( 2.0, 0.0 )*offset ).g * 0.25;
            col.b += render(uv + vec2( 3.0, 0.0 )*offset ).b * 0.25;
            
            gl_FragColor = mix(defaultCol, col, effect);
        }')
	public function new()
	{
		super();
	}
}

class SpeedEffect extends ShaderEffect
{
	public var shader(default,null):SpeedShader = new SpeedShader();

    public var iTime:Float = 0.0;
    public var effect:Float = 0.0;
	public function new():Void
	{
		
	}

	override public function update(elapsed:Float):Void
	{
        iTime += elapsed;
        shader.iTime.value = [iTime];
        shader.effect.value = [effect];
	}
}


class SpeedShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float iTime;
        uniform float effect;

        float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
        vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
        vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

        float noise(vec3 p){
            vec3 a = floor(p);
            vec3 d = p - a;
            d = d * d * (3.0 - 2.0 * d);

            vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
            vec4 k1 = perm(b.xyxy);
            vec4 k2 = perm(k1.xyxy + b.zzww);

            vec4 c = k2 + a.zzzz;
            vec4 k3 = perm(c);
            vec4 k4 = perm(c + 1.0);

            vec4 o1 = fract(k3 * (1.0 / 41.0));
            vec4 o2 = fract(k4 * (1.0 / 41.0));

            vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
            vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

            return o4.y * d.y + o4.x * (1.0 - d.y);
        }

        float speed = 25.0;
        float size = 50.0;
        float reduction = 0.55;
        float cutoff = 0.2;

        void main()
        {
            
            
            vec2 uv = openfl_TextureCoordv.xy;
            vec4 Color = flixel_texture2D(bitmap, uv);
            
            vec2 centeredUV = uv-0.5;
            
            float dist = length(centeredUV);
            
            vec2 dir = normalize(centeredUV) * (size + noise(vec3(iTime)));
            
            float amount = noise(vec3(dir, iTime*speed)) * noise(vec3(dir, iTime*speed*1.2));
            
            amount *= smoothstep(cutoff, 0.7, dist);
            
            if (amount > 0.2)
                amount *= 3.0;
            else
                amount = 0.0;
                
            if (noise(vec3(dir, iTime)) > effect)
                amount = 0.0;
            
            Color.rgb += amount;
            
            
            //Color.rgb += dist;
            

            gl_FragColor = Color;
        }')
	public function new()
	{
		super();
	}
}

class BarsEffect extends ShaderEffect
{
	public var shader(default,null):BarsShader = new BarsShader();
    public var effect:Float = 0.0;
	public function new():Void
	{
		
	}

	override public function update(elapsed:Float):Void
	{
        shader.effect.value = [effect];
	}
}


class BarsShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float effect;

        void main()
        {
            vec2 uv = openfl_TextureCoordv.xy;
            vec4 Color = flixel_texture2D(bitmap, uv);
            
            if (uv.y < effect || uv.y > 1.0-effect)
            {
                Color = vec4(0.0, 0.0, 0.0, 1.0); //make sure alpha is 1 to stop other shaders being weird
            }
                
            
            gl_FragColor = Color;
        }')
	public function new()
	{
		super();
	}
}

class TrailEffect extends ShaderEffect
{
	public var shader(default,null):TrailShader = new TrailShader();
    public var effect:Float = 1.0;
    public var scale:Float = 1.0;
    public var targetCamera:FlxCamera = null;
    private var bitmap:BitmapData;
	public function new():Void
	{
		bitmap = new BitmapData(FlxG.width, FlxG.height, true, 0x00000000);
	}

	override public function update(elapsed:Float):Void
	{
        shader.effect.value = [effect];
        if (targetCamera != null)
        {
            trace('asdhj');
            bitmap.fillRect(bitmap.rect, 0x00000000);
            @:privateAccess
            var bit = targetCamera.flashSprite.__cacheBitmapData;

            bitmap.draw(bit);
        }
        shader.trailBitmap.input = bitmap;
	}
}


class TrailShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float effect;
        uniform sampler2D trailBitmap;

        void main()
        {
            vec2 uv = openfl_TextureCoordv.xy;
            vec4 color = flixel_texture2D(bitmap, uv);
            color += flixel_texture2D(trailBitmap, uv)*effect;

            gl_FragColor = color;
        }')
	public function new()
	{
		super();
	}
}

class RadialBlurEffect extends ShaderEffect
{
	public var shader(default,null):RadialBlurShader = new RadialBlurShader();
    public var strength:Float = 0.2;
    public var noiseScale:Float = 0.1;
    public var type:Int = 0; //blur or bloom
    public var iTime:Float = 0;
    public var speed:Float = 0.5;
	public function new():Void
	{
		update(0);
	}

	override public function update(elapsed:Float):Void
	{
        iTime += elapsed*speed;
        shader.blurStrength.value = [strength];
        shader.noiseScale.value = [noiseScale];
        shader.type.value = [type];
        shader.iTime.value = [iTime];
	}
}


class RadialBlurShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        #define M_PI 3.14159265358979323846
        #define SAMPLE_COUNT 8.0
        #define SAMPLE_COUNT_INV 0.125

        uniform float blurStrength;
        uniform float noiseScale;
        uniform float iTime;
        uniform int type;
        
        float rand(vec2 co){return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);}
        float rand (vec2 co, float l) {return rand(vec2(rand(co), l));}
        float rand (vec2 co, float l, float t) {return rand(vec2(rand(co, l), t));}
        
        float perlin(vec2 p, float dim, float time) {
            vec2 pos = floor(p * dim);
            vec2 posx = pos + vec2(1.0, 0.0);
            vec2 posy = pos + vec2(0.0, 1.0);
            vec2 posxy = pos + vec2(1.0);
            
            float c = rand(pos, dim, time);
            float cx = rand(posx, dim, time);
            float cy = rand(posy, dim, time);
            float cxy = rand(posxy, dim, time);
            
            vec2 d = fract(p * dim);
            d = -0.5 * cos(d * M_PI) + 0.5;
            
            float ccx = mix(c, cx, d.x);
            float cycxy = mix(cy, cxy, d.x);
            float center = mix(ccx, cycxy, d.y);
            
            return center * 2.0 - 1.0;
        }
        float perlin(vec2 p, float dim) {
            return perlin(p, dim, 0.0);
        }
        
    
        void main()
        {
            vec2 uv = openfl_TextureCoordv.xy;
            vec2 blurPosition = vec2(0.5) + vec2(perlin(vec2(iTime, 0.0), 1.0), perlin(vec2(0.0, iTime), 1.0))*noiseScale;
            uv -= blurPosition;
            
            float offset = blurStrength * SAMPLE_COUNT_INV;
            vec4 color = vec4(0.0);
            for(float i = 0.0; i < SAMPLE_COUNT; i++)
            {
                color += flixel_texture2D(bitmap, uv * (1.0 + (i * offset)) + blurPosition);
            }
            color *= SAMPLE_COUNT_INV;
            
            if (type == 0) //blur
            {
                gl_FragColor = color;
            }
            else //bloom
            {
                float brightness = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
                gl_FragColor = flixel_texture2D(bitmap, uv + blurPosition) + color*brightness*blurStrength;
            }
        }')
	public function new()
	{
		super();
	}
}


class SpiralTunnelEffect extends ShaderEffect
{
	public var shader(default,null):SpiralTunnelShader = new SpiralTunnelShader();
    public var strength:Float = 0.7;
    public var iTime:Float = 0;
    public var speed:Float = 1.0;
	public function new():Void
	{
		update(0);
	}

	override public function update(elapsed:Float):Void
	{
        iTime += elapsed*speed;
        shader.strength.value = [strength];
        shader.iTime.value = [iTime];
	}
}


class SpiralTunnelShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        //based on https://www.shadertoy.com/view/Xdl3WH

        #define PI 3.14159265358979323846

        uniform float iTime;
        uniform float strength;

        vec3 blendNormal(vec3 base, vec3 blend) {
            return blend;
        }

        vec3 blendNormal(vec3 base, vec3 blend, float opacity) {
            return (blendNormal(base, blend) * opacity + base * (1.0 - opacity));
        }

        vec4 render( vec2 uv )
        {            
            //funny mirroring shit
            if ((uv.x > 1.0 || uv.x < 0.0) && abs(mod(uv.x, 2.0)) > 1.0)
                uv.x = (0.0-uv.x)+1.0;
            if ((uv.y > 1.0 || uv.y < 0.0) && abs(mod(uv.y, 2.0)) > 1.0)
                uv.y = (0.0-uv.y)+1.0;

            return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
        }

        void main()
        {
            vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
            vec2 iResolution = openfl_TextureSize;
            vec4 color = flixel_texture2D(bitmap, fragCoord.xy / iResolution.xy);

            vec2 p = (2.0 * fragCoord.xy / iResolution.xy - 1.0) * vec2(iResolution.x / iResolution.y, 1.0);
            vec2 uv = vec2(atan(p.y, p.x) * 1.0/PI, 1.0 / sqrt(dot(p, p))) * vec2(2.0, 1.0);
            
            //movement
            uv.y += iTime * 1.5;
            uv.x += sin(uv.y);
            uv.x += iTime * 0.25;
            
            color.rgb = blendNormal(render(uv).rgb, color.rgb, strength);
            
            gl_FragColor = color;
        }
        ')
	public function new()
	{
		super();
	}
}
