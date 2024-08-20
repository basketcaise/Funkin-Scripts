local camBop = false
local camBopType = 1
local camBopMult = {0.015, 0.03}
local camBopDir = 'L'

function onEvent(n, v1, v2)
	if n == 'Set Camera Bop' then
		if not camBop then
			camBop = true
			setProperty('camZoomingMult', 0)
		elseif camBop and v2 == '' then
			camBop = false
			camBopType = 1
		end
		
		if v1 ~= '' then
			camBopMult = split(v1, ',')
		else
			camBopMult = {0.015, 0.03}
		end
		
		if v2 ~= '' then
			camBopType = tonumber(v2)
		end
		
		if tonumber(v2) ~= 3 then
			doTweenAngle('angleSet', 'camHUD', 0, crochet / 1000, 'quintOut')
			doTweenY('ySet', 'camHUD', 0, crochet / 1000, 'quintOut')
		end
	end
end

function onBeatHit()
	local camBops = {
		[1] = function()
			setProperty('camGame.zoom', getProperty('camGame.zoom') + tonumber(camBopMult[1]))
			setProperty('camHUD.zoom', getProperty('camHUD.zoom') + tonumber(camBopMult[2]))
		end,
		[2] = function()
			if curBeat % 2 == 0 then
				setProperty('camGame.zoom', getProperty('camGame.zoom') + tonumber(camBopMult[1]))
				setProperty('camHUD.zoom', getProperty('camHUD.zoom') + tonumber(camBopMult[2]))
			end
		end,
		[3] = function()
			if curBeat % 1 == 0 then
				if camBopDir == 'L' then
					doTweenAngle('angleBopL', 'camHUD', -1, (crochet / 1000) / 2, 'quintOut')
					camBopDir = 'R'
				else
					doTweenAngle('angleBopR', 'camHUD', 1, (crochet / 1000) / 2, 'quintOut')
					camBopDir = 'L'
				end
				doTweenY('yBopDown', 'camHUD', 10, (crochet / 1000) / 2, 'quintOut')
			end
			
			setProperty('camGame.zoom', getProperty('camGame.zoom') + tonumber(camBopMult[1]))
			setProperty('camHUD.zoom', getProperty('camHUD.zoom') + tonumber(camBopMult[2]))
		end
	}
	
	if camBop then
		camBops[camBopType]()
	end
end

function onTweenCompleted(t)
	if t == 'yBopDown' then
		doTweenY('yBopUp', 'camHUD', 0, (crochet / 1000) / 2, 'circIn')
	end
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, tostring(match));
    end
    return result;
end