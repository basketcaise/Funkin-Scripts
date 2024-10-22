// shrimpleHUD 1.3 - SScript 7.7.0 / HScript Iris 1.1.0

import Type;

import backend.CoolUtil;
import backend.Difficulty;

import flixel.util.FlxStringUtil;
import flixel.util.FlxSave;
import flixel.text.FlxText;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;

import states.MainMenuState;
import objects.Bar;

// variables

var hudMap:Map<Int, Any>;
var printMap:Map<Int, String> = [
	1 => 'sVanilla',
	2 => 'Shrimple',
	3 => 'sKade',
	4 => 'Minimal'
];

var sSave:FlxSave;
var sInit:Bool = false;
var curHUD:Int;

// sVanilla vars
var vScoreTxt:FlxText;
var vIconBop:Dynamic;

// Shrimple vars (only one HA)
var sScoreTxt:FlxText;

// sKade vars
var kScoreTxt:FlxText;
var kWatermark:FlxText;
var kTimeBar:Bar;

// Minimal vars
var mScoreTxt:FlxText;
var mRatingFormats:Array<Any> = [
	[new FlxTextFormat(FlxColor.BLACK, false, false, FlxColor.RED), 0.2], // 0% to 19%
	[new FlxTextFormat(0xFFCD8032, false, false, 0xFF674019), 0.8], // 20% to 79%
	[new FlxTextFormat(0xFF808080, false, false, 0xFF404040), 0.9], // 80% to 89%
	[new FlxTextFormat(0xFFFFAA00, false, false, 0xFF805500), 1], // 90% to 99%
	[new FlxTextFormat(0xFF00DDFF, false, false, 0xFF006E80), 1] // 100%
];
var mAccFormat:FlxTextFormatMarkerPair;
var mMissFormat:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(mRatingFormats[mRatingFormats.length - 1][0], '&');
var mBotplayY:Float;

// functions

function onCreate() {
	sSave = new FlxSave();
	sSave.bind('shrimpleHUD', 'Basketcaise');
	
	if (sSave.data.HUD == null) {
		sSave.data.HUD = 1;
		sSave.flush();
	}
	
	setVar('shrimple', true);
}

