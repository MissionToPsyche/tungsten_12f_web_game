extends Camera2D

var shakeAmount := 0.0
@export var shakeBaseAmount := 1.0
@export var shakeDamp := 0.075
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func shake(mag: float):
	shakeAmount += mag
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shakeAmount > 0:
		position.x = randf_range(-shakeBaseAmount, shakeBaseAmount)* shakeAmount
		position.y = randf_range(-shakeBaseAmount, shakeBaseAmount)* shakeAmount
		shakeAmount = lerp(shakeAmount, 0.0, shakeDamp)
	else:
		position = Vector2(0,0)
