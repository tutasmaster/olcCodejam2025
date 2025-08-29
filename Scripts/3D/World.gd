extends Node

var horse_prefab : PackedScene = preload("res://Scenes/3D/Horse.tscn")

@onready var STABLE = $HORSE_STABLE
@onready var PODIUM = $HORSE_PODIUM
@onready var HORSES = $HORSES
@onready var HORSE_CAMERA = $PATH/PathFollow3D/Camera3D
@onready var PODIUM_CAMERA = $HORSE_PODIUM/CAMERA
@onready var STABLE_CAMERA = $HORSE_STABLE/Camera3D
@onready var UI = $UI

enum STATE {
	RACING,
	WINNING,
	PICKING
}
var state = STATE.PICKING
var running = false
var _accum = 0.0
var _cameraSwitchAccum = 0.0

var targetted_horse = null
var targetted_camera = null

const horse_offset = 2.65

func _ready() -> void:
	if(!GameData.IS_DEBUG):
		$DEBUG_VIEW.hide()
	else:
		$DEBUG_VIEW.show()
	$Cutscene.onCutsceneEnd.connect(_onCutsceneEnd)
	$UI_TRANSITIONS.show()
	$UI_TRANSITIONS/AnimationPlayer.play("RESET")
	$UI.HORSE_PICKED = $HORSE_STABLE/Horse
	$UI_TRANSITIONS.onTransition.connect(_onEndTransition)
	Game.onTick.connect(_onTick)
	Game.onEnd.connect(_onEnd)
	setPicking()
	
	var bus = AudioServer.get_bus_index("Master")
	$AudioControl/HBoxContainer/VSlider.value = AudioServer.get_bus_volume_linear(bus)
	
	
		
func startRace():
	max_horse_pos = 0
	state = STATE.RACING
	UI.hide_horse_selection()
	PODIUM.hide()
	HORSES.show()
	STABLE.hide()
	HORSE_CAMERA.make_current()
	
	for c in HORSES.get_children():
		HORSES.remove_child(c)
		c.queue_free()
	
	var i = 0
	for horse in Game.race.horses:
		var h : Node3D = horse_prefab.instantiate()
		h.global_position = Vector3((i - (Game.race.horses.size()-1)/2) * 2,0,0)
		h.name = str(horse.id)
		h.id = horse.id
		h.horse = horse
		$HORSES.add_child(h)
		var curve : Curve3D = $PATH.curve
		h.transform = curve.sample_baked_with_rotation(0,0)
		var side : float = (i+0.5)
		h.global_position = h.global_position * $PATH.scale
		h.global_position += $PATH.global_position + h.global_basis.x * (side - Game.race.horses.size()/2) * horse_offset
		i += 1
		
	$Cutscene.start()
	

var max_horse_pos = 0
func _process(delta: float) -> void:
	if(!running):
		return
	_accum += delta
	_cameraSwitchAccum += delta
	if(_cameraSwitchAccum > 10):
		tryCameraSwitch()
		_cameraSwitchAccum = 0
	while(_accum >= GameData.DEBUG_SPEED):
		_accum -= GameData.DEBUG_SPEED
		Game.tick()
		
	if(targetted_horse):
		$TRACK_CAMERA.global_position = targetted_camera.global_position
		$TRACK_CAMERA.global_rotation = targetted_camera.global_rotation
		
	$PATH/PathFollow3D.progress_ratio = lerp($PATH/PathFollow3D.progress_ratio, max_horse_pos/float(GameData.RACE_STEPS), min(1, delta*5))

func tryCameraSwitch():
	for h in Game.race.horses:
		if(h.placement != -1):
			$TRACK_CAMERA.clear_current()
			HORSE_CAMERA.make_current()
			return
	var coin_flip = randf_range(0,3)
	if(coin_flip < 2):
		var h = $HORSES.get_children().pick_random()
		var camera = h.get_child(0).get_children().pick_random()
		targetted_camera = camera
		$TRACK_CAMERA.global_position = camera.global_position
		$TRACK_CAMERA.global_rotation = camera.global_rotation
		targetted_horse = h
		$TRACK_CAMERA.make_current()
	else:
		$TRACK_CAMERA.clear_current()
		HORSE_CAMERA.make_current()
		

