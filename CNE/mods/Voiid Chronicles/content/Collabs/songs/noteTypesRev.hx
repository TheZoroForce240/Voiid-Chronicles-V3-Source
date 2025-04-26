function registerNoteTypes() {
	noteTypeData.set("RevPunch", {skin: "RevPunchAlt", mustPress: true, health: 1.5, echo: "Wiik3Rev", rotate: true, animSuffix: "-dodge", effect:"blur"});
	noteTypeData.set("RevSword", {skin: "RevSword", mustPress: true, health: 0.5, echo: "Wiik4Rev", animSuffix: "-dodge", effect:"maxHealth", offsetsY: [-10, -10, -10, -10], offsetsYDS: [-10, -10, -10, -10]});
	disableScript();
	//scripts.remove(__script__);
}