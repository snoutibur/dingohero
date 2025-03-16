extends Node2D

# Map data
@export var song:String = ""
@export var artist:String = ""
@export var mapper:String = ""

# For gameplay
@export var bpm:float = 100 # Map's speed
@export var fall_speed:float # pixels/sec for given BPM

# TODO: Read map data
func readData(filePath: String) -> void:
	print("Reading " + filePath)

func set_fall_speed(bar_distance:float) -> void:
	bar_distance /= Global.bars_on_screen
	fall_speed = (bar_distance * bpm) / 240 # Constant from 4 beats/bar @ 60 beats per minute
	print("note fall speed changed to " + str(fall_speed) + "px/s to fit " + str(Global.bars_on_screen) + "bars at 1 bar =" + str(bar_distance))