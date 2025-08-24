extends AnimationPlayer
@export var anim : String = "ARM|Idle Podium"

@export var random_seek : bool = false
func _ready() -> void:
	play(anim)
	if(random_seek):
		seek(randf())
