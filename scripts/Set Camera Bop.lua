local camBop = false
local camBopType = 1
local camBopMult = {0.015, 0.03}

function onEvent(n, v1, v2)
	if n == 'Set Camera Bop' then
		if not camBop then
			camBop = true
			setProperty('camZoomingMult', 0)
		elseif camBop and (tostring(v2) == '' or tonumber(v2) == 0) then
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
		end
	}
	
	if camBop then
		camBops[camBopType]()
	end
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, tostring(match));
    end
    return result;
end