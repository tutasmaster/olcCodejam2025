extends Control
signal onTransition

func startTransition():
	$AnimationPlayer.play("Transition")
	$AudioStreamPlayer.play()

func sendTransition():
	onTransition.emit()
