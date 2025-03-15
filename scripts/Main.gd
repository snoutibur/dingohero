extends Control

func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
