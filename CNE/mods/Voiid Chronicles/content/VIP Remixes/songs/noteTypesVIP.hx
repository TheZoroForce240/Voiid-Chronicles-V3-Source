function registerNoteTypes() {
	noteTypeData.set("RejectedPunch", {skin: "RejectedPunch", mustPress: true, health: 1.0, echo: "Wiik3Purple", rotate: true, animSuffix: "-dodge", effect:"blur"});
	noteTypeData.set("RejectedSword", {skin: "RejectedSword", mustPress: true, health: 0.35, echo: "Wiik4Purple", animSuffix: "-dodge", effect:"maxHealth", offsetsY: [-10, -10, -10, -10], offsetsYDS: [-10, -10, -10, -10]});
	noteTypeData.set("RejectedBullet", {skin: "RejectedBullet", mustPress: true, health: 0.4, echo: "Wiik2", animSuffix: "-dodge", effect:"drain", offsetsX: [-25, -4, -7, 5], offsetsY: [0, 0, -32, 0], offsetsYDS: [-40, -30, 0, -40]});
	noteTypeData.set("REJECTED_VIP_NOTES", {skin: "REJECTED_NOTES", mustPress: false, health: 2.0, echo: "", offsetX: 0, offsetY: 0, offsetsY: [-145, -145, -145, -145], offsetsYDS: [-20, -20, -20, -20]});
	disableScript();
	//scripts.remove(__script__);
}