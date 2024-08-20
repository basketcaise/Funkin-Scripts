modHud = false
replaceSkins = false
function onCreatePost()
	if getProperty('scoreTxt.visible') == false or getProperty('healthBar.visible') == false then -- just to maybe detect if other scripts fuck with the HUD
		modHud = false
	elseif modHud then
		if replaceSkins and boyfriendName == 'bf' and gfName == 'gf' then
			triggerEvent('Change Character', 'BF', 'boxbf')
			triggerEvent('Change Character', 'GF', 'floofgfPlus')
		end
		
		setProperty('scoreTxt.visible', false)
		setProperty('healthBar.y', 35.75)
		setProperty('iconP1.visible', false)
		setProperty('iconP2.visible', false)
		
		scaleObject('timeBar', 0.5, 1)
		setObjectOrder('timeBar', getObjectOrder('iconP1') + 1)
		setProperty('timeBar.x', getProperty('healthBar.x') + 200)
		setProperty('timeBar.y', getProperty('healthBar.y') + 10)
		
		setObjectOrder('timeTxt', getObjectOrder('timeBar') + 1)
		setProperty('timeTxt.x', getProperty('healthBar.x') + 195)
		setProperty('timeTxt.y', getProperty('healthBar.y') + 20)
		
		if botPlay then
			setProperty('grpNoteSplashes.visible', false)
			setProperty('showComboNum', false)
			setProperty('showRating', false)
			setProperty('botplayTxt.visible', false)
			makeLuaText('scoreText', '[BOTPLAY]', 0, getProperty('healthBar.x'), getProperty('healthBar.y') + 20)
		else
			makeLuaText('scoreText', 'SCORE: '..score..'\nACCURACY: ? ['..ratingFC..']\nMISSES: '..misses..'', 0, getProperty('healthBar.x'), getProperty('healthBar.y') + 20)
		end
		
		addLuaText('scoreText')
		setTextAlignment('scoreText', 'left')
		setTextAlignment('timeTxt', 'right')
		setTextSize('timeTxt', getTextSize('scoreText'))
	end
end

function onCountdownTick(counter)
	if modHud and counter == 3 then
		triggerEvent('Hey!', 'both')
	end
end

function onSongStart()
	if modHud and botPlay then
		for i = 0,7 do
			noteTweenAlpha(i, i, 0.5, 1 / playbackRate)
		end
	end
end

function onUpdateScore()
	if modHud and not botPlay then
		setTextString('scoreText', 'SCORE: '..score..'\nACCURACY: '..round((getProperty('ratingPercent') * 100), 2)..'% ['..ratingFC..']\nMISSES: '..misses..'')
	end
end

function noteMiss()
	if modHud and not botPlay then
		setTextString('scoreText', 'SCORE: '..score..'\nACCURACY: '..round((getProperty('ratingPercent') * 100), 2)..'% ['..ratingFC..']\nMISSES: '..misses..'')
	end
end

function round(x, n)
	n = math.pow(10, n or 0)
	x = x * n
	if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
	return x / n
end