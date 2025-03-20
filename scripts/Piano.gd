extends Control

var curNote:int = 24
@onready var octave_template = $Octave

# Finds the octave of a midi note.
func octaveOf(midiNote:int) -> int:
	return int((midiNote - 12) / 12)


func generate_keys(octaves: int):
	print("Generating " + str(octaves) + " octaves using template: " + str(octave_template))

	for i in range(octaves):
		# Add the octaves
		var new_octave = octave_template.duplicate()
		new_octave.name = "Oct" + str(octaveOf(curNote))
		new_octave.position.x = i * octave_template.get_rect().size.x
		add_child(new_octave)
		
		# ID the keys to a MIDI Note
		for key in new_octave.get_children():
			if key.name.begins_with("Key"):
				key.set_meta("midi_note", curNote)  # Attach midi_note as metadata to the key
				key.name = "Key" + str(curNote)
				key.text = str(curNote) # Set the button's text to the MIDI note number
				print("Assigned MIDI note ", str(curNote), " to ", key.name)
				curNote+=1

	# Remove the original template after duplication
	octave_template.queue_free()

	print("Octave generation complete")

func _ready():
	if octave_template == null:
		print("Octave template no exist!")
	else:
		generate_keys(7)


func _on_wide_detection_area_area_entered(area:Area2D) -> void:
	var midi_note = area.get_parent().get_meta("midi_note")
	if midi_note:
		print(midi_note)
	area.get_parent().queue_free()
