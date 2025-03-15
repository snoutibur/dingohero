extends Control

var curNote:int = 36
@onready var octave_template = $Octave

func generate_keys(octaves: int):
	print("Generating " + str(octaves) + " octaves using template: " + str(octave_template))

	for i in range(octaves):
		# Add the octaves
		var new_octave = octave_template.duplicate()
		new_octave.name = "Oct" + str(Global.octaveOf(curNote))
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


func highlightKey(note: int) -> void: #TODO: Select and highlight the right key
	print("Highlighting note: " + str(note))

	# Select note
	var keyName:String = "Octave/$Key" + str(note)
	var target: Node  = get_node(keyName)

	if target:
		target.modulate = Color(1,0,0)
	else:
		print("Note not found!")


func _ready():
	if octave_template == null:
		print("Octave template no exist!")
	else:
		generate_keys(5)
