extends Node2D
var finalScore: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func DisplayScore(score: int):
		
	$Score.text = "Your Score: " + str(score)
	finalScore = score
	


func _on_texture_button_pressed():
	var global_node = get_node("/root/Global")
	global_node.score = global_node.score + finalScore
	print(global_node.score)
	get_tree().change_scene_to_file("res://DecesionTreeScene/decision_tree.tscn")
	
