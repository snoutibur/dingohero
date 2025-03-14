extends Control

# Audio player for the backing track, responsible for playing the song
@onready var audio_player = $BackingSong

# MIDI player, responsible for handling MIDI note events
@onready var midi_player = $MidiPlayer

# Rhythm notifier, used for timing and syncing purposes
@onready var rhythm_notifier = $RhythmNotifier

func _ready():
	# Start playback for audio and MIDI
	audio_player.play()
	midi_player.play()