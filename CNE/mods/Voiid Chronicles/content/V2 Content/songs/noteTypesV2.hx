function registerNoteTypes() {
	noteTypeData.set("BoxingMatchPunch", {skin: "BoxingMatchPunch", mustPress: true, health: 0.75, echo: "Wiik2", animSuffix: "-dodge", effect:"blurSmall"});
	noteTypeData.set("Wiik3Punch", {skin: "Wiik3PunchAlt", mustPress: true, health: 1.0, echo: "Wiik3Purple", animSuffix: "-dodge", effect:"blur"});
	noteTypeData.set("Wiik4Sword", {skin: "Wiik4Sword", mustPress: true, health: 0.35, echo: "Wiik4Purple", animSuffix: "-dodge", effect:"maxHealth", offsetsY: [-10, -10, -10, -10], offsetsYDS: [-10, -10, -10, -10]});
	noteTypeData.set("VoiidBullet", {skin: "VoiidBullet", mustPress: true, health: 0.75, echo: "", animSuffix: "-dodge", effect:"drain", offsetsX: [-25, -4, -7, 5], offsetsY: [0, 0, -32, 0], offsetsYDS: [-40, -30, 0, -40]});
	noteTypeData.set("ParryNote", {skin: "ParryNote", mustPress: true, health: 3, echo: "", animSuffix: "-dodge", offsetsY: [-165, -165, -165, -165], offsetsYDS: [-40, -40, -40, -40], flipUS: true});
	disableScript();
	//scripts.remove(__script__);
}