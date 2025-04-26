import funkin.game.Stage;
var charactersMap:Array<Dynamic> = [];
var stageMap = ["" => null];
function create() {
	for (i in 0...PlayState.SONG.strumLines.length) {
		var map = ["" => []];
		map.clear();
		charactersMap.push(map);
	}
	stageMap.clear();
}
function postCreate() {
	for (i in 0...strumLines.length) {
		var characterNames:Array<String> = [];
		var characters = [];
		for (char in strumLines.members[i].characters) {
			characterNames.push(char.curCharacter);
			characters.push(char);
		}

		var map = charactersMap[i];
		if (!map.exists(Std.string(characterNames))) {
			map.set(Std.string(characterNames), characters);
		}
	}
	if (!stageMap.exists(curStage)) stageMap.set(curStage, stage);

	for (event in events) {
		switch(event.name) {
			case "Change Characters":
				onCharactersPreload(event.params[0], event.params[1]);
			case "Change Stage":
				onStagePreload(event.params[0]);
		}
	}
}

///characters/////////
function onCharactersPreload(group:String, characterNames:String) {
	var strumlineID = groupNameToStrumlineID(group);
	if (strumlineID < 0) return;

	var map = charactersMap[strumlineID];
	var n = Std.string(parseCharacterNames(characterNames));
	if (map.exists(n)) return;

	var arr:Array<Character> = [];
	for (c in parseCharacterNames(characterNames)) {
		var character = new Character(0, 0, c, strumlineID == 1);
		character.globalOffset.x -= (character.frameWidth*character.scale.x)/2;
		character.globalOffset.y -= (character.frameHeight*character.scale.y);
		character.dance();
		arr.push(character);
	}
	map.set(n, arr);
}

function changeCharacters(group:String, characterNames:String) {
	var strumlineID = groupNameToStrumlineID(group);
	if (strumlineID < 0) return;

	var strumline = strumLines.members[strumlineID];

	for (char in strumline.characters) {
		remove(char);
	}
	strumline.characters = [];

	var map = charactersMap[strumlineID];
	var n = Std.string(parseCharacterNames(characterNames));
	if (map.exists(n)) {
		var newCharacters = map.get(n);

		for (char in newCharacters) {
			strumline.characters.push(char);
		}
		updateCharacterPositions(newCharacters, strumlineID);
	}

	scripts.call("onCharactersChanged", [strumlineID, characterNames]);
}

function parseCharacterNames(names) {
	return names.split(',');
}

function updateCharacterPositions(characters:Array<Character>, strumlineID:Int) {
	for (char in characters) {
		char.cameraOffset.set(0,0);
		if (char.xml.exists("camx")) char.cameraOffset.x = Std.parseFloat(char.xml.get("camx")); 
		if (char.xml.exists("camy")) char.cameraOffset.y = Std.parseFloat(char.xml.get("camy"));
		stage.applyCharStuff(char, strumlineIDToGroupName(strumlineID), 0);
	}	
}

function groupNameToStrumlineID(n:String) {
	switch(n.toLowerCase()) {
		case "dad":
			return 0;
		case "bf" | "boyfriend":
			return 1;
		case "gf" | "girlfriend":
			return 2;
	}
	return Std.parseInt(n);
}
function strumlineIDToGroupName(i:Int) {
	switch(i) {
		case 0:
			return "dad";
		case 1:
			return "boyfriend";
		case 2:
			return "girlfriend";
	}
	return "idk";
}



///stages////////////

function onStagePreload(name:String) {
	if (stageMap.exists(name)) return;

	var newStage = new Stage(name);
	stageMap.set(name, newStage);

	for (spr in newStage.stageSprites) remove(spr);
	for (n => pos in newStage.characterPoses) remove(n);
}
function changeStage(name:String) {
	if (!stageMap.exists(name)) return;
	
	var oldStage = stage;
	var newStage = stageMap.get(name);

	for (spr in oldStage.stageSprites) remove(spr);
	for (n => pos in oldStage.characterPoses) remove(n);
	for (s in strumLines.members) {
		for (char in s.characters) remove(char);
	}
	remove(comboGroup, true);

	stage = newStage;


	var parsed = null;
	if (stage.stageXML.exists("startCamPosX") && (parsed = Std.parseFloat(stage.stageXML.get("startCamPosX")))) PlayState.instance.camFollow.x = parsed;
	if (stage.stageXML.exists("startCamPosY") && (parsed = Std.parseFloat(stage.stageXML.get("startCamPosY")))) PlayState.instance.camFollow.y = parsed;
	if (stage.stageXML.exists("zoom") && (parsed = Std.parseFloat(stage.stageXML.get("zoom")))) PlayState.instance.defaultCamZoom = parsed;
	PlayState.instance.curStage = stage.stageXML.exists("name") ? stage.stageXML.get("name") : name;

	for (n in stage.stageXML.elements()) {
		switch(n.nodeName) {
			case "sprite" | "spr" | "sparrow":
				add(stage.stageSprites.get(n.get("name")));
			case "boyfriend" | "bf" | "player":
				add(stage.characterPoses["boyfriend"]);
			case "girlfriend" | "gf":
				add(stage.characterPoses["girlfriend"]);
			case "dad" | "opponent":
				add(stage.characterPoses["dad"]);
			case "ratings" | "combo":
				add(comboGroup);
		}
	}

	for (s in strumLines.members) {
		updateCharacterPositions(s.characters, s.ID);
	}

	insert(members.length-1, comboGroup);

	scripts.call("onStageChanged", [name]);
}



function onEvent(e) {
	var event = e.event;

	switch(event.name) {
		case "Change Characters":
			changeCharacters(event.params[0], event.params[1]);
		case "Change Stage":
			changeStage(event.params[0]);
	}
}