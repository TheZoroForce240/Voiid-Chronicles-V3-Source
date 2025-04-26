import flixel.input.gamepad.FlxGamepadInputID;
import funkin.options.PlayerSettings;
import funkin.backend.system.Controls;
import funkin.backend.system.Controls.Control;

import funkin.backend.assets.ModsFolderLibrary;
import funkin.backend.assets.ModsFolder;

var ogModFolder = ModsFolder.currentModFolder;
var loadedPaths:Array<String> = [];
var init = false;
function postStateSwitch()
{
	if (init)
		return;

	init = true;


	var orderList = Assets.getText(Paths.getPath("content/order.txt"));
	var list = orderList.split("\n");
	list.reverse();
	for (folder in list) {
		var f = StringTools.trim(folder);
		Paths.assetsTree.addLibrary(ModsFolder.loadModLib(ModsFolder.modsPath + ModsFolder.currentModFolder + "/content/" + f, false, ModsFolder.currentModFolder + "/content/" + f));
		loadedPaths.push(f);
	}

	var contentFolders = Paths.getFolderDirectories("content/");
	for (f in contentFolders) {
		if (!loadedPaths.contains(f)) {
			Paths.assetsTree.addLibrary(ModsFolder.loadModLib(ModsFolder.modsPath + ModsFolder.currentModFolder + "/content/" + f, false, ModsFolder.currentModFolder + "/content/" + f));
			loadedPaths.push(f);
		}
	}
}
//make sure that saving charts/characters go to the correct content folder
public static function updateFolderFromSong(song:String) {
	var fullPath = Paths.assetsTree.getSpecificPath("assets/songs/"+song+"/meta.json");
	ModsFolder.currentModFolder = ogModFolder;
	
	var contentFolders = Paths.getFolderDirectories("content/");
	for (f in contentFolders) {
		if (StringTools.startsWith(fullPath, ModsFolder.modsPath + ogModFolder + "/content/" + f)) {
			ModsFolder.currentModFolder = ogModFolder + "/content/" + f;
			trace(ModsFolder.currentModFolder);
		}
	}
}
public static function updateFolderFromCharacter(character:String) {
	var fullPath = Paths.assetsTree.getSpecificPath("assets/data/characters/"+character+".xml");
	ModsFolder.currentModFolder = ogModFolder;
	
	var contentFolders = Paths.getFolderDirectories("content/");
	for (f in contentFolders) {
		if (StringTools.startsWith(fullPath, ModsFolder.modsPath + ogModFolder + "/content/" + f)) {
			ModsFolder.currentModFolder = ogModFolder + "/content/" + f;
			trace(ModsFolder.currentModFolder);
		}
	}
}