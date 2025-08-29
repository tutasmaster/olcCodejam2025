class_name Horse3D
extends Node3D
@export var isDummy = false
var id = -1
var walk_speed = 0
var run_speed = 0

var target_position = null
var horse : Horse = null

var accum = 0
var target = 0

@export var dummy_anim = "ARM|Idle Podium"

func _ready() -> void:
	#var val = $Horse/ARM/Skeleton3D/HORSE.find_blend_shape_by_name("BIG_HEAD")
	#$Horse/ARM/Skeleton3D/HORSE.set_blend_shape_value(val, randf_range(-0.5, 2))
	$AnimationTree.set("parameters/TimeSeek/seek_request", randf_range(-1, 2) )
	apply_model(id)
	$AudioStreamPlayer3D.play(randf_range(0, 4))
	if(isDummy):
		$AnimationTree.queue_free()
		$Horse/AnimationPlayer.seek(randf())
		$Horse/AnimationPlayer.play(dummy_anim)
		$AudioStreamPlayer3D.stop()
	else:
		target = randf_range(5,15)

func set_horse(horse : Horse):
	self.horse = horse

func apply_model(id : int):
	self.id = id
	if(id != -1):
		var def = HorseFactory.getDefinitionFromID(id)
		var head = $Horse/ARM/Skeleton3D/HORSE.find_blend_shape_by_name("BIG_HEAD")
		var chest = $Horse/ARM/Skeleton3D/HORSE.find_blend_shape_by_name("BIG_CHEST")
		var butt = $Horse/ARM/Skeleton3D/HORSE.find_blend_shape_by_name("BIG_ASS")
		var snout = $Horse/ARM/Skeleton3D/HORSE.find_blend_shape_by_name("DROOP_SNOUT")
		var neck = $Horse/ARM/Skeleton3D/HORSE.find_blend_shape_by_name("BIG_NECK")
		var teeth = $Horse/ARM/Skeleton3D/HORSE.find_blend_shape_by_name("BIG_TEETH")
		var belly = $Horse/ARM/Skeleton3D/HORSE.find_blend_shape_by_name("BIG_BELLY")
		$Horse/ARM/Skeleton3D/HORSE.set_blend_shape_value(head, def.headSize)
		$Horse/ARM/Skeleton3D/HORSE.set_blend_shape_value(chest, def.torsoSize)
		$Horse/ARM/Skeleton3D/HORSE.set_blend_shape_value(butt, def.buttSize)
		$Horse/ARM/Skeleton3D/HORSE.set_blend_shape_value(neck, def.neckSize)
		$Horse/ARM/Skeleton3D/HORSE.set_blend_shape_value(teeth, def.toothSize)
		$Horse/ARM/Skeleton3D/HORSE.set_blend_shape_value(snout, def.snoutDroop)
		$Horse/ARM/Skeleton3D/HORSE.set_blend_shape_value(belly, def.bellySize)
		$Horse/ARM/Skeleton3D/HORSE.get_surface_override_material(0).albedo_color = def.color
		$Horse/ARM/Skeleton3D/HORSE.get_surface_override_material(1).albedo_color = def.cover_color
		$Horse/ARM/Skeleton3D/HORSE.get_surface_override_material(2).albedo_color = def.maine_color

func lerp_animation(anim, target, delta):
	if($AnimationTree.get(anim)):
		$AnimationTree.set(anim, lerpf($AnimationTree.get(anim), target, delta))
	
func _process(delta : float) -> void:
	if(isDummy):
		return
		
	accum += delta
	if(accum >= target):
		accum = 0
		target = randf_range(5, 15)
		var audio = $Audio.get_children().pick_random()
		audio.pitch_scale = randf_range(0.8,1.2)
		audio.play()
	
	if(run_speed == 0):
		$AudioStreamPlayer3D.volume_linear = 0
	else:
		$AudioStreamPlayer3D.volume_linear = 1
	$AudioStreamPlayer3D.pitch_scale = max(run_speed * 0.75, 0.1)
	
	lerp_animation("parameters/WALK_SPEED/blend_amount", walk_speed, delta)
	lerp_animation("parameters/RUN_SPEED/blend_amount", run_speed, delta)
	if(target_position):
		global_position = global_position.lerp(target_position, min(1,delta * 5))


func setRunningSpeed(value : float):
	if(value < 1.0):
		walk_speed = value
	else:
		walk_speed = 1.0
		
	run_speed = value
		
