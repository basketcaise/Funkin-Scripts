function onCreatePost()
	setProperty('scoreTxt.visible', false)
	
	scaleObject('timeBar', 0.5, 1)
	setObjectOrder('timeBar', getObjectOrder('iconP1') + 1)
	setProperty('timeBar.x', getProperty('healthBar.x') + 200)
	setProperty('timeBar.y', getProperty('healthBar.y') + 10)
	
	setObjectOrder('timeTxt', getObjectOrder('timeBar') + 1)
	setProperty('timeTxt.x', getProperty('healthBar.x') + 195)
	setProperty('timeTxt.y', getProperty('healthBar.y') + 20)
	
	if botPlay then
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

function goodNoteHit()
	if not botPlay then
		setTextString('scoreText', 'SCORE: '..score..' ['..ratingFC..']')
	end
end

function onResume()
	if botPlay then
		setTextString('scoreText', 'SCORE: [CPU]')
	end
end