-- shrimpleHUD 1.2 -- Psych 0.7.2+ --

local hudFunctions = {
	[1] = function() -- Vanilla-like
		setProperty('scoreTxt.visible', false)
		
		if luaTextExists('kScoreTxt') then
			removeLuaText('kScoreTxt')
			removeLuaText('kWatermark')
		end
		
		if downscroll then
			setProperty('healthBar.y', 79.2)
		else
			setProperty('healthBar.y', 640.8)
		end

		if not luaTextExists('vScoreTxt') then
			makeLuaText('vScoreTxt', 'SCORE: '..score..' ['..ratingFC..']', 200, getProperty('healthBar.x') + 402.5, getProperty('healthBar.y') - 20)
			setTextAlignment('vScoreTxt', 'right')
		end
		addLuaText('vScoreTxt')
		
		scaleObject('timeBar', 0.5, 1)
		setProperty('timeBar.x', getProperty('healthBar.x') + 200)
		setProperty('timeTxt.x', getProperty('healthBar.x') + 195)
		setProperty('timeBar.y', getProperty('healthBar.y') + 12.5)
		setProperty('timeTxt.y', getProperty('healthBar.y') + 22.5)
		
		if botPlay then
			setProperty('grpNoteSplashes.visible', false)
			setProperty('showComboNum', false)
			setProperty('showRating', false)
			setProperty('botplayTxt.visible', false)
			setTextString('vScoreTxt', '[BOTPLAY]')
		end
		
		setTextAlignment('timeTxt', 'right')
		setTextSize('timeTxt', getTextSize('vScoreTxt'))
	end,
	[2] = function() -- Shrimple
		setProperty('scoreTxt.visible', false)
		setProperty('iconP1.visible', false)
		setProperty('iconP2.visible', false)
		
		if luaTextExists('vScoreTxt') then
			removeLuaText('vScoreTxt')
		end
		
		if not luaTextExists('sScoreTxt') then
			makeLuaText('sScoreTxt', 'SCORE: '..score..'\nACCURACY: '..round((getProperty('ratingPercent') * 100), 2)..'% ['..ratingFC..']\nMISSES: '..misses, 0, getProperty('healthBar.x'))
			setTextAlignment('sScoreTxt', 'left')
		end
		addLuaText('sScoreTxt')
		
		if downscroll then
			setProperty('healthBar.y', 35.75)
			
			setProperty('sScoreTxt.y', getProperty('healthBar.y') + 22.5)
			
			setProperty('timeBar.y', getProperty('healthBar.y') + 12.5)
			setProperty('timeTxt.y', getProperty('healthBar.y') + 22.5)
		else
			setProperty('healthBar.y', 684.25)
			
			if botPlay then
				setProperty('sScoreTxt.y', getProperty('healthBar.y') - 20)
			else
				setProperty('sScoreTxt.y', getProperty('healthBar.y') - 50)
			end
			
			setProperty('timeBar.y', getProperty('healthBar.y') - 30)
			setProperty('timeTxt.y', getProperty('healthBar.y') - 20)
		end
		
		scaleObject('timeBar', 0.5, 1)
		setProperty('timeBar.x', getProperty('healthBar.x') + 200)
		setProperty('timeTxt.x', getProperty('healthBar.x') + 195)
		
		if botPlay then
			setProperty('grpNoteSplashes.visible', false)
			setProperty('showComboNum', false)
			setProperty('showRating', false)
			setProperty('botplayTxt.visible', false)
			setTextString('sScoreTxt', '[BOTPLAY]')
		end
		
		setTextAlignment('timeTxt', 'right')
		setTextSize('timeTxt', getTextSize('sScoreTxt'))
	end,
	[3] = function() -- sKade
		setProperty('scoreTxt.visible', false)
		setProperty('iconP1.visible', true)
		setProperty('iconP2.visible', true)
		
		if luaTextExists('sScoreTxt') then
			removeLuaText('sScoreTxt')
		end
		
		if not luaTextExists('kScoreTxt') then
			makeLuaText('kScoreTxt', 'Score: '..score..' | Combo Breaks: '..misses..' | Accuracy: '..round((getProperty('ratingPercent') * 100), 2)..'% | ('..ratingFC..') '..ratingName, 0)
			setTextAlignment('kScoreTxt', 'center')
			screenCenter('kScoreTxt', 'X')
		end
		addLuaText('kScoreTxt')
		
		if not luaTextExists('kWatermark') then
			makeLuaText('kWatermark', songName..' - '..difficultyName..' | PE '..version, 0, 5)
		end
		addLuaText('kWatermark')
		
		if downscroll then
			setProperty('timeBar.y', 680)
			setProperty('healthBar.y', 50)
			
			setProperty('iconP1.y', getProperty('healthBar.y') - 70)
			setProperty('iconP2.y', getProperty('healthBar.y') - 70)
			
			setProperty('kWatermark.y',  getProperty('timeBar.y') + 20)
		else
			setProperty('timeBar.y', 5)
			setProperty('healthBar.y', 650)
			
			setProperty('iconP1.y', getProperty('healthBar.y') - 75)
			setProperty('iconP2.y', getProperty('healthBar.y') - 75)
			
			setProperty('kWatermark.y',  getProperty('healthBar.y') + 50)
		end
		
		if not middlescroll then
			for i = 0,3 do
				setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x') + 35)
			end
			
			for i = 4,7 do
				setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x') - 25)
			end
		end
		
		setProperty('kScoreTxt.y', getProperty('healthBar.y') + 40)
		
		scaleObject('timeBar', 1.5, 1)
		screenCenter('timeBar', 'X')
		screenCenter('timeTxt', 'X')
		setProperty('timeBar.x', getProperty('timeBar.x') - 300)
		setProperty('timeTxt.y', getProperty('timeBar.y') + 10)
		
		setTimeBarColors('00FF00', '808080')
		setHealthBarColors('FF0000', '66FF33')
		
		if botPlay then
			setProperty('grpNoteSplashes.visible', true)
			setProperty('showComboNum', true)
			setProperty('showRating', true)
			setProperty('botplayTxt.visible', true)
		end
		
		setTextAlignment('timeTxt', 'center')
		setTextSize('timeTxt', getTextSize('kScoreTxt'))
	end
}

