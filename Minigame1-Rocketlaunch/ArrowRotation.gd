extends ParallaxLayer

@onready var animation = $AnimationPlayer2
var final_rotation_value = 0
func _ready():
	animation.play("arrow")
	
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if OS.get_keycode_string(event.keycode) == "Space" and event.is_pressed():
			animation.stop(true)
			final_rotation_value = get_node("Arrow").get("rotation_degrees")
			if final_rotation_value < 45 and final_rotation_value > -45:
				animation.play("GoodJob")
			else:
				animation.play("tryagain")
				await get_tree().create_timer(1.4).timeout
				animation.play("arrow")
			
	
func _process(delta):
	pass
