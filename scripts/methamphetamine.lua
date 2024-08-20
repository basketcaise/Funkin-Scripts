local editScrollSpeed = false
local rateMult = 0.5
luaDebugMode = true

function onCreatePost()
	if luaDebugMode then
		makeLuaText('rate', playbackRate, 0, 0, getProperty('botplayTxt.y') - 50)
		setTextSize('rate', 26)
		screenCenter('rate', 'X')
		addLuaText('rate')
		
		makeLuaText('mult', rateMult..' ('..(rateMult * 0.001)..')', 0, 0, getProperty('botplayTxt.y') - 75)
		setTextSize('mult', 20)
		setTextColor('mult', 'FFFF00')
		screenCenter('mult', 'X')
		addLuaText('mult')
	end
	
	if editScrollSpeed then
		setProperty('songSpeed', 0.01)
	end
end

function onStepHit()
	rateMult = rateMult * 1.005
	
	if editScrollSpeed then
		setProperty('songSpeed', getProperty('songSpeed') + (rateMult * 0.001))
	else
		setProperty('playbackRate', getProperty('playbackRate') + (rateMult * 0.001))
	end
	
	if luaDebugMode then
		if editScrollSpeed then
			setTextString('rate', round(getProperty('songSpeed'), 3))
		else
			setTextString('rate', round(getProperty('playbackRate'), 3))
		end
		screenCenter('rate', 'X')
		
		setTextString('mult', round(rateMult, 3)..' ('..round(rateMult * 0.001, 3)..')')
		screenCenter('mult', 'X')
	end
end

function round(x, n)
	n = math.pow(10, n or 0)
	x = x * n
	if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
	return x / n
end