function onCreate()
	initSaveData('shrimpleHUD', 'shrimpleHUD')
	if getDataFromSave('shrimpleHUD', 'HUD') == nil then
		setDataFromSave('shrimpleHUD', 'HUD', 1)
		flushSaveData('shrimpleHUD')
	end
	setVar('sHUDEnabled', true)
end

function onCreatePost()
	if getVar('sHUDEnabled') then
		if version < '0.7.2' then
			debugPrint('This version of shrimpleHUD is intended for v0.7.2+. Things might not work correctly!')
		end
		
		screenCenter('healthBar', 'X')
		hudFunctions[getDataFromSave('shrimpleHUD', 'HUD')]()
	end
end

function onUpdatePost()
	curHUD = getDataFromSave('shrimpleHUD', 'HUD')
	local hudPrints = {
		[1] = 'HUD style set to Vanilla-like',
		[2] = 'HUD style set to Shrimple',
		[3] = 'HUD style set to sKade'
	}
	
	if keyboardJustPressed('NINE') and getVar('sHUDEnabled') then
		if curHUD < #hudFunctions then
			hudFunctions[curHUD + 1]()
			debugPrint(hudPrints[curHUD + 1], 'YELLOW')
			setDataFromSave('shrimpleHUD', 'HUD', curHUD + 1)
		elseif curHUD >= #hudFunctions then
			hudFunctions[1]()
			debugPrint(hudPrints[1], 'YELLOW')
			
			if not middlescroll then
				for i = 0,3 do
					setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x') - 35)
				end
			
				for i = 4,7 do
					setPropertyFromGroup('strumLineNotes', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x') + 25)
				end
			end
			
			setProperty('iconP1.y', getProperty('healthBar.y') - 75)
			setProperty('iconP2.y', getProperty('healthBar.y') - 75)
			
			runHaxeCode([[
				healthBar.setColors(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
				return;
			]])
			setTimeBarColors('FFFFFF', '000000')
			
			setDataFromSave('shrimpleHUD', 'HUD', 1)
		end
		flushSaveData('shrimpleHUD')
	end
end

function onUpdateScore()
	local scoreFunctions = {
		[1] = function()
			setTextString('vScoreTxt', 'SCORE: '..score..' ['..ratingFC..']')
		end,
		[2] = function()
			setTextString('sScoreTxt', 'SCORE: '..score..'\nACCURACY: '..round((getProperty('ratingPercent') * 100), 2)..'% ['..ratingFC..']\nMISSES: '..misses)
		end,
		[3] = function()
			setTextString('kScoreTxt', 'Score: '..score..' | Combo Breaks: '..misses..' | Accuracy: '..round((getProperty('ratingPercent') * 100), 2)..'% | ('..ratingFC..') '..ratingName, 0)
			screenCenter('kScoreTxt', 'X')
		end
	}

	if not botPlay and getVar('sHUDEnabled') and startedCountdown then
		scoreFunctions[getDataFromSave('shrimpleHUD', 'HUD')]()
	end
end

function onEvent(n)
	if curHUD == 3 and getVar('sHUDEnabled') and n == 'Change Character' then
		setHealthBarColors('FF0000', '66FF33')
	end
end

-- etc functions --

function round(x, n)
	n = math.pow(10, n or 0)
	x = x * n
	if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
	return x / n
end