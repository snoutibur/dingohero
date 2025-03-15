extends Node

var debug_print : bool = false

func octaveOf(midiNote:int) -> int:
	return int((midiNote - 12) / 12)
