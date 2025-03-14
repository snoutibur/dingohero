extends Node2D

@onready var audio_player = $BackingSong
@onready var midi_player = $MidiPlayer

func _ready():
	midi_player.connect("note-on", Callable(self, "_on_note_on"))
	midi_player.connect("note-off", Callable(self, "_on_note_off"))
	audio_player.play()
	midi_player.play()