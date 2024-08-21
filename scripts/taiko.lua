local enableTaiko = true -- toggles the script you dumbfuck
local changeNoteskin = true -- changes noteskin to Chip, set to false if your build doesn't have it
local prevNoteSkin = ''

function onCreate()
	if enableTaiko and changeNoteskin then
		if getPropertyFromClass('backend.ClientPrefs', 'data.noteSkin') ~= 'Chip' then
			prevNoteSkin = getPropertyFromClass('backend.ClientPrefs', 'data.noteSkin')
			setPropertyFromClass('backend.ClientPrefs', 'data.noteSkin', 'Chip')
		end
	end
end

function onCreatePost()
	if enableTaiko then
		for i = 0,3 do
			if downscroll then
				setPropertyFromGroup('playerStrums', i, 'x', 1100)
			else
				setPropertyFromGroup('playerStrums', i, 'y', 570)
				setPropertyFromGroup('playerStrums', i, 'x', 100)
			end
			
			setPropertyFromGroup('opponentStrums', i, 'x', -500)
			setPropertyFromGroup('playerStrums', i, 'direction', 0)
		end
		
		if downscroll then
			setProperty('timeBar.x', 25)
			setProperty('timeTxt.x', 275)
		else
			setProperty('timeBar.x', 1100)
			setProperty('timeTxt.x', 1100)
		end
	end
end

function onSpawnNote(i, n, t, s)
	if enableTaiko then
		setPropertyFromGroup('notes', i, 'angle', 270)
		
		if s then
			if getPropertyFromGroup('notes', i, 'animation.curAnim.name'):match('holdend') ~= 'holdend' then
				setPropertyFromGroup('unspawnNotes', i, 'offset.x', 105)
				setPropertyFromGroup('unspawnNotes', i, 'offset.y', -185)
			else
				setPropertyFromGroup('unspawnNotes', i, 'offset.y', -20)
			end
		end
	end
end

function onDestroy()
	if enableTaiko and prevNoteSkin ~= '' then
		setPropertyFromClass('backend.ClientPrefs', 'data.noteSkin', prevNoteSkin)
	end
end
