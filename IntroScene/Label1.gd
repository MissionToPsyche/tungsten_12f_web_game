extends Label

var typing_speed = 0.05

func _ready():
	text = "Hi there, space explorer! Let's assemble our star team and unlock the secrets of how planets are made with the exciting Psyche mission!"
	visible_characters = 0
	$Timer.wait_time = typing_speed
	$Timer.start()

func _on_Timer_timeout():
	visible_characters += 1
	if visible_characters == text.length():
		$Timer.stop()
