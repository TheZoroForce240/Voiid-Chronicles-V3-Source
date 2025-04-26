package ui;

import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import openfl.geom.Rectangle;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import lime.utils.UInt8Array;
import haxe.io.Bytes;
import lime.utils.Assets;
import lime.media.AudioBuffer;
import flixel.FlxG;
import openfl.utils.ByteArray;
import flixel.FlxSprite;

class BaseComplex
{
    
    public var real:Float;
    public var img:Float;
    public function new(real:Float, img:Float)
    {
        this.real = real;
        this.img = img;
    }
}

@:forward abstract Complex(BaseComplex) to BaseComplex from BaseComplex 
{
    public function new(real:Float, img:Float)
    {
        this = new BaseComplex(real, img);
    }

    //operator stuff
    @:op(a + b)
    static inline function add(a:Complex, b:Complex):Complex
    {
        return new Complex(a.real+b.real, a.img+b.img);
    }
    @:op(A - B)
    static inline function subtract(a:Complex, b:Complex):Complex
    {
        return new Complex(a.real-b.real, a.img-b.img);
    }

    @:op(A * B)
    static inline function multiply(a:Complex, b:Complex):Complex
    {
        var newReal = a.real * b.real - a.img * b.img;
        var newImg = a.real * b.img + a.img * b.real;
        return new Complex(newReal, newImg);
    }

    //im  going insane

    public function polar()
    {
        var r = Math.sqrt((this.real*this.real)+(this.img*this.img));
        var theta = Math.atan(this.img/this.real); 
        return new Complex(r*Math.cos(theta), r*Math.sin(theta));
    }

    public function exp()
    {
        return new Complex(Math.exp(this.real) * Math.cos(this.img), Math.exp(this.real) * Math.sin(this.img));
    }

    public function conj()
    {
        this.img = -this.img;
    }

    public function scale(val:Float)
    {
        this.real *= val;
        this.img *= val;
    }
}

class VisualizerSprite extends FlxSpriteGroup
{
    var buffer:AudioBuffer;
    var bufferBytes:Bytes;
    var bars:Array<FlxSprite> = [];
    override public function new(x:Float, y:Float)
    {
        super(x, y);
        //var bytes = ByteArray.fromBytes(Bytes.)
        FlxG.sound.playMusic(Paths.inst("king hit"));
        //buffer = Assets.getAsset(Paths.inst("burnout"), SOUND, false);
        //bufferBytes = buffer.data.toBytes();
        //generateSprite(buffer, 1280, 100);

        @:privateAccess
        {
            var sound = FlxG.sound.music._sound;
            buffer = sound.__buffer;
        }

        


        var barCount:Int = 64;
        for (i in 0...barCount)
        {
            var bar = new FlxSprite((1280/barCount)*i, 720).makeGraphic(Std.int(1280/barCount), 1);
            add(bar);
            bars.push(bar);
        }


        /*
        var shit:Array<Int> = [1,1,2,4,6,0,1,7];
        var samples:Array<Complex> = [];
        for (i in 0...shit.length)
        {
            samples.push(new Complex(shit[i], 0));
        }
        var s = fft(samples);
        for (i in s)
        {
            trace(i.real + ", " + i.img);
        }*/

        //trace(buffer.bitsPerSample);

    }

    var lastTime:Float = 0;
    override public function update(elapsed:Float)
    {
        lastTime = FlxG.sound.music.time;
        var freqs = getFFTFromTime(FlxG.sound.music.time);
        for (i in 0...bars.length)
        {
            var s = Math.sqrt((freqs[i].real * freqs[i].real) + (freqs[i].img * freqs[i].img));
            //trace(freqs[i].real);
            bars[i].scale.y = FlxMath.lerp(bars[i].scale.y, Math.abs(s)*0.1, elapsed*70);
            //bars[i].scale.y = Math.abs(s)*0.1;
            //bars[i].scale.y = log10(s)*20;
            //bars[i].scale.y = Math.log(Math.abs(freqs[i].real))*20;
            //bars[i].scale.y = log10(Math.abs(freqs[i].real))*10;
        }

        super.update(elapsed);

    }

