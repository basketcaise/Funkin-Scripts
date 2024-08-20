function onUpdatePost()
	if getProperty('camZooming') then
		setProperty('playbackRate', getRandomFloat(0.1, 2))
		
		scaleObject('boyfriendGroup', getRandomFloat(getProperty('boyfriend.jsonScale') - 0.3, getProperty('boyfriend.jsonScale') + 0.3), getRandomFloat(getProperty('boyfriend.jsonScale') - 0.3, getProperty('boyfriend.jsonScale') + 0.3), false)
		scaleObject('gfGroup', getRandomFloat(getProperty('gf.jsonScale') - 0.3, getProperty('gf.jsonScale') + 0.3), getRandomFloat(getProperty('gf.jsonScale') - 0.3, getProperty('gf.jsonScale') + 0.3), false)
		scaleObject('dadGroup', getRandomFloat(getProperty('dad.jsonScale') - 0.3, getProperty('dad.jsonScale') + 0.3), getRandomFloat(getProperty('dad.jsonScale') - 0.3, getProperty('dad.jsonScale') + 0.3), false)
	end
end