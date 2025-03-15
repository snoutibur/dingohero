extends Node2D

# Audio player for the backing track, responsible for playing the song
@onready var audio_player = $BackingSong

# MIDI player, responsible for handling MIDI note events
@onready var midi_player = $MidiPlayer

# MIDI event constants
const MIDI_MESSAGE_NOTE_OFF = 0x80
const MIDI_MESSAGE_NOTE_ON = 0x90

func _ready():
	# Start playback for audio and MIDI
	audio_player.play()
	midi_player.play()

func _on_midi_player_midi_event(channel, event):
	print(channel.number)
