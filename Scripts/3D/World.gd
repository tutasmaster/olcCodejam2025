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

func _ready() -> void:
	$Cutscene.onCutsceneEnd.connect(_onCutsceneEnd)
	$UI_TRANSITIONS.show()
	$UI_TRANSITIONS/AnimationPlayer.play("RESET")
	$UI.HORSE_PICKED = $HORSE_STABLE/Horse
	$UI_TRANSITIONS.onTransition.connect(_onEndTransition)
	Game.onTick.connect(_onTick)
	Game.onEnd.connect(_onEnd)
	setPicking()
		
func startRace():
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
		h.global_position += $PATH.global_position + h.global_basis.x * (side - Game.race.horses.size()/2) * 2.5
		i += 1
		
	$Cutscene.start()
	

func _process(delta: float) -> void:
	var vector3Array = $PATH.curve.get_baked_points()
	var i = 0
	for v in vector3Array:
		vector3Array[i] = vector3Array[i] * $PATH.scale
		vector3Array[i] += $PATH.global_position
		i += 1
	DebugDraw3D.draw_line_path(vector3Array)
	if(!running):
		return
	_accum += delta
	while(_accum >= GameData.DEBUG_SPEED):
		_accum -= GameData.DEBUG_SPEED
		Game.tick()

func _onTick():
	var count = 0
	for h in $HORSES.get_children():
		var horse3D : Horse3D = h
		var curve : Curve3D = $PATH.curve
		var offset = h.horse.position/float(GameData.RACE_STEPS) * curve.get_baked_length()
		var base_position = curve.sample_baked_with_rotation(offset)
		horse3D.transform = base_position
		var side : float = (count+0.5)
		h.global_position = h.global_position * $PATH.scale
		h.global_position += $PATH.global_position + h.global_basis.x * (side - Game.race.horses.size()/2) * 2.5
		horse3D.setRunningSpeed(float(h.horse.current_speed) * GameData.ANIMATION_SCALE)
		#h.global_position.z = (horse.position/float(GameData.RACE_STEPS))*100
	
		count += 1
	
	var max = 0
	for horse in Game.race.horses:
		if(horse.position > max):
			max = horse.position
	$PATH/PathFollow3D.progress_ratio = max/float(GameData.RACE_STEPS)
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
	STABLE.show()
	STABLE_CAMERA.make_current()
	UI.show_horse_selection()
	state = STATE.PICKING

func _onCutsceneEnd():
	running = true
