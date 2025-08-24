extends Node

var horses = [
	HorseDefinition.new(0, "Plinko"),
	HorseDefinition.new(1, "4-Dimesional Rotation"),
	HorseDefinition.new(2, "House"),
	HorseDefinition.new(3, "Dr. Props"),
	HorseDefinition.new(4, "Batman"),
	HorseDefinition.new(5, "Woopa"),
	HorseDefinition.new(6, "Tribunal"),
	HorseDefinition.new(7, "Left Cheek"),
	HorseDefinition.new(8, "Correct Horse"),
]

func getDefinitionFromID(id : int) -> HorseDefinition:
	for h in horses:
		if(id == h.id):
			return h
	return null

func defToHorse(horse: HorseDefinition):
	var result = Horse.new(horse.id, horse.name)
	return result

func defToHorseList(horses: Array[HorseDefinition]):
	var result = []
	for h in horses:
		result.push_back(defToHorse(h))
	return result

func getNextRaceHorseDefinitions() -> Array[HorseDefinition]:
	var next : Array[HorseDefinition] = []
	while(next.size() < GameData.HORSES_PER_RACE):
		var h = horses.pick_random()
		var foundHorse = false
		for horse in next:
			if(h.id == horse.id):
				foundHorse = true
				break
		if(!foundHorse):
			next.push_back(h)
	return next

func getNextRaceHorses():
	var result = defToHorseList(getNextRaceHorseDefinitions())
	print(result)
	return result
