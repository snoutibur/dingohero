extends Control

@onready var timer = $Timer
@onready var indicator_node = $Indicator
@onready var strong = $StrongClick
@onready var weak = $WeakClick

@export var metroClick:bool = true;

# Timecode
@export var bar:int = 0
@export var fourth:int = 0
@export var sixteenth:int = 0

signal metronome_tick(beat:int, bar:int)

func start():
	var click:float = 15 / Map.bpm # 1/16 note resolution
	timer.wait_time = click
	timer.start()

func _on_timer_timeout() -> void:
	sixteenth+=1;
	if sixteenth > 4:
		sixteenth = 1
		fourth+=1
		weak.play()
	if fourth > 4:
		fourth = 1
		bar+=1
		strong.play()
		emit_signal("metronome_tick", fourth, bar)


func _process(delta: float) -> void:
	indicator_node.text = str(bar) + " . " + str(fourth) + " . " + str(sixteenth)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_metronome"):
		if metroClick:
			metroClick = false
			weak.volume_linear = 0
			strong.volume_linear = 0
		else:
			metroClick = true
			weak.volume_linear = 1
			strong.volume_linear = 1
		print("Metronome click is " + str(metroClick))
