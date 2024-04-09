extends Node2D

var fade_in: AnimationPlayer
var typing_speed = 0.05

func _ready():
	fade_in = $AnimationPlayer
	$ContinueButton.visible = false
	$ContinueButton.pressed.connect(self._on_ContinueButton_pressed)
	start_sequence()

func start_sequence():
	$Panel/Label.visible_characters = 0
	fade_in.play("Black_in")
	await get_tree().create_timer(fade_in.current_animation_length).timeout
	animate_text()
	await get_tree().create_timer(5.0).timeout
	$ContinueButton.visible = true
	

func animate_text():
	var text = "Your team is looking great! Now let's head over to the lab to design our satellite and prepare for launch!"
	for i in range(text.length()):
		$Panel/Label.visible_characters = i + 1
		await get_tree().create_timer(typing_speed).timeout
	
func _on_ContinueButton_pressed():
	print("Button pressed")  # Debug statement
	get_tree().change_scene_to_file("res://BuilderScene/satellite-lab.tscn")
