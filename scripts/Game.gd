extends Control

## Initialization ##
# Metronome display and audio
@onready var metronome = $Metronome

# Audio player for the backing track
@onready var audio_player = $BackingSong
# MIDI player, responsible for handling MIDI note events
@onready var visualMIDI = $VisualMIDI


func _ready():
	adjust_fall_speed() # Make sure the notes are falling at the right speed for screen size.

	# PLAY AUDIO & VISUALIZER #
	# MIDI
#	visualMIDI.set_soundfont(Global.soundfont)
#	visualMIDI.set_file("res://maps/LyricWulfFish.mid")
	visualMIDI.set_file("res://maps/shelterMelody.mid")
	visualMIDI.set_tempo(Map.bpm)

	# MIDI must start first so it has time to hit the piao.
	visualMIDI.play()
	var hold_time = Global.bars_on_screen * 4 * (60/Map.bpm)
	await get_tree().create_timer(hold_time).timeout  # Wait for the delay

	# Start playback for the audio and timekeeper.
	metronome.start()
	audio_player.play()


## SYNC AUDIO / MIDI ##
func beats_to_seconds(bar:int, beat:int , time_signature:int, bpm:float) -> float:
	return ((bar -1) * time_signature + beat) * (60.0 / Map.bpm)

func beats_to_ticks(bar:int, beat: int, time_signature:int, ticks_per_beat:int) -> int:
	return ((bar) * time_signature + beat) * ticks_per_beat

func _on_metronome_metronome_tick(bar: int, beat: int) -> void:
	# Turn metronome click to seconds
	var audio_target = beats_to_seconds(bar, beat, 4, Map.bpm)

	# Sync Audio file
	var audio_position = audio_player.get_playback_position()
	if abs(audio_position - audio_target) > .05:
		audio_player.seek(audio_target)
		print("Resyncing audio to", audio_target, "seconds")

	# Sync MIDI File TODO: Sync doesn't actually work
#	visualMIDI.sync_to_beat(bar-Global.bars_on_screen, beat, 1)

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
# Adjusting fall speed
func _on_resized() -> void: # Note speed is dependent on window size and the distance between the piano and top of the game viewport.
	adjust_fall_speed()

func adjust_fall_speed():
	var piano_node = $Piano
	var pointA = Vector2(0,0)
	var pointB = Vector2(0, piano_node.position.y)
	Map.set_fall_speed(pointA.distance_to(pointB)) # Note speed is calculated under Map.gd and stored as class variables.
	
	
# Spawning
func spawnNote(note:int) -> void:
	# Load the note scene
	var note_scene = preload("res://scenes/note.tscn")
	var note_instance = note_scene.instantiate()
	
	# Add the note too tree + add meta
	note_instance.set_meta("midi_note", note)
	add_child(note_instance)
	
	# Find the key
	var target_key_path:String = "Piano/Oct" + str(Piano.octaveOf(note)) + "/Key" + str(note)
	var key: Node = get_node(target_key_path)

	# Put the note where it's supposed to go
	if key:
		var key_center_position = key.global_position + (key.size * 0.25)
		note_instance.position = Vector2(key_center_position.x, 0)
	else:
		push_error("Failed to get key.")
		
	
## EVENTS ##
func _on_midi_player_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/GameEnd.tscn")
