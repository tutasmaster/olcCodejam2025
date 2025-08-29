extends Node

signal onDefinitionUpdate()

var horses : Array[HorseDefinition] = [
	HorseDefinition.new(0, "Plinko"),
	HorseDefinition.new(1, "4th Dimensional Rotation"),
	HorseDefinition.new(2, "Residence"),
	HorseDefinition.new(3, "Dr. Props"),
	HorseDefinition.new(4, "Batman"),
	HorseDefinition.new(5, "Woopa"),
	HorseDefinition.new(6, "Tribunal"),
	HorseDefinition.new(7, "Left Cheek"),
	HorseDefinition.new(8, "Correct Horse"),
	HorseDefinition.new(9, "Chick the Tina"),
	HorseDefinition.new(10, "Chadeleur"),
	HorseDefinition.new(11, "A Latrine's Lament"),
	HorseDefinition.new(12, "Skonk da Donk"),
	HorseDefinition.new(13, "Muriel"),
	HorseDefinition.new(14, "Senseless Albany"),
	HorseDefinition.new(15, "Barbie"),
	HorseDefinition.new(16, "Cleopatra"),
	HorseDefinition.new(17, "Primary Citizen"),
	HorseDefinition.new(18, "Old Man Skate"),
	HorseDefinition.new(19, "1984"),
	HorseDefinition.new(20, "Horrid Scalp"),
	HorseDefinition.new(21, "Discombulated"),
	HorseDefinition.new(22, "Sherlock Horse"),
	HorseDefinition.new(23, "Horseinator"),
	HorseDefinition.new(24, "Rainbow Dash"),
	HorseDefinition.new(25, "Burnt Umber"),
	HorseDefinition.new(26, "Barry"),
	HorseDefinition.new(27, "Insurance France"),
	HorseDefinition.new(28, "Valerian Malpractice"),
	HorseDefinition.new(29, "Steady Firebreathing"),
	HorseDefinition.new(30, "Rock Hurl"),
	HorseDefinition.new(31, "Rocket Brain"),
	HorseDefinition.new(32, "I Heart Cribbing"),
	HorseDefinition.new(33, "Greedy Order"),
	HorseDefinition.new(34, "Equine Oreo"),
	HorseDefinition.new(35, "Brand Loyalty"),
	HorseDefinition.new(36, "Eletronica Automovel"),
	HorseDefinition.new(37, "Color and Light"),
	HorseDefinition.new(38, "Must Have"),
	HorseDefinition.new(39, "Future Glue"),
	HorseDefinition.new(40, "Latest Plan"),
	HorseDefinition.new(41, "Four Greedy Horders"),
	HorseDefinition.new(42, "Rosetta Shitpost"),
	HorseDefinition.new(43, "One Western One"),
	HorseDefinition.new(44, "Rubik's Cube"),
	HorseDefinition.new(45, "Fevereiro"),
	HorseDefinition.new(46, "People Understand"),
	HorseDefinition.new(47, "Just Enough Sense"),
	HorseDefinition.new(48, "Cuneiform"),
	HorseDefinition.new(49, "These Days"),
	HorseDefinition.new(50, "Vowel Guesses"),
	HorseDefinition.new(51, "Sweatn'Tears"),
]

func _init():
	#PLINKO
	horses[0].color = Color.from_string("#452304", Color.PURPLE)
	horses[0].maine_color = Color.from_string("#1b0e01", Color.PURPLE)
	horses[0].cover_color = Color.DARK_RED
	horses[0].headSize = 0.05
	horses[0].strategy = Horse.STRATEGY.ENDURANCE
	#BATMAN
	horses[4].color = Color.BLACK
	horses[4].cover_color = Color.BLACK
	horses[4].maine_color = Color.BLACK
	horses[4].torsoSize = 0.2
	horses[4].strategy = Horse.STRATEGY.ENDURANCE
	#OREO
	horses[34].color = Color.BLACK
	horses[34].cover_color = Color.WHITE
	horses[34].maine_color = Color.BLACK
	horses[34].headSize = 0.2
	horses[34].buttSize = 0.5
	horses[34].strategy = Horse.STRATEGY.ENDURANCE

