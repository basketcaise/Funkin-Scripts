import backend.CoolUtil;
import flixel.util.FlxSave;
import flixel.text.FlxText;
import flixel.math.FlxBasePoint;
import flixel.graphics.frames.FlxTileFrames;

var fruityDancer:FlxSprite;
var fruityDances:Array<String> = ['waiting', 'stepping', 'jumping', 'zombie', 'waving', 'hula', 'windmill', 'zitabata', 'dervish'];
var holdingDancer:Bool = false;

var fruitySave:FlxSave;
var fruityTimer:FlxTimer;
var fruityText:FlxText;

function onCreate() {
	fruitySave = new FlxSave();
	fruitySave.bind('FruityDance-Psych', 'Basketcaise');
	
	if (fruitySave.data.curDance == null) {
		fruitySave.data.dancerX = 0;
		fruitySave.data.dancerY = 0;
		fruitySave.data.curDance = 0;
		
		fruitySave.flush();
	}
	
	fruityDancer = new FlxSprite(fruitySave.data.dancerX, fruitySave.data.dancerY);
	fruityDancer.frames = FlxTileFrames.fromGraphic(Paths.image('fruityDancer'), FlxBasePoint.get(220, 256));
	fruityDancer.cameras = [camOther];
	add(fruityDancer);
	
	fruityTimer = new FlxTimer();
	
	fruityText = new FlxText(fruityDancer.getGraphicMidpoint().x - 640, fruityDancer.getGraphicMidpoint().y - 125, FlxG.width, 'Fruity Dance!');
	fruityText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, 'center');
	fruityText.cameras = [camOther];
	fruityText.alpha = 0;
	add(fruityText);
	
	fruityDancer.animation.add('held', [0 + (8 * (fruityDances.length)), 1 + (8 * (fruityDances.length)), 2 + (8 * (fruityDances.length)), 3 + (8 * (fruityDances.length)), 4 + (8 * (fruityDances.length )), 5 + (8 * (fruityDances.length)), 6 + (8 * (fruityDances.length)), 7 + (8 * (fruityDances.length))], 8, true);
	
	for (i in 0...fruityDances.length) {
		fruityDancer.animation.add(fruityDances[i] + 'Left', [0 + (8 * i), 1 + (8 * i), 2 + (8 * i), 3 + (8 * i)], 8, false);
		fruityDancer.animation.add(fruityDances[i] + 'Right', [4 + (8 * i), 5 + (8 * i), 6 + (8 * i), 7 + (8 * i)], 8, false);
	}
	
	CoolUtil.setTextBorderFromString(fruityText, 'outline');
	fruityText.borderColor = FlxColor.BLACK;
	fruityText.borderSize = 1.25;
	
	FlxG.mouse.visible = true;
}

function onUpdatePost() {
	if (FlxG.mouse.overlaps(fruityDancer, camOther) && FlxG.mouse.pressed && (FlxG.mouse.deltaScreenX != 0 || FlxG.mouse.deltaScreenY != 0)) {
		holdingDancer = true;
		fruityDancer.animation.play('held', false);
		
		fruityDancer.x += FlxG.mouse.deltaScreenX * camGame.zoom;
		fruityDancer.y += FlxG.mouse.deltaScreenY * camGame.zoom;
		
		fruityText.x += FlxG.mouse.deltaScreenX * camGame.zoom;
		fruityText.y += FlxG.mouse.deltaScreenY * camGame.zoom;
	} else if (holdingDancer) {
		holdingDancer = false;
		
		fruitySave.data.dancerX = fruityDancer.x;
		fruitySave.data.dancerY = fruityDancer.y;
		
		fruitySave.flush();
	}
	
	if (FlxG.keys.justPressed.SPACE) {
		if (fruitySave.data.curDance >= fruityDances.length - 1)
			fruitySave.data.curDance = 0;
		else
			fruitySave.data.curDance += 1;
		
		fruitySave.flush();
		
		fruityTimer.cancel();
		FlxTween.completeTweensOf(fruityText);
		FlxTween.completeTweensOf(fruityText.offset);
		FlxTween.globalManager.update(0);
		
		fruityText.text = fruityDances[fruitySave.data.curDance];
		fruityText.alpha = 1;
		
		fruityTimer.start(1 / playbackRate, () -> {
			FlxTween.tween(fruityText, {alpha: 0}, 1 / playbackRate, {onComplete: function() { fruityText.text = 'Fruity Dance!'; } });
			FlxTween.tween(fruityText.offset, {y: 25}, 1 / playbackRate, {onComplete: function() { fruityText.offset.y = 0; } });
		});
	}
}

function onCountdownTick(tick:Countdown, counter:Int) {
	if (!holdingDancer) {
		if (counter % 2 == 1)
			fruityDancer.animation.play(fruityDances[fruitySave.data.curDance] + 'Left', false);
		else if (counter % 2 == 0)
			fruityDancer.animation.play(fruityDances[fruitySave.data.curDance] + 'Right', false);
	}
}

function onBeatHit() {
	if (!holdingDancer) {
		if (curBeat % 2 == 1)
			fruityDancer.animation.play(fruityDances[fruitySave.data.curDance] + 'Left', false);
		else if (curBeat % 2 == 0)
			fruityDancer.animation.play(fruityDances[fruitySave.data.curDance] + 'Right', false);
	}
}

function onDestroy() {
	FlxG.mouse.visible = false;
	fruitySave.close();
}