function onCreatePost() {
	hudMap = [
		1 => () -> { // sVanilla
			if (!sInit) game.timeTxt.borderSize = 1.25;
			
			vScoreTxt = new FlxText(-game.healthBar.x, game.healthBar.y - 20, FlxG.width);
			vScoreTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'right', Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE, FlxColor.BLACK);
			vScoreTxt.borderSize = 1.25;
			vScoreTxt.visible = !ClientPrefs.data.hideHud;
			vScoreTxt.cameras = [game.camHUD];
			add(vScoreTxt);
			
			game.timeTxt.fieldWidth = FlxG.width;
			game.timeTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'right', Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE, FlxColor.BLACK);
			game.timeTxt.setPosition(-game.healthBar.x, game.healthBar.y + 20);
			
			if (game.cpuControlled) {
				game.botplayTxt.visible = false;
				vScoreTxt.text = '[CPU]';
			}
		},
		2 => () -> { // Shrimple
			if (!sInit) game.timeTxt.borderSize = 1.25;
			
			game.healthBar.y = ClientPrefs.data.downScroll ? 39.5 : 680.5;
			
			game.iconP1.visible = false;
			game.iconP2.visible = false;
			
			sScoreTxt = new FlxText(game.healthBar.x, ClientPrefs.data.downScroll ? game.healthBar.y + 20 : (!game.instakillOnMiss ? game.healthBar.y - 50 : game.healthBar.y - 35), FlxG.width);
			sScoreTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'left', Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE, FlxColor.BLACK);
			sScoreTxt.borderSize = 1.25;
			sScoreTxt.visible = !ClientPrefs.data.hideHud;
			sScoreTxt.cameras = [game.camHUD];
			game.uiGroup.add(sScoreTxt);
			
			game.timeTxt.fieldWidth = FlxG.width;
			game.timeTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'right', Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE, FlxColor.BLACK);
			game.timeTxt.setPosition(-game.healthBar.x, ClientPrefs.data.downScroll ? game.healthBar.y + 20 : game.healthBar.y - 20);
			
			if (game.cpuControlled) {
				sScoreTxt.text = '[CPU]';
				if (!ClientPrefs.data.downScroll) sScoreTxt.y = game.healthBar.y - 20;
				game.botplayTxt.visible = false;
			}
		},
		3 => () -> { // sKade
			if (!sInit) {
				game.timeTxt.borderSize = 1.25;
				
				if (ClientPrefs.data.downScroll)
					game.timeTxt.y += 5;
				else
					game.timeTxt.y += 6.5;
			}
			
			game.healthBar.y = ClientPrefs.data.downScroll ? 50 : 650;
			game.healthBar.setColors(0xFFFF0000, 0xFF66FF33);
			
			game.iconP1.y = game.healthBar.y - 75;
			game.iconP2.y = game.healthBar.y - 75;
			
			game.updateIconsScale = function() {
				var scaleRand:Float = FlxG.random.float(0.25, 0.75); // to mimic kade icon scale fuckery
				
				var mult:Float = FlxMath.lerp(1, game.iconP1.scale.x, scaleRand);
				game.iconP1.scale.set(mult, mult);
				game.iconP1.updateHitbox();
				
				var mult:Float = FlxMath.lerp(1, game.iconP2.scale.x, scaleRand);
				game.iconP2.scale.set(mult, mult);
				game.iconP2.updateHitbox();
			}
			
			if (game.cpuControlled) game.botplayTxt.y = ClientPrefs.data.downScroll ? game.healthBar.y + 70 : game.healthBar.y - 90;
			
			if (!ClientPrefs.data.middleScroll) {
				for (i in 0...game.opponentStrums.members.length) game.opponentStrums.members[i].x += 25;
				for (i in 0...game.playerStrums.members.length) game.playerStrums.members[i].x -= 25;
			}
			
			kWatermark = new FlxText(5, 695, FlxG.width, game.songName + ' - ' + Difficulty.getString() + ' | PE ' + MainMenuState.psychEngineVersion);
			kWatermark.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'left', Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE, FlxColor.BLACK);
			kWatermark.borderSize = 1.25;
			kWatermark.visible = !ClientPrefs.data.hideHud;
			kWatermark.cameras = [game.camHUD];
			game.uiGroup.add(kWatermark);
			
			kScoreTxt = new FlxText(0, game.healthBar.y + 30, FlxG.width);
			kScoreTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'center', Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE, FlxColor.BLACK);
			kScoreTxt.borderSize = 1.25;
			kScoreTxt.visible = !ClientPrefs.data.hideHud;
			kScoreTxt.cameras = [game.camHUD];
			game.uiGroup.add(kScoreTxt);
			
			kTimeBar = new Bar(0, ClientPrefs.data.downScroll ? 680 : 25, 'healthBar', function() return game.songPercent, 0, 1);
			kTimeBar.visible = (ClientPrefs.data.timeBarType != 'Disabled');
			kTimeBar.setColors(FlxColor.LIME, FlxColor.GRAY);
			kTimeBar.screenCenter(0x01);
			game.uiGroup.add(kTimeBar);
			
			game.uiGroup.remove(game.timeTxt);
			game.uiGroup.insert(game.uiGroup.members.indexOf(kTimeBar) + 1, game.timeTxt);
			game.timeTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'center', Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE, FlxColor.BLACK);
		},
		4 => () -> { // Minimal
			if (!sInit) game.timeTxt.visible = false;
			
			mScoreTxt = new FlxText(-game.healthBar.x, game.healthBar.y + 20, FlxG.width);
			mScoreTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, 'right', Type.resolveEnum('flixel.text.FlxTextBorderStyle').OUTLINE, FlxColor.BLACK);
			mScoreTxt.borderSize = 1.25;
			mScoreTxt.visible = !ClientPrefs.data.hideHud;
			mScoreTxt.cameras = [game.camHUD];
			add(mScoreTxt);
		}
	];
	
	if (getVar('shrimple')) {
		vIconBop = game.updateIconsScale;
		mBotplayY = game.botplayTxt.y;
		
		game.healthBar.screenCenter(0x01);
		game.scoreTxt.visible = false;
		game.timeBar.visible = false;
		
		game.grpNoteSplashes.visible = !game.cpuControlled;
		game.showComboNum = !game.cpuControlled;
		game.showRating = !game.cpuControlled;
		
		game.ratingFC = '?';
		curHUD = sSave.data.HUD;
		hudMap[curHUD]();
		
		game.updateScore(false);
		game.setOnScripts('shrimpStyle', shrimpStyle);
		sInit = true;
	}
}

function onUpdatePost(elapsed:Float) {
	if ((getVar('shrimple') && !getVar('lockShrimple')) && FlxG.keys.justPressed.TAB) {
		curHUD = FlxMath.wrap(curHUD + 1, 1, mapLength(hudMap));
		
		shrimpSwitch(true);
		hudMap[curHUD]();
		game.updateScore(false);
		
		if (sSave.data.HUD == curHUD)
			debugPrint('HUD style set to ' + printMap[curHUD], FlxColor.YELLOW);
		else
			debugPrint('ERROR: HUD style failed to be saved.', FlxColor.RED);
	}
}

