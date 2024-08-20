ogHud = false
function onCreatePost()
	if ogHud then
		setProperty('scoreTxt.visible', false)
		
		scaleObject('timeBar', 0.5, 1)
		setObjectOrder('timeBar', getObjectOrder('iconP1') + 1)
		setProperty('timeBar.x', getProperty('healthBar.x') + 200)
		setProperty('timeBar.y', getProperty('healthBar.y') + 10)
		
		setObjectOrder('timeTxt', getObjectOrder('timeBar') + 1)
		setProperty('timeTxt.x', getProperty('healthBar.x') + 195)
		setProperty('timeTxt.y', getProperty('healthBar.y') + 20)
		
		if botPlay then
			for i = 0,3 do
				setPropertyFromGroup('playerStrums', i, 'alpha', 0.5)
			end
			setProperty('showComboNum', false)
			setProperty('showRating', false)
			setProperty('botplayTxt.visible', false)
			makeLuaText('scoreText', 'SCORE: [CPU]', 200, getProperty('healthBar.x') + 400, getProperty('healthBar.y') - 20)
		else
			makeLuaText('scoreText', 'SCORE: '..score..' ['..ratingFC..']', 200, getProperty('healthBar.x') + 400, getProperty('healthBar.y') - 20)
		end
		
		addLuaText('scoreText')
		setTextAlignment('scoreText', 'right')
		setTextAlignment('timeTxt', 'right')
		setTextSize('timeTxt', getTextSize('scoreText'))
	end
end

function goodNoteHit()
	if ogHud then
		if not botPlay then
			setTextString('scoreText', 'SCORE: '..score..' ['..ratingFC..']')
		else
			for i = 0,3 do
				setPropertyFromGroup('grpNoteSplashes', i, 'visible', false)
			end
		end
	end
end

function onResume()
	if botPlay and ogHud then
		setTextString('scoreText', 'SCORE: [CPU]')
	end
end