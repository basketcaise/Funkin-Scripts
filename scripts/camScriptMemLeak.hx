function onMoveCamera(focus:String) {
	camFollow.setPosition(700, 570);
}

function goodNoteHit(note:Note) {
	camFollow.setPosition(700, 570);
	if (PlayState.SONG.notes[game.curSection].mustHitSection) {
		switch (boyfriend.animation.curAnim.name) {
			case "singLEFT":
				game.camFollow.x = game.camFollow.x - 30;
			case "singRIGHT":
				game.camFollow.x = game.camFollow.x + 30;
			case "singUP":
				game.camFollow.y = game.camFollow.y - 30;
			case "singDOWN":
				game.camFollow.y = game.camFollow.y + 30;
		}
	}
}

function opponentNoteHit(note:Note) {
	camFollow.setPosition(700, 570);
	if (!PlayState.SONG.notes[game.curSection].mustHitSection) {
		switch (dad.animation.curAnim.name) {
			case "singLEFT":
				game.camFollow.x = game.camFollow.x - 30;
			case "singRIGHT":
				game.camFollow.x = game.camFollow.x + 30;
			case "singUP":
				game.camFollow.y = game.camFollow.y - 30;
			case "singDOWN":
				game.camFollow.y = game.camFollow.y + 30;
		}
	}
}