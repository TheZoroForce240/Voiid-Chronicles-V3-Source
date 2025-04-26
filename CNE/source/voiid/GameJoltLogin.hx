package voiid;

import flixel.addons.api.FlxGameJolt;
import funkin.editors.ui.UIButtonList;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UITextBox;
import funkin.backend.assets.Paths;
import funkin.editors.ui.UIState;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import lime.system.System;

class GameJoltLogin extends UIState
{
	var usernameBox:UITextBox;
	var usertokenBox:UITextBox;
	var statusText:UIText;
	var logout:UIButton;
	var login:UIButton;
    public function new()
    {
        super();
    }
    override public function create()
    {
        FlxG.mouse.visible = true;

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/online/room/bg_online'));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = true;
        add(bg);



		usernameBox = new UITextBox(0, 300, FlxG.save.data.gameJoltUserName != null ? FlxG.save.data.gameJoltUserName : "", 600, 64, false);
		usernameBox.label.size = 48;
		usernameBox.caretSpr.scale.set(1, 48);
		usernameBox.caretSpr.updateHitbox();
		usernameBox.x = 640 - (usernameBox.bWidth*0.5);
		add(usernameBox);

		var nameLabel = new UIText(usernameBox.x, usernameBox.y-40, 0, "Username", 30);
		add(nameLabel);


		usertokenBox = new UITextBox(0, 450, FlxG.save.data.gameJoltUserToken != null ? FlxG.save.data.gameJoltUserToken : "", 600, 64, false);
		usertokenBox.label.textField.displayAsPassword = true;
		usertokenBox.label.size = 48;
		usertokenBox.caretSpr.scale.set(1, 48);
		usertokenBox.caretSpr.updateHitbox();
		usertokenBox.x = 640 - (usertokenBox.bWidth*0.5);
		add(usertokenBox);
		

		var tokenLabel = new UIText(usertokenBox.x, usertokenBox.y-40, 0, "User/Game Token", 30);
		add(tokenLabel);


		statusText = new UIText(usernameBox.x, 560, 0, "", 30);
		add(statusText);

		logout = new UIButton(640-180, 620, "Sign Out", function() {
			FlxG.save.data.gameJoltUserName = null;
			FlxG.save.data.gameJoltUserToken = null;
			FlxG.save.flush();
			GameJolt.logout();
			statusText.text = "";
		});
		add(logout);

		login = new UIButton(640+60, 620, "Sign In", function() {
			FlxG.save.data.gameJoltUserName = usernameBox.label.text;
			FlxG.save.data.gameJoltUserToken = usertokenBox.label.text;
			FlxG.save.flush();
			login.selectable = false;
			logout.selectable = false;
			statusText.text = "Signing in...";
			GameJolt.login(function(success) {

				if (success) {
					statusText.text = "Signed in successfully!";
				} else {
					GameJolt.logout();
					statusText.text = "Failed to sign in.";
				}

				login.selectable = true;
				logout.selectable = true;
			});
		});
		add(login);


        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE) exit();
    }

	function exit() {
		#if UPLOAD_WHITELIST
		DevWhitelist.updateWhitelist();
		#end
		#if devbuild
		DevWhitelist.checkname();
		FlxG.switchState(new funkin.menus.TitleState());
		#else
		FlxG.switchState(new funkin.menus.MainMenuState());
		#end
	}
}