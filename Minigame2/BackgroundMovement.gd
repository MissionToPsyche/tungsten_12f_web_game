extends ParallaxBackground

@export var scrolling_speed: float = 50.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_base_offset.y += scrolling_speed * delta
	#pass
