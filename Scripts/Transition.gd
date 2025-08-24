extends Control
signal onTransition

func startTransition():
	$AnimationPlayer.play("Transition")

func sendTransition():
	onTransition.emit()
