import backend.MusicBeatState;
import flixel.sound.FlxSound;
import flixel.math.FlxBasePoint;
import flixel.graphics.frames.FlxTileFrames;

var jumpSprite:FlxSprite;
var gameOverStatic:FlxSprite;
var gameOverScreen:FlxSprite;
var gameOverTxt:FlxSprite;

var jumpTimer:FlxTimer;
var jumpSound:FlxSound;
var staticSound:FlxSound;

function onCreate() {
	var jumpRand = FlxG.random.int(1, 10);
	var jumpMap:Map<Int, Dynamic> = [ // amount of frames for each sheet
		1 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
		2 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
		3 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
		4 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
		5 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
		6 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
		7 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
		8 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
		9 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
		10 => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
	];
	
	jumpSprite = new FlxSprite();
	jumpSprite.frames = FlxTileFrames.fromGraphic(Paths.image('jumps/' + jumpRand), FlxBasePoint.get(1024, 768));
	jumpSprite.animation.add('scare', jumpMap[jumpRand], 20, false);
	jumpSprite.cameras = [camOther];
	jumpSprite.visible = false;
	add(jumpSprite);
	
	gameOverScreen = new FlxSprite().loadGraphic(Paths.image('gameOverScreen'));
	gameOverScreen.cameras = [camOther];
	gameOverScreen.visible = false;
	add(gameOverScreen);
	
	gameOverTxt = new FlxSprite(0, FlxG.height - 60).loadGraphic(Paths.image('gameOverTxt'));
	gameOverTxt.cameras = [camOther];
	gameOverTxt.visible = false;
	gameOverTxt.screenCenter(1);
	add(gameOverTxt);
	
	gameOverStatic = new FlxSprite();
	gameOverStatic.frames = FlxTileFrames.fromGraphic(Paths.image('gameOverStatic'), FlxBasePoint.get(1024, 768));
	gameOverStatic.animation.add('static', [0, 1, 2, 3, 4, 5], 20, true);
	gameOverStatic.cameras = [camOther];
	gameOverStatic.visible = false;
	add(gameOverStatic);
	
	var toScale:Array<FlxSprite> = [jumpSprite, gameOverScreen, gameOverStatic];
	for (i in toScale) {
		i.scale.set(FlxG.width / i.width, FlxG.height / i.height);
		i.updateHitbox();
		i.screenCenter();
	}
	
	jumpTimer = new FlxTimer();
	jumpSound = new FlxSound().loadEmbedded(Paths.sound('scream'));
	staticSound = new FlxSound().loadEmbedded(Paths.sound('static'));
}

function onUpdatePost() {
	if (gameOverScreen.visible) {
		if (controls.ACCEPT)
			MusicBeatState.resetState();
		else if (controls.BACK)
			game.endSong();
	}
}

function onGameOver() {
	if (!boyfriend.stunned) {
		camOther.filters = [];
		
		game.healthLoss = 0;
		game.canPause = false;
		boyfriend.stunned = true;
		
		jumpSprite.visible = true;
		FlxG.animationTimeScale = 1;
		jumpSprite.animation.play('scare', true);
		
		jumpSound.play(true);
		jumpTimer.start(0.8, () -> {
			jumpSound.stop();
			jumpSprite.visible = false;
			camGame.visible = false;
			camHUD.visible = false;
			
			game.paused = true;
			
			vocals.stop();
			opponentVocals.stop();
			FlxG.sound.music.stop();
			
			game.persistentUpdate = false;
			game.persistentDraw = false;
			
			FlxTimer.globalManager.clear();
			FlxTween.globalManager.clear();
			
			modchartTimers.clear();
			modchartTweens.clear();
			
			game.isDead = true;
			game.KillNotes();
			
			gameOverStatic.visible = true;
			gameOverStatic.animation.play('static', true);
			staticSound.play(true);
			
			jumpTimer.start(5, () -> {
				gameOverStatic.alpha = 0.25;
				gameOverScreen.visible = true;
				gameOverTxt.visible = true;
			});
		});
	}
	
	return Function_Stop;
}