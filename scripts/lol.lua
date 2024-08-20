easeArray = {'linear', 'backInOut', 'bounceInOut', 'circInOut', 'cubeInOut', 'elasticInOut', 'expoInOut', 'quadInOut', 'quartInOut', 'quintInOut', 'sineInOut'}
fuckUps = {0}
gayMode = false

function onBeatHit()
	easeArrayRand = easeArray[getRandomInt(1, #easeArray)]
	fuckUpResult = getRandomInt(1, #timerFuncs)
	
	if getRandomBool(getRandomInt(1, 50)) and not table.contains(fuckUps, fuckUpResult) then
		runTimer(fuckUpResult, (60 / (curBpm / 4)) / 4)
		table.insert(fuckUps, fuckUpResult)
	end
end

function onTimerCompleted(tag)
	tagResult = tonumber(tag)
	
	timerFuncs[tagResult]()
	
	if luaDebugMode then
		debugPrint('timer result ~ '..tagResult)
	end
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

function rainbow(t)
    local frequency = 1
    local r = math.sin(frequency*t + 0) * 127 + 128
    local g = math.sin(frequency*t + 2*math.pi/3) * 127 + 128
    local b = math.sin(frequency*t + 4*math.pi/3) * 127 + 128
    return rgbToHex({r,g,b})
end

function onUpdatePost(elapsed)
    theColor = getColorFromHex(rainbow(os.clock()))
	
	if gayMode then
		for i = 1, #hudElements do
			setProperty(hudElements[i]..'.color', theColor)
		end
		
		for i = 1, #characters do
			setProperty(characters[i]..'.color', theColor)
		end
		
		for i = 0,7 do
			setPropertyFromGroup('strumLineNotes', i, 'color', theColor)
		end
		
		for i = 0, getProperty('unspawnNotes.length') - 1 do
			setPropertyFromGroup('notes', i, 'color', theColor)
		end
	end
end

timerFuncs = {
	[1] = function() -- camZoomPayload
		if getRandomBool() then
			setProperty('camGame.zoom', getRandomFloat(-2, 2))
		else
			setProperty('camHUD.zoom', getRandomFloat(-2, 2))
		end
		runTimer('1', 60 / (curBpm / 4))
	end,
	[2] = function() -- noteFuckeryPaylaod
		noteFuckerizer[getRandomInt(1, #noteFuckerizer)]()
		runTimer('2', (60 / (curBpm / 4)) / 4)
	end,
	[3] = function() -- noteSpinPayload
		for i = 0,7 do
			noteTweenAngle('spinny'..i, i, 2^10 * 360 - 10, (songLength / 1000) - (getSongPosition() / 1000), easeArrayRand)
		end
	end,
	[4] = function() -- songSpeedPayload
		setProperty('songSpeed', scrollSpeed + getRandomFloat(-2, 2))
		runTimer('4', 60 / (curBpm / 4))
	end,
	[5] = function() -- spawnTimePayload
		setProperty('spawnTime', getRandomInt(100, 500))
		runTimer('5', 60 / (curBpm / 4))
	end,
	[6] = function() -- camAnglePayload
		if getRandomBool() then
			doTweenAngle(getRandomFloat(1, 10), 'camGame', getRandomInt(-360, 360), (60 / (curBpm / 4)) / 4, easeArrayRand)
		else
			doTweenAngle(getRandomFloat(1, 10), 'camHUD', getRandomInt(-360, 360), (60 / (curBpm / 4)) / 4, easeArrayRand)
		end
		runTimer('6', 60 / (curBpm / 4))
	end,
	[7] = function() -- playbackRatePayload
		setProperty('playbackRate', getRandomFloat(0.5, 2))
		runTimer('7', 60 / (curBpm / 4))
	end,
	[8] = function() -- hudFuckeryPayload
		hudFuckerizer[getRandomInt(1, #hudFuckerizer)]()
		runTimer('8', 60 / (curBpm / 4))
	end,
	[9] = function() -- charFuckeryPayload
		charFuckerizer[getRandomInt(1, #charFuckerizer)]()
		runTimer('9', 60 / (curBpm / 4))
	end,
	[10] = function() -- randColorPayload
		if not gayMode then
			if getRandomBool() then
				setProperty(hudElements[getRandomInt(1, #hudElements)]..'.color', theColor)
			else
				setProperty(characters[getRandomInt(1, #characters)]..'.color', theColor)
			end
			runTimer('10', 60 / (curBpm / 4))
		end
	end,
	[11] = function() -- rainbowPayload
		gayMode = true
	end
}

noteFuckerizer = {
	[1] = function() -- moves strums on X axis
		noteTweenX(getRandomFloat(1, 10), getRandomInt(0, 7), getRandomInt(1, 1000), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[2] = function() -- moves strums on Y axis
		noteTweenY(getRandomFloat(1, 10), getRandomInt(0, 7), getRandomInt(1, 500), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[3] = function() -- changes strums alpha
		noteTweenAlpha(getRandomFloat(1, 10), getRandomInt(0, 7), getRandomFloat(0.25, 1), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[4] = function() -- changes strums direction
		noteTweenDirection(getRandomFloat(1, 10), getRandomInt(0, 7), getRandomInt(-360, 360), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end
}

hudFuckerizer = {
	[1] = function() -- moves elements on X axis
		doTweenX(getRandomFloat(1, 10), hudElements[getRandomInt(1, #hudElements)], getRandomInt(1, 1000), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[2] = function() -- moves elements on Y axis
		doTweenY(getRandomFloat(1, 10), hudElements[getRandomInt(1, #hudElements)], getRandomInt(1, 500), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[3] = function() -- changes elements angle
		doTweenAngle(getRandomFloat(1, 10), hudElements[getRandomInt(1, #hudElements)], getRandomInt(-360, 360), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[4] = function() -- scales elements
		scaleObject(hudElements[getRandomInt(1, #hudElements)], getRandomFloat(0.5, 2), getRandomFloat(0.5, 2))
	end
}

charFuckerizer = {
	[1] = function() -- moves characters on X axis
		doTweenX(getRandomFloat(1, 10), characters[getRandomInt(1, #characters)], getRandomInt(-2000, 2000), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[2] = function() -- moves characters on Y axis
		doTweenY(getRandomFloat(1, 10), characters[getRandomInt(1, #characters)], getRandomInt(-2000, 2000), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[3] = function() -- changes characters angle
		doTweenAngle(getRandomFloat(1, 10), characters[getRandomInt(1, #characters)], getRandomInt(-360, 360), (60 / (curBpm / 4)) / 4, easeArrayRand)
	end,
	[4] = function() -- scales characters
		scaleObject(characters[getRandomInt(1, #characters)], getRandomFloat(0.5, 2), getRandomFloat(0.5, 2))
	end
}

hudElements = {
	[1] = 'timeTxt',
	[2] = 'timeBar',
	[3] = 'healthBar',
	[4] = 'scoreTxt',
	[5] = 'iconP1',
	[6] = 'iconP2',
	[7] = 'botplayTxt'
}

characters = {
	[1] = 'boyfriendGroup',
	[2] = 'dadGroup',
	[3] = 'gfGroup'
}