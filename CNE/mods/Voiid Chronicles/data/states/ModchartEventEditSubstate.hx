import funkin.editors.ui.UISubstateWindow;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UIDropDown;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UICheckbox;

var propertyMap = ["" => null];

var curX = 0;
var curY = 0;

function create() {
	var n = CURRENT_EVENT.event.type;
	switch(CURRENT_EVENT.event.type) {
		case "setShaderProperty" | "tweenShaderProperty":
			n = CURRENT_EVENT.event.name + "." + CURRENT_EVENT.event.property;
		case "setModifierValue" | "tweenModifierValue":
			n = CURRENT_EVENT.event.name;
	}

	winTitle = "Edit Modchart Event - " + n;
	winWidth = 960;

	switch(CURRENT_EVENT.event.type) {
		case "setShaderProperty" | "addCameraZoom" | "addHUDZoom" | "setModifierValue":
			winWidth = 520;
			winHeight = 300;
		case "tweenShaderProperty" | "tweenModifierValue":
			winHeight = 420;
	}

}
function addLabelOn(ui:UISprite, text:String)
	add(new UIText(ui.x, ui.y - 24, 0, text));

function addStepperButtons(stepper:UINumericStepper, change1:Float, change2:Float = 0.0, w:Float = 32.0) {

	var leftButton = new UIButton(stepper.x-w, stepper.y, "<", function() {
		stepper.onChange(Std.string(stepper.value-change1));
	}, w); add(leftButton);

	if (change2 != 0.0) {
		var leftButton2 = new UIButton(leftButton.x-w, stepper.y, "<<", function() {
			stepper.onChange(Std.string(stepper.value-change2));
		}, w); add(leftButton2);
	}

	var rightButton = new UIButton(stepper.x+stepper.bWidth, stepper.y, ">", function() {
		stepper.onChange(Std.string(stepper.value+change1));
	}, w); add(rightButton);

	if (change2 != 0.0) {
		var rightButton2 = new UIButton(rightButton.x+rightButton.bWidth, stepper.y, ">>", function() {
			stepper.onChange(Std.string(stepper.value+change2));
		}, w); add(rightButton2);
	}
}

var useEaseBoxes = false;
var easeBoxes = [];
var easeWidth = 300;
var easeBoxWidth = 5;
var easeFunc = FlxEase.linear;
var easeList = [
	"linear",

	"quadIn",
	"quadOut",
	"quadInOut",

	"cubeIn",
	"cubeOut",
	"cubeInOut",

	"quartIn",
	"quartOut",
	"quartInOut",

	"quintIn",
	"quintOut",
	"quintInOut",

	"sineIn",
	"sineOut",
	"sineInOut",

	"bounceIn",
	"bounceOut",
	"bounceInOut",

	"circIn",
	"circOut",
	"circInOut",

	"expoIn",
	"expoOut",
	"expoInOut",

	"backIn",
	"backOut",
	"backInOut",

	"elasticIn",
	"elasticOut",
	"elasticInOut",

	"smoothStepIn",
	"smoothStepOut",
	"smoothStepInOut",

	"smootherStepIn",
	"smootherStepOut",
	"smootherStepInOut"
];