func _onTick():
	var count = 0
	for h in $HORSES.get_children():
		var horse3D : Horse3D = h
		var curve : Curve3D = $PATH.curve
		var offset = h.horse.position/float(GameData.RACE_STEPS) * curve.get_baked_length()
		var base_position = curve.sample_baked_with_rotation(offset)
		horse3D.global_basis = base_position.basis
		var side : float = (count+0.5)
		var pos = base_position.origin * $PATH.scale
		pos += $PATH.global_position + h.global_basis.x * (side - Game.race.horses.size()/2) * horse_offset
		#h.global_position = h.global_position * $PATH.scale
		#h.global_position += $PATH.global_position + h.global_basis.x * (side - Game.race.horses.size()/2) * 2.5
		h.target_position = pos
		horse3D.setRunningSpeed(float(h.horse.current_speed) * GameData.ANIMATION_SCALE)
		#h.global_position.z = (horse.position/float(GameData.RACE_STEPS))*100
	
		count += 1
	
	for horse in Game.race.horses:
		if(horse.position > max_horse_pos):
			max_horse_pos = horse.position
			
	if(GameData.IS_DEBUG):
		var text = ""
		for h in Game.race.horses:
			text += h.name + "\n"
			text += "\tStrategy: " + str(h.strategy) + "\n"
			text += "\tCurrent Speed: " + str(h.current_speed) + "\n"
			text += "\tStamina: " 
			if h.stamina < 50:
				text += "[color=#F00]"
			text += str(h.stamina)
			if h.stamina < 50:
				text += "[/color]"
			text += "\n\n"
		$DEBUG_VIEW/RichTextLabel.text = text
func _onEnd():
	running = false
	startTransition()
	
func startTransition():
	$UI_TRANSITIONS.startTransition()
	
func _onEndTransition():
	if(state == STATE.RACING):
		setWinning()
		await get_tree().create_timer(3).timeout
		startTransition()
	elif(state == STATE.WINNING):
		setPicking()
	elif(state == STATE.PICKING):
		startRace()

func setWinning():
	$CHEER.play()
	HORSE_CAMERA.clear_current()
	STABLE_CAMERA.clear_current()
	PODIUM_CAMERA.make_current()
	PODIUM.show()
	HORSES.hide()
	var horses = []
	var placement = 1
	while(horses.size() < 3):
		for h in Game.race.horses:
			if h.placement == placement:
				horses.push_back(h)
		placement += 1
	
	$HORSE_PODIUM/CSGCylinder3D/Horse.apply_model(horses[0].id)
	$HORSE_PODIUM/CSGCylinder3D2/Horse.apply_model(horses[1].id)
	$HORSE_PODIUM/CSGCylinder3D3/Horse.apply_model(horses[2].id)
	$HORSE_PODIUM/CSGCylinder3D/MeshInstance3D.mesh.text = horses[0].name
	$HORSE_PODIUM/CSGCylinder3D2/MeshInstance3D2.mesh.text = horses[1].name
	$HORSE_PODIUM/CSGCylinder3D3/MeshInstance3D3.mesh.text = horses[2].name
	
	state = STATE.WINNING

func setPicking():
	Game.newGame()
	$UI.selected_horse = randi_range(1, GameData.HORSES_PER_RACE)-1
	STABLE.show()
	STABLE_CAMERA.make_current()
	UI.show_horse_selection()
	state = STATE.PICKING


func _onCutsceneEnd():
	running = true


var toggled_on = false

func _on_button_pressed() -> void:
	toggled_on = !toggled_on
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus, toggled_on)
	
	if(toggled_on):
		$AudioControl/HBoxContainer/Button.text = "UNMUTE"
	else:
		$AudioControl/HBoxContainer/Button.text = "MUTE"
		


func _on_v_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus, value)
