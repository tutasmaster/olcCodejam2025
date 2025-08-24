extends Node

var last_set_db : float = 1.0

func set_master_volume(value : float):
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))
	last_set_db = value
	return value
	
func set_sfx_volume(value : float):
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))
	last_set_db = value
	return value

func set_music_volume(value : float):
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))
	last_set_db = value
	return value