function postCreate() {
	propertyMap.clear();

	curX = windowSpr.x + 20;
	curY = windowSpr.y + 41;

	var displayName = "";
	switch(CURRENT_EVENT.event.type) {
		case "addCameraZoom": 
			displayName = "Add Camera Zoom";
		case "addHUDZoom": 
			displayName = "Add HUD Zoom";
		case "setShaderProperty": 
			displayName = "Set Shader Property";
		case "setModifierValue": 
			displayName = "Set Modifier Property";
		case "tweenShaderProperty": 
			displayName = "Tween Shader Property";
		case "tweenModifierValue": 
			displayName = "Tween Modifier Property";
	}

	switch(CURRENT_EVENT.event.type) {
		case "addCameraZoom" | "addHUDZoom":
			add(new UIText(curX, curY, 0, displayName, 24));
			curY += 28 + 50;

			curX = windowSpr.x + (windowSpr.bWidth/2) - 50;
			addStepper("value", "Value", CURRENT_EVENT.event.value, 0.01, 0.1);

		case "setShaderProperty" | "setModifierValue":
			add(new UIText(curX, curY, 0, displayName, 24));
			curY += 28 + 50;

			curX = windowSpr.x + (windowSpr.bWidth/2) - 50;
			addStepper("value", "Value", CURRENT_EVENT.event.value);

		case "tweenShaderProperty" | "tweenModifierValue":
			add(new UIText(curX, curY, 0, displayName, 24));
			curY += 28 + 50;

			var temp = curY;
			curX += 115;
			
			curY -= 50;
			createEaseBoxes();
			curY += 50;

			addStepper("startValue", "Start Value", CURRENT_EVENT.event.startValue);

			curX -= 65;
			addCheckbox("DI_startValue", "Inverse on Downscroll?", CURRENT_EVENT.event.DI_startValue != null ? CURRENT_EVENT.event.DI_startValue : false);
			curX += 65;

			curY = temp;
			curX += 600;
			addStepper("value", "End Value", CURRENT_EVENT.event.value);
			
			curX -= 65;
			addCheckbox("DI_value", "Inverse on Downscroll?", CURRENT_EVENT.event.DI_value != null ? CURRENT_EVENT.event.DI_value : false);
			curX += 65;

			curY += 100;
			var dropdown = new UIDropDown(windowSpr.x+(windowSpr.bWidth/2)-150, curY, 320, 32, easeList, easeList.indexOf(CURRENT_EVENT.event.ease));
			propertyMap.set("ease", dropdown);
			dropdown.onChange = function(index) {
				easeFunc = CoolUtil.flxeaseFromString(easeList[index], "");
			};
			add(dropdown);

			curY -= 28;
			addStepper("time", "Tween Length (steps)", CURRENT_EVENT.event.time, 1, 4);
	}

	trace(CURRENT_EVENT.event);

	var saveButton = new UIButton(windowSpr.x + windowSpr.bWidth - 20, windowSpr.y + windowSpr.bHeight - 16 - 32, "Save & Close", function() {
		switch(CURRENT_EVENT.event.type) {
			case "setShaderProperty" | "addCameraZoom" | "addHUDZoom" | "setModifierValue":
				CURRENT_EVENT.event.value = propertyMap.get("value").value;
			case "tweenShaderProperty" | "tweenModifierValue":
				CURRENT_EVENT.event.startValue = propertyMap.get("startValue").value;
				CURRENT_EVENT.event.value = propertyMap.get("value").value;
				CURRENT_EVENT.event.ease = easeList[propertyMap.get("ease").index];
				CURRENT_EVENT.event.time = propertyMap.get("time").value;

				CURRENT_EVENT.event.DI_startValue = propertyMap.get("DI_startValue").checked;
				CURRENT_EVENT.event.DI_value = propertyMap.get("DI_value").checked;
		}
		EVENT_EDIT_CALLBACK();
		close();
	});
	saveButton.x -= saveButton.bWidth;
	add(saveButton);

	var closeButton = new UIButton(saveButton.x - 10, saveButton.y, "Close", function() {
		EVENT_EDIT_CANCEL_CALLBACK();
		close();
	});
	closeButton.color = 0xFFFF0000;
	closeButton.x -= closeButton.bWidth;
	add(closeButton);

	var deleteButton = new UIButton(windowSpr.x + 20, windowSpr.y + windowSpr.bHeight - 16 - 32, "Delete", function() {
		EVENT_DELETE_CALLBACK();
		close();
	});
	add(deleteButton);
}

function addStepper(name, label, value, ?stepperV1, ?stepperV2) {

	if (stepperV1 == null) stepperV1 = 0.1;
	if (stepperV2 == null) stepperV2 = 1;
	
	var text = new UIText(curX, curY, 0, label);
	add(text);
	curY += 28;

	var numericStepper = new UINumericStepper(curX, curY, value, 1, 3, null, null, 120);
	add(numericStepper);
	curY += 50;

	addStepperButtons(numericStepper, stepperV1, stepperV2, 32);

	text.x += numericStepper.bWidth/2;
	text.x -= text.width/2;

	propertyMap.set(name, numericStepper);
}

function addCheckbox(name, label, value) {


	var checkbox = new UICheckbox(curX, curY, label, value);
	add(checkbox);
	propertyMap.set(name, checkbox);
}


function createEaseBoxes() {
	useEaseBoxes = true;

	var easeText = new UIText(windowSpr.x+(windowSpr.bWidth/2), curY, 0, "Ease");
	add(easeText);
	easeText.x -= easeText.width/2;

	for (i in 0...(easeWidth/easeBoxWidth)) {
		var spr = new FlxSprite();
		spr.makeSolid(easeBoxWidth, easeBoxWidth, -1);
		add(spr);
		spr.x = windowSpr.x + ((windowSpr.bWidth/2) - 150) + (easeBoxWidth/2) + (i * easeBoxWidth);
		spr.y = curY + 40;
		easeBoxes.push(spr);
	}
	easeFunc = CoolUtil.flxeaseFromString(CURRENT_EVENT.event.ease, "");
}
function update(elapsed) {

	if (useEaseBoxes) {
		for (i in 0...easeBoxes.length) {
			var spr = easeBoxes[i];
	
			var value = easeFunc(i/easeBoxes.length)*100;
			if (propertyMap.get("value").value < propertyMap.get("startValue").value) value = -value + 100;
	
			spr.offset.y = CoolUtil.fpsLerp(spr.offset.y, value - 100, 0.1);
		}
	}

}