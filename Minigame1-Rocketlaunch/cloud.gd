extends Sprite2D

var speed 
var direction
var init_pos
func _ready():
	init_pos = position

func _process(delta):
	# Move the cloud based on speed and direction
	position += speed * direction * delta

	# Add logic to wrap the cloud when it goes off-screen
	if position.x-100 > get_viewport_rect().size.x:
		position.x = init_pos.x  
		position.y = randf_range(10, 250)
		direction = Vector2(randf_range(0, 1), 0).normalized()
		
	if position.x+100 < 0:
		position.x = 1360
		position.y = randf_range(10, 250)
		direction = Vector2(randf_range(-1, 0), 0).normalized()

