extends Node

var race : Race = Race.new()
var player : Player = Player.new()

signal onTick()
signal onEnd()

var firstGame = false

func newGame():
	if(firstGame):
		for i in range(GameData.PLANTED_ITEMS_PER_ROUND):
			HorseFactory.simulateFeeding()
	race = Race.new()
	race.start()
	if(!firstGame):
		firstGame = true
	race.onEnd.connect(_onEnd)

func _onEnd():
	for b in Game.player.bets:
		for h in Game.race.horses:
			if (h.id == b):
				if(h.placement == 1):
					Game.player.money += Game.player.bets[b] * 3
				elif(h.placement == 2):
					Game.player.money += Game.player.bets[b] * 2
				elif(h.placement == 3):
					Game.player.money += Game.player.bets[b] * 1
				Game.player.bets[b] = 0
				break
	onEnd.emit()

func start():
	race.start()

func tick():
	race.tick()
	onTick.emit()
	
