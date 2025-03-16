extends Control

@onready var timer = $Timer
@onready var indicator_node = $Indicator
@onready var strong = $StrongClick
@onready var weak = $WeakClick

@export var metronome_running:bool = false;

# Timecode
@export var bar:int = 0
@export var eight:int = 0
@export var sixteenth:int = 0

func start():
	var click:float = 15 / Map.bpm # 1/16 note resolution
	timer.wait_time = click
	timer.start()

func _on_timer_timeout() -> void:
	sixteenth+=1;
	
	if sixteenth > 4:
		sixteenth = 1
		eight+=1
		weak.play()
	if eight > 4:
		eight = 1
		bar+=1
		strong.play()

func _input(event: InputEvent) -> void:
	pass

func _process(delta: float) -> void:
	indicator_node.text = str(bar) + " . " + str(eight) + " . " + str(sixteenth)
