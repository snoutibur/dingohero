extends Node

var debug_print : bool = false

func octaveOf(midiNote:int) -> int:
	midiNote-=12
	midiNote/=12
	return midiNote