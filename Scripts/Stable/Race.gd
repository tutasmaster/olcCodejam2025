class_name Race
extends Node

signal onEnd()

var placement = 1

var horses : Array[Horse] = []

var simulation : bool = false
	
func start():
	horses = HorseFactory.getNextRaceHorses()
	for h in horses:
		h.start()

var isOver = false

func tick():
	for h in horses:
		if !h.has_finished:
			h.tick()
	var hasPlaced = false
	isOver = true
	for h in horses:
		if(h.position < GameData.RACE_STEPS):
			isOver = false
		else:
			if(!h.has_finished):
				h.has_finished = true
				h.placement = placement
				h.current_speed = 0
				hasPlaced = true
	if (hasPlaced):
		placement += 1
			
	if isOver:
		if !simulation:
			for h in horses:
				if(h.placement == 1):
					HorseFactory.getDefinitionFromID(h.id).wins += 1
				else:
					HorseFactory.getDefinitionFromID(h.id).losses += 1
				
		onEnd.emit()
		
func _onDefinitionUpdate():
	horses = HorseFactory.updateHorses(horses)
	for h in horses:
		h.start()
	
