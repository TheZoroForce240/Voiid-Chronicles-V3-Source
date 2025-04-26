package;

import flixel.FlxG;
import haxe.io.Bytes;
import haxe.crypto.RC4;

/**
 * A Class that stores a value, and encrypts it with a randomly generated key, to obscure it within memory and make it harder to find/edit.
 */
class EncryptedValue<T>
{
    public var value(get, set):T;
    public function new(val:T)
    {
        initKey(val);
    }

    private var k:RC4 = new RC4();
	private var key:Bytes;
	private var bytes:Bytes;

	private final hexStrings:Array<String> = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];

	private function genKey()
	{
		var str:String = "";
		for (i in 0...32)
			str += hexStrings[FlxG.random.int(0, 15)]; //random key
		key = Bytes.ofHex(str);
	}

	private function initKey(val:T)
	{
		genKey();
		bytes = Bytes.ofString(stringify(val));
		k.init(key);
		bytes = k.encrypt(bytes);
	}

	public function get_value():T 
    {
		k.init(key);
        return parse(k.decrypt(bytes).toString());
	}

	public function set_value(value:T):T 
    {
		genKey(); //generate new random key
		k.init(key);
		bytes = Bytes.ofString(stringify(value));
		bytes = k.encrypt(bytes);
        return value;
	}


    //this need to be overriden
    function parse(str:String):T
    {
        return null;
    }

    //this could be overriden for some classes by you could also have a toString function in the class
    function stringify(v:T)
    {
        return Std.string(v);
    }
}

class EncryptedString extends EncryptedValue<String>
{
    override function parse(str:String)
    {
        return str; //returns itself
    }
}
class EncryptedInt extends EncryptedValue<Int>
{
    override function parse(str:String) : Int
    {
        return Std.parseInt(str); //parse into int
    }
}
class EncryptedFloat extends EncryptedValue<Float>
{
    override function parse(str:String) : Float
    {
        return Std.parseFloat(str); //parse into float
    }
}