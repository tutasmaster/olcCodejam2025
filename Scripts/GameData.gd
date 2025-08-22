extends Node

func get_properties() -> Dictionary[String, String]:
	var properties = {
		"_LABEL" : "Main",
		"_LABEL1" : "Main",
		"_LABEL2" : "Main",
		"_LABEL3" : "Main",
		"_LABEL4" : "Main",
		"_LABEL5" : "Main",
		"_LABEL6" : "Main",
	}
	return properties

func update_property(name, value):
	set(name, value)
