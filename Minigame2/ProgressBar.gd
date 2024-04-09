extends Node2D

@onready var progTimer: Node = $Progress
@onready var progBar: Node = $TextureProgressBar
@export var totalTime : float = 70.0 

var alive: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	progTimer.wait_time = totalTime
	progTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive:
		progBar.value = get_seconds_elapsed()

func get_seconds_elapsed() -> float:
	return progTimer.wait_time - progTimer.time_left
