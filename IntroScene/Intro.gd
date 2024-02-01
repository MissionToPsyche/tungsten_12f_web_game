extends Node2D

var fade_in: AnimationPlayer

func _ready():
	fade_in = $AnimationPlayer
	$yes.visible = false
	$no.visible = false
	$male_nasa_scientist.visible = false
	start_sequence()

func start_sequence():
	var timer = Timer.new()  # It's good practice to declare local variables with 'var'
	timer.wait_time = 5  # Wait time before starting the fade-in effect
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	fade_in.play("Black_in")  # Play the fade-in animation
	await get_tree().create_timer(0).timeout
	
	# After fade-in animation starts, set up a delay to change the scene
	# Adjust the delay to match your animation length or use the animation_finished signal
	var scene_change_timer = Timer.new()
	scene_change_timer.wait_time = 1.5  # Adjust based on the length of your fade-in animation
	scene_change_timer.one_shot = true
	scene_change_timer.connect("timeout", Callable(self, "_on_intro_end"))
	add_child(scene_change_timer)
	scene_change_timer.start()

func _on_intro_end():
	get_tree().change_scene_to_file("res://TeamBuilderScene/team_builder.tscn")
