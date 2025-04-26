import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;

function postCreate() {
	actualMaxHealth = 10;
	maxHealth = 10;
	health = 5;
}
function onChangeHealthBar(prefix) {
	if (prefix == "rvip") {
		healthBarBG.loadGraphic(Paths.image('newHealthBarRVIP'));
		healthBarBG.updateHitbox();
		healthBarBG.screenCenter(FlxAxes.X);
		remove(healthBar);

		healthBar = new FlxBar(healthBarBG.x + 13, healthBarBG.y + 15, 
			FlxBarFillDirection.RIGHT_TO_LEFT, Std.int(healthBarBG.width - 25), 23, 
			PlayState.instance, 'health', 0, maxHealth);

		healthBar.scrollFactor.set();
		healthBar.updateHitbox();
		

		if (!downscroll) {
			healthBar.offset.y += 15;
			healthBarBG.offset.y += 15;
		} else {
			healthBar.offset.y -= 18;
			healthBarBG.offset.y -= 18;
			healthBarBG.offset.y -= 15;
		}


		var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
		var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
		healthBar.createFilledBar(leftColor, rightColor);
		healthBar.cameras = [camHUD];

		insert(members.indexOf(healthBarBG)-1, healthBar);
	}
}
function onPostChangeMechanicBars(t) {
	if (t == "rvip") {
		if (!downscroll) {
			drainHPBar.offset.y += 15;
			lostHPBar.offset.y += 15;
		} else {
			drainHPBar.offset.y -= 18;
			lostHPBar.offset.y -= 18;
		}
	}
}