    function getFFTFromTime(time:Float)
    {
        //var sampleIdx = Std.int(time*buffer.sampleRate*buffer.channels*2);
        /*var a = buffer.sampleRate*buffer.channels*2;
        var sampleIdx = Std.int(time*a);
        //trace(time);
        //trace(sample);
        //trace(buffer.bitsPerSample);

        var samples:Array<Complex> = [];

        

        //var mult = Std.int(a/bars.length);

        for (i in 0...(bars.length))
        {
            var window = 0.54 - 0.46 * Math.cos((2 * Math.PI * i) / (bars.length*2));
            //var window = 1.0;
            samples.push(new Complex((bufferBytes.getInt32(sampleIdx+(i*mult)))*window, 0));
        }*/

        var totalSamples = Std.int((buffer.data.length * 8) / (buffer.channels * buffer.bitsPerSample));

        var secondOffset = (time) / 1000;
        var totalSeconds = totalSamples / buffer.sampleRate;

        if (secondOffset < 0) secondOffset = 0;
        if (secondOffset > totalSeconds) secondOffset = totalSeconds;

        var ratio = (secondOffset / totalSeconds);
        var totalOffset = Std.int(buffer.data.length * ratio);

        var samples:Array<Complex> = [];
        //var sampleIdx = Std.int(((time*buffer.sampleRate)*(buffer.channels*buffer.bitsPerSample)/8));
        for (i in 0...(bars.length*2))
        {
            var window = 0.54 - 0.46 * Math.cos((2 * Math.PI * i) / (bars.length));
            //var window = 1.0;
            var s = buffer.data[totalOffset+Std.int(i*((buffer.channels*buffer.bitsPerSample)/8))];
            //var s = buffer.data[totalOffset+i];
            samples.push(new Complex(s*window, 0));
        }

        return fft(samples);
    }
    /*

    function fft(samples:Array<Complex>)
    {
        var N:Int = samples.length;
        var k:Int = N;
        var n:Int;
        var thetaT = Math.PI / N;
        var phiT = new Complex(Math.cos(thetaT), -Math.sin(thetaT));
        var T:Complex;
        while (k > 1)
        {
            n = k;
            k >>= 1;
            phiT = phiT * phiT;
            T = new Complex(1.0, 0.0);
            for (l in 0...k)
            {
                var a = l;
                while(a < N)
                {
                    var b = a + k;
                    var t = samples[a] - samples[b];
                    samples[a] += samples[b];
                    samples[b] = t * T;
                    a += n;
                }
                T *= phiT;
            }
        }
        // Decimate
        var m = Std.int(log2(N));
        for (a in 0...N)
        {
            var b = a;
            // Reverse bits
            b = (((b & 0xaaaaaaaa) >> 1) | ((b & 0x55555555) << 1));
            b = (((b & 0xcccccccc) >> 2) | ((b & 0x33333333) << 2));
            b = (((b & 0xf0f0f0f0) >> 4) | ((b & 0x0f0f0f0f) << 4));
            b = (((b & 0xff00ff00) >> 8) | ((b & 0x00ff00ff) << 8));
            b = ((b >> 16) | (b << 16)) >> (32 - m);
            if (b > a)
            {
                var t = samples[a];
                samples[a] = samples[b];
                samples[b] = t;
            }
        }
        return samples;
    }
    */
    

    function log2(n:Float)
    {
        return Math.log( n ) / Math.log( 2 );
    }
    function log10(n:Float)
    {
        return Math.log( n ) / Math.log( 10 );
    }

    //https://gist.github.com/lukicdarkoo/3f0d056e9244784f8b4a
    function fft(samples:Array<Complex>)
    {
        var N:Int = samples.length;
        if (N <= 1)
            return samples;

        var odd:Array<Complex> = [];
        var even:Array<Complex> = [];
        for (i in 0...Math.floor(N/2))
        {
            even[i] = samples[i*2];
            odd[i] = samples[i*2+1];
        }

        odd = fft(odd);
        even = fft(even);

        for (k in 0...Math.floor(N/2))
        {
            var w = (-2.0 * (k/N) * Math.PI);
            var t:Complex = new Complex(0.0, w);
            t = t.exp() * odd[k];
            samples[k] = even[k] + t;
		    samples[Math.floor(N / 2) + k] = even[k] - t;
        }

        return samples;
    }

    function ifft(samples:Array<Complex>)
    {
        for (s in samples)
            s.conj(); //turn into conjugate

        samples = fft(samples); // now do fft

        for (s in samples)
            s.conj(); //conjugate again

        var scaleMult = 1/samples.length;
        for (s in samples)
            s.scale(scaleMult); //divide by size

        return samples;
    }


    /*
    //https://www.oreilly.com/library/view/c-cookbook/0596007612/ch11s18.html
    function fft(samples:Array<Complex>, log2n:Int)
    {
        var output:Array<Complex> = [];
        for (i in 0...samples.length)
        {
            output.push(new Complex(1.0, 0.0));
        }
        //output.resize(samples.length);
        var J = new Complex(-0, -1);
        var n = 1 << log2n;
        for (i in 0...n) 
        {
            output[bitReverse(i, log2n)] = samples[i];
        }
        for (s in 1...(log2n))
        {
            //trace(output);
            var m = 1 << s;
            var m2 = m >> 1;
            var w:Complex = new Complex(1.0, 0.0);
            var wm:Complex = (J * new Complex(Math.PI / m2, 0.0)).exp();
            //complex wm = exp(-J * (PI / m2));
            for (j in 0...m2)
            {
                var k = j;
                while (k < n)
                {
                    k += m;
                    var t = w * output[k + m2];
                    var u = output[k];
                    output[k] = u + t;
                    output[k + m2] = u - t;
                }
                w *= wm;
            }
        }
        return output;
    }

    function bitReverse(x:Int, log2n:Int) 
    {
        var n = 0;
        var mask = 0x1;
        for (i in 0...log2n) {
            n <<= 1;
            n |= (x & 1);
            x >>= 1;
        }
        return n;
    }

    */

    /*public function generateSprite(buffer:AudioBuffer, w:Int, h:Int)
    {
        makeGraphic(w, h, FlxColor.TRANSPARENT);
        //buffer.sampleRate
        var samples:Array<Int> = [];

        var idx:Int = 0;
        var bytes = buffer.data.toBytes();
        while(true)
        {
            var b = bytes.getUInt16(idx);
            //trace(b);
            samples.push(b);
            idx += buffer.channels*2;

            if (idx >= bytes.length)
                break;
        }


        for (i in 0...samples.length)
        {
            pixels.fillRect(new Rectangle((w/samples.length)*i, 0, (w/samples.length), (samples[i]/65535)*h), 0xFF0000FF);
        }
        screenCenter();
        //trace(samples);
    }*/
}