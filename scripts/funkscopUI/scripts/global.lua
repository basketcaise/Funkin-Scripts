local ui = {'healthBar', 'scoreTxt', 'timeTxt', 'iconBF', 'iconOpp'}
local petscopCredit = {
	['Impatience'] = 'Punkett' -- example
}

function onCreate()
	if getModSetting('aspect', 'funkscopUI') then
		addHaxeLibrary('Lib', 'openfl')
		
		setPropertyFromClass('openfl.Lib', 'application.window.resizable', false)
		setPropertyFromClass('openfl.Lib', 'application.window.maximized', false)
		setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)
		
		setPropertyFromClass('openfl.Lib', 'application.window.width', 960)
		setPropertyFromClass('openfl.Lib', 'application.window.height', 720)
		
		setPropertyFromClass('flixel.FlxG', 'width', 960)
		setPropertyFromClass('openfl.Lib', 'current.stage.stageWidth', 960)
		
		runHaxeCode([[
			var stage = Lib.current.stage;
			var resolutionX = 0;
			var resolutionY = 0;
			
			if (stage.window != null) {
				var display = stage.window.display;
				
				if (display != null) {
					resolutionX = Math.ceil(display.currentMode.width * stage.window.scale);
					resolutionY = Math.ceil(display.currentMode.height * stage.window.scale);
				}
			}
			
			if (resolutionX <= 0) {
				resolutionX = stage.stageWidth;
				resolutionY = stage.stageHeight;
			}
			
			Lib.application.window.x = (resolutionX - Lib.application.window.width) / 2;
			Lib.application.window.y = (resolutionY - Lib.application.window.height) / 2;
		]])
		
		setProperty('camGame.width', 960)
		setProperty('camHUD.width', 960)
		setProperty('camOther.width', 960)
	end
	
	makeLuaSprite('cdScreen')
	makeGraphic('cdScreen', screenWidth, screenHeight, '000000')
	setObjectCamera('cdScreen', 'camOther')
	addLuaSprite('cdScreen')
	
	for i = 0,3 do
		makeLuaSprite('petscopCD'..i, 'ui/'..i)
		scaleObject('petscopCD'..i, 6, 6)
		setProperty('petscopCD'..i..'.antialiasing', false)
		setProperty('petscopCD'..i..'.visible', false)
		setObjectCamera('petscopCD'..i, 'camOther')
		screenCenter('petscopCD'..i, 'XY')
		addLuaSprite('petscopCD'..i)
	end
	
	setProperty('skipArrowStartTween', true)
end

function onCreatePost()
	secCrochet = 60 / (curBpm / 4)
	local petscopScore = {
		[0] = 35,
		[1] = 20,
		[2] = 10,
		[3] = 5
	}
	
	makeLuaSprite('petscopTBar')
	makeGraphic('petscopTBar', screenWidth, 137, '000000')
	setObjectCamera('petscopTBar', 'camHUD')
	addLuaSprite('petscopTBar')
	
	makeLuaSprite('petscopBBar', nil, 0, 583)
	makeGraphic('petscopBBar', screenWidth, 137, '000000')
	setObjectCamera('petscopBBar', 'camHUD')
	addLuaSprite('petscopBBar')
	
	makeLuaText('songTxt', songName, 0, 0, 600)
	setTextFont('songTxt', 'PetscopWide.ttf')
	setTextSize('songTxt', 46)
	screenCenter('songTxt', 'X')
	setProperty('songTxt.alpha', 0)
	addLuaText('songTxt')
	
	makeLuaText('creditTxt', petscopCredit[songName], 0, 0, 650)
	setTextFont('creditTxt', 'PetscopWide.ttf')
	setTextSize('creditTxt', 38)
	screenCenter('creditTxt', 'X')
	setProperty('creditTxt.alpha', 0)
	addLuaText('creditTxt')
	
	makeLuaText('ratingTxt', nil, 0)
	setTextFont('ratingTxt', 'PetscopWide.ttf')
	setTextSize('ratingTxt', 32)
	
	setTextString('scoreTxt', 'Pieces: '..score..' | Misses: '..misses..' | Rating: ?')
	setTextFont('scoreTxt', 'PetscopWide.ttf')
	setTextSize('scoreTxt', 36)
	
	setTextFont('timeTxt', 'PetscopTall.ttf')
	screenCenter('timeTxt', 'X')
	setTextSize('timeTxt', 52)
	
	if downscroll then
		setProperty('healthBar.y', getProperty('healthBar.y') - 30)
		
		setProperty('scoreTxt.y', getProperty('scoreTxt.y') - 30)
		setProperty('ratingTxt.y', getProperty('scoreTxt.y') + 40)
		setProperty('timeTxt.y', getProperty('timeTxt.y') - 45)
	else
		setProperty('timeTxt.y', getProperty('timeTxt.y') + 25)
		setProperty('ratingTxt.y', getProperty('healthBar.y') - 40)
	end
	
	makeAnimatedLuaSprite('iconBF', nil, getProperty('iconP1.x'), getProperty('healthBar.y') - 70)
	loadGraphic('iconBF', 'icons/icon-'..getProperty('boyfriend.healthIcon'), 150)
	addAnimation('iconBF', 'icon', {0, 1}, 0)
	setObjectCamera('iconBF', 'camHUD')
	setProperty('iconBF.flipX', true)
	addLuaSprite('iconBF', true)
	
	makeAnimatedLuaSprite('iconOpp', nil, getProperty('iconP2.x'), getProperty('healthBar.y') - 70)
	loadGraphic('iconOpp', 'icons/icon-'..getProperty('dad.healthIcon'), 150)
	addAnimation('iconOpp', 'icon', {0, 1}, 0)
	setObjectCamera('iconOpp', 'camHUD')
	addLuaSprite('iconOpp', true)
	
	if botPlay then
		if downscroll then
			makeLuaSprite('demo', 'ui/demo', 0, getProperty('botplayTxt.y') - 50)
		else
			makeLuaSprite('demo', 'ui/demo', 0, getProperty('botplayTxt.y') + 50)
		end
		setObjectCamera('demo', 'camOther')
		screenCenter('demo', 'X')
		addLuaSprite('demo', true)
		
		setProperty('botplayTxt.y', -100)
	end
	
	for i = 0, getProperty('strumLineNotes.length') - 1 do
		setPropertyFromGroup('strumLineNotes', i, 'alpha', 0)
		setPropertyFromGroup('strumLineNotes', i, 'scale.x', 0.65)
		setPropertyFromGroup('strumLineNotes', i, 'scale.y', 0.65)
		--setPropertyFromGroup('strumLineNotes', i, 'useRGBShader', false)
	end
	
	for i = 0,3 do
		if downscroll then
			setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + 27.5)
			setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + 27.5)
		else
			setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 35)
			setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 35)
		end
		
		setProperty('ratingsData['..i..'].score', petscopScore[i])
	end
	
	for _,v in pairs(ui) do
		setProperty(v..'.alpha', 0)
	end
	
	setProperty('comboGroup.visible', false)
	setProperty('timeBar.visible', false)
	setProperty('iconP1.visible', false)
	setProperty('iconP2.visible', false)
	
	setProperty('ratingTxt.alpha', 0)
	addLuaText('ratingTxt')
