var stageState = 0;
public function breakStage() {
	_breakStage();
}

//hscript call event cant call public funcs
function _breakStage() {
	if (stageState >= 2) return;
	stage.stageSprites['ring'+stageState].alpha = 0;
	stageState++;
	stage.stageSprites['ring'+stageState].alpha = 1;
}