extends Node2D

# Audio player for the backing track, responsible for playing the song
@onready var audio_player = $BackingSong

# MIDI player, responsible for handling MIDI note events
@onready var midi_player = $MidiPlayer

func _ready():
	midi_player.set_file("res://maps/Shelter/LyricWulfShelter.mid")
	
	# Start playback for audio and MIDI
	audio_player.play()
	midi_player.play()
# Calculates where the note should be
func noteXpos(note:int) -> float:
	var key_width = 20
	var startX = 100
	return startX + (note-21) * key_width

# Spawns in notes
func spawn_falling_notes(note:int) -> void:
	var noteSprite = Sprite2D.new()
	noteSprite.texture = preload("res://assets/uFurry.png")
	noteSprite.position = Vector2(noteXpos(noteSprite), 0)
	add_child(noteSprite)
	noteSprite.animate_fall()