end

function onCountdownTick(counter)
	local petscopCD = {
		[0] = function()
			doTweenZoom('cdZoom', 'camOther', 1.1, secCrochet / playbackRate)
			setProperty('petscopCD3.visible', true)
		end,
		[1] = function()
			removeLuaSprite('petscopCD3')
			setProperty('petscopCD2.visible', true)
		end,
		[2] = function()
			removeLuaSprite('petscopCD2')
			setProperty('petscopCD1.visible', true)
		end,
		[3] = function()
			removeLuaSprite('petscopCD1')
			setProperty('petscopCD0.visible', true)
			doTweenAngle('GO', 'petscopCD0', 360, (secCrochet / 4) / playbackRate, 'quadOut')
		end
	}
	
	if petscopCD[counter] then
		petscopCD[counter]()
	end
end

function onUpdatePost()
	if botPlay then
		if songStarted and getProperty('botplayTxt.alpha') == 1 then
			setProperty('demo.visible', true)
		else
			setProperty('demo.visible', false)
		end
	end
	
	setProperty('iconBF.x', getProperty('healthBar.barCenter') + (150 * getProperty('iconBF.scale.x') - 150) / 2 - 26)
	setProperty('iconBF.animation.curAnim.curFrame', getProperty('iconP1.animation.curAnim.curFrame'))
	
	setProperty('iconOpp.x', getProperty('healthBar.barCenter') - (150 * getProperty('iconOpp.scale.x')) / 2 - 26 * 2)
	setProperty('iconOpp.animation.curAnim.curFrame', getProperty('iconP2.animation.curAnim.curFrame'))
end

function onUpdateScore()
	local petscopRatings = {
		['Perfect!!'] = 'A+',
		['Sick!'] = 'A',
		['Great'] = 'B+',
		['Good'] = 'B',
		['Nice'] = 'C+',
		['Meh'] = 'C',
		['Bruh'] = 'D+',
		['Bad'] = 'D',
		['Shit'] = 'F+',
		['You Suck!'] = 'F',
	}
	
	if songStarted then
		setTextString('scoreTxt', 'Pieces: '..score..' | Misses: '..misses..' | Rating: '..petscopRatings[ratingName]..' ('..round((getProperty('ratingPercent') * 100), 2)..'%) - '..ratingFC)
	end
end

