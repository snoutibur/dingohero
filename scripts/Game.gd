
extends Control

# Audio player for the backing track, responsible for playing the song
@onready var audio_player = $BackingSong
# MIDI player, responsible for handling MIDI note events
@onready var visualMIDI = $VisualMIDI
# Metronome display and audio
@onready var metronome = $Metronome

var playing:bool = false

func _ready():
	adjust_fall_speed()

	# PLAY AUDIO #
	# MIDI
#	visualMIDI.set_soundfont(Global.soundfont)
#	midi_player.set_file("res://maps/LyricWulfFish.mid")
	visualMIDI.set_file("res://maps/Shelter/LyricWulfShelter.mid")

	# MIDI must start first so it has time to hit the piao.
	visualMIDI.play()
	var hold_time = Global.bars_on_screen * 4 * (60/Map.bpm)
	await get_tree().create_timer(hold_time).timeout  # Wait for the delay

	# Start playback for the audio and timekeeper.
	metronome.start()
	audio_player.play()



## SYNC AUDIO / MIDI ##
func beats_to_seconds(bar:int, beat:int , time_signature:int, bpm:float) -> float:
	return (bar * 4 + beat) * (60.0 / Map.bpm)

func beats_to_ticks(bar:int, beat: int, time_signature:int, ticks_per_beat:int) -> int:
	return (bar * time_signature + beat) * ticks_per_beat

func _on_metronome_metronome_tick(bar: int, beat: int) -> void:
	# Turn metronome click to seconds
	var audio_target = beats_to_seconds(bar, beat, 4, Map.bpm)

	# Sync Audio file
	var audio_position = audio_player.get_playback_position()
	if abs(audio_position - audio_target) > .05:
		audio_player.seek(audio_target)
		print("Resyncing audio to", audio_target, "seconds")

	# Sync MIDI File
	

# MIDI EVENTS #
# Visuals
func _on_midi_player_midi_event(channel, event):
	# Spawn notes
	match event.type:
		SMF.MIDIEventType.note_on:
			spawnNote(event.note)

	# Output event data to stdout
	if(Global.debug_print):
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

## NOTE VISUALS ##
# Spawning
func spawnNote(note:int) -> void:
	# Load the note scene
	var note_scene = preload("res://scenes/note.tscn")
	var note_instance = note_scene.instantiate()
	add_child(note_instance)

	# Find the key
	var target_key_path:String = "Piano/Oct" + str(Global.octaveOf(note)) + "/Key" + str(note)
	var key: Node = get_node(target_key_path)

	# Put the note where it's supposed to go
	if key:
		var key_center_position = key.global_position + (key.size * 0.25)
		note_instance.position = Vector2(key_center_position.x, 0)
	else:
		push_error("Failed to get key.")


# Note speed is calculated under Map.gd and stored as class variables.
# Note speed is dependent on window size and the distance between the piano and top of the game viewport.
func adjust_fall_speed():
	var piano_node = $Piano
	var pointA = Vector2(0,0)
	var pointB = Vector2(0, piano_node.position.y)
	Map.set_fall_speed(pointA.distance_to(pointB))

func _on_resized() -> void:
	adjust_fall_speed()


## GAME END
func _on_midi_player_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/GameEnd.tscn")
