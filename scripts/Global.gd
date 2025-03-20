extends Node

## MIDI / VISUAL CONFIG ##
@export var soundfont : String = "res://assets/sf/GS sound set (16 bit).SF2"
@export var bars_on_screen:int = 2

## THEME CONFIG ##
@export var white_key_color = Color(1,1,1)
@export var black_key_color = Color(0,0,0)
@export var highlight_color = Color(.545, .850, .631)

## DEV SETTINGS ##
@export var debug_print : bool = false