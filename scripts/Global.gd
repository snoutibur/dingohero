extends Node

@export var debug_print : bool = false
@export var soundfont : String = "res://assets/sf/GS sound set (16 bit).SF2"
@export var bars_on_screen:int = 2

func octaveOf(midiNote:int) -> int:
	return int((midiNote - 12) / 12)