function onSpawnNote(i, d, t, s) -- thank you neb for the note scale code
	local anim = getPropertyFromGroup('notes', i, 'animation.name')
	local isEnd = anim:sub(#anim-2,#anim)=='end';
	local petscopSplashes = {
		{0xC24B99, 0xFFFFFF, 0x3C1F56}, -- left
		{0x00FFFF, 0xFFFFFF, 0x1542B7}, -- down
		{0x12FA05, 0xFFFFFF, 0x0A4447}, -- up
		{0xF9393F, 0xFFFFFF, 0x651038} -- right
	}
	
	--[[setPropertyFromGroup('notes', i, 'rgbShader.enabled', false)
	setPropertyFromGroup('notes', i, 'noteSplashData.r', petscopSplashes[d + 1][1])
	setPropertyFromGroup('notes', i, 'noteSplashData.g', petscopSplashes[d + 1][2])
	setPropertyFromGroup('notes', i, 'noteSplashData.b', petscopSplashes[d + 1][3])]]--
	
	setPropertyFromGroup('notes', i, 'scale.x', 0.65)
	
	if isEnd or not s then
		setPropertyFromGroup('notes', i, 'scale.y', 0.65)
	end
	
	if isEnd then
		setPropertyFromGroup('notes', i, 'offsetY', getPropertyFromGroup('notes', i, 'offsetY') - 12.5)
	end
end

function goodNoteHit(i, d, t, s)
	local petscopRating = {
		['sick'] = 'Amazing! ',
		['good'] = 'Good ',
		['bad'] = 'Okay ',
		['shit'] = 'Bad... '
	}
	
	if not s and not botPlay then
		setTextString('ratingTxt', petscopRating[getPropertyFromGroup('notes', i, 'rating')]..combo)
		scaleObject('ratingTxt', 1.075, 1.075)
		screenCenter('ratingTxt', 'X')
		
		doTweenX('rTxtX', 'ratingTxt.scale', 1, 0.2 / playbackRate)
		doTweenY('rTxtY', 'ratingTxt.scale', 1, 0.2 / playbackRate)
		
		doTweenAlpha('rTxtA', 'ratingTxt', 1, 0.001)
		runTimer('rTxt', 0.5 / playbackRate)
    end
	
	for i = 0, getProperty('grpNoteSplashes.length') - 1 do
		setPropertyFromGroup('grpNoteSplashes', i, 'scale.x', 0.65)
		setPropertyFromGroup('grpNoteSplashes', i, 'scale.y', 0.65)
	end
end

function noteMiss()
	setTextString('ratingTxt', 'Miss '..combo)
	screenCenter('ratingTxt', 'X')
	
	doTweenAlpha('rTxtA', 'ratingTxt', 1, 0.001)
	runTimer('rTxt', 0.5 / playbackRate)
end

function onEvent(n)
	if n == 'Change Character' then
		loadGraphic('iconBF', 'icons/icon-'..getProperty('boyfriend.healthIcon'), 150)
		addAnimation('iconBF', 'icon', {0, 1}, 0)
		
		loadGraphic('iconOpp', 'icons/icon-'..getProperty('dad.healthIcon'), 150)
		addAnimation('iconOpp', 'icon', {0, 1}, 0)
	end
end


function onTweenCompleted(n)
	if n == 'cdZoom' then
		setProperty('camOther.zoom', 1)
	elseif n == 'GO' then
		songStarted = true
		
		removeLuaSprite('petscopCD0')
		removeLuaSprite('cdScreen')
		cameraFlash('camOther', 'FFFFFF', 0.5 / playbackRate)
		
		runTimer('credits', 0.5 / playbackRate)
		runTimer('creditsEnd', (secCrochet * 2) / playbackRate)
	end
end

function onTimerCompleted(n)
	local petscopTimers = {
		['rTxt'] = function()
			doTweenAlpha('rTxtA', 'ratingTxt', 0, 0.5 / playbackRate, 'quadOut')
		end,
		['credits'] = function()
			doTweenAlpha('songTxt', 'songTxt', 1, 0.5 / playbackRate, 'quadOut')
			doTweenAlpha('creditTxt', 'creditTxt', 1, 0.5 / playbackRate, 'quadOut')
		end,
		['creditsEnd'] = function()
			for _,v in pairs(ui) do
				doTweenAlpha('ui'..v, v, 1, 0.5 / playbackRate, 'quadOut')
			end
			
			for i = 0,7 do
				noteTweenAlpha(i, i, 1, 0.5 / playbackRate)
			end
			
			doTweenAlpha('songTxt', 'songTxt', 0, 0.5 / playbackRate, 'quadOut')
			doTweenAlpha('creditTxt', 'creditTxt', 0, 0.5 / playbackRate, 'quadOut')
		end
	}
	
	if petscopTimers[n] then
		petscopTimers[n]()
	end
end

function onDestroy()
	if getModSetting('aspect', 'funkscopUI') then
		setPropertyFromClass('openfl.Lib', 'application.window.width', 1280)
		setPropertyFromClass('openfl.Lib', 'application.window.height', 720)
		setPropertyFromClass('openfl.Lib', 'application.window.resizable', true)
			
		setPropertyFromClass('flixel.FlxG', 'width', 1280)
		setPropertyFromClass('openfl.Lib', 'current.stage.stageWidth', 1280)
		
		setPropertyFromClass('openfl.Lib', 'application.window.x', 320)
		setPropertyFromClass('openfl.Lib', 'application.window.y', 180)
	end
end

function round(x, n)
	n = math.pow(10, n or 0)
	x = x * n
	if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
	return x / n
end