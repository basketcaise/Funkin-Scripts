function onStepHit() {
	if (curStep % 4 == 0) {
		FlxTween.tween(boyfriend, {y: BF_Y + (boyfriend.positionArray[1] - 100)}, (Conductor.stepCrochet * 0.002) / playbackRate, {ease: FlxEase.quadOut});
		boyfriend.scale.set(boyfriend.jsonScale + 0.3, boyfriend.jsonScale - 0.15);
		FlxTween.tween(boyfriend.scale, {x: boyfriend.jsonScale, y: boyfriend.jsonScale}, (Conductor.stepCrochet * 0.002) / playbackRate, {ease: FlxEase.quadOut});
	} else if (curStep % 4 == 2) {
		FlxTween.tween(boyfriend, {y: BF_Y + boyfriend.positionArray[1]}, (Conductor.stepCrochet * 0.002) / playbackRate, {ease: FlxEase.sineIn});
	}
}