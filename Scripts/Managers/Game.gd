extends Node

var race : Race = Race.new()
var player : Player = Player.new()

signal onTick()
signal onEnd()

func newGame():
	race = Race.new()
	race.start()
	race.onEnd.connect(_onEnd)

func _onEnd():
	for b in Game.player.bets:
		for h in Game.race.horses:
			if (h.id == b):
				if(h.placement == 1):
					Game.player.money += Game.player.bets[b] * 3
				Game.player.bets[b] = 0
			break
	onEnd.emit()

func start():
	race.start()

func tick():
	race.tick()
	onTick.emit()
	
