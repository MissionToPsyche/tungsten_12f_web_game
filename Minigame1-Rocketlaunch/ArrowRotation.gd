extends ParallaxLayer

@onready var animation = $AnimationPlayer2
var final_rotation_value = 0
var final_power_value = 0
var animation_arrow= false;
var animation_power= false;

func _ready():
	$PowerBar.visible = false;
	animation.stop(true)
	animation.play("arrow")
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if OS.get_keycode_string(event.keycode) == "Space" and event.is_pressed():
			animation.stop(true)
			
			if !animation_arrow and !animation_power: 
				final_rotation_value = get_node("Arrow").get("rotation_degrees")
				if final_rotation_value < 45 and final_rotation_value > -45:
					var node_arrow = get_node("Arrow")
					animation.play("GoodJob")
					await get_tree().create_timer(1.3).timeout
					node_arrow.queue_free()
					animation_arrow = true;
					$PowerBar.visible = true;
					animation.play("powerBar")
				else:
					animation.play("tryagain")
					await get_tree().create_timer(1.4).timeout
					animation.play("arrow")
					
			elif animation_arrow and !animation_power:
				final_power_value = get_node("PowerBar/PowerSetter").get("position")
				if final_power_value.y > 250 and final_power_value.y< 300:
					animation.play("GoodJob")
					await get_tree().create_timer(1.3).timeout
					get_node("PowerBar").queue_free()
					animation_power = true
					await get_tree().create_timer(1.3).timeout
					animation.play("CameraPan")
				else:
					animation.play("tryagain")
					await get_tree().create_timer(1.4).timeout
					animation.play("powerBar")
				
				

			
	
func _process(delta):
	pass
