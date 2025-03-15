extends Node2D

const Utility = preload( "res://addons/midi/Utility.gd" )
const SMF = preload( "res://addons/midi/SMF.gd" )

# Audio player for the backing track, responsible for playing the song
@onready var audio_player = $BackingSong
# MIDI player, responsible for handling MIDI note events
@onready var midi_player = $MidiPlayer


func _ready():
	midi_player.set_soundfont("res://assets/sf/GS sound set (16 bit).SF2")
	midi_player.set_file("res://maps/Shelter/LyricWulfShelter.mid")
	
	# Start playback for audio and MIDI
	audio_player.play()
	midi_player.play()

	spawnNote(60)

# Calculates where the note should be
func noteXpos(note:int) -> float:
	var key_width = 20
	var startX = 100
	return startX + (note-21) * key_width

# Spawns in notes
func spawnNote(note:int) -> void:
	var noteSprite = Sprite2D.new() # better to spawn instances of a note scene.
	noteSprite.texture = preload("res://assets/uFurry.png")
	noteSprite.position = Vector2(noteXpos(note), 0)
	add_child(noteSprite)
	# make notesprite fall


func _on_midi_player_midi_event( channel, event ):
	# channel is same as $GodotMidiPlayer.channel_status[track_id]
	# event is event parameter. see SMF.gd and MidiPlayer.gd
	# 	-> more information at "MIDIEvent" at https://bitbucket.org/arlez80/godot-midi-player/wiki/struct/SMF

	# Output event data to stdout
	var event_string = ""
	match event.type:
		SMF.MIDIEventType.note_off:
			event_string = "NoteOff %d" % event.note
		SMF.MIDIEventType.note_on:
			event_string = "NoteOn note[%d] velocity[%d]" % [ event.note, event.velocity ]
		SMF.MIDIEventType.polyphonic_key_pressure:
			event_string = "PolyphonicKeyPressure note[%d] value[%d]" % [ event.note, event.value ]
		SMF.MIDIEventType.control_change:
			event_string = "ControlChange number[%d] value[%d]" % [ event.number, event.value ]
		SMF.MIDIEventType.program_change:
			event_string = "ProgramChange #%d" % event.number
		SMF.MIDIEventType.pitch_bend:
			event_string = "PitchBend %d -> %f" % [ event.value, ( event.value / 8192.0 ) - 1.0 ]
		SMF.MIDIEventType.channel_pressure:
			event_string = "ChannelPressure %d" % event.value
		SMF.MIDIEventType.system_event:
			event_string = "SystemEvent %d" % event.args.type

	print( channel, event, "channel:%d event-type:%s" % [
	channel.number,
	event_string,
	])