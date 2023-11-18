extends ColorRect

@onready var animation = $AnimationPlayer

func _ready():
	animation.play("skycolor")
	
func _process(delta):
	pass
