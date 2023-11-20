extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize clouds' initial position, speed, and direction
	for cloud in get_children():
		if cloud is Node2D:
			cloud.position.x = randf_range(0, get_viewport_rect().size.x)
			cloud.position.y = randf_range(10, 250)
			cloud.speed = Vector2(randf_range(5, 10), 0)  # Adjust the speed range as needed
			cloud.direction = Vector2(randf_range(-1, 1), 0).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update each cloud's movement
	for cloud in get_children():
		if cloud is Node2D:
			cloud._process(delta)