function onUpdateScore() {
	var sAccuracy:Float = CoolUtil.floorDecimal(game.ratingPercent * 100, 2);
	
	if (getVar('shrimple') && !game.cpuControlled) {
		if (game.ratingPercent < 1) {
			for (i in 0...mRatingFormats.length - 1) {
				if (game.ratingPercent < mRatingFormats[i][1]) {
					mAccFormat = new FlxTextFormatMarkerPair(mRatingFormats[i][0], '$');
					break;
				}
			}
		} else {
			mAccFormat = new FlxTextFormatMarkerPair(mRatingFormats[mRatingFormats.length - 1][0], '$');
		}
		
		if (game.songMisses > 9)
			mMissFormat = new FlxTextFormatMarkerPair(mRatingFormats[0][0], '&');
		else if (game.songMisses > 0)
			mMissFormat = new FlxTextFormatMarkerPair(mRatingFormats[3][0], '&');
		
		switch(curHUD) {
			case 1:
				vScoreTxt.text = 'Score: ' + FlxStringUtil.formatMoney(game.songScore, false) + ' [' + game.ratingFC + ']';
			case 2:
				sScoreTxt.text = 'SCORE: ' + game.songScore + '\nACCURACY: ' + sAccuracy + '% [' + game.ratingFC + ']' + (!game.instakillOnMiss ? '\nMISSES: ' + game.songMisses : '');
			case 3:
				kScoreTxt.text = 'Score: ' + game.songScore + (!game.instakillOnMiss ? ' | Combo Breaks: ' + game.songMisses : '') + ' | Accuracy: ' + sAccuracy + '% (' + game.ratingFC + ') ' + game.ratingName;
			case 4:
				mScoreTxt.applyMarkup('$' + sAccuracy + '%$' + (!game.instakillOnMiss ? ' / &' + game.songMisses + '&' : ''), [mAccFormat, mMissFormat]);
				
		}
	}
}

function onResume() { // for setting botplay in charting mode pause menu
	if (getVar('shrimple')) {
		switch(curHUD) {
			case 1:
				if (game.cpuControlled) {
					game.botplayTxt.visible = false;
					vScoreTxt.text = '[CPU]';
				}
			case 2:
				if (game.cpuControlled) {
					game.botplayTxt.visible = false;
					sScoreTxt.text = '[CPU]';
					if (!ClientPrefs.data.downScroll) sScoreTxt.y = game.healthBar.y - 20;
				} else {
					sScoreTxt.y = ClientPrefs.data.downScroll ? game.healthBar.y + 20 : (!game.instakillOnMiss ? game.healthBar.y - 50 : game.healthBar.y - 35);
				}
			case 3:
				if (game.cpuControlled) kScoreTxt.text = '';
			case 4:
				if (game.cpuControlled) mScoreTxt.text = '';
		}
		
		game.grpNoteSplashes.visible = !game.cpuControlled;
		game.showComboNum = !game.cpuControlled;
		game.showRating = !game.cpuControlled;
		
		game.updateScore(false);
	}
}

function opponentNoteHit(note:Note) {
	if (getVar('shrimple') && curHUD == 3) {
		game.opponentStrums.members[note.noteData].playAnim('static');
		game.opponentStrums.members[note.noteData].resetAnim = 0; 
	} 
}

function onEvent(n:String) { if (n == 'Change Character' && (getVar('shrimple') && curHUD == 3)) game.healthBar.setColors(0xFFFF0000, 0xFF66FF33); }
function onDestroy() { sSave.close(); }

function shrimpStyle(HUD:Int, ?print:Bool = false) {
	if (getVar('shrimple') && HUD != curHUD) {
		if (HUD >= 1 && HUD <= mapLength(hudMap)) {
			curHUD = HUD;
			
			shrimpSwitch(false);
			hudMap[curHUD]();
			game.updateScore(false);
			
			if (print) debugPrint('HUD style set to ' + printMap[curHUD], FlxColor.YELLOW);
		} else {
			debugPrint('shrimpStyle(' + HUD + '): Invalid HUD style!', FlxColor.RED);
		}
	}
}

function shrimpSwitch(saveSwitch:Bool) {
	switch (curHUD) {
		case 1:
			mScoreTxt.destroy();
			game.timeTxt.visible = true;
		case 2:
			vScoreTxt.destroy();
		case 3:
			sScoreTxt.destroy();
			
			if (game.cpuControlled) game.botplayTxt.visible = true;
			
			game.timeTxt.fieldWidth = 400;
			game.timeTxt.setPosition(42 + (FlxG.width / 2) - 248, ClientPrefs.data.downScroll ? FlxG.height - 39 : 25.5);
			
			game.iconP1.visible = !ClientPrefs.data.hideHud;
			game.iconP2.visible = !ClientPrefs.data.hideHud;
		case 4:
			kWatermark.destroy();
			kScoreTxt.destroy();
			kTimeBar.destroy();
			
			game.healthBar.y = ClientPrefs.data.downScroll ? 79.2 : 640.8;
			
			game.iconP1.y = game.healthBar.y - 75;
			game.iconP2.y = game.healthBar.y - 75;
			
			game.reloadHealthBarColors();
			
			if (!ClientPrefs.data.middleScroll) {
				for (i in 0...game.opponentStrums.members.length) game.opponentStrums.members[i].x -= 25;
				for (i in 0...game.playerStrums.members.length) game.playerStrums.members[i].x += 25;
			}
			
			game.updateIconsScale = vIconBop;
			
			game.timeTxt.visible = false;
			game.botplayTxt.y = mBotplayY;
	}
	
	if (saveSwitch) {
		sSave.data.HUD = curHUD;
		sSave.flush();
	}
}

function mapLength(map:Map) { // maps don't have a length property for some reason
	var length:Int = 0;
	for (key in map.keys()) length = length + 1;
	return length;
}