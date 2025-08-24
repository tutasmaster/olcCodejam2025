class_name Horse

enum STRATEGY {
	RUNNER,
	ENDURANCE
}

var id: int = 0
var name: String = "Horse"
var position: int = 0
var stamina: int = 30
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
	stamina = 30
	has_finished = false
	placement = -1
	if strategy == STRATEGY.RUNNER:
		current_speed = 3
	else:
		current_speed = 2

func tickRunner():
	if GameData.VARIANCE:
		current_speed += randi_range(-10, 10)/10
	current_speed = clamp(current_speed,2,4)
	
func tickEndurance():
	if position == GameData.RACE_STEPS / 2:
		current_speed = 5
	if GameData.VARIANCE:
		current_speed += randi_range(-10, 10)/10
		current_speed = clamp(current_speed,1,7)

func tick():
	if(strategy == STRATEGY.RUNNER):
		tickRunner()
	if(strategy == STRATEGY.ENDURANCE):
		tickEndurance()
	position += min(stamina+1,current_speed)
	position = clamp(position,0,GameData.RACE_STEPS)
	stamina -= current_speed
	if(stamina < 0):
		stamina = 0
	stamina += 4-clamp(current_speed, 1, 2)