func simulateFeeding():
	var item = ItemFactory.items.pick_random()
	while(!item.isUsableByNPC):
		item = ItemFactory.items.pick_random()
	apply_effect(item, horses.pick_random().id)

func updateHorses(horses : Array[Horse]) -> Array[Horse]:
	var result : Array[Horse] = []
	for h in horses:
		var newHorse = getDefinitionFromID(h.id)
		result.push_back(defToHorse(newHorse))
	return result

func getDefinitionFromID(id : int) -> HorseDefinition:
	for h in horses:
		if(id == h.id):
			return h
	return null

func recalculateOdds():
	for h in horses:
		h.simulatedVictories = 0
		h.simulatedLosses = 0
	for i in range(1000):
		var r = Race.new()
		r.simulation = true
		r.start()
		while(!r.isOver):
			r.tick()
		for h in r.horses:
			if(h.placement == 1):
				HorseFactory.getDefinitionFromID(h.id).simulatedVictories += 1
			else:
				HorseFactory.getDefinitionFromID(h.id).simulatedLosses += 1

func apply_effect(item : Item, horseId : int):
	var horse = getDefinitionFromID(horseId)
	if item.type == Item.EFFECT_TYPE.STAMINA:
		horse.bellySize += item.potency * 0.005
		horse.stamina += item.potency
	if item.type == Item.EFFECT_TYPE.SPEED:
		horse.buttSize += item.potency * 0.05
		horse.topSpeed += item.potency
		horse.stamina -= item.potency * 20
	if item.type == Item.EFFECT_TYPE.START_SPEED:
		horse.snoutDroop += item.potency * 0.1
		horse.startSpeed += item.potency
	if item.type == Item.EFFECT_TYPE.AGGRESSIVENESS:
		horse.neckSize += item.potency * 0.05
		horse.headSize -= item.potency * 0.05
		horse.aggressiveness += item.potency
		horse.aggressiveness = clamp(horse.aggressiveness, 1, 10)
	if item.type == Item.EFFECT_TYPE.RANDOMIZE_STRAT:
		horse.toothSize += item.potency * 0.1
		var current_strategy = horse.strategy
		var result_strategy = horse.strategy
		while(current_strategy == result_strategy):
			var result = randi_range(0,1)
			if(result == 0):
				result_strategy = Horse.STRATEGY.RUNNER
			else:
				result_strategy = Horse.STRATEGY.ENDURANCE
		horse.strategy = result_strategy
	if item.type == Item.EFFECT_TYPE.MAKE_BLUE:
		var currentColor = horse.color
		currentColor = lerp(currentColor, Color.from_hsv(0.6,0.5,currentColor.v),item.potency * 0.1) 
		horse.color = currentColor
	if item.type == Item.EFFECT_TYPE.MAKE_PINK:
		var currentColor = horse.color
		currentColor = lerp(currentColor, Color.from_hsv(0,0.3,0.5),item.potency * 0.1) 
		horse.color = currentColor
		
	onDefinitionUpdate.emit()
	pass

func defToHorse(horse: HorseDefinition):
	var result : Horse = Horse.new(horse.id, horse.name)
	result.name = horse.name
	result.stamina = horse.stamina
	result.top_speed = horse.topSpeed 
	result.start_speed = horse.startSpeed 
	result.strategy = horse.strategy
	result.aggressiveness = horse.aggressiveness
	return result

func defToHorseList(horses: Array[HorseDefinition]) -> Array[Horse]:
	var result : Array[Horse] = []
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

func getNextRaceHorses() -> Array[Horse]:
	var result = defToHorseList(getNextRaceHorseDefinitions())
	return result
