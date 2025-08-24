extends Node

var _accum = 0

var running = false
var ui_horses : Array[HSlider] = []
var ui_bets : Array[SpinBox] = []

func _ready() -> void:
	Game.onTick.connect(onTick)
	Game.race.onEnd.connect(onEnd)
	for horse in Game.race.horses:
		var hslider = HSlider.new()
		hslider.max_value = GameData.RACE_STEPS
		hslider.editable = false
		hslider.name = horse.id
		$DEBUG/RACE/HORSES.add_child(hslider)
		var label = Label.new()
		label.text = horse.id
		$DEBUG/RACE/BETS/BET_VALUES.add_child(label)
		var spin_box = SpinBox.new()
		spin_box.value = 0
		spin_box.name = horse.id
		ui_bets.push_back(spin_box)
		$DEBUG/RACE/BETS/BET_VALUES.add_child(spin_box)
		
		ui_horses.push_back(hslider)

func _process(delta: float) -> void:
	if(!running):
		return
	_accum += delta
	while(_accum >= GameData.DEBUG_SPEED):
		_accum -= GameData.DEBUG_SPEED
		Game.tick()
		
func onTick():
	for h in ui_horses:
		for horse in Game.race.horses:
			if(h.name == horse.id):
				h.value = horse.position
				break
	$DEBUG/RACE/MONEY.text = "MONEY: " + str(Game.player.money) + "$"

func onEnd():
	for b in Game.player.bets:
		for h in Game.race.horses:
			if (h.id == b):
				if(h.placement == 1):
					Game.player.money += Game.player.bets[b] * 3
				Game.player.bets[b] = 0
	$DEBUG/RACE/MONEY.text = "MONEY: " + str(Game.player.money) + "$"
	
func _on_start_pressed() -> void:
	running = true;
	for h in Game.race.horses:
		for b in ui_bets:
			if(b.name == h.id):
				Game.player.bets[h.id] = int(b.value)
				Game.player.money -= int(b.value)
				break
	Game.start()
				
