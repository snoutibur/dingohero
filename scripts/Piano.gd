extends Control

@onready var octave_template = $Octave

var num_octaves = 7

func generate_keys(octaves: int):
	print("Generating " + str(octaves) + " octaves")
	for i in range(octaves):
		var new_octave = octave_template.duplicate()
		new_octave.position.x = i * octave_template.get_rect().size.x
		add_child(new_octave)
	# Remove the original template after duplication
	octave_template.queue_free()

func _ready():
	print(octave_template)

	if octave_template == null:
		print("Octave template no exist!")
	else:
		generate_keys(num_octaves)
