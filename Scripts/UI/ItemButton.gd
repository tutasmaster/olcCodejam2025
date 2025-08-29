extends CustomButton

var item : Item = null

func _ready() -> void:
	super._ready()
	if(item != null):
		$Label.text = str(item.price) + "G"
