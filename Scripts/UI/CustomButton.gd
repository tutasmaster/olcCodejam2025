class_name CustomButton
extends Button

func _ready():
	if(disabled):
		disable()
	else:
		enable()

func enable():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	disabled = false
	
func disable():
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	disabled = true
