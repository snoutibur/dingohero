extends Node2D

# Map data
@export var song:String = ""
@export var artist:String = ""
@export var mapper:String = ""

# TODO: Read map data
func readData(filePath: String) -> void:
	print("Reading " + filePath)