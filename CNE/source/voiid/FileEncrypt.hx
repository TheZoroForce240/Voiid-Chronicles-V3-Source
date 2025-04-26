package voiid;

import lime.utils.Assets;
import haxe.io.Path;
import haxe.io.BytesData;
import haxe.crypto.mode.Mode;
import flixel.FlxG;
import sys.io.File;
import funkin.backend.system.Main;
import sys.FileSystem;
import haxe.io.Bytes;
import haxe.crypto.Aes;

using StringTools;

class FileEncrypt {

	@:unreflective
	private static var e:Aes;
	@:unreflective
	static var key:Bytes;
	@:unreflective
	static var fileMap:Map<String, Int> = [];

	@:unreflective
	public static function init() {
		#if ENCRYPTED_FILES
		var array = funkin.backend.scripting.events.TransitionCreationEvent.K.g();
		array.reverse();
		var string = "";
		for (a in array)
			string += a;

		key = Bytes.ofHex(string);
		e = new Aes(key);
		string = "";
		
		#if ENCRYPT_FILES
		encryptLib("mods/Voiid Chronicles");
		for (folder in FileSystem.readDirectory("mods/Voiid Chronicles/content/")) {
			encryptLib("mods/Voiid Chronicles/content/"+folder);
		}
		encryptFile("mods/Voiid Chronicles/gj");
		File.saveBytes("data", e.encrypt(Mode.CTR, Bytes.ofString(list), NoPadding));
		#end
		verifyFiles();

		#end
	}
	@:unreflective
	public static function verifyFiles() {
		var data = File.getBytes("data");
		var d = e.decrypt(Mode.CTR, data, NoPadding);
		var list = d.toString();

		for (l in list.split("\n")) {
			if (l.trim() != "") {
				var d = l.split(":");
				fileMap.set(d[0], Std.parseInt(d[1]));

				if (!FileSystem.exists(d[0])) {
					Sys.exit(0);
				}
			}
		}
	}

	#if ENCRYPT_FILES
	private static var list:String = "";

	private static function encryptLib(libPath:String) {
		if (FileSystem.exists(libPath+"/songs/")) {
			for (song in FileSystem.readDirectory(libPath+"/songs/")) {
				if (FileSystem.isDirectory(libPath+"/songs/"+song)) {

					if (FileSystem.exists(libPath+"/songs/"+song+"/charts/")) {
						for (chart in FileSystem.readDirectory(libPath+"/songs/"+song+"/charts/")) {
							encryptFile(libPath+"/songs/"+song+"/charts/"+chart);
						}
					}

					if (FileSystem.exists(libPath+"/songs/"+song+"/scripts/")) {
						for (script in FileSystem.readDirectory(libPath+"/songs/"+song+"/scripts/")) {
							encryptFile(libPath+"/songs/"+song+"/scripts/"+script);
						}
					}
		
					encryptFile(libPath+"/songs/"+song+"/meta.json");
					encryptFile(libPath+"/songs/"+song+"/events.json");
					encryptFile(libPath+"/songs/"+song+"/LE_events.json");
				} else {
					//playstate script
					encryptFile(libPath+"/songs/"+song);
				}
			}
		}


		if (FileSystem.exists(libPath+"/data/stages/")) {
			for (stage in FileSystem.readDirectory(libPath+"/data/stages/")) {
				if (StringTools.endsWith(stage, ".hx")) {
					encryptFile(libPath+"/data/stages/"+stage);
				}
			}
		}
		if (FileSystem.exists(libPath+"/data/events/")) {
			for (event in FileSystem.readDirectory(libPath+"/data/events/")) {
				if (StringTools.endsWith(event, ".hx")) {
					encryptFile(libPath+"/data/events/"+event);
				}
			}
		}
		encryptFile(libPath+"/data/global.hx");

		if (FileSystem.exists(libPath+"/data/states/")) {
			for (script in FileSystem.readDirectory(libPath+"/data/states/")) {
				encryptFile(libPath+"/data/states/"+script);
			}
		}
		if (FileSystem.exists(libPath+"/data/scripts/")) {
			for (script in FileSystem.readDirectory(libPath+"/data/scripts/")) {
				encryptFile(libPath+"/data/scripts/"+script);
			}
		}
		if (FileSystem.exists(libPath+"/source/")) {
			for (script in FileSystem.readDirectory(libPath+"/source/")) {
				encryptFile(libPath+"/source/"+script);
			}
		}
		#if ENCRYPT_IMAGES_AND_AUDIO
		scanAndEncryptFiles(libPath+"/images/", "png");

		scanAndEncryptFiles(libPath+"/songs/", "ogg");
		scanAndEncryptFiles(libPath+"/sounds/", "ogg");
		scanAndEncryptFiles(libPath+"/music/", "ogg");
		#end
	}

	private static function scanAndEncryptFiles(path:String, ext:String) {
		if (FileSystem.exists(path)) {
			for (file in FileSystem.readDirectory(path)) {
				if (FileSystem.isDirectory(path+file)) {
					scanAndEncryptFiles(path+file+"/", ext);
				} else {
					if (Path.extension(file) == ext) {
						encryptFile(path+file);
					}
				}
			}
		}
	}

	

	private static function encryptFile(path:String) {
		if (FileSystem.exists(path) && FileSystem.exists(Main.pathBack + path)) {
			var ogFile = File.getBytes(Main.pathBack + path);
			var data = e.encrypt(Mode.CTR, ogFile, NoPadding);
			File.saveBytes(path, data);

			list += path + ":" + data.length + "\n";
		}
	}
	#end

	public static function decryptString(path:String) {
		var data = Assets.getBytes(path);
		verify(path, data.length);
		var b = e.decrypt(Mode.CTR, data, NoPadding);
		return b.toString();
	}
	public static function decryptBytes(path:String) {
		var data = lime.utils.Bytes.fromFile(path);
		verify(path, data.length);
		var b = e.decrypt(Mode.CTR, data, NoPadding);
		return b;
	}
	@:unreflective
	private static function verify(path:String, len:Int) {
		if (fileMap.exists(path)) {
			if (len != fileMap.get(path)) {
				Sys.exit(0);
			}
		}
	}
}