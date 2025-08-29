class_name Horse

enum STRATEGY {
	RUNNER,
	ENDURANCE
}

var id: int = 0
var name: String = "Horse"
var position: int = 0
var stamina: int = 30
var top_speed: int = 5
var start_speed: int = 0
var aggressiveness: int = 5
var current_speed: int = 1
var has_finished : bool = false
var placement : int = -1
var strategy: STRATEGY = STRATEGY.RUNNER

func _init(id: int, name: String, strategy: STRATEGY = STRATEGY.RUNNER):
	self.id = id
	self.name = name
	self.strategy = strategy
	start()

func start():
	position = 0
	has_finished = false
	placement = -1
	if strategy == STRATEGY.RUNNER:
		current_speed = 3 + start_speed
	else:
		current_speed = 2 + start_speed

func tickRunner():
	if GameData.VARIANCE:
		var step = 10 - aggressiveness
		current_speed += randi_range(-step, step)/aggressiveness
	current_speed = clamp(current_speed,2,top_speed)
	
func tickEndurance():
	var step = 10 - aggressiveness
	step = (aggressiveness / 10) * GameData.RACE_STEPS
	if position < step:
		current_speed = 2 + start_speed
	else:
		current_speed = top_speed

func tick():
	if(strategy == STRATEGY.RUNNER):
		tickRunner()
	elif(strategy == STRATEGY.ENDURANCE):
		tickEndurance()
	current_speed = min(current_speed, stamina)
	position += min(stamina+1,current_speed)
	position = clamp(position,0,GameData.RACE_STEPS)
	stamina -= current_speed
	if(stamina < 0):
		stamina = 0
	stamina += 5-clamp(current_speed, 1, 3)
