extends Area2D


@export var speed = 200
@export var maxTilt = 20

@export var TiltSpeed = 1
@onready var collistion_rect: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_axis("move_left","move_right")
	
	if input > 0:
		direction = Vector2.RIGHT
		if(sprite_2d.rotation_degrees < maxTilt):
			sprite_2d.rotation_degrees = sprite_2d.rotation_degrees + TiltSpeed
	elif input < 0:
		direction = Vector2.LEFT
		if(sprite_2d.rotation_degrees > -maxTilt):
			sprite_2d.rotation_degrees = sprite_2d.rotation_degrees - TiltSpeed
	else:
		direction = Vector2.ZERO
		if(sprite_2d.rotation_degrees > 0.5):
			sprite_2d.rotation_degrees = sprite_2d.rotation_degrees - TiltSpeed
		elif(sprite_2d.rotation_degrees < -0.5):
			sprite_2d.rotation_degrees = sprite_2d.rotation_degrees + TiltSpeed
	
	var delta_mvmt = speed * delta * direction.x
	position.x += delta_mvmt
