import funkin.backend.utils.DiscordUtil;
import funkin.backend.utils.WindowUtils;

function onGameOver() {
	DiscordUtil.changePresence('Game Over', PlayState.SONG.meta.displayName + " (" + PlayState.difficulty + ")");
}

function onDiscordPresenceUpdate(e) {
	var data = e.presence;

	if(data.button1Label == null)
		data.button1Label = "Voiid's Den";
	if(data.button1Url == null)
		data.button1Url = "https://discord.gg/TyB6ZaSsmC";
}

function onPlayStateUpdate() {
	DiscordUtil.changeSongPresence(
		PlayState.instance.detailsText,
		(PlayState.instance.paused ? "Paused - " : "") + PlayState.SONG.meta.displayName + " (" + PlayState.difficulty + ")",
		PlayState.instance.inst,
		PlayState.instance.getIconRPC()
	);
}

function onMenuLoaded(name:String) {
	// Name is either "Main Menu", "Freeplay", "Title Screen", "Options Menu", "Credits Menu", "Beta Warning", "Update Available Screen", "Update Screen"
	DiscordUtil.changePresenceSince("In the Menus", null);
	if (WindowUtils.winTitle == "Voiid Chronicles")
	{
		DiscordUtil.currentID = "1030560676923588739";
	}
}

function onEditorTreeLoaded(name:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Choosing a Character", null);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("Choosing a Chart", null);
		case "Stage Editor":
			DiscordUtil.changePresenceSince("Choosing a Stage", null);
	}
}

function onEditorLoaded(name:String, editingThing:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Editing a Character", editingThing);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("Editing a Chart", editingThing);
		case "Stage Editor":
			DiscordUtil.changePresenceSince("Editing a Stage", editingThing);
	}
}